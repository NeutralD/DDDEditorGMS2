/*
 * Projection variables
 */

ini_open(DATA_INI);
x = ini_read_real("Camera", "x", 0);
y = ini_read_real("Camera", "y", 0);
z = ini_read_real("Camera", "z", 100);

xto = ini_read_real("Camera", "xto", 512);
yto = ini_read_real("Camera", "yto", 512);
zto = ini_read_real("Camera", "zto", 0);

xup = ini_read_real("Camera", "xup", 0);
yup = ini_read_real("Camera", "yup", 0);
zup = ini_read_real("Camera", "zup", 1);

fov = ini_read_real("Camera", "fov", 50);
pitch = ini_read_real("Camera", "pitch", 0);
direction = ini_read_real("Camera", "direction", 0);

anim_x = ini_read_real("Camera", "ax", 0);
anim_y = ini_read_real("Camera", "ay", 100);
anim_z = ini_read_real("Camera", "az", 100);

anim_xto = ini_read_real("Camera", "axto", 0);
anim_yto = ini_read_real("Camera", "ayto", 0);
anim_zto = ini_read_real("Camera", "azto", 0);

anim_xup = ini_read_real("Camera", "axup", 0);
anim_yup = ini_read_real("Camera", "ayup", 0);
anim_zup = ini_read_real("Camera", "azup", 1);

anim_fov = ini_read_real("Camera", "afov", 50);
anim_pitch = ini_read_real("Camera", "apitch", 0);
anim_direction = ini_read_real("Camera", "adirection", 0);

alarm[ALARM_CAMERA_SAVE] = room_speed * CAMERA_SAVE_FREQUENCY;

/*smf_test_model = smf_model_load(get_open_filename("", "smf"));
smf_test_model = smf_test_model[1];
smf_test_animation = smf_model_load(get_open_filename("", "smf"));
smf_test_animation = smf_test_animation[1];*/
smf_light_add_direction(smf_vector_normalize([-1, -1, -1]), c_white, 1);

/*
 * Editor modes
 */

mode = EditorModes.EDITOR_3D;

// if / when you add more of these remember to also add another series of Draw
// instructions to Camera.Draw
enum EditorModes {
    EDITOR_3D,
    EDITOR_EVENT,
    EDITOR_DATA,
    EDITOR_ANIMATION,
}

/*
 * Raycasting stuff
 */

MOUSE_X = window_mouse_get_x();
MOUSE_Y = window_mouse_get_y();
mouse_3d_lock = false;

/*
 * Vertex formats
 */

gpu_set_alphatestenable(true);
gpu_set_alphatestref(20);

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_texcoord();
vertex_format_add_colour();
vertex_format_add_colour();     // second color information is for extra data
vertex_format = vertex_format_end();

grid = noone;
grid_centered = noone;

grid_sphere = noone;

/*
 * selection stuff
 */

under_cursor = noone;

selection = ds_list_create();
selected_entities = ds_list_create();
last_selection = noone;

selection_mode = ini_read_real("selection", "mode", SelectionModes.RECTANGLE);
selection_addition = ini_read_real("selection", "addition", false);
selection_fill_type = ini_read_real("selection", "fill-type", FillTypes.TILE);
selection_mask = ini_read_real("selection", "mask", SELECTION_MASK_ALL);

selection_fill_mesh = -1;       // list index
selection_fill_tile_x = 4;
selection_fill_tile_y = 0;
selection_fill_autotile = 0;

view_wireframe = ini_read_real("view", "wireframe", false);
view_grid = ini_read_real("view", "grid", true);
view_backface = ini_read_real("view", "backface", false);
view_texture = ini_read_real("view", "texture", true);
view_entities = ini_read_real("view", "entities", true);

mouse_drag_behavior = ini_read_real("mouse", "drag-behavior", 0);

tile_data_view = TileSelectorDisplayMode.PASSAGE;
tile_on_click = TileSelectorOnClick.SELECT;

enum TileSelectorDisplayMode {
    PASSAGE,
    PRIORITY,
    FLAGS,
    TAGS,
}

enum TileSelectorOnClick {
    SELECT,
    MODIFY,
}

/*
 * inputs; maybe these can be rebound though a menu, but that's not important now
 */

input_selection_add = vk_control;

/*
 * other stuff
 */

changes = ds_list_create();
deletions = ds_list_create();
ui = ui_init_main();
ui_event = ui_init_event();
ui_game_data = noone;
ui_animation = ui_init_animation();
menu = instance_create_depth(0, 0, 0, MenuMain);
dialogs = ds_list_create();

stuff_to_destroy = ds_queue_create();

instance_deactivate_object(UIThing);

gpu_set_tex_repeat(true);

/*
 * preview stuff
 */

mesh_preview = noone;
mesh_x = 0;
mesh_y = 0;
mesh_z = 0;
mesh_xrot = 0;
mesh_yrot = 0;
mesh_zrot = 0;
mesh_scale = 1;

mesh_preview_grid = vertex_create_buffer();
vertex_begin(mesh_preview_grid, vertex_format);

var x1 = -6 * TILE_WIDTH;
var y1 = -6 * TILE_HEIGHT;
var x2 = -x1;
var y2 = -y1;

for (var i = 0; i <= 12; i++) {
    vertex_point_line(mesh_preview_grid, x1 + i * TILE_WIDTH, y1, 0, c_white, 1);
    vertex_point_line(mesh_preview_grid, x1 + i * TILE_WIDTH, y2, 0, c_white, 1);
    
    vertex_point_line(mesh_preview_grid, x1, y1 + i * TILE_HEIGHT, 0, c_white, 1);
    vertex_point_line(mesh_preview_grid, x2, y1 + i * TILE_HEIGHT, 0, c_white, 1);
}

vertex_end(mesh_preview_grid);
vertex_freeze(mesh_preview_grid);

/*
 * end of step actions
 */

schedule_rebuild_master_texture = false;
schedule_view_master_texture = false;
schedule_save = false;
schedule_open = false;

/*
 * enumerated constants that i need
 */

enum SelectionModes {
    SINGLE,
    RECTANGLE,
    CIRCLE
}

enum FillTypes {
    TILE,
    AUTOTILE,
    MESH,
    PAWN,
    EFFECT,
    TERRAIN,
}

fill_types = [safc_fill_tile, safc_fill_autotile, safc_fill_mesh, safc_fill_pawn, safc_fill_effect, safc_fill_terrain];

/*
 * the autotile shader
 */

shd_uniform_at_tex_offset = shader_get_uniform(shd_default_autotile, "texoffset");
shd_value_at_tex_offset = array_create(MAX_AUTOTILE_SHADER_POSITIONS);

/*
 * Event editor
 */

event_canvas_active_node = noone;
event_canvas_active_node_index = 0;

event_x = ini_read_real("Camera", "ex", 0);
event_y = ini_read_real("Camera", "ey", 100);
event_z = ini_read_real("Camera", "ez", 100);

event_xto = ini_read_real("Camera", "exto", 0);
event_yto = ini_read_real("Camera", "eyto", 0);
event_zto = ini_read_real("Camera", "ezto", 0);

event_xup = ini_read_real("Camera", "exup", 0);
event_yup = ini_read_real("Camera", "eyup", 0);
event_zup = ini_read_real("Camera", "ezup", 1);

event_fov = ini_read_real("Camera", "efov", 50);
event_pitch = ini_read_real("Camera", "epitch", 0);
event_direction = ini_read_real("Camera", "edirection", 0);

event_map = noone;

ini_close();