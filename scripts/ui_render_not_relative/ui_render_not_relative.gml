/// @param UIThing
/// @param x
/// @param y
// this is mainly so that tabs don't draw their contents relative to their own position
// in the row, but you can use it for other things too

var thing = argument0;
var xx = argument1;
var yy = argument2;

var str = "";
for (var i = 0; i < ds_list_size(thing.contents); i++) {
    var what = thing.contents[| i];
    if (what.enabled) {
        script_execute(what.render, what, xx, yy);
    }
}