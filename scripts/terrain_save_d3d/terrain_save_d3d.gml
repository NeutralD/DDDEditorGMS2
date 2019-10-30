/// @param filename

var fn = argument0;
var terrain = Stuff.terrain;
var bytes = buffer_get_size(terrain.terrain_buffer_data);
var vertices = 0;

var buffer = buffer_create(1000000, buffer_grow, 1);
buffer_write(buffer, buffer_text, "100\n");
var addr_capacity = buffer_tell(buffer);
buffer_write(buffer, buffer_text, "00000000\n0 4\n");

for (var i = 0; i < bytes; i = i + terrain.format_size * 3) {
    var z0 = buffer_peek(terrain.terrain_buffer_data, i + 8, buffer_f32);
    var z1 = buffer_peek(terrain.terrain_buffer_data, i + 8 + terrain.format_size, buffer_f32);
    var z2 = buffer_peek(terrain.terrain_buffer_data, i + 8 + terrain.format_size * 2, buffer_f32);
    
    if (terrain.save_under_z_0 || z0 > 0 || z1 > 0 || z2 > 0) {
        for (var j = 0; j < terrain.format_size * 3; j = j + terrain.format_size) {
            var xx = buffer_peek(terrain.terrain_buffer_data, j + i, buffer_f32);
            var yy = buffer_peek(terrain.terrain_buffer_data, j + i + 4, buffer_f32);
            var zz = buffer_peek(terrain.terrain_buffer_data, j + i + 8, buffer_f32);
            var nx = buffer_peek(terrain.terrain_buffer_data, j + i + 12, buffer_f32);
            var ny = buffer_peek(terrain.terrain_buffer_data, j + i + 16, buffer_f32);
            var nz = buffer_peek(terrain.terrain_buffer_data, j + i + 20, buffer_f32);
            var xtex = buffer_peek(terrain.terrain_buffer_data, j + i + 24, buffer_f32);
            var ytex = buffer_peek(terrain.terrain_buffer_data, j + i + 28, buffer_f32);
            var color = buffer_peek(terrain.terrain_buffer_data, j + i + 32, buffer_u32);
            buffer_write(buffer, buffer_text, "9 " +
                string(xx) + " " + string(yy) + " " + string(zz) + " " +
                string(nx) + " " + string(ny) + " " + string(nz) + " " +
                string(xtex) + " " + string(ytex) + " " +
                string(color & 0xffffff) + " " +
                string(((color >> 24) & 0xff) / 255) + "\n"
            );
            vertices++;
        }
    }
}

buffer_poke(buffer, addr_capacity, buffer_text, string_pad(vertices + 2, "0", 8));

if (vertices / 3 >= 32000) {
    dialog_create_notice(noone, "This terrain contains " + string_comma(vertices / 3) + " triangles (" + string_comma(vertices) + " total vertices). You may still use it for your own purposes, but it will not be able to view it in Model Creator, which has a limit of 32000 vertices.",
        "Hey!", "Okay", 540, 240
    );
}

buffer_write(buffer, buffer_text, "1\n");

buffer_save_ext(buffer, fn, 0, buffer_tell(buffer));
buffer_delete(buffer);