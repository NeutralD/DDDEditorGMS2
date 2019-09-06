render = ui_render;
contents = ds_list_create();
root = noone;
enabled = true;

interactive = true;
outline = true;             // not used in all element types

key = "key";

text = "thing";
height = 24;
width = 128;

color = c_black;
alignment = fa_left;
valignment = fa_middle;

// if you have a list of ui things in a list, and want to iterate over the list, but
// want to ignore this one
is_aux = false;

// if this is set to true the mouse click check will use mouse_within_rectangle_adjusted
// instead of mouse_within_rectangle_view
adjust_view = false;