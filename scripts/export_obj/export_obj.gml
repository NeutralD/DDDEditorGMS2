/// @param fname
/// @param mesh

var fn = argument0;
var mesh = argument1;

buffer_seek(mesh.buffer, buffer_seek_start, 0);

var buffer = buffer_create(1024, buffer_grow, 1);

buffer_write(buffer, buffer_text, "# DDD OBJ file\r\n");
buffer_write(buffer, buffer_text, "mtllib " + filename_name(filename_name(filename_change_ext(fn, ".mtl"))) + "\r\n\r\n");

var active_mtl = "None";

var mtl_alpha = ds_map_create();
var mtl_r = ds_map_create();
var mtl_g = ds_map_create();
var mtl_b = ds_map_create();

var color = [0xffffffff, 0xffffffff, 0xffffffff];
var xx, yy, zz, nx, ny, nz, xtex, ytex;

var n = 1;

while (buffer_tell(mesh.buffer) < buffer_get_size(mesh.buffer)) {
    for (var i = 0; i < 3; i++) {
        xx = buffer_read(mesh.buffer, buffer_f32);
        yy = buffer_read(mesh.buffer, buffer_f32);
        zz = buffer_read(mesh.buffer, buffer_f32);
        nx = buffer_read(mesh.buffer, buffer_f32);
        ny = buffer_read(mesh.buffer, buffer_f32);
        nz = buffer_read(mesh.buffer, buffer_f32);
        xtex = buffer_read(mesh.buffer, buffer_f32) / TILESET_TEXTURE_WIDTH;
        ytex = buffer_read(mesh.buffer, buffer_f32) / TILESET_TEXTURE_HEIGHT;
        color[i] = buffer_read(mesh.buffer, buffer_u32);
        buffer_read(mesh.buffer, buffer_u32);
        
        buffer_write(buffer, buffer_text, "v " + decimal(xx) + " " + decimal(yy) + " " + decimal(zz) + "\r\n");
        buffer_write(buffer, buffer_text, "vt " + decimal(xtex) + " " + decimal(ytex) + "\r\n");
        buffer_write(buffer, buffer_text, "vn " + decimal(nx) + " " + decimal(ny) + " " + decimal(nz) + "\r\n");
    }
    
    var c = floor(((color[0] & 0xffffff) + (color[1] & 0xffffff) + (color[2] & 0xffffff)) / 3);
    var a = (((color[0] & 0xff000000) >> 24) + ((color[1] & 0xff000000) >> 24) + ((color[2] & 0xff000000) >> 24)) / 3;
    
    var mtl_name = string(floor((color[0] + color[1] + color[2]) / 4));
    
    if (!ds_map_exists(mtl_alpha, mtl_name)) {
        mtl_alpha[? mtl_name] = a;
        mtl_r[? mtl_name] = (c & 0x0000ff) / 255;
        mtl_g[? mtl_name] = ((c & 0x00ff00) >> 8) / 255;
        mtl_b[? mtl_name] = ((c & 0xff0000) >> 16) / 255;
    }
    
    active_mtl = mtl_name;
    
    if (string_length(active_mtl) > 0) {
        buffer_write(buffer, buffer_text, "usemtl " + active_mtl + "\r\n");
    }
        
    var text0 = string(n) + "/" + string(n) + "/" + string(n);
    n++;
    var text1 = string(n) + "/" + string(n) + "/" + string(n);
    n++;
    var text2 = string(n) + "/" + string(n) + "/" + string(n);
    n++;
    buffer_write(buffer, buffer_text, "f " + text0 + " " + text1 + " " + text2 + "\r\n\r\n");
}

buffer_save_ext(buffer, fn, 0, buffer_tell(buffer));
buffer_delete(buffer);
buffer = buffer_create(1024, buffer_grow, 1);

buffer_write(buffer, buffer_text, "# DDD MTL file\r\n");
buffer_write(buffer, buffer_text, "# Material count: " + string(ds_map_size(mtl_alpha)) + "\r\n");

for (var mtl = ds_map_find_first(mtl_alpha); mtl != undefined; mtl = ds_map_find_next(mtl_alpha, mtl)) {
    buffer_write(buffer, buffer_text, "\r\nnewmtl " + mtl + "\r\n");
    buffer_write(buffer, buffer_text, "Kd " + string(mtl_r[? mtl]) + " " + string(mtl_g[? mtl]) + " " + string(mtl_b[? mtl]) + "\r\n");
    buffer_write(buffer, buffer_text, "d " + string(mtl_alpha[? mtl]) + "\r\n");
    buffer_write(buffer, buffer_text, "illum 2\r\n");
}

buffer_save_ext(buffer, filename_change_ext(fn, ".mtl"), 0, buffer_tell(buffer));
buffer_delete(buffer);