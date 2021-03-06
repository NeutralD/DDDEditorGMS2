/// @description smf_quadratic_bezier(a, b, c, amount)
/// @param a
/// @param b
/// @param c
/// @param amount

var a = argument0;
var b = argument1;
var c = argument2;
var amount = argument3;

return (sqr(1 - amount) * (a + b) + sqr(amount) * (b + c)) / 2 + 2 * amount * (1 - amount) * b;