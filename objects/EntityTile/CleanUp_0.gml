if (Stuff.is_quitting) exit;

event_inherited();

Stuff.map.active_map.contents.population[ETypes.ENTITY_TILE]--;
vertex_delete_buffer(vbuffer);
vertex_delete_buffer(wbuffer);