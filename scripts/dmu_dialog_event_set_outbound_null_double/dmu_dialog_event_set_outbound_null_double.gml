/// @param UIButton

var button = argument0;

var node = button.root.node;
var index = button.root.index;

event_connect_node(node, noone, index, true);

// the only difference between this and the normal version is that this
// destroys two dialogs instead of just one, since there will be two dialogs
// to destroy
dialog_destroy();
dialog_destroy();