event_inherited();

if (buffer_exists(buffer)) buffer_delete(buffer);
if (wbuffer) vertex_delete_buffer(wbuffer);
if (cshape) c_shape_destroy(cshape);

if (vbuffer) {
    switch (type) {
        case MeshTypes.RAW: vertex_delete_buffer(vbuffer); break;
        case MeshTypes.SMF: smf_model_destroy(vbuffer); break;
    }
}

ds_list_delete(Stuff.all_meshes, ds_list_find_index(Stuff.all_meshes, id));

ds_map_destroy(animations);