event_inherited();

var camera = view_get_camera(view_3d);
depth_surface_base = surface_create(camera_get_view_width(camera), camera_get_view_height(camera));
depth_surface_top = surface_create(camera_get_view_width(camera), camera_get_view_height(camera));

x = setting_get("Terrain", "x", 0);
y = setting_get("Terrain", "y", 0);
z = setting_get("Terrain", "z", 100);

xto = setting_get("Terrain", "xto", 512);
yto = setting_get("Terrain", "yto", 512);
zto = setting_get("Terrain", "zto", 0);

xup = 0;
yup = 0;
zup = 1;

fov = setting_get("Terrain", "fov", 50);
pitch = setting_get("Terrain", "pitch", 0);
direction = setting_get("Terrain", "direction", 0);

update = editor_update_terrain;
render = editor_render_terrain;
save = editor_save_setting_terrain;

texture_name = "b_tileset_overworld_0.png";
texture = terrain_create_texture_sprite(PATH_GRAPHICS + texture_name);
texture_width = 2048;
texture_height = 2048;

vertices_per_square = 6;

// general settings
height = DEFAULT_TERRAIN_HEIGHT;
width = DEFAULT_TERRAIN_WIDTH;

view_scale = 32;
save_scale = 1;
export_all = false;
view_water = true;
export_swap_uvs = false;
export_swap_zup = false;
smooth_shading = false;
dual_layer = false;
orthographic = false;
orthographic_scale = 1;

cursor_position = undefined;
// height defaults
brush_min = 1.5;
brush_max = 8;
rate_min = 0.02;
rate_max = 1;
// height settings
rate = 0.125;
radius = 4;
mode = TerrainModes.Z;
submode = TerrainSubmodes.MOUND;
style = TerrainStyles.CIRCLE;
// texture defautls
tile_size = 32 / 4096;
texel = 1 / 4096;
// texture settings
tile_brush_x = 32 / 4096;
tile_brush_y = 32 / 4096;
// paint defaults
paint_strength_min = 0.01;
paint_strength_max = 1;
// paint settings
paint_color = 0xffffffff;
paint_strength = 0.05;

var t = get_timer();

height_data = buffer_create(buffer_sizeof(buffer_f32) * width * height, buffer_fixed, 1);
color_data = buffer_create(buffer_sizeof(buffer_u32) * width * height, buffer_fixed, 1);
buffer_fill(color_data, 0, buffer_u32, 0xffffffff, buffer_get_size(color_data));
// you don't need a texture UV buffer, since that will only be set and not mutated

terrain_buffer = vertex_create_buffer();
vertex_begin(terrain_buffer, Stuff.graphics.vertex_format_basic);

for (var i = 0; i < width - 1; i++) {
    for (var j = 0; j < height - 1; j++) {
        terrain_create_square(terrain_buffer, i, j, 1, 0, 0, tile_size, texel);
    }
}

vertex_end(terrain_buffer);
terrain_buffer_data = buffer_create_from_vertex_buffer(terrain_buffer, buffer_fixed, 1);
vertex_freeze(terrain_buffer);

wtf("Terrain creation took " + string((get_timer() - t) / 1000) + " milliseconds");

enum TerrainModes {
    Z,
    TEXTURE,
    COLOR,
}

enum TerrainSubmodes {
    MOUND,
    AVERAGE,
    AVG_FLAT,
    ZERO,
    TEXTURE,
    COLOR,
}

enum TerrainStyles {
    BLOCK,
    CIRCLE,
}

submode_equation[TerrainSubmodes.MOUND] = terrain_sub_mound;
submode_equation[TerrainSubmodes.AVERAGE] = terrain_sub_avg;
submode_equation[TerrainSubmodes.AVG_FLAT] = terrain_sub_flat;
submode_equation[TerrainSubmodes.ZERO] = terrain_sub_zero;

style_radius_coefficient[TerrainStyles.BLOCK] = 2.0;        // this will effectively fill the entire space
style_radius_coefficient[TerrainStyles.CIRCLE] = 1.0;       // an exact circle

ui = ui_init_terrain(id);
mode_id = ModeIDs.TERRAIN;