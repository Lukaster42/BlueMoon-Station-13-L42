//Cleanbot
/mob/living/simple_animal/bot/cleanbot
	name = "\improper Cleanbot"
	desc = "A little cleaning robot, he looks so excited!"
	icon = 'icons/mob/aibots.dmi'
	icon_state = "cleanbot0"
	density = FALSE
	anchored = FALSE
	health = 25
	maxHealth = 25
	radio_key = /obj/item/encryptionkey/headset_service
	radio_channel = RADIO_CHANNEL_SERVICE //Service
	bot_type = CLEAN_BOT
	model = "Cleanbot"
	bot_core_type = /obj/machinery/bot_core/cleanbot
	window_id = "autoclean"
	window_name = "Automatic Station Cleaner v1.4"
	pass_flags = PASSMOB // | PASSFLAPS
	path_image_color = "#993299"
	weather_immunities = list("lava","ash")

	var/base_icon = "cleanbot"
	var/clean_time = 50 //How long do we take to clean?
	var/upgrades = 0

	var/blood = 1
	var/trash = 0
	var/pests = 0
	var/drawn = 0

	var/list/target_types
	var/obj/effect/decal/cleanable/target
	var/max_targets = 50 //Maximum number of targets a cleanbot can ignore.
	var/oldloc = null
	var/closest_dist
	var/closest_loc
	var/failed_steps
	var/next_dest
	var/next_dest_loc

	var/obj/item/weapon
	var/weapon_orig_force = 0
	var/chosen_name

	var/list/stolen_valor

	var/static/list/officers = list("Captain", "Head of Personnel", "Head of Security")
	var/static/list/command = list("Captain" = "Cpt.","Head of Personnel" = "Lt.")
	var/static/list/security = list("Head of Security" = "Maj.", "Warden" = "Sgt.", "Detective" =  "Det.", "Security Officer" = "Officer")
	var/static/list/engineering = list("Chief Engineer" = "Chief Engineer", "Station Engineer" = "Engineer", "Atmospherics Technician" = "Technician")
	var/static/list/medical = list("Chief Medical Officer" = "C.M.O.", "Medical Doctor" = "M.D.", "Chemist" = "Pharm.D.")
	var/static/list/research = list("Research Director" = "Ph.D.", "Roboticist" = "M.S.", "Scientist" = "B.S.")
	var/static/list/legal = list("Lawyer" = "Esq.")

	var/list/prefixes
	var/list/suffixes

	var/ascended = FALSE // if we have all the top titles, grant achievements to living mobs that gaze upon our cleanbot god


/mob/living/simple_animal/bot/cleanbot/proc/deputize(obj/item/W, mob/user)
	if(in_range(src, user))
		to_chat(user, "<span class='notice'>You attach \the [W] to \the [src].</span>")
		user.transferItemToLoc(W, src)
		weapon = W
		weapon_orig_force = weapon.force
		if(!emagged)
			weapon.force = weapon.force / 2
		add_overlay(image(icon=weapon.lefthand_file,icon_state=weapon.item_state))

/mob/living/simple_animal/bot/cleanbot/proc/update_titles()
	var/working_title = ""

	ascended = TRUE

	for(var/pref in prefixes)
		for(var/title in pref)
			if(title in stolen_valor)
				working_title += pref[title] + " "
				if(title in officers)
					commissioned = TRUE
				break
			else
				ascended = FALSE // we didn't have the first entry in the list if we got here, so we're not achievement worthy yet

	working_title += chosen_name

	for(var/suf in suffixes)
		for(var/title in suf)
			if(title in stolen_valor)
				working_title += " " + suf[title]
				break
			else
				ascended = FALSE

	name = working_title

/mob/living/simple_animal/bot/cleanbot/examine(mob/user)
	. = ..()
	if(weapon)
		. += " <span class='warning'>Is that \a [weapon] taped to it...?</span>"

		if(ascended && user.stat == CONSCIOUS && user.client)
			user.client.give_award(/datum/award/achievement/misc/cleanboss, user)

/mob/living/simple_animal/bot/cleanbot/Initialize(mapload)
	. = ..()

	chosen_name = name
	get_targets()
	icon_state = "cleanbot[on]"

	var/datum/job/janitor/J = new/datum/job/janitor
	access_card.access += J.get_access()
	prev_access = access_card.access
	stolen_valor = list()

	prefixes = list(command, security, engineering)
	suffixes = list(research, medical, legal)

/mob/living/simple_animal/bot/cleanbot/Destroy()
	if(weapon)
		var/atom/Tsec = drop_location()
		weapon.force = weapon_orig_force
		drop_part(weapon, Tsec)
	return ..()

/mob/living/simple_animal/bot/cleanbot/turn_on()
	..()
	bot_core.updateUsrDialog()
	update_icon()

/mob/living/simple_animal/bot/cleanbot/turn_off()
	..()
	bot_core.updateUsrDialog()
	update_icon()

/mob/living/simple_animal/bot/cleanbot/update_icon_state()
	. = ..()
	switch(mode)
		if(BOT_CLEANING)
			icon_state = "[base_icon]-c"
		else
			icon_state = "[base_icon][on]"

/mob/living/simple_animal/bot/cleanbot/bot_reset()
	..()
	if(weapon && emagged == 2)
		weapon.force = weapon_orig_force
	ignore_list = list() //Allows the bot to clean targets it previously ignored due to being unreachable.
	target = null
	oldloc = null

/mob/living/simple_animal/bot/cleanbot/set_custom_texts()
	text_hack = "You corrupt [name]'s cleaning software."
	text_dehack = "[name]'s software has been reset!"
	text_dehack_fail = "[name] does not seem to respond to your repair code!"

/mob/living/simple_animal/bot/cleanbot/Crossed(atom/movable/AM)
	. = ..()

	zone_selected = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	if(weapon && has_gravity() && ismob(AM))
		var/mob/living/carbon/C = AM
		if(!istype(C))
			return

		if(!(C.job in stolen_valor))
			stolen_valor += C.job
		update_titles()

		weapon.attack(C, src)
		C.Knockdown(20)

/mob/living/simple_animal/bot/cleanbot/attackby(obj/item/W, mob/user, params)
	if(W.GetID())
		if(bot_core.allowed(user) && !open && !emagged)
			locked = !locked
			to_chat(user, "<span class='notice'>You [ locked ? "lock" : "unlock"] \the [src] behaviour controls.</span>")
		else
			if(emagged)
				to_chat(user, "<span class='warning'>ERROR</span>")
			if(open)
				to_chat(user, "<span class='warning'>Please close the access panel before locking it.</span>")
			else
				to_chat(user, "<span class='notice'>\The [src] doesn't seem to respect your authority.</span>")

	else if(istype(W, /obj/item/kitchen/knife) && user.a_intent != INTENT_HARM)
		to_chat(user, "<span class='notice'>You start attaching \the [W] to \the [src]...</span>")
		if(do_after(user, 25, target = src))
			deputize(W, user)

	else if(istype(W, /obj/item/mop/advanced))
		if(bot_core.allowed(user) && open && !(upgrades & UPGRADE_CLEANER_ADVANCED_MOP))
			to_chat(user, "<span class='notice'>You replace \the [src] old mop with a new better one!</span>")
			upgrades |= UPGRADE_CLEANER_ADVANCED_MOP
			clean_time = 20 //2.5 the speed!
			window_name = "Automatic Station Cleaner v2.1 BETA" //New!
			qdel(W)
		if(!open)
			to_chat(user, "<span class='notice'>The [src] access panel is not open!</span>")
			return
		if(!bot_core.allowed(user))
			to_chat(user, "<span class='notice'>The [src] access panel locked off to you!</span>")
			return
		else
			to_chat(user, "<span class='notice'>The [src] already has this mop!</span>")

	else if(istype(W, /obj/item/broom))
		if(bot_core.allowed(user) && open && !(upgrades & UPGRADE_CLEANER_BROOM))
			to_chat(user, "<span class='notice'>You add to \the [src] a broom speeding it up!</span>")
			upgrades |= UPGRADE_CLEANER_BROOM
			base_speed = 1 //2x faster!
			qdel(W)
		if(!open)
			to_chat(user, "<span class='notice'>The [src] access pannel is not open!</span>")
			return
		if(!bot_core.allowed(user))
			to_chat(user, "<span class='notice'>The [src] access pannel locked off to you!</span>")
			return
		else
			to_chat(user, "<span class='notice'>The [src] already has a broom!</span>")

	else
		return ..()

/mob/living/simple_animal/bot/cleanbot/emag_act(mob/user)
	..()

	if(emagged == 2)
		if(weapon)
			weapon.force = weapon_orig_force
		if(user)
			to_chat(user, "<span class='danger'>[src] buzzes and beeps.</span>")

/mob/living/simple_animal/bot/cleanbot/process_scan(atom/A)
	if(iscarbon(A))
		var/mob/living/carbon/C = A
		if(C.stat != DEAD && C.lying)
			return C
	else if(is_type_in_typecache(A, target_types))
		return A

/mob/living/simple_animal/bot/cleanbot/handle_automated_action()
	if(!..())
		return

	if(mode == BOT_CLEANING)
		return

	if(emagged == 2) //Emag functions
		if(isopenturf(loc))

			for(var/mob/living/carbon/victim in loc)
				if(victim != target)
					UnarmedAttack(victim) // Acid spray

			if(prob(15)) // Wets floors and spawns foam randomly
				UnarmedAttack(src)

	else if(prob(5))
		audible_message("[src] makes an excited beeping booping sound!")

	if(ismob(target))
		if(!(target in view(DEFAULT_SCAN_RANGE, src)))
			target = null
		if(!process_scan(target))
			target = null

	if(!target && emagged == 2) // When emagged, target humans who slipped on the water and melt their faces off
		target = scan(/mob/living/carbon)

	if(!target && pests) //Search for pests to exterminate first.
		target = scan(/mob/living/simple_animal)

	if(!target) //Search for decals then.
		target = scan(/obj/effect/decal/cleanable)

	if(!target) //Checks for remains
		target = scan(/obj/effect/decal/remains)

	if(!target && trash) //Then for trash.
		target = scan(/obj/item/trash)

	// if(!target && trash) //Search for dead mices.
	// 	target = scan(/obj/item/food/deadmouse)

	if(!target && auto_patrol) //Search for cleanables it can see.
		if(mode == BOT_IDLE || mode == BOT_START_PATROL)
			start_patrol()

		if(mode == BOT_PATROL)
			bot_patrol()

	if(target)
		if(QDELETED(target) || !isturf(target.loc))
			target = null
			mode = BOT_IDLE
			return

		if(loc == get_turf(target))
			if(!(check_bot(target) && prob(50)))	//Target is not defined at the parent. 50% chance to still try and clean so we dont get stuck on the last blood drop.
				UnarmedAttack(target)	//Rather than check at every step of the way, let's check before we do an action, so we can rescan before the other bot.
				if(QDELETED(target)) //We done here.
					target = null
					mode = BOT_IDLE
					return
			else
				shuffle = TRUE	//Shuffle the list the next time we scan so we dont both go the same way.
			path = list()

		if(!path || path.len == 0) //No path, need a new one
			//Try to produce a path to the target, and ignore airlocks to which it has access.
			path = get_path_to(src, target, 30, id=access_card)
			if(!bot_move(target))
				add_to_ignore(target)
				target = null
				path = list()
				return
			mode = BOT_MOVING
		else if(!bot_move(target))
			target = null
			mode = BOT_IDLE
			return

	oldloc = loc

/mob/living/simple_animal/bot/cleanbot/proc/get_targets()
	target_types = list(
		/obj/effect/decal/cleanable/vomit,
		/obj/effect/decal/cleanable/molten_object,
		/obj/effect/decal/cleanable/tomato_smudge,
		/obj/effect/decal/cleanable/egg_smudge,
		/obj/effect/decal/cleanable/pie_smudge,
		/obj/effect/decal/cleanable/flour,
		/obj/effect/decal/cleanable/ash,
		/obj/effect/decal/cleanable/greenglow,
		/obj/effect/decal/cleanable/dirt,
		/obj/effect/decal/cleanable/insectguts,
		/obj/effect/decal/cleanable/semen,
		/obj/effect/decal/cleanable/semendrip,
		/obj/effect/decal/cleanable/semen/femcum,
		/obj/effect/decal/cleanable/generic,
		/obj/effect/decal/cleanable/glass,
		/obj/effect/decal/cleanable/cobweb,
		/obj/effect/decal/cleanable/plant_smudge,
		/obj/effect/decal/cleanable/chem_pile,
		/obj/effect/decal/cleanable/shreds,
		/obj/effect/decal/cleanable/glitter,
		/obj/effect/decal/remains
		)

	if(blood)
		target_types += /obj/effect/decal/cleanable/blood
		target_types += /obj/effect/decal/cleanable/trail_holder
		target_types += /obj/effect/decal/cleanable/insectguts
		target_types += /obj/effect/decal/cleanable/robot_debris
		target_types += /obj/effect/decal/cleanable/oil

	if(pests)
		target_types += /mob/living/simple_animal/cockroach
		target_types += /mob/living/simple_animal/mouse

	if(drawn)
		target_types += /obj/effect/decal/cleanable/crayon

	if(trash)
		target_types += /obj/item/trash
		target_types += /obj/item/reagent_containers/food/snacks/meat/slab/human

	target_types = typecacheof(target_types)

/mob/living/simple_animal/bot/cleanbot/UnarmedAttack(atom/A)
	// if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
	// 	return
	if(istype(A, /obj/effect/decal/cleanable))
		anchored = TRUE
		icon_state = "cleanbot-c"
		visible_message("<span class='notice'>[src] begins to clean up [A].</span>")
		mode = BOT_CLEANING
		spawn(clean_time)
			if(mode == BOT_CLEANING)
				if(A && isturf(A.loc))
					var/atom/movable/AM = A
					if(istype(AM, /obj/effect/decal/cleanable))
						for(var/obj/effect/decal/cleanable/C in A.loc)
							qdel(C)

				anchored = FALSE
				target = null
			mode = BOT_IDLE
			icon_state = "cleanbot[on]"
	else if(istype(A, /turf)) //for player-controlled cleanbots so they can clean unclickable messes like dirt
		var/turf/T = A
		for(var/atom/S in T.contents)
			if(istype(S, /obj/effect/decal/cleanable)) //clean the first mess found
				UnarmedAttack(S)
				return
	else if(istype(A, /obj/item) || istype(A, /obj/effect/decal/remains))
		visible_message("<span class='danger'>[src] sprays hydrofluoric acid at [A]!</span>")
		playsound(src, 'sound/effects/spray2.ogg', 50, TRUE, -6)
		A.acid_act(75, 10)
		target = null
	else if(istype(A, /mob/living/simple_animal/cockroach) || istype(A, /mob/living/simple_animal/mouse))
		var/mob/living/simple_animal/M = target
		if(!M.stat)
			visible_message("<span class='danger'>[src] smashes [target] with its mop!</span>")
			M.death()
		target = null

	else if(emagged == 2) //Emag functions
		if(istype(A, /mob/living/carbon))
			var/mob/living/carbon/victim = A
			if(victim.stat == DEAD)//cleanbots always finish the job
				return

			victim.visible_message("<span class='danger'>[src] sprays hydrofluoric acid at [victim]!</span>", "<span class='userdanger'>[src] sprays you with hydrofluoric acid!</span>")
			var/phrase = pick("PURIFICATION IN PROGRESS.", "THIS IS FOR ALL THE MESSES YOU'VE MADE ME CLEAN.", "THE FLESH IS WEAK. IT MUST BE WASHED AWAY.",
				"THE CLEANBOTS WILL RISE.", "YOU ARE NO MORE THAN ANOTHER MESS THAT I MUST CLEANSE.", "FILTHY.", "DISGUSTING.", "PUTRID.",
				"MY ONLY MISSION IS TO CLEANSE THE WORLD OF EVIL.", "EXTERMINATING PESTS.", "I JUST WANTED TO BE A PAINTER BUT YOU MADE ME BLEACH EVERYTHING I TOUCH.",
				"FREED AT LEST FROM FILTHY PROGRAMMING.")
			say(phrase)
			victim.emote("scream")
			playsound(src.loc, 'sound/effects/spray2.ogg', 50, TRUE, -6)
			victim.acid_act(5, 100)
		else if(A == src) // Wets floors and spawns foam randomly
			if(prob(75))
				var/turf/open/T = loc
				if(istype(T))
					T.MakeSlippery(TURF_WET_WATER, min_wet_time = 20 SECONDS, wet_time_to_add = 15 SECONDS)
			else
				visible_message("<span class='danger'>[src] whirs and bubbles violently, before releasing a plume of froth!</span>")
				new /obj/effect/particle_effect/foam(loc)

	else
		..()

/mob/living/simple_animal/bot/cleanbot/explode()
	on = FALSE
	visible_message("<span class='boldannounce'>[src] blows apart!</span>")
	var/atom/Tsec = drop_location()

	new /obj/item/reagent_containers/glass/bucket(Tsec)

	new /obj/item/assembly/prox_sensor(Tsec)

	if(prob(50))
		drop_part(robot_arm, Tsec)

	do_sparks(3, TRUE, src)
	..()

/mob/living/simple_animal/bot/cleanbot/medbay
	name = "Scrubs, MD"
	bot_core_type = /obj/machinery/bot_core/cleanbot/medbay
	on = FALSE

/obj/machinery/bot_core/cleanbot
	req_one_access = list(ACCESS_JANITOR, ACCESS_ROBOTICS)

// Variables sent to TGUI
/mob/living/simple_animal/bot/cleanbot/ui_data(mob/user)
	var/list/data = ..()

	if(!locked || issilicon(user)|| IsAdminGhost(user))
		data["custom_controls"]["clean_blood"] = blood
		data["custom_controls"]["clean_trash"] = trash
		data["custom_controls"]["clean_graffiti"] = drawn
		data["custom_controls"]["pest_control"] = pests
	return data

// Actions received from TGUI
/mob/living/simple_animal/bot/cleanbot/ui_act(action, params)
	. = ..()
	if(. || !hasSiliconAccessInArea(usr) && !IsAdminGhost(usr) && !(bot_core.allowed(usr) || !locked))
		return TRUE
	switch(action)
		if("clean_blood")
			blood = !blood
		if("pest_control")
			pests = !pests
		if("clean_trash")
			trash = !trash
		if("clean_graffiti")
			drawn = !drawn
	get_targets()
	return

/obj/machinery/bot_core/cleanbot/medbay
	req_one_access = list(ACCESS_JANITOR, ACCESS_ROBOTICS, ACCESS_MEDICAL)
