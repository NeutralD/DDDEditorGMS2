/// @param v0
/// @param v1
/// @param f

// ease (co)sine out

// weird arguments but they match the format used by http://www.gizma.com/easing
var t = argument2;
var b = argument0;
var c = argument1 - argument0;

return c * sin(t * (pi / 2)) + b;