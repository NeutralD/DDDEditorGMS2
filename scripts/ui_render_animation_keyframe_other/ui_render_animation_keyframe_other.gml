/// @param UIButton
/// @param x
/// @param y

var button = argument0;
var xx = argument1;
var yy = argument2;

var animation = button.root.root.active_animation;
var timeline = button.root.root.el_timeline;
var timeline_layer = ui_list_selection(button.root.root.el_layers);
var keyframe = (timeline_layer == noone) ? noone : animation_get_keyframe(animation, timeline_layer, timeline.playing_moment);

// we must abuse truthiness wherever possible
button.interactive = (keyframe && true);

ui_render_button(button, xx, yy);