/// @param buffer
/// @param EntityMeshAutotile

var buffer = argument0;
var entity = argument1;

serialize_save_entity_mesh(buffer, entity);

buffer_write(buffer, buffer_u8, entity.terrain_id);
buffer_write(buffer, buffer_u8, entity.terrain_type);