/// @param UIInput

var input = argument0;

var list = Camera.selected_entities;

for (var i = 0; i < ds_list_size(list); i++) {
    var thing = list[| i];
    if (thing.rotateable) {        
        thing.rot_xx = real(input.value);
        thing.modification = Modifications.UPDATE;
        ds_list_add(Camera.changes, thing);
    }
}