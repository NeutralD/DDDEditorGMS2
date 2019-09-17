/// @param x
/// @param y
/// @param DataEventNode

var xx = argument0;
var yy = argument1;
var node = argument2;

draw_sprite(spr_event_delete, 0, xx, yy);

if (!dialog_exists()) {
    var tolerance = 8;
    if (mouse_within_rectangle_adjusted(xx - tolerance, yy - tolerance, xx + tolerance, yy + tolerance)) {
        draw_sprite(spr_event_delete, 1, xx, yy);
        if (Controller.release_left) {
            if (show_question("Delete?")) {
                instance_destroy_later(node);
            }
        }
    }
}