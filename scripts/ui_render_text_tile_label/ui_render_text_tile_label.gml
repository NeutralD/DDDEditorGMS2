/// @param UIText
/// @param x
/// @param y

var text = argument0;
var xx = argument1;
var yy = argument2;

text.text = "Tile Properties: " + string(Stuff.map.selection_fill_tile_x) + ", " + string(Stuff.map.selection_fill_tile_y);

ui_render_text(text, xx, yy);