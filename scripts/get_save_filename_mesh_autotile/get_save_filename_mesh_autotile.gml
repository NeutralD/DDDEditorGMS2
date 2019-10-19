/// @param [name]

var name = (argument_count > 0) ? argument[0] : "";

var path = get_save_filename_ext("Mesh Autotile files (*.ddd_atm)|*.ddd_atm", name, Stuff.setting_location_mesh, "Select a mesh autotile collection");
var dir = filename_dir(path);

if (string_length(dir) > 0) {
    Stuff.setting_location_mesh = dir;
    setting_save_string("location", "mesh", dir);
}

return path;