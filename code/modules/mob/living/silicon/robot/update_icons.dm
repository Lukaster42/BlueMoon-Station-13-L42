/// this is bad code
/mob/living/silicon/robot/update_icons()
	cut_overlays()
	icon_state = module.cyborg_base_icon
	//Citadel changes start here - Allows modules to use different icon files, and allows modules to specify a pixel offset
	icon = (module.cyborg_icon_override ? module.cyborg_icon_override : initial(icon))
	if(laser)
		add_overlay("laser")//Is this even used??? - Yes borg/inventory.dm
	if(disabler)
		add_overlay("disabler")//ditto

	if(sleeper_g && module.sleeper_overlay)
		add_overlay("[module.sleeper_overlay]_g[sleeper_nv ? "_nv" : ""]")
	if(sleeper_r && module.sleeper_overlay)
		add_overlay("[module.sleeper_overlay]_r[sleeper_nv ? "_nv" : ""]")
	if(stat == DEAD && module.has_snowflake_deadsprite)
		icon_state = "[module.cyborg_base_icon]-wreck"

	if(module.cyborg_pixel_offset)
		var/matrix/M = transform
		M.c = module.cyborg_pixel_offset
		transform = M
	//End of citadel changes

	if(module.cyborg_base_icon == "robot")
		icon = 'icons/mob/robots.dmi'
		var/matrix/M = transform
		M.c = 0 // Cyborg's initial x offset is very likely to be 0
		transform = M
	if(stat != DEAD && !(IsUnconscious() || IsStun() || IsParalyzed() || low_power_mode)) //Not dead, not stunned.
		if(!eye_lights)
			eye_lights = new()
		if(lamp_enabled || lamp_doom)
			eye_lights.icon_state = "[module.special_light_key ? "[module.special_light_key]":"[module.cyborg_base_icon]"]_l"
			eye_lights.color = lamp_doom? COLOR_RED : lamp_color
			eye_lights.plane = 19 //glowy eyes
		else
			eye_lights.icon_state = "[module.special_light_key ? "[module.special_light_key]":"[module.cyborg_base_icon]"]_e[is_servant_of_ratvar(src) ? "_r" : ""]"
			eye_lights.color = COLOR_WHITE
			eye_lights.plane = -1
		eye_lights.icon = icon
		add_overlay(eye_lights)

	if(opened)
		if(wiresexposed)
			add_overlay("ov-opencover +w")
		else if(cell)
			add_overlay("ov-opencover +c")
		else
			add_overlay("ov-opencover -c")
	if(hat)
		var/mutable_appearance/head_overlay = hat.build_worn_icon(default_layer = 20, default_icon_file = 'icons/mob/clothing/head.dmi', override_state = hat.icon_state)
		head_overlay.pixel_y += hat_offset
		add_overlay(head_overlay)
	update_fire()

	if(client && stat != DEAD && module.dogborg == TRUE)
		if(resting)
			if(sitting)
				icon_state = "[module.cyborg_base_icon]-sit"
			if(bellyup)
				icon_state = "[module.cyborg_base_icon]-bellyup"
			else if(!sitting && !bellyup)
				icon_state = "[module.cyborg_base_icon]-rest"
			cut_overlays()
		else
			icon_state = "[module.cyborg_base_icon]"

	if(client && stat != DEAD && module.canrest == TRUE)	//For the new borgs who are not dogs
		if(resting)
			if(sitting)
				icon_state = "[module.cyborg_base_icon]-sit"
			else if(!sitting)
				icon_state = "[module.cyborg_base_icon]-rest"
			cut_overlays()
		else
			icon_state = "[module.cyborg_base_icon]"
	SEND_SIGNAL(src, COMSIG_ROBOT_UPDATE_ICONS)
