/// @param UIButton

var button = argument[0];
var datadata = button.root.selected_data;

if (ds_list_size(datadata.properties) < 1000) {
    var property = instance_create_depth(0, 0, 0, DataProperty);
    property.name = "Property" + string(ds_list_size(datadata.properties));
    ds_list_add(datadata.properties, property);
    ui_list_deselect(button.root.el_list_p);
    instance_deactivate_object(property);
    button.root.selected_property = noone;
    
    button.root.changed = true;
    
    dialog_data_type_disable(button.root);
    
    button.root.el_data_name.interactive = true;
    button.root.el_add_p.interactive = true;
    button.root.el_remove_p.interactive = true;
} else {
    dialog_create_notice(button.root, "Please don't try to create more than a thousand properties on a single data type. Bad things will happen.", "Hey!");
}