/// @param UIInput

var input = argument0;

var data = Stuff.all_meshes[| Camera.selection_fill_mesh];

if (data) {
    data.zmax = real(input.value);
}