/// @param EditorModeMap

var mode = argument0;

var map = Stuff.map.active_map;
var map_contents = map.contents;

draw_clear(c_black);

gpu_set_zwriteenable(true);
gpu_set_cullmode(Stuff.setting_view_backface ? cull_noculling : cull_counterclockwise);
// this used to be turned off for 2D maps and there was a comment saying weird things
// would happen, but it was causing layering issues and i havent seen anything bad
// happen from turning it off yet
gpu_set_ztestenable(true);

draw_set_color(c_white);

var camera = view_get_camera(view_current);
var vw = view_get_wport(view_current);
var vh = view_get_hport(view_current);
camera_set_view_mat(camera, matrix_build_lookat(mode.x, mode.y, mode.z, mode.xto, mode.yto, mode.zto, mode.xup, mode.yup, mode.zup));
camera_set_proj_mat(camera, matrix_build_projection_perspective_fov(-mode.fov, -vw / vh, CAMERA_ZNEAR, CAMERA_ZFAR));
camera_apply(camera);

graphics_draw_water();

if (Stuff.setting_view_grid) {
    transform_set(0, 0, Stuff.map.edit_z * TILE_DEPTH + 0.5, 0, 0, 0, 1, 1, 1);
    vertex_submit(Stuff.graphics.grid, pr_linelist, -1);
    transform_reset();
    transform_set(0, 0, 0.5, 0, 0, 0, 1, 1, 1);
    vertex_submit(Stuff.graphics.axes, pr_linelist, -1);
}

// spart draw code goes here