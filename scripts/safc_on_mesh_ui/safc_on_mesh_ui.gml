/// @param EntityMesh

var mesh = argument0;

safc_on_entity_ui(mesh);

Stuff.map.ui.element_entity_mesh_animated.value = mesh.animated;
Stuff.map.ui.element_entity_mesh_animated.interactive = true;

Stuff.map.ui.element_entity_mesh_autotile_data.interactive = instanceof(mesh, EntityMeshAutotile);