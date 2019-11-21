/// @param UIList
/// @param xx
/// @param yy

var list = argument0;
var xx = argument1;
var yy = argument2;

var otext = list.text;

var datadata = list.root.selected_data;

if (datadata) {
    list.text = otext + string(ds_list_size(datadata.properties));
    list.entries = datadata.properties;
} else {
    list.entries = Stuff.empty_list;
}

ui_render_list(list, xx, yy);
list.text = otext;