/obj/item/storage/box/syndicate

/obj/item/storage/box/syndicate/PopulateContents()
	switch (pickweight(list("bloodyspai" = 3, "stealth" = 2, "bond" = 2, "screwed" = 2, "sabotage" = 3, "guns" = 2, "murder" = 2, "baseball" = 1, "implant" = 1, "hacker" = 3, "darklord" = 1, "sniper" = 1, "metaops" = 1, "ninja" = 1, "ancient" = 1)))
		if("bloodyspai") // 30 tc now this is more right
			new /obj/item/clothing/under/chameleon(src) // 2 tc since it's not the full set
			new /obj/item/clothing/mask/chameleon(src) // Goes with above
			new /obj/item/card/id/syndicate(src) // 2 tc
			new /obj/item/clothing/shoes/chameleon/noslip(src) // 2 tc
			new /obj/item/camera_bug(src) // 1 tc
			new /obj/item/multitool/ai_detect(src) // 1 tc
			new /obj/item/encryptionkey/syndicate(src) // 2 tc
			new /obj/item/reagent_containers/syringe/mulligan(src) // 4 tc
			new /obj/item/switchblade(src) //I'll count this as 5 tc
			new /obj/item/storage/fancy/cigarettes/cigpack_syndicate (src) // 2 tc this shit heals
			new /obj/item/flashlight/emp(src) // 2 tc
			new /obj/item/chameleon(src) // 7 tc

		if("stealth") // 31 tc
			new /obj/item/gun/energy/kinetic_accelerator/crossbow(src)
			new /obj/item/pen/sleepy(src)
			new /obj/item/healthanalyzer/rad_laser(src)
			new /obj/item/chameleon(src)
			new /obj/item/soap/syndie(src)
			new /obj/item/clothing/glasses/thermal/syndi(src)

		if("bond") // 29 tc
			new /obj/item/gun/ballistic/automatic/pistol/suppressed(src)
			new /obj/item/ammo_box/magazine/m10mm(src)
			new /obj/item/ammo_box/magazine/m10mm(src)
			new /obj/item/clothing/under/chameleon(src)
			new /obj/item/card/id/syndicate(src)
			new /obj/item/reagent_containers/syringe/stimulants(src)
			new /obj/item/clothing/neck/tie/red(src)

		if("screwed") // 29 tc
			new /obj/item/sbeacondrop/bomb(src)
			new /obj/item/grenade/syndieminibomb(src)
			new /obj/item/sbeacondrop/powersink(src)
			new /obj/item/clothing/suit/space/syndicate/black/red(src)
			new /obj/item/clothing/head/helmet/space/syndicate/black/red(src)
			new /obj/item/encryptionkey/syndicate(src)

		if("guns") // 30 tc now
			new /obj/item/gun/ballistic/revolver(src)
			new /obj/item/ammo_box/a357(src)
			new /obj/item/ammo_box/a357(src)
			new /obj/item/card/emag(src)
			new /obj/item/grenade/plastic/c4(src)
			new /obj/item/clothing/gloves/color/latex/nitrile(src)
			new /obj/item/clothing/mask/gas/clown_hat(src)
			new /obj/item/clothing/under/suit/black_really(src)
			new /obj/item/screwdriver/power(src) //2 tc item

		if("murder") // 35 tc
			new /obj/item/melee/transforming/energy/sword/saber(src)
			new /obj/item/clothing/glasses/thermal/syndi(src)
			new /obj/item/card/emag(src)
			new /obj/item/clothing/shoes/chameleon/noslip(src)
			new /obj/item/encryptionkey/syndicate(src)
			new /obj/item/grenade/syndieminibomb(src)
			new /obj/item/clothing/glasses/phantomthief/syndicate(src)
			new /obj/item/reagent_containers/syringe/stimulants(src)

		if("baseball") // 44~ tc
			new /obj/item/melee/baseball_bat/ablative/syndi(src) //Lets say 12 tc, lesser sleeping carp
			new /obj/item/clothing/glasses/sunglasses/garb(src) //Lets say 2 tc
			new /obj/item/card/emag(src) //6 tc
			new /obj/item/clothing/shoes/sneakers/noslip(src) //2tc
			new /obj/item/encryptionkey/syndicate(src) //1tc
			new /obj/item/autosurgeon/anti_drop(src) //Lets just say 7~
			new /obj/item/clothing/under/syndicate/baseball(src) //3tc
			new /obj/item/clothing/head/soft/baseball(src) //Lets say 4 tc
			new /obj/item/reagent_containers/hypospray/medipen/stimulants/baseball(src) //lets say 5tc
			new /obj/item/melee/baseball_bat/telescopic(src) // 2 tc

		if("implant") // 67+ tc holy shit what the fuck this is a lottery disguised as fun boxes isn't it?
			new /obj/item/implanter/freedom(src)
			new /obj/item/implanter/uplink/precharged(src)
			new /obj/item/implanter/emp(src)
			new /obj/item/implanter/adrenalin(src)
			new /obj/item/implanter/explosive(src)
			new /obj/item/implanter/storage(src)
			new /obj/item/implanter/radio/syndicate(src)
			new /obj/item/implanter/stealth(src)

		if("hacker") // 30 tc
			new /obj/item/aiModule/syndicate(src)
			new /obj/item/card/emag(src)
			new /obj/item/encryptionkey/binary(src)
			new /obj/item/aiModule/toyAI(src)
			new /obj/item/multitool/ai_detect(src)
			new /obj/item/flashlight/emp(src)
			new /obj/item/emagrecharge(src)

		if("lordsingulo") // "36" tc aka 23 tc
			new /obj/item/sbeacondrop(src) // 14 kinda useless
			new /obj/item/clothing/suit/space/syndicate/black/red(src) //2
			new /obj/item/clothing/head/helmet/space/syndicate/black/red(src) //2
			new /obj/item/card/emag(src) //6
			new /obj/item/emagrecharge(src) //2
			new /obj/item/storage/toolbox/syndicate(src) //1
			new /obj/item/card/id/syndicate(src) //2
			new /obj/item/flashlight/emp(src) //2
			new /obj/item/jammer(src) //5

		if("sabotage") // ~28 tc now
			new /obj/item/grenade/plastic/c4 (src)
			new /obj/item/grenade/plastic/c4 (src)
			new /obj/item/grenade/plastic/x4 (src)
			new /obj/item/grenade/plastic/x4 (src)
			new /obj/item/doorCharge(src)
			new /obj/item/doorCharge(src)
			new /obj/item/camera_bug(src)
			new /obj/item/sbeacondrop/powersink(src)
			new /obj/item/cartridge/virus/syndicate(src)
			new /obj/item/storage/toolbox/syndicate(src) //To actually get to those places
			new /obj/item/pizzabox/bomb

		if("darklord") //20 tc + tk + summon item close enough for now
			new /obj/item/dualsaber(src)
			new /obj/item/dnainjector/telemut/darkbundle(src)
			new /obj/item/clothing/suit/hooded/chaplain_hoodie(src)
			new /obj/item/card/id/syndicate(src)
			new /obj/item/clothing/shoes/chameleon/noslip(src) //because slipping while being a dark lord sucks
			new /obj/item/book/granter/spell/summonitem(src)

		if("sniper") //This shit is unique so can't really balance it around tc, also no silencer because getting killed without ANY indicator on what killed you sucks
			new /obj/item/gun/ballistic/automatic/sniper_rifle(src) // 12 tc
			new /obj/item/ammo_box/magazine/sniper_rounds/penetrator(src)
			new /obj/item/clothing/glasses/thermal/syndi(src)
			new /obj/item/clothing/gloves/color/latex/nitrile(src)
			new /obj/item/clothing/mask/gas/clown_hat(src)
			new /obj/item/clothing/under/suit/black_really(src)

		if("metaops") // 30 tc
			new /obj/item/clothing/suit/space/hardsuit/syndi(src) // 8 tc
			new /obj/item/gun/ballistic/automatic/shotgun/bulldog/unrestricted(src) // 8 tc
			new /obj/item/implanter/explosive(src) // 2 tc
			new /obj/item/ammo_box/magazine/m12g(src) // 2 tc
			new /obj/item/ammo_box/magazine/m12g(src) // 2 tc
			new /obj/item/grenade/plastic/c4 (src) // 1 tc
			new /obj/item/grenade/plastic/c4 (src) // 1 tc
			new /obj/item/card/emag(src) // 6 tc

		if("ninja") // 40~ tc worth
			new /obj/item/katana(src) // Unique , basicly a better esword. 10 tc?
			new /obj/item/implanter/adrenalin(src) // 8 tc
			new /obj/item/throwing_star(src) // ~5 tc for all 6
			new /obj/item/throwing_star(src)
			new /obj/item/throwing_star(src)
			new /obj/item/implanter/emp(src)
			new /obj/item/grenade/smokebomb(src)
			new /obj/item/grenade/smokebomb(src)
			new /obj/item/storage/belt/chameleon(src) // Unique but worth at least 2 tc
			new /obj/item/card/id/syndicate(src) // 2 tc
			new /obj/item/chameleon(src) // 7 tc

		if("ancient") //A kit so old, it's probably older than you. //This bundle is filled with the entire unlink contents traitors had access to in 2006, from OpenSS13. Notably the esword was not a choice but existed in code.
			new /obj/item/storage/toolbox/emergency/old/ancientbundle(src) //Items fit neatly into a classic toolbox just to remind you what the theme is.

/obj/item/storage/toolbox/emergency/old/ancientbundle //So the subtype works

/obj/item/storage/toolbox/emergency/old/ancientbundle/PopulateContents()
	new /obj/item/card/emag(src)
	new /obj/item/pen/sleepy(src)
	new /obj/item/reagent_containers/pill/cyanide(src)
	new /obj/item/chameleon(src) //its not the original cloaking device, but it will do.
	new /obj/item/gun/ballistic/revolver(src)
	new /obj/item/implanter/freedom(src)
	new /obj/item/stack/telecrystal(src) //The failsafe/self destruct isn't an item we can physically include in the kit, but 1 TC is technically enough to buy the equivalent.

/obj/item/storage/box/syndie_kit
	name = "box"
	desc = "A sleek, sturdy box."
	icon_state = "syndiebox"
	illustration = "writing_syndie"

/obj/item/storage/box/syndie_kit/imp_freedom
	name = "boxed freedom implant (with injector)"

/obj/item/storage/box/syndie_kit/imp_freedom/PopulateContents()
	var/obj/item/implanter/O = new(src)
	O.imp = new /obj/item/implant/freedom(O)
	O.update_icon()

/obj/item/storage/box/syndie_kit/imp_warp
	name = "boxed warp implant (with injector)"

/obj/item/storage/box/syndie_kit/imp_warp/PopulateContents()
	var/obj/item/implanter/O = new(src)
	O.imp = new /obj/item/implant/warp(O)
	O.update_icon()

/obj/item/storage/box/syndie_kit/imp_microbomb
	name = "Microbomb Implant (with injector)"

/obj/item/storage/box/syndie_kit/imp_microbomb/PopulateContents()
	var/obj/item/implanter/O = new(src)
	O.imp = new /obj/item/implant/explosive(O)
	O.update_icon()

/obj/item/storage/box/syndie_kit/imp_macrobomb
	name = "Macrobomb Implant (with injector)"

/obj/item/storage/box/syndie_kit/imp_macrobomb/PopulateContents()
	var/obj/item/implanter/O = new(src)
	O.imp = new /obj/item/implant/explosive/macro(O)
	O.update_icon()

/obj/item/storage/box/syndie_kit/imp_uplink
	name = "boxed uplink implant (with injector)"

/obj/item/storage/box/syndie_kit/imp_uplink/PopulateContents()
	..()
	var/obj/item/implanter/O = new(src)
	O.imp = new /obj/item/implant/uplink(O)
	O.update_icon()

/obj/item/storage/box/syndie_kit/bioterror
	name = "bioterror syringe box"

/obj/item/storage/box/syndie_kit/bioterror/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/syringe/bioterror(src)

/obj/item/storage/box/syndie_kit/imp_adrenal
	name = "boxed adrenal implant (with injector)"

/obj/item/storage/box/syndie_kit/imp_adrenal/PopulateContents()
	var/obj/item/implanter/O = new(src)
	O.imp = new /obj/item/implant/adrenalin(O)
	O.update_icon()

/obj/item/storage/box/syndie_kit/imp_storage
	name = "boxed storage implant (with injector)"

/obj/item/storage/box/syndie_kit/imp_storage/PopulateContents()
	new /obj/item/implanter/storage(src)

/obj/item/storage/box/syndie_kit/space
	name = "boxed space suit and helmet"

/obj/item/storage/box/syndie_kit/space/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.can_hold = typecacheof(list(/obj/item/clothing/suit/space/syndicate, /obj/item/clothing/head/helmet/space/syndicate))

/obj/item/storage/box/syndie_kit/space/PopulateContents()
	new /obj/item/clothing/suit/space/syndicate/black/red(src) // Black and red is so in right now
	new /obj/item/clothing/head/helmet/space/syndicate/black/red(src)

/obj/item/storage/box/syndie_kit/emp
	name = "boxed EMP kit"

/obj/item/storage/box/syndie_kit/emp/PopulateContents()
	new /obj/item/grenade/empgrenade(src)
	new /obj/item/grenade/empgrenade(src)
	new /obj/item/grenade/empgrenade(src)
	new /obj/item/grenade/empgrenade(src)
	new /obj/item/grenade/empgrenade(src)
	new /obj/item/implanter/emp(src)

/obj/item/storage/box/syndie_kit/chemical
	name = "boxed chemical kit"

/obj/item/storage/box/syndie_kit/chemical/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 14

/obj/item/storage/box/syndie_kit/chemical/PopulateContents()
	new /obj/item/reagent_containers/glass/bottle/polonium(src)
	new /obj/item/reagent_containers/glass/bottle/venom(src)
	new /obj/item/reagent_containers/glass/bottle/fentanyl(src)
	new /obj/item/reagent_containers/glass/bottle/formaldehyde(src)
	new /obj/item/reagent_containers/glass/bottle/spewium(src)
	new /obj/item/reagent_containers/glass/bottle/cyanide(src)
	new /obj/item/reagent_containers/glass/bottle/histamine(src)
	new /obj/item/reagent_containers/glass/bottle/initropidril(src)
	new /obj/item/reagent_containers/glass/bottle/pancuronium(src)
	new /obj/item/reagent_containers/glass/bottle/sodium_thiopental(src)
	new /obj/item/reagent_containers/glass/bottle/coniine(src)
	new /obj/item/reagent_containers/glass/bottle/curare(src)
	new /obj/item/reagent_containers/glass/bottle/amanitin(src)
	new /obj/item/reagent_containers/syringe(src)

/obj/item/storage/box/syndie_kit/nuke
	name = "box"

/obj/item/storage/box/syndie_kit/nuke/PopulateContents()
	new /obj/item/screwdriver/nuke(src)
	new /obj/item/nuke_core_container(src)
	new /obj/item/paper/guides/antag/nuke_instructions(src)

/obj/item/storage/box/syndie_kit/supermatter
	name = "box"

/obj/item/storage/box/syndie_kit/supermatter/PopulateContents()
	new /obj/item/scalpel/supermatter(src)
	new /obj/item/hemostat/supermatter(src)
	new /obj/item/nuke_core_container/supermatter(src)
	new /obj/item/paper/guides/antag/supermatter_sliver(src)

/obj/item/storage/box/syndie_kit/tuberculosisgrenade
	name = "boxed virus grenade kit"

/obj/item/storage/box/syndie_kit/tuberculosisgrenade/PopulateContents()
	new /obj/item/grenade/chem_grenade/tuberculosis(src)
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/hypospray/medipen/tuberculosiscure(src)
	new /obj/item/reagent_containers/syringe(src)
	new /obj/item/reagent_containers/glass/bottle/tuberculosiscure(src)

/obj/item/storage/box/syndie_kit/chameleon
	name = "chameleon kit"

/obj/item/storage/box/syndie_kit/chameleon/PopulateContents()
	new /obj/item/clothing/under/chameleon(src)
	new /obj/item/clothing/suit/chameleon(src)
	new /obj/item/clothing/gloves/chameleon/insulated(src)
	new /obj/item/clothing/shoes/chameleon(src)
	new /obj/item/clothing/glasses/chameleon(src)
	new /obj/item/clothing/head/chameleon(src)
	new /obj/item/clothing/mask/chameleon(src)
	new /obj/item/storage/backpack/chameleon(src)
	new /obj/item/radio/headset/chameleon(src)
	new /obj/item/stamp/chameleon(src)
	new /obj/item/pda/chameleon(src)
	new /obj/item/clothing/neck/cloak/chameleon(src) //ЭТО ПИЗДЕЦ ОНИ ЗАЧЕМ-ТО СЛОМАЛИ ХАМЕЛЕОНКУ И ОТКАЗЫВАЮТСЯ ЕЁ ЧИНИТЬ

//5*(2*4) = 5*8 = 45, 45 damage if you hit one person with all 5 stars.
//Not counting the damage it will do while embedded (2*4 = 8, at 15% chance)
/obj/item/storage/box/syndie_kit/throwing_weapons/PopulateContents()
	new /obj/item/throwing_star(src)
	new /obj/item/throwing_star(src)
	new /obj/item/throwing_star(src)
	new /obj/item/throwing_star(src)
	new /obj/item/throwing_star(src)
	new /obj/item/restraints/legcuffs/bola/tactical(src)
	new /obj/item/restraints/legcuffs/bola/tactical(src)

/obj/item/storage/box/syndie_kit/cutouts/PopulateContents()
	for(var/i in 1 to 3)
		new/obj/item/cardboard_cutout/adaptive(src)
	new/obj/item/toy/crayon/rainbow(src)

/obj/item/storage/box/syndie_kit/romerol/PopulateContents()
	new /obj/item/reagent_containers/glass/bottle/romerol(src)
	new /obj/item/reagent_containers/syringe(src)
	new /obj/item/reagent_containers/dropper(src)
	new /obj/item/paper/guides/antag/romerol_instructions(src)

/obj/item/storage/box/syndie_kit/ez_clean/PopulateContents()
	for(var/i in 1 to 3)
		new/obj/item/grenade/chem_grenade/ez_clean(src)

/obj/item/storage/box/hug/reverse_revolver/PopulateContents()
	new /obj/item/gun/ballistic/revolver/reverse(src)

/obj/item/storage/box/syndie_kit/mimery/PopulateContents()
	new /obj/item/book/granter/spell/mimery_blockade(src)
	new /obj/item/book/granter/spell/mimery_guns(src)

/obj/item/storage/box/syndie_kit/imp_radio/PopulateContents()
	new /obj/item/implanter/radio/syndicate(src)

/obj/item/storage/box/syndie_kit/centcom_costume/PopulateContents()
	new /obj/item/clothing/under/rank/centcom/officer/syndicate(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/gloves/color/black(src)
	new /obj/item/radio/headset/headset_cent/empty(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/storage/backpack/satchel(src)
	new /obj/item/pda/heads(src)
	new /obj/item/clipboard(src)

/obj/item/storage/box/syndie_kit/chameleon/broken/PopulateContents()
	new /obj/item/clothing/under/chameleon/broken(src)
	new /obj/item/clothing/suit/chameleon/broken(src)
	new /obj/item/clothing/gloves/chameleon/broken(src)
	new /obj/item/clothing/shoes/chameleon/noslip/broken(src)
	new /obj/item/clothing/glasses/chameleon/broken(src)
	new /obj/item/clothing/head/chameleon/broken(src)
	new /obj/item/clothing/mask/chameleon/broken(src)
	new /obj/item/storage/backpack/chameleon/broken(src)
	new /obj/item/radio/headset/chameleon/broken(src)
	new /obj/item/stamp/chameleon/broken(src)
	new /obj/item/pda/chameleon/broken(src)
	// No chameleon laser, they can't randomise for //REASONS//

/obj/item/storage/box/syndie_kit/bee_grenades
	name = "buzzkill grenade box"
	desc = "A sleek, sturdy box with a buzzing noise coming from the inside. Uh oh."

/obj/item/storage/box/syndie_kit/bee_grenades/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/grenade/spawnergrenade/buzzkill(src)

/obj/item/storage/box/syndie_kit/sleepytime/PopulateContents()
	new /obj/item/clothing/under/syndicate/bloodred/sleepytime(src)
	new /obj/item/reagent_containers/food/drinks/mug/coco(src)
	new /obj/item/toy/plush/carpplushie(src)
	new /obj/item/bedsheet/syndie(src)

/obj/item/storage/box/syndie_kit/kitchen_gun
	name = "Kitchen Gun (TM) package"

/obj/item/storage/box/syndie_kit/kitchen_gun/PopulateContents()
	new /obj/item/gun/ballistic/automatic/pistol/m1911/kitchengun(src)
	new /obj/item/ammo_box/magazine/m45/kitchengun(src)
	new /obj/item/ammo_box/magazine/m45/kitchengun(src)


/obj/item/storage/box/strange_seeds_10pack

/obj/item/storage/box/strange_seeds_10pack/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/seeds/random(src)

	if(prob(50))
		new /obj/item/seeds/random(src) //oops, an additional packet might have slipped its way into the box

/obj/item/storage/box/syndie_kit/revolver

/obj/item/storage/box/syndie_kit/revolver/PopulateContents()
	new /obj/item/gun/ballistic/revolver/syndicate(src)
	new /obj/item/ammo_box/a357(src)

/obj/item/storage/box/syndie_kit/pistol

/obj/item/storage/box/syndie_kit/pistol/PopulateContents()
	new /obj/item/gun/ballistic/automatic/pistol(src)
	new /obj/item/ammo_box/magazine/m10mm(src)

/obj/item/storage/box/syndie_kit/contract_kit
	name = "contractor kit"
	desc = "Supplied to Syndicate contractors in active mission areas."

/obj/item/storage/box/syndicate/contractor_loadout
	name = "standard loadout"
	desc = "Supplied to Syndicate contractors, providing their specialised space suit and chameleon uniform."
	icon_state = "syndiebox"
	illustration = "writing_syndie"

/obj/item/paper/contractor_guide
	name = "Contractor Guide"

/obj/item/paper/contractor_guide/Initialize(mapload)
	info = {"<p>Welcome agent, congratulations on your new position as contractor. On top of your already assigned objectives,
			this kit will provide you contracts to take on for TC payments.</p>
			<p>Provided within, we give your specialist contractor space suit. It's even more compact, being able to fit into a pocket, and faster than the
			Syndicate space suit available to you on the uplink. We also provide your chameleon jumpsuit and mask, both of which can be changed
			to any form you need for the moment. The cigarettes are a special blend - it'll heal your injuries slowly overtime.</p>
			<p>The three additional items, apart from the tablet and loadout box, have been randomly selected from what we had available. We hope
			they're useful to you for you mission.</p>
			<p>The contractor hub, available at the top right of the uplink, will provide you unique items and abilities. These are bought using Contractor Rep,
			with two Rep being provided each time you complete a contract.</p>
			<h3>Using the tablet</h3>
			<ol>
				<li>Open the Syndicate Contract Uplink program.</li>
				<li>Assign yourself.</li>
				<li>Here, you can accept a contract, and redeem your TC payments from completed contracts.</li>
				<li>The payment number shown in brackets is the bonus you'll recieve when bringing your target <b>alive</b>. You recieve the
				other number regardless of if they were alive or dead.</li>
				<li>Contracts are completed by bringing the target to designated dropoff, calling for extraction, and putting them
				inside the pod.</li>
			</ol>
			<p>Be careful when accepting a contract. While you'll be able to see the location of the dropoff point, cancelling will make it
			unavailable to take on again.</p>
			<p>The tablet can also be recharged at any cell charger.</p>
			<h3>Extracting</h3>
			<ol>
				<li>Make sure both yourself and your target are at the dropoff.</li>
				<li>Call the extraction, and stand back from the drop point</li>
				<li>If it fails, make sure your target is inside, and there's a free space for the pod to land.</li>
				<li>Grab your target, and drag them into the pod.</li>
			</ol>
			<h3>Ransoms</h3>
			<p>We need your target for our own reasons, but we ransom them back to your mission area once their use is served. They will return back
			from where you sent them off from in several minutes time. You will be paid in TC for your services.</p>

			<p>Good luck agent. You can burn this document with the supplied lighter.</p>"}

	return ..()

/obj/item/storage/box/syndicate/contractor_loadout/PopulateContents()
	new /obj/item/clothing/head/helmet/space/syndicate/contract(src)
	new /obj/item/clothing/suit/space/syndicate/contract(src)
	new /obj/item/clothing/under/chameleon(src)
	new /obj/item/clothing/mask/chameleon(src)
	new /obj/item/card/id/syndicate(src)
	new /obj/item/storage/fancy/cigarettes/cigpack_syndicate(src)
	new /obj/item/lighter(src)

/obj/item/storage/box/syndie_kit/contract_kit/PopulateContents()
	new /obj/item/modular_computer/tablet/syndicate_contract_uplink/preset/uplink(src)
	new /obj/item/storage/box/syndicate/contractor_loadout(src)
	new /obj/item/melee/classic_baton/telescopic/contractor_baton(src)
	var/list/item_list = list(	// All 4 TC or less - some nukeops only items, but fit nicely to the theme.
		/obj/item/storage/backpack/duffelbag/syndie/x4,
		/obj/item/storage/box/syndie_kit/throwing_weapons,
		/obj/item/gun/syringe/syndicate,
		/obj/item/pen/edagger,
		/obj/item/pen/sleepy,
		/obj/item/flashlight/emp,
		/obj/item/reagent_containers/syringe/mulligan,
		/obj/item/clothing/shoes/chameleon/noslip,
		/obj/item/storage/firstaid/tactical,
		/obj/item/storage/backpack/duffelbag/syndie/surgery,
		/obj/item/encryptionkey/syndicate,
		/obj/item/clothing/glasses/thermal/syndi,
		/obj/item/storage/box/syndie_kit/imp_uplink,
		/obj/item/clothing/gloves/krav_maga/combatglovesplus,
		/obj/item/gun/ballistic/automatic/c20r/toy/unrestricted/riot,
		/obj/item/reagent_containers/syringe/stimulants,
		/obj/item/storage/box/syndie_kit/imp_freedom,
		/obj/item/storage/toolbox/infiltrator
	)
	var/obj/item1 = pick_n_take(item_list)
	var/obj/item2 = pick_n_take(item_list)
	var/obj/item3 = pick_n_take(item_list)
	new item1(src)	// Create three, non repeat items from the list.
	new item2(src)
	new item3(src)
	new /obj/item/paper/contractor_guide(src)	//Paper guide

/obj/item/storage/box/syndie_kit/northstar

/obj/item/storage/box/syndie_kit/northstar/PopulateContents()
	new /obj/item/clothing/gloves/fingerless/pugilist/rapid(src)
	new /obj/item/clothing/accessory/padding(src)
	new /obj/item/clothing/under/chameleon(src)
	new /obj/item/storage/fancy/cigarettes/cigpack_syndicate(src)
	new /obj/item/lighter(src)

/obj/item/storage/box/syndie_kit/scarp

/obj/item/storage/box/syndie_kit/scarp/PopulateContents()
	new /obj/item/book/granter/martial/carp(src)
	new /obj/item/clothing/suit/hooded/carp_costume(src)
	new /obj/item/staff/bostaff(src)

/obj/item/storage/box/syndie_kit/sleepytime/cardpack/PopulateContents()
	. = ..()
	new /obj/item/cardpack/syndicate(src)
	new /obj/item/cardpack/syndicate(src)

/obj/item/storage/box/syndie_kit/imp_deathrattle
	name = "deathrattle implant box"
	desc = "Contains eight linked deathrattle implants."

/obj/item/storage/box/syndie_kit/imp_deathrattle/PopulateContents()
	new /obj/item/implanter(src)

	var/datum/deathrattle_group/group = new

	var/implants = list()
	for(var/j in 1 to 8)
		var/obj/item/implantcase/deathrattle/case = new (src)
		implants += case.imp

	for(var/i in implants)
		group.register(i)
	desc += " The implants are registered to the \"[group.name]\" group."
