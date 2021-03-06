event_inherited();

save_script = serialize_save_entity_mesh;
load_script = serialize_load_entity_mesh;

name = "Mesh";
etype = ETypes.ENTITY_MESH;
etype_flags = ETypeFlags.ENTITY_MESH;

Stuff.map.active_map.contents.population[ETypes.ENTITY_MESH]++;

static = true;

mesh = 0;                           // GUID
mesh_submesh = 0;                   // proto-GUID
animated = false;
animation_index = 0;
animation_type = SMF_loop_linear;

// editor properties

slot = MapCellContents.MESHPAWN;
rotateable = true;
offsettable = true;
scalable = true;

batch = batch_mesh;
batch_collision = batch_collision_mesh;
render = render_mesh;
selector = select_single;
on_select_ui = safc_on_mesh_ui;