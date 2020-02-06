if (Stuff.is_quitting) exit;

event_inherited();

for (var i = 0; i < ds_list_size(batches); i++) {
    vertex_delete_buffer(batches[| i]);
    vertex_delete_buffer(batches_wire[| i]);
}

ds_list_destroy(batches);
ds_list_destroy(batches_wire);

// don't actually delete the instances from here or bad things will happen
ds_list_destroy(batch_instances);
ds_list_destroy(batch_in_the_future);
ds_list_destroy(dynamic);

// the last three lists are not guaranteed to have all
// entities in the map in them. this one is.
ds_list_destroy_instances(all_entities);
ds_list_destroy_instances(all_camera_zones);
ds_map_destroy(all_refids);

ds_grid_destroy(map_grid);

if (frozen) vertex_delete_buffer(frozen);
if (frozen_wire) vertex_delete_buffer(frozen_wire);
buffer_delete(frozen_data);
buffer_delete(frozen_data_wire);

for (var i = 0; i < array_length_1d(mesh_autotile_raw); i++) {
    if (mesh_autotile_raw[i]) {
        buffer_delete(mesh_autotile_raw[i]);
        vertex_delete_buffer(mesh_autotiles[i]);
    }
}