/// @param filename
/// @param [adjust-UVs?]
/// @param [existing-object]
/// @param [replace-index]

var buffer = buffer_load(argument[0]);
var adjust = (argument_count > 1 && argument[1] != undefined) ? argument[1] : true;
var existing = (argument_count > 2 && argument[2] != undefined) ? argument[2] : noone;
var replace_index = (argument_count > 3 && argument[3] != undefined) ? argument[3] : -1;

var data = ds_map_create();
ds_map_read(data, buffer_read_string(buffer));

var version = data[? "version"];
var grid_size = ds_map_exists(data, "grid_size") ? data[? "grid_size"] : 0;

ds_map_destroy(data);

var n = buffer_read(buffer, buffer_f32);

repeat (n) {
    var mesh_name = buffer_read_string(buffer);
    var mesh = import_vrax_next(buffer, grid_size, mesh_name, existing);
    ds_list_add(Stuff.all_meshes, mesh);
}

buffer_delete(buffer);