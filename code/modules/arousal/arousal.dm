/mob/living
	var/mb_cd_length = 5 SECONDS						//5 second cooldown for masturbating because fuck spam.
	var/mb_cd_timer = 0									//The timer itself

/mob/living/carbon/human
	var/saved_underwear = ""//saves their underwear so it can be toggled later
	var/saved_undershirt = ""
	var/saved_socks = ""
	var/hidden_underwear = FALSE
	var/hidden_undershirt = FALSE
	var/hidden_socks = FALSE
	var/arousal_rate = 1

//Mob procs
/mob/living/carbon/human/verb/underwear_toggle()
	set name = "Toggle undergarments"
	set category = "IC"

	var/confirm = input(src, "Select what part of your form to alter", "Undergarment Toggling") as null|anything in list("Top", "Bottom", "Socks", "All")
	if(!confirm)
		return
	if(confirm == "Top")
		hidden_undershirt = !hidden_undershirt
		log_message("[hidden_undershirt ? "removed" : "put on" ] [ru_ego()] undershirt.", LOG_EMOTE)

	if(confirm == "Bottom")
		hidden_underwear = !hidden_underwear
		log_message("[hidden_underwear ? "removed" : "put on"] [ru_ego()] underwear.", LOG_EMOTE)

	if(confirm == "Socks")
		hidden_socks = !hidden_socks
		log_message("[hidden_socks ? "removed" : "put on"] [ru_ego()] socks.", LOG_EMOTE)

	if(confirm == "All")
		var/on_off = (hidden_undershirt || hidden_underwear || hidden_socks) ? FALSE : TRUE
		hidden_undershirt = on_off
		hidden_underwear = on_off
		hidden_socks = on_off
		log_message("[on_off ? "removed" : "put on"] all [ru_ego()] undergarments.", LOG_EMOTE)

	update_body(TRUE)


/mob/living/carbon/human/proc/adjust_arousal(strength, cause = "manual toggle", aphro = FALSE,maso = FALSE) // returns all genitals that were adjust
	var/list/obj/item/organ/genital/genit_list = list()
	if(!client?.prefs.arousable || (aphro && (client?.prefs.cit_toggles & NO_APHRO)) || (maso && !HAS_TRAIT(src, TRAIT_MASO)))
		return // no adjusting made here
	var/enabling = strength > 0
	for(var/obj/item/organ/genital/G in internal_organs)
		if(G.genital_flags & GENITAL_CAN_AROUSE && !G.aroused_state && prob(abs(strength)*G.sensitivity * arousal_rate))
			G.set_aroused_state(enabling,cause)
			G.update_appearance()
			update_body(TRUE)
			if(G.aroused_state)
				genit_list += G
	return genit_list

/obj/item/organ/genital/proc/climaxable(mob/living/carbon/human/H, silent = FALSE) //returns the fluid source (ergo reagents holder) if found.
	if((genital_flags & GENITAL_FUID_PRODUCTION))
		. = reagents
	else
		if(linked_organ)
			. = linked_organ.reagents
	if(!. && !silent)
		to_chat(H, "<span class='warning'>Твой [name] не в состоянии производить собственную жидкость, ведь у него отсутствуют органы для этого.</span>")

/mob/living/carbon/human/proc/do_climax(datum/reagents/R, atom/target, obj/item/organ/genital/G, spill = TRUE)
	if(!G)
		return
	if(!target || !R)
		return
	var/turfing = isturf(target)
	var/condomning
	if(istype(G, /obj/item/organ/genital/penis))
		var/obj/item/organ/genital/penis/P = G
		condomning = locate(/obj/item/genital_equipment/condom) in P.contents
	G.generate_fluid(R)
	log_message("Climaxed using [G] with [target]", LOG_EMOTE)
	if(condomning)
		to_chat(src, "<span class='userlove'>Ты чувствуешь, как презерватив наполняется изнутри и таким-то образом наполняется твоей спермой!</span>")
		R.trans_to(condomclimax(), R.total_volume)
	else
		if(spill && R.total_volume >= 5)
			R.reaction(turfing ? target : target.loc, TOUCH, 1, 0)
		if(!turfing)
			R.trans_to(target, R.total_volume * (spill ? G.fluid_transfer_factor : 1), log = TRUE)
	G.last_orgasmed = world.time
	R.clear_reagents()
	//skyrat edit - chock i am going to beat you to death
	//this is not a joke i am actually going to break your
	//ribcage
	if(!Process_Spacemove(turn(dir, 180)))
		newtonian_move(turn(dir, 180))
	//

/mob/living/carbon/human/proc/mob_climax_outside(obj/item/organ/genital/G, mb_time = 30) //This is used for forced orgasms and other hands-free climaxes
	var/datum/reagents/fluid_source = G.climaxable(src, TRUE)
	if(!fluid_source)
		to_chat(src,"<span class='userdanger'>Твой [G.name] предательски сжимается, не имея возможности кончить...</span>")
		return
	if(mb_time) //as long as it's not instant, give a warning
		to_chat(src,"<span class='userlove'>Вы чувствуете, что вот-вот достигнете оргазма!</span>")
		if(!do_after(src, mb_time, target = src) || !G.climaxable(src, TRUE))
			return
	to_chat(src,"<span class='userlove'>Вы оргазмируете [isturf(loc) ? "прямо на <b>'[loc]'</b>" : ""], отлично! Конечно же, [G.name] изливается следом.</span>")
	do_climax(fluid_source, loc, G)

/mob/living/carbon/human/proc/mob_climax_partner(obj/item/organ/genital/G, mob/living/L, spillage = TRUE, mb_time = 30, obj/item/organ/genital/Lgen = null) //Used for climaxing with any living thing
	var/datum/reagents/fluid_source = G.climaxable(src)
	if(!fluid_source)
		return
	if(mb_time) //Skip warning if this is an instant climax.
		to_chat(src,"<span class='userlove'>Ты вот-вот достигнешь кульминации [(Lgen) ? "в <b>[L]</b> [Lgen.name]" : "совместно с <b>[L]</b>"]!</span>")
		to_chat(L,"<span class='userlove'>[src] вот-вот достигнет кульминации [(Lgen) ? "в твой [Lgen.name]" : "совместно с тобой"]!</span>")
		if(!do_after(src, mb_time, target = src) || !in_range(src, L) || !G.climaxable(src, TRUE))
			return
	if(spillage)
		to_chat(src,"<span class='userlove'>Вы испытываете оргазм с <b>[L]</b>, изливая [(Lgen) ? "[L.ru_ego()] [Lgen.name]" : "[L.ru_ego()] / [Lgen.name]"]. [G.name] требует отдыха после использования!</span>")
		to_chat(L,"<span class='userlove'>[src] кульминирует [(Lgen) ? "в твою [Lgen.name]" : "совместно с тобой"], в процессе попросту переполненяя и закономерно проливая всякое. [G.name] требует отдыха после использования!</span>")
	else //knots and other non-spilling orgasms
		to_chat(src,"<span class='userlove'>Вы достигаете кульминации И [(Lgen) ? "в <b>[L]</b> [Lgen.name]" : "совместно с <b>[L]</b>"], в процессе ничего не проливая. [G.name] требует отдыха после использования!</span>")
		to_chat(L,"<span class='userlove'>[src] кульминирует [(Lgen) ? "в твою [Lgen.name]" : "совместно с тобой"], [ru_ego()] [G.name] ничего не проливает в процессе! [G.name] требует отдыха после использования!</span>")
	//SEND_SIGNAL(L, COMSIG_ADD_MOOD_EVENT, "orgasm", /datum/mood_event/orgasm) //Sandstorm edit
	do_climax(fluid_source, spillage ? loc : L, G, spillage,, Lgen)
	//L.receive_climax(src, Lgen, G, spillage)

/mob/living/carbon/human/proc/mob_fill_container(obj/item/organ/genital/G, obj/item/reagent_containers/container, mb_time = 30) //For beaker-filling, beware the bartender
	var/datum/reagents/fluid_source = G.climaxable(src)
	if(!fluid_source)
		return
	if(mb_time)
		to_chat(src,"<span class='userlove'>Вы начали [G.masturbation_verb] прямо над <b>[container]</b>. [G.name] в готовности к этому...</span>")
		if(!do_after(src, mb_time, target = src) || !in_range(src, container) || !G.climaxable(src, TRUE))
			return
	to_chat(src,"<span class='userlove'>[G.name] стимулируется вашими же усилиями, вы пытаетесь наполнить <b>[container]</b>.</span>")
	message_admins("[ADMIN_LOOKUPFLW(src)] использует [ru_ego()] [G.name], чтобы наполнить <b>[container]</b> [G.get_fluid_name()].")
	log_consent("[key_name(src)] использует [ru_ego()] [G.name], чтобы наполнить <b>[container]</b> [G.get_fluid_name()].")
	do_climax(fluid_source, container, G, FALSE, cover = TRUE)

/mob/living/carbon/human/proc/pick_climax_genitals(silent = FALSE)
	var/list/genitals_list
	var/list/worn_stuff = get_equipped_items()

	for(var/obj/item/organ/genital/G in internal_organs)
		if((G.genital_flags & CAN_CLIMAX_WITH) && G.is_exposed(worn_stuff)) //filter out what you can't masturbate with
			LAZYADD(genitals_list, G)
	if(LAZYLEN(genitals_list))
		var/obj/item/organ/genital/ret_organ = input(src, "Чем?", "Климаксировать", null) as null|obj in genitals_list
		return ret_organ
	else if(!silent)
		to_chat(src, "<span class='warning'>Вы не можете достичь кульминации без наличия гениталий.</span>")

/mob/living/carbon/human/proc/pick_partner(silent = FALSE)
	var/list/partners = list()
	if(pulling)
		partners += pulling
	if(pulledby)
		partners += pulledby
	//Now we got both of them, let's check if they're proper
	for(var/mob/living/L in partners)
		if(!L.client || !L.mind) // can't consent, not a partner
			partners -= L
		if(iscarbon(L))
			var/mob/living/carbon/C = L
			if(!C.exposed_genitals.len && !C.is_groin_exposed() && !C.is_chest_exposed() && C.is_mouth_covered()) //Nothing through_clothing, no proper partner.
				partners -= C
	//NOW the list should only contain correct partners
	if(!partners.len)
		if(!silent)
			to_chat(src, "<span class='warning'>Вы не можете сделать это в одиночку.</span>")
		return //No one left.
	var/mob/living/target = input(src, "С кем?", "Партнёр по Совокуплению", null) as null|anything in partners //pick one, default to null
	if(target && in_range(src, target))
		to_chat(src,"<span class='notice'>Ожидание согласия...</span>")
		var/consenting = input(target, "Вы хотите, чтобы [src] кончил совместно с вами?","Механика Кульминации","Нет") in list("Да","Нет")
		if(consenting == "Да")
			return target
		else
			message_admins("[ADMIN_LOOKUPFLW(src)] tried to climax with [target], but [target] did not consent.")
			log_consent("[key_name(src)] tried to climax with [target], but [target] did not consent.")

/mob/living/carbon/human/proc/pick_climax_container(silent = FALSE)
	var/list/containers_list = list()

	for(var/obj/item/reagent_containers/C in held_items)
		if(C.is_open_container() || istype(C, /obj/item/reagent_containers/food/snacks))
			containers_list += C
	for(var/obj/item/reagent_containers/C in range(1, src))
		if((C.is_open_container() || istype(C, /obj/item/reagent_containers/food/snacks)) && CanReach(C))
			containers_list += C

	if(containers_list.len)
		var/obj/item/reagent_containers/SC = input(src, "В или на что? (Отмена, если никуда)", null)  as null|obj in containers_list
		if(SC && CanReach(SC))
			return SC
	else if(!silent)
		to_chat(src, "<span class='warning'>Вы не сможете сделать это без соответствующего контейнера.</span>")

/mob/living/carbon/human/proc/available_rosie_palms(silent = FALSE, list/whitelist_typepaths = list(/obj/item/dildo))
	if(restrained(TRUE)) //TRUE ignores grabs
		if(!silent)
			to_chat(src, "<span class='warning'>Вы не можете сделать это, будучи связанным!</span>")
		return FALSE
	if(!get_num_arms() || !get_empty_held_indexes())
		if(whitelist_typepaths)
			if(!islist(whitelist_typepaths))
				whitelist_typepaths = list(whitelist_typepaths)
			for(var/path in whitelist_typepaths)
				if(is_holding_item_of_type(path))
					return TRUE
		if(!silent)
			to_chat(src, "<span class='warning'>Вам нужна как минимум одна свободная рука.</span>")
		return FALSE
	return TRUE

//Here's the main proc itself
//skyrat edit - forced partner and spillage
/mob/living/carbon/human/proc/mob_climax(forced_climax=FALSE,cause = "", var/mob/living/forced_partner = null, var/forced_spillage = TRUE, var/obj/item/organ/genital/forced_receiving_genital = null) //Forced is instead of the other proc, makes you cum if you have the tools for it, ignoring restraints
	set waitfor = FALSE
	if(mb_cd_timer > world.time)
		if(!forced_climax) //Don't spam the message to the victim if forced to come too fast
			to_chat(src, "<span class='warning'>Вы должны подождать [DisplayTimeText((mb_cd_timer - world.time), TRUE)] до того, как можете сделать это снова!</span>")
		return

	if(!client?.prefs.arousable || !has_dna())
		return
	if(stat == DEAD)
		if(!forced_climax)
			to_chat(src, "<span class='warning'>Ты не можешь сделать это, будучи мертвым!</span>")
		return
	if(forced_climax) //Something forced us to cum, this is not a masturbation thing and does not progress to the other checks
		log_message("was forced to climax by [cause]",LOG_EMOTE)
		for(var/obj/item/organ/genital/G in internal_organs)
			if(!(G.genital_flags & CAN_CLIMAX_WITH)) //Skip things like wombs and testicles
				continue
			var/mob/living/partner
			var/check_target
			var/list/worn_stuff = get_equipped_items()

			if(G.is_exposed(worn_stuff))
				if(pulling) //Are we pulling someone? Priority target, we can't be making option menus for this, has to be quick
					if(isliving(pulling)) //Don't fuck objects
						check_target = pulling
				if(pulledby && !check_target) //prioritise pulled over pulledby
					if(isliving(pulledby))
						check_target = pulledby
				//Now we should have a partner, or else we have to come alone
				if(check_target)
					if(iscarbon(check_target)) //carbons can have clothes
						var/mob/living/carbon/C = check_target
						if(C.exposed_genitals.len || C.is_groin_exposed() || C.is_chest_exposed()) //Are they naked enough?
							partner = C
					else //A cat is fine too
						partner = check_target
				//skyrat edit
				if(forced_partner)
					if((forced_partner == "none") || (!istype(forced_partner)))
						partner = null
					else
						partner = forced_partner
				//
				if(partner) //Did they pass the clothing checks?
					//skyrat edit
					mob_climax_partner(G, partner, spillage = forced_spillage, mb_time = 0, Lgen = forced_receiving_genital, forced = forced_climax) //Instant climax due to forced
					//
					continue //You've climaxed once with this organ, continue on
			//not exposed OR if no partner was found while exposed, climax alone
			mob_climax_outside(G, mb_time = 0) //removed climax timer for sudden, forced orgasms
		//Now all genitals that could climax, have.
		//Since this was a forced climax, we do not need to continue with the other stuff
		mb_cd_timer = world.time + mb_cd_length
		return
	//If we get here, then this is not a forced climax and we gotta check a few things.

	if(stat == UNCONSCIOUS) //No sleep-masturbation, you're unconscious.
		to_chat(src, "<span class='warning'>Вы должны быть в сознании, чтобы сделать это!</span>")
		return

	//Ok, now we check what they want to do.
	var/choice = input(src, "Выбор Сексуальной Активности", "Сексуальная Активность:") as null|anything in list("Оргазмировать в одиночестве","Оргазмировать совмпестно с кем-то", "Climax over partner", "Наполнить контейнер половыми жидкостями")
	if(!choice)
		return

	switch(choice)
		if("Оргазмировать в одиночестве")
			if(!available_rosie_palms())
				return
			var/obj/item/organ/genital/picked_organ = pick_climax_genitals()
			if(picked_organ && available_rosie_palms(TRUE))
				mob_climax_outside(picked_organ)
		if("Оргазмировать совместно с кем-то")
			//We need no hands, we can be restrained and so on, so let's pick an organ
			var/obj/item/organ/genital/picked_organ = pick_climax_genitals()
			var/obj/item/organ/genital/picked_target = null
			if(picked_organ)
				var/mob/living/partner = pick_partner() //Get someone
				if(partner)
					picked_target = pick_receiving_organ(partner)
					var/spillage = input(src, "Would your fluids spill outside?", "Choose overflowing option", "Yes") as null|anything in list("Yes", "No")
					if(spillage && in_range(src, partner))
						mob_climax_partner(picked_organ, partner, spillage == "Yes" ? TRUE : FALSE, Lgen = picked_target)
		if("Наполнить контейнер половыми жидкостями")
			//We'll need hands and no restraints.
			if(!available_rosie_palms(FALSE, /obj/item/reagent_containers))
				return
			//We got hands, let's pick an organ
			var/obj/item/organ/genital/picked_organ
			picked_organ = pick_climax_genitals() //Gotta be climaxable, not just masturbation, to fill with fluids.
			if(picked_organ)
				//Good, got an organ, time to pick a container
				var/obj/item/reagent_containers/fluid_container = pick_climax_container()
				if(fluid_container && available_rosie_palms(TRUE, /obj/item/reagent_containers))
					mob_fill_container(picked_organ, fluid_container)
		if("Оргазмировать на кого-то (CTRL+ЛКМ)")
			//We need no hands, we can be restrained and so on, so let's pick an organ
			var/obj/item/organ/genital/picked_organ = pick_climax_genitals()
			if(picked_organ)
				var/mob/living/partner = pick_partner() //Get someone
				if(partner)
					mob_climax_over(picked_organ, partner, TRUE)

	mb_cd_timer = world.time + mb_cd_length

/mob/living/carbon/human/verb/climax_verb()
	set category = "IC"
	set name = "Climax"
	set desc = "Lets you choose a couple ways to ejaculate."
	mob_climax()
