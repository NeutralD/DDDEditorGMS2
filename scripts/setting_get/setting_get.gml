/// @param object
/// @param name
/// @param default

var object = argument0;
var name = argument1;
var def = argument2;

var domain = Stuff.settings[? object];
if (domain) {
    if (ds_map_exists(domain, name)) {
        return domain[? name];
    }
    
    return def
}

show_error("Setting object not found: " + object, false);

return def;