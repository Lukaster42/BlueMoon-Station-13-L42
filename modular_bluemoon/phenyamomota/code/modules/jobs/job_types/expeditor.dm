/datum/job/expeditor
	title = "Expeditor"
	flag = EXPEDITOR
	department_head = list("Captain", "RD")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "The captain and the research director"
	selection_color = "#9574cd"
	req_admin_notify = 0
	minimal_player_age = 18
	exp_requirements = 360
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SCIENCE
	considered_combat_role = FALSE
	outfit = /datum/outfit/job/expeditor
	custom_spawn_text = "<font color='red'>Expeditor: You are here to explore space and gateway. You have very limited access. You are not Secuirty and you are not in the line of secceustion. You have no power, listen to the Captain and the RD. DO NOT BREAK OUTBACK FIRING PINS WITHOUT REASONS OR YOU WILL GONNA BE PUNISHED!</font>"
	access = list(ACCESS_ROBOTICS, ACCESS_RESEARCH, ACCESS_MINERAL_STOREROOM, ACCESS_TECH_STORAGE, ACCESS_GATEWAY, ACCESS_EVA, ACCESS_TELEPORTER)
	minimal_access = list(ACCESS_ROBOTICS, ACCESS_RESEARCH, ACCESS_MINERAL_STOREROOM, ACCESS_TECH_STORAGE, ACCESS_GATEWAY, ACCESS_EVA, ACCESS_TELEPORTER)
	paycheck = PAYCHECK_HARD
	paycheck_department = ACCOUNT_SCI
	alt_titles = list("Space Expeditor", "Gateway Explorer", "Space Explorer", "Sexplorer", "Sexpeditor", "Exploration Field Medic", "Exploration Engineer", "Exploration Mercenary", "Exploration Operative")
	display_order = JOB_DISPLAY_ORDER_EXPEDITOR
	blacklisted_quirks = list(/datum/quirk/mute, /datum/quirk/brainproblems, /datum/quirk/prosopagnosia, /datum/quirk/insanity)
	threat = 2

/datum/outfit/job/expeditor
	name = "Expeditor"
	jobtype = /datum/job/expeditor
	id = /obj/item/card/id
	belt = /obj/item/storage/belt/military/assault
	ears = /obj/item/radio/headset/headset_sci
	uniform = /obj/item/clothing/under/syndicate/combat/exp
	suit = /obj/item/clothing/suit/armor/vest/exp
	head = /obj/item/clothing/head/helmet/exp
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/combat
	suit_store = /obj/item/gun/energy/e_gun/mini/expeditor
	r_pocket = /obj/item/kitchen/knife/combat
	l_pocket = /obj/item/pda
	backpack_contents = list(/obj/item/storage/firstaid/regular = 1)

/obj/item/radio/headset/headset_exp
	name = "expeditor's headset"
	desc = "This is used by expeditors."
	icon = 'modular_bluemoon/phenyamomota/icon/obj/radio.dmi'
	mob_overlay_icon = 'modular_bluemoon/phenyamomota/icon/mob/ears.dmi'
	icon_state = "exp_headset"
	item_state = "exp_headset"
	keyslot = new /obj/item/encryptionkey/headset_sci

/obj/item/radio/headset/headset_exp/bowman
	name = "expeditor's bowman headset"
	desc = "This is used by expeditors. It protects from flashbangs"
	icon_state = "exp_headset_alt"
	item_state = "exp_headset_alt"
	bowman = TRUE

/obj/item/gun/energy/e_gun/mini/expeditor
	name = "expeditor's miniature energy gun"
	desc = "Modernized pistol-sized energy gun with a built-in flashlight and expanded cell. It has two settings: stun and kill."
	w_class = WEIGHT_CLASS_SMALL
	cell_type = /obj/item/stock_parts/cell{charge = 1200; maxcharge = 1200}
	pin = /obj/item/firing_pin/explorer

/obj/item/clothing/under/syndicate/combat/exp
	icon = 'modular_bluemoon/phenyamomota/icon/obj/clothing/under.dmi'
	mob_overlay_icon = 'modular_bluemoon/phenyamomota/icon/mob/clothing/under.dmi'
	anthro_mob_worn_overlay = 'modular_bluemoon/phenyamomota/icon/mob/clothing/under_digi.dmi'
	name = "expeditionary turtleneck"
	desc = "Standart combat turtleneck with printed expiditionary marks."
	icon_state = "tactical_exp"
	item_state = "tactical_exp"
	mutantrace_variation = STYLE_DIGITIGRADE|USE_SNEK_CLIP_MASK|USE_QUADRUPED_CLIP_MASK

/obj/item/clothing/shoes/combat/exp
	icon = 'modular_bluemoon/phenyamomota/icon/obj/clothing/shoes.dmi'
	mob_overlay_icon = 'modular_bluemoon/phenyamomota/icon/mob/clothing/shoes.dmi'
	anthro_mob_worn_overlay = 'modular_bluemoon/phenyamomota/icon/mob/clothing/shoes_digi.dmi'
	name = "expeditionary boots"
	desc = "Black hardboots with solid sole."
	icon_state = "combat_exp"
	item_state = "combat_exp"

/obj/item/clothing/suit/armor/vest/exp
	icon = 'modular_bluemoon/phenyamomota/icon/obj/clothing/suits.dmi'
	mob_overlay_icon = 'modular_bluemoon/phenyamomota/icon/mob/clothing/suits.dmi'
	name = "expeditionary armor vest"
	desc = "Base armor vest designed for ordinary expeditors. With cool speedy violet vertical line."
	icon_state = "vest_exp"
	item_state = "vest_exp"
	armor = list(MELEE = 40, BULLET = 40, LASER = 30, ENERGY = -20, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 50, WOUND = 30) //Для упрощения нейтрализации
	unique_reskin = list(
		"Standart" = list(
			"icon_state" = "vest_exp",
			"item_state" = "vest_exp",
			"name" = "expeditionary armor vest"
		),
		"Forest" = list(
			"icon_state" = "vest_exp_forest",
			"item_state" = "vest_exp_forest",
			"name" = "forest expeditionary armor vest"
		),
		"Desert" = list(
			"icon_state" = "vest_exp_desert",
			"item_state" = "vest_exp_desert",
			"name" = "desert expeditionary armor vest"
		)
	)

/obj/item/clothing/head/helmet/exp
	icon = 'modular_bluemoon/phenyamomota/icon/obj/clothing/head.dmi'
	mob_overlay_icon = 'modular_bluemoon/phenyamomota/icon/mob/clothing/head.dmi'
	name = "expeditionary helmet"
	desc = "Sturdy ballistic helmet with violet protective glass."
	icon_state = "helmet_exp"
	item_state = "helmet_exp"
	armor = list(MELEE = 40, BULLET = 40, LASER = 30, ENERGY = -20, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 50, WOUND = 30) //Для упрощения нейтрализации
	unique_reskin = list(
		"Standart" = list(
			"icon_state" = "helmet_exp",
			"item_state" = "helmet_exp",
			"name" = "expeditionary helmet"
		),
		"Forest" = list(
			"icon_state" = "helmet_exp_forest",
			"item_state" = "helmet_exp_forest",
			"name" = "forest expeditionary helmet"
		),
		"Desert" = list(
			"icon_state" = "helmet_exp_desert",
			"item_state" = "helmet_exp_desert",
			"name" = "desert expeditionary helmet"
		)
	)
