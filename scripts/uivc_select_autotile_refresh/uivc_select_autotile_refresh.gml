var ts = get_active_tileset();

// refresh values that don't like to do it on their own
ui_input_set_value(Stuff.map.ui.t_p_autotile_editor.element_priority, string(ts.at_priority[Stuff.map.selection_fill_autotile]));
ui_input_set_value(Stuff.map.ui.t_p_autotile_editor.element_tag, string(ts.at_tags[Stuff.map.selection_fill_autotile]));

var list = Stuff.map.ui.t_p_autotile_editor.element_list.entries;
for (var i = 0; i < AUTOTILE_MAX; i++) {
    if (ts.autotiles[i]) {
        var data = Stuff.all_graphic_autotiles[| ts.autotiles[i]];
        // this can happen if an autotile graphic is removed while it's still being referenced by the game
        // @todo some way to inform the user that this has happened
        if (is_array(data)) {
            list[| i] = string(i) + "." + data[AvailableAutotileProperties.NAME];
        } else {
            list[| i] = string(i) + ". <none set>";
        }
    }
}