/// @param UIText
/// @param x
/// @param y

var text = argument0;
var xx = argument1;
var yy = argument2;

text.text = "Event: "+ Stuff.event.active.name;
ui_render_text(text, xx, yy);