/// @description void omu_mr_play_se(UIThing);
/// @param UIThing

if (ds_list_size(argument0.root.route.steps)<255) {
    ds_list_add(argument0.root.route.steps, [MoveRouteActions.PLAY_SE, 0]);
}
