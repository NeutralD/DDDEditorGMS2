/// @param buffer

var buffer = argument0;
var list = Stuff.all_graphic_particles;

buffer_write(buffer, buffer_datatype, SerializeThings.IMAGE_PARTICLES);
var addr_next = buffer_tell(buffer);
buffer_write(buffer, buffer_u64, 0);

var n_images = ds_list_size(list);
buffer_write(buffer, buffer_u32, n_images);

var individual_images = (n_images < 100) && true;
buffer_write(buffer, buffer_u8, individual_images);

for (var i = 0; i < n_images; i++) {
    var data = list[| i];
    
    serialize_save_generic(buffer, data);
    buffer_write(buffer, buffer_u16, data.hframes);
    buffer_write(buffer, buffer_u16, data.vframes);
    buffer_write(buffer, buffer_f32, data.x);
    buffer_write(buffer, buffer_f32, data.y);
    buffer_write(buffer, buffer_f32, data.width);
    buffer_write(buffer, buffer_f32, data.height);
    
    var bools = pack(data.texture_exclude);
    buffer_write(buffer, buffer_u32, bools);
    
    if (individual_images) {
        buffer_write_sprite(buffer, data.picture);
    }
}

if (!individual_images) {
    buffer_write_sprite(buffer, Stuff.all_graphic_particle_texture);
}

buffer_poke(buffer, addr_next, buffer_u64, buffer_tell(buffer));

return buffer_tell(buffer);