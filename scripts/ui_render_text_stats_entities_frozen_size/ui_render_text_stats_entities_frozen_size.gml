/// @param UIText
/// @param x
/// @param y

var text = argument0;
var xx = argument1;
var yy = argument2;

var size = Stuff.map.active_map.contents.frozen_data_size;
text.text = "    (" + ((size > 1) ? string(size) : "-") + " bytes)"

ui_render_text(text, xx, yy);