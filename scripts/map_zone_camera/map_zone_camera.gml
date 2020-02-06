/// @param Dialog

var root = argument0;
var zone = root.zone;

var dw = 360;
var dh = 320;

var dg = dialog_create(dw, dh, "Camera Zone Settings: " + zone.name, dialog_default, dc_close_no_questions_asked, root);
dg.zone = zone;

var columns = 1;
var spacing = 16;
var ew = (dw - columns * spacing * 2) / columns;
var eh = 24;

var col1_x = 16;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = eh;

var yy = 64;
var yy_base = yy;

var el_name = create_input(col1_x, yy, "Name", ew, eh, uivc_input_map_camera_zone_name, zone.name, "name", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
el_name.tooltip = "A name; this is for identification (and possibly debugging) purposes and has no influence on gameplay";
yy = yy + el_name.height + spacing;

var el_camera_distance = create_input(col1_x, yy, "Distance", ew, eh, uivc_input_map_camera_zone_distance, zone.camera_distance, "float", validate_double, 0, 32, 10, vx1, vy1, vx2, vy2, dg);
el_name.tooltip = "How far the camera is to be from its target, measured in tile distances";
yy = yy + el_camera_distance.height + spacing;

var el_camera_angle = create_input(col1_x, yy, "Angle", ew, eh, uivc_input_map_camera_zone_angle, zone.camera_angle, "float", validate_double, -89, 89, 4, vx1, vy1, vx2, vy2, dg);
el_name.tooltip = "The angle above the ground of the camera, measured in degrees; a positive angle is looking down on the camera target, and a negative angle is looking up";
yy = yy + el_camera_angle.height + spacing;

var el_priority = create_input(col1_x, yy, "Priority", ew, eh, uivc_input_map_camera_zone_priority, zone.zone_priority, "int", validate_int, 0, 1000, 3, vx1, vy1, vx2, vy2, dg);
el_name.tooltip = "If multiple camera zones overlap, the one with the highest priority will be the one that is acted upon";
yy = yy + el_priority.height + spacing;

var b_width = 128;
var b_height = 32;
var el_commit = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_name,
    el_camera_distance,
    el_camera_angle,
    el_priority,
    el_commit
);

return dg;