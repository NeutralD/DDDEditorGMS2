/// @param UIRadioArray

var radio = argument0;
var mesh = radio.root.root.mesh;

var start_slope = mesh.slope;
mesh.slope = global.at_mask_values[radio.value];

if (start_slope != mesh.slope) {
    selection_update_autotiles();
}