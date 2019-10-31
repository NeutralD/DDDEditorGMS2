/// @param EditorModeTerrain
/// @param cursor-position[]

var terrain = argument0;
var position = argument1;
var xx = floor(position[vec3.xx]);
var yy = floor(position[vec3.yy]);
var radius = floor(terrain.radius);
var xtex = terrain.tile_brush_x;
var ytex = terrain.tile_brush_y;

var n = 0;

for (var i = max(0, xx - radius + 1); i < min(terrain.width - 1, xx + radius + 1); i++) {
    for (var j = max(0, yy - radius + 1); j < min(terrain.height - 1, yy + radius + 1); j++) {
        var d = point_distance(xx, yy, i + 0.5, j + 0.5);
        if (d <= radius * terrain.style_radius_coefficient[terrain.style]) {
            terrain_set_texture(terrain, i, j, xtex, ytex);
            n++;
        }
    }
}

if (n) {
    vertex_delete_buffer(terrain.terrain_buffer);
    terrain.terrain_buffer = vertex_create_buffer_from_buffer(terrain.terrain_buffer_data, terrain.vertex_format);
	vertex_freeze(terrain.terrain_buffer);
}