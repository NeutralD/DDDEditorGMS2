/// @param UIInput

var input = argument0;
var list = input.root.el_list;
var selection = ui_list_selection(list);

if (selection + 1) {
    var file_data = list.entries[| selection];
    internal_name_set(file_data, input.value, false, true);
}