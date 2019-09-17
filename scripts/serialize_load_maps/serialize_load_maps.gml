/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;

var n_maps = buffer_read(buffer, buffer_u16);

repeat (n_maps) {
	var map = instance_create_depth(0, 0, 0, DataMapContainer);
	map.version = version;
	serialize_load_generic(buffer, map, version);
	
	var size = buffer_read(buffer, buffer_u32);
	map.data_buffer = buffer_read_buffer(buffer, size);
	
	buffer_seek(map.data_buffer, buffer_seek_start, 0);
	
	buffer_read(map.data_buffer, buffer_datatype);
	// @todo when all of the map contents variables have been moved over to regular map
	//serialize_load_map_contents_meta(map.data_buffer, version, map);
	if (version < DataVersions.MAPS_NUKED) {
		buffer_read(map.data_buffer, buffer_string);
		buffer_read(map.data_buffer, buffer_string);
		buffer_read(map.data_buffer, buffer_string);
	}

	map.xx = buffer_read(map.data_buffer, buffer_u16);
	map.yy = buffer_read(map.data_buffer, buffer_u16);
	map.zz = buffer_read(map.data_buffer, buffer_u16);
	
	buffer_seek(map.data_buffer, buffer_seek_start, 0);
}

Stuff.active_map = guid_get(Stuff.game_starting_map);

serialize_load_current_map(Stuff.active_map, version);

uivc_select_autotile_refresh();