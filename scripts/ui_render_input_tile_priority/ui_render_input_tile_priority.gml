/// @param UIInput
/// @param x
/// @param y

var input = argument0;
var xx = argument1;
var yy = argument2;

var ts = get_active_tileset();

input.value = string(ts.priority[# Stuff.map.selection_fill_tile_x, Stuff.map.selection_fill_tile_y]);
input.interactive = (Stuff.dimensions == Dimensions.TWOD);

ui_render_input(input, xx, yy);