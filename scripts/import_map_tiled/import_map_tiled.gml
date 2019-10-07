var filename = get_open_filename("Tiled JSON files (*.json)|*.json", "");

var map = Stuff.active_map;
var map_contents = map.contents;

if (file_exists(filename)) {
	var json_buffer = buffer_load(filename);
	var json = json_decode(buffer_read(json_buffer, buffer_text));
	buffer_delete(json_buffer);
	
	var json_type = json[? "type"];
	if (json_type == "map") {
		
		var json_layers = json[? "layers"];
		
		var json_properties = json[? "properties"];
		var map_id = -1;
		
		for (var i = 0; i < ds_list_size(json_properties); i++) {
			var property_name = ds_map_find_value(json_properties[| i], "name");
			var property_type = ds_map_find_value(json_properties[| i], "type");
			var property_value = ds_map_find_value(json_properties[| i], "value");
			
			if (property_name = "id") {
				map_id = property_value;
			}
		}
		
		var json_width = json[? "width"];
		var json_height = json[? "height"];
		
		var json_tilesets = json[? "tilesets"];
		var tileset_columns = 0;
		if (!ds_list_empty(json_tilesets)) {
			//import_map_tiled_tileset(json_tilesets[| 0]);
			// @todo gml update chained accessors
			var tileset_source = ds_map_find_value(json_tilesets[| 0], "source");
			if (!file_exists(tileset_source)) {
				tileset_source = filename_path(filename) + filename_name(tileset_source);
			}
			if (file_exists(tileset_source)) {
				var tileset_buffer = buffer_load(tileset_source);
				var tileset_json = json_decode(buffer_read(json_buffer, buffer_text));
				buffer_delete(tileset_buffer);
				tileset_columns = tileset_json[? "columns"];
				ds_map_destroy(tileset_json);
			}
		}
        
		if (tileset_columns) {
			var json_layers = json[? "layers"];
			var layer_z = 0;
			for (var i = 0; i < ds_list_size(json_layers); i++) {
				var layer_data = json_layers[| i];
				var layer_type = layer_data[? "type"];
			
				switch (layer_type) {
					case "group": layer_z = import_map_tiled_layer_folder(layer_data, tileset_columns, layer_z); break;
					case "objectgroup": layer_z = import_map_tiled_layer_object(layer_data, tileset_columns, layer_z); break;
					case "tilelayer": layer_z = import_map_tiled_layer_tile(layer_data, tileset_columns, layer_z); break;
				}
			}
            
            if (map_contents.frozen) vertex_delete_buffer(map_contents.frozen);
            if (map_contents.frozen_wire) vertex_delete_buffer(map_contents.frozen_wire);
            
            if (buffer_get_size(map_contents.frozen_data) - 1) {
                map_contents.frozen = vertex_create_buffer_from_buffer(map_contents.frozen_data, Camera.vertex_format);
                vertex_freeze(map_contents.frozen);
            }
            if (buffer_get_size(map_contents.frozen_data_wire) - 1) {
                map_contents.frozen_wire = vertex_create_buffer_from_buffer(map_contents.frozen_data_wire, Camera.vertex_format);
                vertex_freeze(map_contents.frozen_wire);
            }
            
		} else {
			dialog_create_notice(noone, "No valid tileset file found for " + filename_name(filename) + ". Please find one.");
		}
	}
	
	ds_map_destroy(json);
}