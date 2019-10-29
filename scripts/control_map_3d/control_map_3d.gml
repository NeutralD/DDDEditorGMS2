if (Camera.menu.active_element) {
	return false;
}

var mouse_vector = update_mouse_vector(x, y, z, xto, yto, zto, xup, yup, zup, fov, CW / CH);

var xx = mouse_vector[vec3.xx] * MILLION;
var yy = mouse_vector[vec3.yy] * MILLION;
var zz = mouse_vector[vec3.zz] * MILLION;

if (c_raycast_world(x, y, z, x + xx, y + yy, z + zz, CollisionMasks.MAIN)) {
    under_cursor = c_object_get_userid(c_hit_object(0));
} else {
    under_cursor = noone;
}

var floor_x = -1;
var floor_y = -1;
var floor_cx = -1;
var floor_cy = -1;

if (zz < z) {
	var f = abs(z / zz);
	floor_x = x + xx * f;
	floor_y = y + yy * f;
    
	// the bounds on this are weird - in some places the cell needs to be rounded up and in others it
	// needs to be rounded down, so the minimum allowed "cell" is (-1, -1) - be sure to max() this later
	// if it would cause issues
	floor_cx = clamp(floor_x div TILE_WIDTH, -1, Stuff.active_map.xx - 1);
	floor_cy = clamp(floor_y div TILE_HEIGHT, -1, Stuff.active_map.yy - 1);
    
	if (Controller.press_left) {
		if (ds_list_size(selection) < MAX_SELECTION_COUNT) {
		    if (!keyboard_check(input_selection_add) && !selection_addition) {
		        selection_clear();
		    }
		    switch (selection_mode) {
		        case SelectionModes.SINGLE: var stype = SelectionSingle; break;
		        case SelectionModes.RECTANGLE: var stype = SelectionRectangle; break;
		        case SelectionModes.CIRCLE: var stype = SelectionCircle; break;
		    }
			
		    var tz = under_cursor ? under_cursor.zz : 0;
        
		    last_selection = instance_create_depth(0, 0, 0, stype);
		    ds_list_add(selection, last_selection);
		    script_execute(last_selection.onmousedown, last_selection, max(0, floor_cx), max(0, floor_cy), tz);
		}
	}
	if (Controller.mouse_left) {
		if (last_selection) {
		    script_execute(last_selection.onmousedrag, last_selection, floor_cx + 1, floor_cy + 1);
		}
	}
	if (Controller.release_left) {
		// selections of zero area are just deleted outright
		if (last_selection) {
		    if (script_execute(last_selection.area, last_selection) == 0) {
		        instance_activate_object(last_selection);
		        instance_destroy(last_selection);
		        ds_list_pop(selection);
		        last_selection = noone;
		        sa_process_selection();
		    }
		}
	}
}

if (keyboard_check_pressed(vk_space)) {
	sa_fill();
}
if (keyboard_check_pressed(vk_delete)) {
	sa_delete();
}

// move the camera

if (!keyboard_check(vk_control)) {
	var mspd = (min(log10(max(abs(z), 1)) * 4, 320) + 1) / Stuff.dt;
	var xspeed = 0;
	var yspeed = 0;
	var zspeed = 0;
    
	if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
	    xspeed = xspeed + dcos(direction) * mspd * Stuff.dt;
	    yspeed = yspeed - dsin(direction) * mspd * Stuff.dt;
	    zspeed = zspeed - dsin(pitch) * mspd * Stuff.dt;
	}
	if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
	    xspeed = xspeed - dcos(direction) * mspd * Stuff.dt;
	    yspeed = yspeed + dsin(direction) * mspd * Stuff.dt;
	    zspeed = zspeed + dsin(pitch) * mspd * Stuff.dt;
	}
	if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
	    xspeed = xspeed - dsin(direction) * mspd * Stuff.dt;
	    yspeed = yspeed - dcos(direction) * mspd * Stuff.dt;
	}
	if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
	    xspeed = xspeed + dsin(direction) * mspd * Stuff.dt;
	    yspeed = yspeed + dcos(direction) * mspd * Stuff.dt;
	}
	if (Controller.mouse_right) {
		var camera_cx = view_get_xport(view_current) + view_get_wport(view_current) / 2;
		var camera_cy = view_get_yport(view_current) + view_get_hport(view_current) / 2;
		var dx = (MOUSE_X - camera_cx) / 16;
		var dy = (MOUSE_Y - camera_cy) / 16;
		direction = (360 + direction - dx) % 360;
		pitch = clamp(pitch + dy, -89, 89);
		window_mouse_set(camera_cx, camera_cy);
		xto = x + dcos(direction);
		yto = y - dsin(direction);
		zto = z - dsin(pitch);
	}
    
	x += xspeed;
	y += yspeed;
	z += zspeed;
	xto += xspeed;
	yto += yspeed;
	zto += zspeed;
	xup = 0;
	yup = 0;
	zup = 1;
} else {
	if (Controller.press_right) {
		Controller.press_right = false;
		// if there is no selection, select the single square under the cursor. Otherwise you might
		// want to do operations on large swaths of entities, so don't clear it or anythign like that.
		
		if (selection_empty()) {
	        var tz = under_cursor ? under_cursor.zz : 0;
	        last_selection = instance_create_depth(0, 0, 0, SelectionSingle);
	        ds_list_add(selection, last_selection);
	        script_execute(last_selection.onmousedown, last_selection, floor_cx, floor_cy, tz);
		}
		
		var menu = Camera.menu.menu_right_click;
		menu_activate_extra(menu);
		menu.x = Camera.MOUSE_X;
		menu.y = Camera.MOUSE_Y;
	}
}