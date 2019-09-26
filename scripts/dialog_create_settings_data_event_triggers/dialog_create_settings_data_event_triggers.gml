/// @param Dialog

var dw = 320;
var dh = 680;

var dg = dialog_create(dw, dh, "Data Settings: Global Switches", dialog_default, dc_close_no_questions_asked, argument0);

var ew = dw - 64;
var eh = 24;

var vx1 = ew / 2 + 16;
var vy1 = 0;
var vx2 = ew;
var vy2 = vy1 + eh;

var spacing = 16;

var yy = 64;
var yy_start = 64;

var el_list = create_list(32, yy, "Event Triggers (max 32)", "<no swiches>", ew, eh, 16, null, false, dg, Stuff.all_event_triggers);
el_list.numbered = true;
dg.el_list = el_list;

yy = yy + ui_get_list_height(el_list) + spacing;

var el_name = create_input(32, yy, "Trigger name:", ew, eh, uivc_global_trigger_name, 0, "", "16 characters", validate_string, ui_value_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
yy = yy + el_name.height + spacing;
dg.el_name = el_name;

var el_add = create_button(32, yy, "Add Trigger", ew, eh, fa_center, null, dg);
dg.el_add = el_add;

yy = yy + el_add.height + spacing;

var el_remove = create_button(32, yy, "Remove Trigger", ew, eh, fa_center, null, dg);
dg.el_remove = el_remove;

yy = yy + el_remove.height + spacing;

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_list, el_name, el_add, el_remove,
    el_confirm);

keyboard_string = "";

return dg;