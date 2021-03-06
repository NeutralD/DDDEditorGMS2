/// @param Dialog

var dialog = argument0;

var dw = 512;
var dh = 400;

var dg = dialog_create(dw, dh, "Data: Availalbe Autotiles", dialog_default, dc_close_no_questions_asked, dialog);

var columns = 2;
var spacing = 16;
var ew = dw / columns - spacing * 2;
var eh = 24;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = eh;

var b_width = 128;
var b_height = 32;

var yy = 64;

var n = ds_list_size(Stuff.all_graphic_autotiles);
var el_list = create_list(16, yy, "Available autotiles: " + string(n) + " / ", "", dw / 2 - 16, b_height, 7, null, false, dg, Stuff.all_graphic_autotiles);
el_list.entries_are = ListEntries.INSTANCES;

var el_preview = create_image_button(dw / 2 + 16, yy, "If an autotile was loaded into this slot it would be previewed here", noone, dw / 2 - 32, dw / 2 - 32, fa_center, null, dg);
el_preview.render = ui_render_image_button_autotile_preview;
dg.el_preview = el_preview;

yy += dg.el_preview.height + 16;

var el_load = create_button(dw * 3 / 4, yy, "Load Autotile", b_width, b_height, fa_center, null, dg, fa_center, fa_top);
var el_confirm = create_button(dw / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg, fa_center);

ds_list_add(dg.contents,
    el_list,
    el_confirm,
    el_preview,
    el_load
);

return dg;