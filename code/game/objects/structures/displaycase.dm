/obj/structure/displaycase
	name = "display case"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "glassbox0"
	desc = "A display case for prized possessions."
	density = TRUE
	anchored = TRUE
	resistance_flags = ACID_PROOF
	armor = list(MELEE = 30, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 10, BIO = 0, RAD = 0, FIRE = 70, ACID = 100)
	max_integrity = 200
	integrity_failure = 0.25
	attack_hand_speed = CLICK_CD_MELEE
	attack_hand_is_action = TRUE
	var/obj/item/showpiece = null
	var/alert = TRUE
	var/open = FALSE
	var/openable = TRUE
	var/obj/item/electronics/airlock/electronics
	var/start_showpiece_type = null //add type for items on display
	var/list/start_showpieces = list() //Takes sublists in the form of list("type" = /obj/item/bikehorn, "trophy_message" = "henk")
	var/trophy_message = ""

/obj/structure/displaycase/Initialize(mapload)
	. = ..()
	if(start_showpieces.len && !start_showpiece_type)
		var/list/showpiece_entry = pick(start_showpieces)
		if (showpiece_entry && showpiece_entry["type"])
			start_showpiece_type = showpiece_entry["type"]
			if (showpiece_entry["trophy_message"])
				trophy_message = showpiece_entry["trophy_message"]
	if(start_showpiece_type)
		showpiece = new start_showpiece_type (src)
	update_icon()

/obj/structure/displaycase/Destroy()
	if(electronics)
		QDEL_NULL(electronics)
	if(showpiece)
		QDEL_NULL(showpiece)
	return ..()

/obj/structure/displaycase/examine(mob/user)
	. = ..()
	if(alert)
		. += "<span class='notice'>Hooked up with an anti-theft system.</span>"
	if(showpiece)
		. += "<span class='notice'>There's [showpiece] inside.</span>"
	if(trophy_message)
		. += "The plaque reads:"
		. += trophy_message


/obj/structure/displaycase/proc/dump()
	if (showpiece)
		showpiece.forceMove(loc)
		showpiece = null

/obj/structure/displaycase/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			playsound(src.loc, 'sound/effects/glasshit.ogg', 75, 1)
		if(BURN)
			playsound(src.loc, 'sound/items/welder.ogg', 100, 1)

/obj/structure/displaycase/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		dump()
		if(!disassembled)
			new /obj/item/shard( src.loc )
			trigger_alarm()
	qdel(src)

/obj/structure/displaycase/obj_break(damage_flag)
	if(!broken && !(flags_1 & NODECONSTRUCT_1))
		density = FALSE
		broken = 1
		new /obj/item/shard( src.loc )
		playsound(src, "shatter", 70, 1)
		update_icon()
		trigger_alarm()

/obj/structure/displaycase/proc/trigger_alarm()
	//Activate Anti-theft
	if(alert)
		var/area/alarmed = get_base_area(src)
		alarmed.burglaralert(src)
		playsound(src, 'sound/effects/alert.ogg', 50, 1)

/obj/structure/displaycase/update_icon_state()
	var/icon/I
	if(open)
		I = icon('icons/obj/stationobjs.dmi',"glassbox_open")
	else
		I = icon('icons/obj/stationobjs.dmi',"glassbox0")
	if(broken)
		I = icon('icons/obj/stationobjs.dmi',"glassboxb0")
	if(showpiece)
		var/icon/S = getFlatIcon(showpiece)
		S.Scale(17,17)
		I.Blend(S,ICON_UNDERLAY,8,8)
	src.icon = I
	return

/obj/structure/displaycase/attackby(obj/item/W, mob/user, params)
	if(W.GetID() && !broken && openable)
		if(allowed(user))
			to_chat(user,  "<span class='notice'>You [open ? "close":"open"] [src].</span>")
			toggle_lock(user)
		else
			to_chat(user,  "<span class='warning'>Access denied.</span>")
	else if(W.tool_behaviour == TOOL_WELDER && user.a_intent == INTENT_HELP && !broken)
		if(obj_integrity < max_integrity)
			if(!W.tool_start_check(user, amount=5))
				return

			to_chat(user, "<span class='notice'>You begin repairing [src].</span>")
			if(W.use_tool(src, user, 40, amount=5, volume=50))
				obj_integrity = max_integrity
				update_icon()
				to_chat(user, "<span class='notice'>You repair [src].</span>")
		else
			to_chat(user, "<span class='warning'>[src] is already in good condition!</span>")
		return
	else if(!alert && W.tool_behaviour == TOOL_CROWBAR && openable) //Only applies to the lab cage and player made display cases
		if(broken)
			if(showpiece)
				to_chat(user, "<span class='notice'>Remove the displayed object first.</span>")
			else
				to_chat(user, "<span class='notice'>You remove the destroyed case</span>")
				qdel(src)
		else
			to_chat(user, "<span class='notice'>You start to [open ? "close":"open"] [src].</span>")
			if(W.use_tool(src, user, 20))
				to_chat(user,  "<span class='notice'>You [open ? "close":"open"] [src].</span>")
				toggle_lock(user)
	else if(open && !showpiece)
		if(user.transferItemToLoc(W, src))
			showpiece = W
			to_chat(user, "<span class='notice'>You put [W] on display</span>")
			update_icon()
	else if(istype(W, /obj/item/stack/sheet/glass) && broken)
		var/obj/item/stack/sheet/glass/G = W
		if(G.get_amount() < 2)
			to_chat(user, "<span class='warning'>You need two glass sheets to fix the case!</span>")
			return
		to_chat(user, "<span class='notice'>You start fixing [src]...</span>")
		if(do_after(user, 20, target = src))
			G.use(2)
			broken = 0
			obj_integrity = max_integrity
			update_icon()
	else
		return ..()

/obj/structure/displaycase/proc/toggle_lock(mob/user)
	open = !open
	update_icon()

/obj/structure/displaycase/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/displaycase/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	if (showpiece && (broken || open))
		to_chat(user, "<span class='notice'>You deactivate the hover field built into the case.</span>")
		log_combat(user, src, "deactivates the hover field of")
		dump()
		src.add_fingerprint(user)
		update_icon()
		return
	else
	    //prevents remote "kicks" with TK
		if (!Adjacent(user))
			return
		user.visible_message("<span class='danger'>[user] kicks the display case.</span>", null, null, COMBAT_MESSAGE_RANGE)
		log_combat(user, src, "kicks")
		user.do_attack_animation(src, ATTACK_EFFECT_KICK)
		take_damage(2)

/obj/structure/displaycase_chassis
	anchored = TRUE
	density = FALSE
	name = "display case chassis"
	desc = "The wooden base of a display case."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "glassbox_chassis"
	var/obj/item/electronics/airlock/electronics


/obj/structure/displaycase_chassis/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WRENCH) //The player can only deconstruct the wooden frame
		to_chat(user, "<span class='notice'>You start disassembling [src]...</span>")
		I.play_tool_sound(src)
		if(I.use_tool(src, user, 30))
			playsound(src.loc, 'sound/items/deconstruct.ogg', 50, 1)
			new /obj/item/stack/sheet/mineral/wood(get_turf(src), 5)
			qdel(src)

	else if(istype(I, /obj/item/electronics/airlock))
		to_chat(user, "<span class='notice'>You start installing the electronics into [src]...</span>")
		I.play_tool_sound(src)
		if(do_after(user, 30, target = src) && user.transferItemToLoc(I,src))
			electronics = I
			to_chat(user, "<span class='notice'>You install the airlock electronics.</span>")

	else if(istype(I, /obj/item/stack/sheet/glass))
		var/obj/item/stack/sheet/glass/G = I
		if(G.get_amount() < 10)
			to_chat(user, "<span class='warning'>You need ten glass sheets to do this!</span>")
			return
		to_chat(user, "<span class='notice'>You start adding [G] to [src]...</span>")
		if(do_after(user, 20, target = src))
			G.use(10)
			var/obj/structure/displaycase/display = new(src.loc)
			if(electronics)
				electronics.forceMove(display)
				display.electronics = electronics
				if(electronics.one_access)
					display.req_one_access = electronics.accesses
				else
					display.req_access = electronics.accesses
			qdel(src)
	else
		return ..()

//The captains display case requiring specops ID access is intentional. "that was a joke, totally useless, everyone broke it anyways, atleast the captain can have his OWN THING -- sandstorm edit"
//The lab cage and captains display case do not spawn with electronics, which is why req_access is needed.
/obj/structure/displaycase/captain
	alert = TRUE
	start_showpiece_type = /obj/item/gun/energy/laser/captain
	req_access = list(ACCESS_CAPTAIN)

/obj/structure/displaycase/labcage
	name = "lab cage"
	desc = "A glass lab container for storing interesting creatures."
	start_showpiece_type = /obj/item/clothing/mask/facehugger/lamarr
	req_access = list(ACCESS_RD)

/obj/structure/displaycase/clown
	desc = "In the event of clown, honk glass."
	alert = TRUE
	start_showpiece_type = /obj/item/bikehorn
	req_access = list(ACCESS_CENT_GENERAL)

/obj/structure/displaycase/trophy
	name = "trophy display case"
	desc = "Store your trophies of accomplishment in here, and they will stay forever."
	var/placer_key = ""
	var/added_roundstart = TRUE
	var/is_locked = TRUE

	alert = TRUE
	integrity_failure = 0
	openable = FALSE

/obj/structure/displaycase/trophy/Initialize(mapload)
	. = ..()
	GLOB.trophy_cases += src

/obj/structure/displaycase/trophy/Destroy()
	GLOB.trophy_cases -= src
	return ..()

/obj/structure/displaycase/trophy/attackby(obj/item/W, mob/user, params)

	if(!user.Adjacent(src)) //no TK museology
		return
	if(user.a_intent == INTENT_HARM)
		return ..()

	if(user.is_holding_item_of_type(/obj/item/key/displaycase))
		if(added_roundstart)
			is_locked = !is_locked
			to_chat(user, "You [!is_locked ? "un" : ""]lock the case.")
		else
			to_chat(user, "<span class='danger'>The lock is stuck shut!</span>")
		return

	if(is_locked)
		to_chat(user, "<span class='danger'>The case is shut tight with an old fashioned physical lock. Maybe you should ask the curator for the key?</span>")
		return

	if(!added_roundstart)
		to_chat(user, "You've already put something new in this case.")
		return

	if(is_type_in_typecache(W, GLOB.blacklisted_cargo_types))
		to_chat(user, "<span class='danger'>The case rejects the [W].</span>")
		return

	for(var/a in W.GetAllContents())
		if(is_type_in_typecache(a, GLOB.blacklisted_cargo_types))
			to_chat(user, "<span class='danger'>The case rejects the [W].</span>")
			return

	if(user.transferItemToLoc(W, src))

		if(showpiece)
			to_chat(user, "You press a button, and [showpiece] descends into the floor of the case.")
			QDEL_NULL(showpiece)

		to_chat(user, "You insert [W] into the case.")
		showpiece = W
		added_roundstart = FALSE
		update_icon()

		placer_key = user.ckey

		trophy_message = W.desc //default value

		var/chosen_plaque = stripped_input(user, "What would you like the plaque to say? Default value is item's description.", "Trophy Plaque")
		if(chosen_plaque)
			if(user.Adjacent(src))
				trophy_message = chosen_plaque
				to_chat(user, "You set the plaque's text.")
			else
				to_chat(user, "You are too far to set the plaque's text.")

		SSpersistence.SaveTrophy(src)
		return TRUE

	else
		to_chat(user, "<span class='warning'>\The [W] is stuck to your hand, you can't put it in the [src.name]!</span>")

	return

/obj/structure/displaycase/trophy/dump()
	if (showpiece)
		if(added_roundstart)
			visible_message("<span class='danger'>The [showpiece] crumbles to dust!</span>")
			new /obj/effect/decal/cleanable/ash(loc)
			QDEL_NULL(showpiece)
		else
			..()

/obj/item/key/displaycase
	name = "display case key"
	desc = "The key to the curator's display cases."

/obj/item/showpiece_dummy
	name = "Cheap Replica"

/obj/item/showpiece_dummy/Initialize(mapload, path)
	. = ..()
	var/obj/item/I = path
	name = initial(I.name)
	icon = initial(I.icon)
	icon_state = initial(I.icon_state)

/obj/structure/displaycase/forsale
	name = "vend-a-tray"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "laserbox0"
	desc = "A display case with an ID-card swiper. Use your ID to purchase the contents."
	density = FALSE
	max_integrity = 100
	req_access = null
	start_showpiece_type = /obj/item/reagent_containers/food
	alert = FALSE //No, we're not calling the fire department because someone stole your cookie.
	// glass_fix = FALSE //Fixable with tools instead.
	///The price of the item being sold. Altered by grab intent ID use.
	var/sale_price = 20
	///The Account which will receive payment for purchases. Set by the first ID to swipe the tray.
	var/datum/bank_account/payments_acc = null
	///We're using the same trick as paper does in order to cache the image, and only load the UI when messed with.
	var/list/viewing_ui = list()

/obj/structure/displaycase/forsale/update_icon()	//remind me to fix my shitcode later
	var/icon/I
	if(open)
		I = icon('icons/obj/stationobjs.dmi',"laserboxb0")
	else
		I = icon('icons/obj/stationobjs.dmi',"laserbox0")
	if(!showpiece && !open)
		I = icon('icons/obj/stationobjs.dmi',"laserbox_open")
	if(broken)
		I = icon('icons/obj/stationobjs.dmi',"laserbox_broken")
	if(showpiece)
		var/icon/S = getFlatIcon(showpiece)
		S.Scale(17,17)
		I.Blend(S,ICON_UNDERLAY,8,12)
	src.icon = I
	return

/obj/structure/displaycase/forsale/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Vendatray", name)
		ui.set_autoupdate(FALSE)
		viewing_ui[user] = ui
		ui.open()

/obj/structure/displaycase/forsale/ui_data(mob/user)
	var/list/data = list()
	var/register = FALSE
	if(payments_acc)
		register = TRUE
		data["owner_name"] = payments_acc.account_holder
	if(showpiece)
		data["product_name"] = capitalize(showpiece.name)
		var/base64 = icon2base64(icon(showpiece.icon, showpiece.icon_state, SOUTH, 1))
		data["product_icon"] = base64
	data["registered"] = register
	data["product_cost"] = sale_price
	data["tray_open"] = open
	return data

/obj/structure/displaycase/forsale/ui_act(action, params)
	if(..())
		return
	var/obj/item/card/id/potential_acc = usr.get_idcard(hand_first = TRUE)
	switch(action)
		if("Buy")
			if(!showpiece)
				to_chat(usr, "<span class='notice'>There's nothing for sale.</span>")
				return TRUE
			if(broken)
				to_chat(usr, "<span class='notice'>[src] appears to be broken.</span>")
				return TRUE
			if(!payments_acc)
				to_chat(usr, "<span class='notice'>[src] hasn't been registered yet.</span>")
				return TRUE
			if(!usr.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
				return TRUE
			if(!potential_acc)
				to_chat(usr, "<span class='notice'>No ID card detected.</span>")
				return
			var/datum/bank_account/account = potential_acc.registered_account
			if(!account)
				to_chat(usr, "<span class='notice'>[potential_acc] has no account registered!</span>")
				return
			if(!account.has_money(sale_price))
				to_chat(usr, "<span class='notice'>You do not possess the funds to purchase this.</span>")
				return TRUE
			else
				account.adjust_money(-sale_price)
				if(payments_acc)
					payments_acc.adjust_money(sale_price)
				usr.put_in_hands(showpiece)
				to_chat(usr, "<span class='notice'>You purchase [showpiece] for [sale_price] credits.</span>")
				// playsound(src, 'sound/effects/cashregister.ogg', 40, TRUE)
				icon = 'icons/obj/stationobjs.dmi'
				flick("laserbox_vend", src)
				showpiece = null
				update_icon()
				SStgui.update_uis(src)
				return TRUE
		if("Open")
			if(!payments_acc)
				to_chat(usr, "<span class='notice'>[src] hasn't been registered yet.</span>")
				return TRUE
			if(!potential_acc || !potential_acc.registered_account)
				return
			if(!check_access(potential_acc))
				playsound(src, 'sound/machines/buzz-sigh.ogg', 50, TRUE)
				return
			toggle_lock()
			SStgui.update_uis(src)
		if("Register")
			if(payments_acc)
				return
			if(!potential_acc || !potential_acc.registered_account)
				return
			if(!check_access(potential_acc))
				playsound(src, 'sound/machines/buzz-sigh.ogg', 50, TRUE)
				return
			payments_acc = potential_acc.registered_account
			playsound(src, 'sound/machines/click.ogg', 20, TRUE)
		if("Adjust")
			if(!check_access(potential_acc) || potential_acc.registered_account != payments_acc)
				playsound(src, 'sound/machines/buzz-sigh.ogg', 50, TRUE)
				return

			var/new_price_input = input(usr,"Set the sale price for this vend-a-tray.","new price",0) as num|null
			if(isnull(new_price_input) || (payments_acc != potential_acc.registered_account))
				to_chat(usr, "<span class='warning'>[src] rejects your new price.</span>")
				return
			if(!usr.canUseTopic(src, BE_CLOSE, FALSE, NO_TK) )
				to_chat(usr, "<span class='warning'>You need to get closer!</span>")
				return
			new_price_input = clamp(round(new_price_input, 1), 10, 1000)
			sale_price = new_price_input
			to_chat(usr, "<span class='notice'>The cost is now set to [sale_price].</span>")
			SStgui.update_uis(src)
			return TRUE
	. = TRUE
/obj/structure/displaycase/forsale/attackby(obj/item/I, mob/living/user, params)
	if(isidcard(I))
		//Card Registration
		var/obj/item/card/id/potential_acc = I
		if(!potential_acc.registered_account)
			to_chat(user, "<span class='warning'>This ID card has no account registered!</span>")
			return
		if(payments_acc == potential_acc.registered_account)
			playsound(src, 'sound/machines/click.ogg', 20, TRUE)
			toggle_lock()
			return
	if(istype(I, /obj/item/pda))
		return TRUE
	SStgui.update_uis(src)
	. = ..()


/obj/structure/displaycase/forsale/multitool_act(mob/living/user, obj/item/I)
	. = ..()
	if(obj_integrity <= (integrity_failure *  max_integrity))
		to_chat(user, "<span class='notice'>You start recalibrating [src]'s hover field...</span>")
		if(do_after(user, 20, target = src))
			broken = 0
			obj_integrity = max_integrity
			update_icon()
		return TRUE

/obj/structure/displaycase/forsale/wrench_act(mob/living/user, obj/item/I)
	. = ..()
	if(open && user.a_intent == INTENT_HELP )
		if(anchored)
			to_chat(user, "<span class='notice'>You start unsecuring [src]...</span>")
		else
			to_chat(user, "<span class='notice'>You start securing [src]...</span>")
		if(I.use_tool(src, user, 16, volume=50))
			if(QDELETED(I))
				return
			if(anchored)
				to_chat(user, "<span class='notice'>You unsecure [src].</span>")
			else
				to_chat(user, "<span class='notice'>You secure [src].</span>")
			anchored = !anchored
			return
	else if(!open && user.a_intent == INTENT_HELP)
		to_chat(user, "<span class='notice'>[src] must be open to move it.</span>")
		return

/obj/structure/displaycase/forsale/emag_act(mob/user)
	. = ..()
	payments_acc = null
	req_access = list()
	to_chat(user, "<span class='warning'>[src]'s card reader fizzles and smokes, and the account owner is reset.</span>")

/obj/structure/displaycase/forsale/examine(mob/user)
	. = ..()
	if(showpiece && !open)
		. += "<span class='notice'>[showpiece] is for sale for [sale_price] credits.</span>"
	if(broken)
		. += "<span class='notice'>[src] is sparking and the hover field generator seems to be overloaded. Use a multitool to fix it.</span>"

/obj/structure/displaycase/forsale/obj_break(damage_flag)
	if(!broken && !(flags_1 & NODECONSTRUCT_1))
		broken = TRUE
		playsound(src, "shatter", 70, TRUE)
		update_icon()
		trigger_alarm() //In case it's given an alarm anyway.

/obj/structure/displaycase/forsale/kitchen
	desc = "A display case with an ID-card swiper. Use your ID to purchase the contents. Meant for the bartender and chef."
	req_one_access = list(ACCESS_KITCHEN, ACCESS_BAR)
