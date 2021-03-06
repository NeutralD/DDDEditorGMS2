/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;

var addr_next = buffer_read(buffer, buffer_u64);

ds_list_clear_instances(Stuff.all_se);

var n_se = buffer_read(buffer, buffer_u16);

for (var i = 0; i < n_se; i++) {
    var se = instance_create_depth(0, 0, 0, DataAudio);
    
    serialize_load_generic(buffer, se, version);
    
    se.temp_name = buffer_read(buffer, buffer_string);
    var length = buffer_read(buffer, buffer_u32);
    var fbuffer = buffer_create(length, buffer_fixed, 1);
    buffer_copy(buffer, buffer_tell(buffer), length, fbuffer, 0);
    buffer_seek(buffer, buffer_seek_relative, length);
    buffer_save_ext(fbuffer, se.temp_name, 0, buffer_get_size(fbuffer));
    buffer_delete(fbuffer);
    
    se.fmod_rate = buffer_read(buffer, buffer_u32);
    
    if (length == 0) {
        wtf("Audio file was not embedded properly, you probably want to re-load: " + string(se.GUID) + " [" + se.name + "]");
    } else {
        se.fmod = FMODGMS_Snd_LoadStream(environment_get_variable("localappdata") + "\\DDDEditor2\\" + se.temp_name);
    }
    
    ds_list_add(Stuff.all_se, se);
}