/// @param UIList
/// @param x
/// @param y

var list = argument0;
var xx = argument1;
var yy = argument2;

var otext = list.text;
var oentries = list.entries;

list.text = otext + string(ds_list_size(Stuff.all_animations));
list.entries = Stuff.all_animations;

ui_render_list(list, xx, yy);

list.text = otext;
list.entries = oentries;