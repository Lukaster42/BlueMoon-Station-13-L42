#define CHALLENGE_TELECRYSTALS 280
#define PLAYER_SCALING 1.5
#define CHALLENGE_TIME_LIMIT 25000
#define CHALLENGE_PLAYERS_TARGET 25 //target players population. anything below is a malus to the challenge tc bonus.
#define TELECRYSTALS_MALUS_SCALING 1 //the higher the value, the bigger the malus.
#define CHALLENGE_SHUTTLE_DELAY 25000 // ¯\_(ツ)_/¯ minutes, so the ops have at least ¯\_(ツ)_/¯ minutes before the shuttle is callable.

GLOBAL_LIST_EMPTY(jam_on_wardec)
GLOBAL_VAR_INIT(war_declared, FALSE)

/obj/item/nuclear_challenge
	name = "Declaration of War (Challenge Mode)"
	icon = 'icons/obj/device.dmi'
	icon_state = "gangtool-red"
	item_state = "radio"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	desc = "Use to send a declaration of hostilities to the target, delaying your shuttle departure for 20 minutes while they prepare for your assault.  \
			Such a brazen move will attract the attention of powerful benefactors within the Syndicate, who will supply your team with a massive amount of bonus telecrystals.  \
			Must be used within five minutes, or your benefactors will lose interest."
	var/declaring_war = FALSE
	var/uplink_type = /obj/item/uplink/nuclear

/obj/item/nuclear_challenge/attack_self(mob/living/user)
	if(!check_allowed(user))
		return

	declaring_war = TRUE
	var/are_you_sure = alert(user, "Consult your team carefully before you declare war on [station_name()]]. Are you sure you want to alert the enemy crew? You have [DisplayTimeText(world.time-SSticker.round_start_time - CHALLENGE_TIME_LIMIT)] to decide", "Declare war?", "Yes", "No")
	declaring_war = FALSE

	if(!check_allowed(user))
		return

	if(are_you_sure == "No")
		to_chat(user, "On second thought, the element of surprise isn't so bad after all.")
		return

	var/war_declaration = "A syndicate fringe group has declared their intent to utterly destroy [station_name()] with a nuclear device, and dares the crew to try and stop them."

	declaring_war = TRUE
	var/custom_threat = alert(user, "Do you want to customize your declaration?", "Customize?", "Yes", "No")
	declaring_war = FALSE

	if(!check_allowed(user))
		return

	if(custom_threat == "Yes")
		declaring_war = TRUE
		war_declaration = stripped_input(user, "Insert your custom declaration", "Declaration")
		declaring_war = FALSE

	if(!check_allowed(user) || !war_declaration)
		return

	priority_announce(war_declaration, title = "Declaration of War", sound = 'sound/machines/alarm.ogg', has_important_message = TRUE)

	to_chat(user, "You've attracted the attention of powerful forces within the syndicate. A bonus bundle of telecrystals has been granted to your team. Great things await you if you complete the mission.")

	for(var/V in GLOB.syndicate_shuttle_boards)
		var/obj/item/circuitboard/computer/syndicate_shuttle/board = V
		board.challenge = TRUE

	for(var/obj/machinery/computer/camera_advanced/shuttle_docker/D in GLOB.jam_on_wardec)
		D.jammed = TRUE

	GLOB.war_declared = TRUE
	var/list/nukeops = get_antag_minds(/datum/antagonist/nukeop)
	var/actual_players = GLOB.joined_player_list.len - nukeops.len
	var/tc_malus = 0
	if(actual_players < CHALLENGE_PLAYERS_TARGET)
		tc_malus = FLOOR(((CHALLENGE_TELECRYSTALS / CHALLENGE_PLAYERS_TARGET) * (CHALLENGE_PLAYERS_TARGET - actual_players)) * TELECRYSTALS_MALUS_SCALING, 1)

	new uplink_type(get_turf(user), user.key, CHALLENGE_TELECRYSTALS - tc_malus + CEILING(PLAYER_SCALING * actual_players, 1))

	CONFIG_SET(number/shuttle_refuel_delay, max(CONFIG_GET(number/shuttle_refuel_delay), CHALLENGE_SHUTTLE_DELAY))
	SSblackbox.record_feedback("amount", "nuclear_challenge_mode", 1)

	qdel(src)

///Admin only proc to bypass checks and force a war declaration. Button on antag panel.
/obj/item/nuclear_challenge/proc/force_war()
	var/are_you_sure = tgui_alert(usr, "Are you sure you wish to force a war declaration?", "Declare war?", list("Yes", "No"))

	if(are_you_sure != "Yes")
		return

	var/war_declaration = "A syndicate fringe group has declared their intent to utterly destroy [station_name()] with a nuclear device, and dares the crew to try and stop them."

	var/custom_threat = tgui_alert(usr, "Do you want to customize the declaration?", "Customize?", list("Yes", "No"))

	if(custom_threat == "Yes")
		war_declaration = tgui_input_text(usr, "Insert your custom declaration", "Declaration", multiline = TRUE)

	if(!war_declaration)
		to_chat(usr, span_warning("Invalid war declaration."))
		return

	priority_announce(war_declaration, title = "Declaration of War", sound = 'sound/machines/alarm.ogg', has_important_message = TRUE)

	for(var/V in GLOB.syndicate_shuttle_boards)
		var/obj/item/circuitboard/computer/syndicate_shuttle/board = V
		board.challenge = TRUE

	for(var/obj/machinery/computer/camera_advanced/shuttle_docker/D in GLOB.jam_on_wardec)
		D.jammed = TRUE

	distribute_tc()

	CONFIG_SET(number/shuttle_refuel_delay, max(CONFIG_GET(number/shuttle_refuel_delay), CHALLENGE_SHUTTLE_DELAY))

	qdel(src)

/obj/item/nuclear_challenge/proc/distribute_tc(mob/living/user)
	var/list/orphans = list()
	var/list/uplinks = list()

	for (var/datum/mind/M in get_antag_minds(/datum/antagonist/nukeop))
		if (iscyborg(M.current))
			continue
		var/datum/component/uplink/uplink = M.find_syndicate_uplink()
		if (!uplink)
			orphans += M.current
			continue
		uplinks += uplink

	var/tc_to_distribute = CHALLENGE_TELECRYSTALS
	var/tc_per_nukie = round(tc_to_distribute / (length(orphans)+length(uplinks)))

	GLOB.war_declared = TRUE
	var/list/nukeops = get_antag_minds(/datum/antagonist/nukeop)
	var/actual_players = GLOB.joined_player_list.len - nukeops.len
	var/tc_malus = 0
	if(actual_players < CHALLENGE_PLAYERS_TARGET)
		tc_malus = FLOOR(((CHALLENGE_TELECRYSTALS / CHALLENGE_PLAYERS_TARGET) * (CHALLENGE_PLAYERS_TARGET - actual_players)) * TELECRYSTALS_MALUS_SCALING, 1)

	new uplink_type(get_turf(user), user.key, CHALLENGE_TELECRYSTALS - tc_malus + CEILING(PLAYER_SCALING * actual_players, 1))

	for (var/mob/living/L in orphans)
		var/TC = new /obj/item/stack/telecrystal(L.drop_location(), tc_per_nukie)
		to_chat(L, span_warning("Your uplink could not be found so your share of the team's bonus telecrystals has been bluespaced to your [L.put_in_hands(TC) ? "hands" : "feet"]."))
		tc_to_distribute -= tc_per_nukie

	if (tc_to_distribute > 0) // What shall we do with the remainder...
		for (var/mob/living/simple_animal/hostile/carp/cayenne/C in GLOB.mob_living_list)
			if (C.stat != DEAD)
				var/obj/item/stack/telecrystal/TC = new(C.drop_location(), tc_to_distribute)
				TC.throw_at(get_step(C, C.dir), 3, 3)
				C.visible_message(span_notice("[C] coughs up a half-digested telecrystal"),span_notice("You cough up a half-digested telecrystal!"))
				break

/obj/item/nuclear_challenge/proc/check_allowed(mob/living/user)
	if(declaring_war)
		to_chat(user, "You are already in the process of declaring war! Make your mind up.")
		return FALSE

	if(!user.onSyndieBase())
		to_chat(user, "You have to be at your base to use this.")
		return FALSE
	if(world.time-SSticker.round_start_time > CHALLENGE_TIME_LIMIT)
		to_chat(user, "It's too late to declare hostilities. Your benefactors are already busy with other schemes. You'll have to make do with what you have on hand.")
		return FALSE
	for(var/V in GLOB.syndicate_shuttle_boards)
		var/obj/item/circuitboard/computer/syndicate_shuttle/board = V
		if(board.moved)
			to_chat(user, "The shuttle has already been moved! You have forfeit the right to declare war.")
			return FALSE
	return TRUE

/obj/item/nuclear_challenge/clownops
	uplink_type = /obj/item/uplink/clownop

#undef CHALLENGE_TELECRYSTALS
#undef CHALLENGE_TIME_LIMIT
#undef CHALLENGE_PLAYERS_TARGET
#undef TELECRYSTALS_MALUS_SCALING
#undef CHALLENGE_SHUTTLE_DELAY
