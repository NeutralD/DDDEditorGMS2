/// @param UIInput

if (script_execute(argument0.validation, argument0.value)) {
    var selection = ui_list_selection(argument0.root.el_list);

    if (selection != noone) {
        // no alphabetize
        var already = internal_name_get(argument0.value);
        if (already == noone || already == Stuff.all_bgm[| selection]) {
            internal_name_remove(Stuff.all_bgm[| selection].internal_name);
            internal_name_set(Stuff.all_bgm[| selection], argument0.value);
            argument0.color = c_black;
        } else {
            argument0.color = c_red;
        }
    }
}