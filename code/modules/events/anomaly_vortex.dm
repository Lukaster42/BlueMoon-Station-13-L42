/datum/round_event_control/anomaly/anomaly_vortex
	name = "Anomaly: Vortex"
	typepath = /datum/round_event/anomaly/anomaly_vortex

	min_players = 20
	max_occurrences = 2
	weight = 10

/datum/round_event/anomaly/anomaly_vortex
	start_when = 10
	announce_when = 3
	anomaly_path = /obj/effect/anomaly/bhole

/datum/round_event/anomaly/anomaly_vortex/announce(fake)
	priority_announce("Обнаружена высокоинтенсивная вихревая аномалия на сканерах большой дальности. Ожидаемое место: [impact_area.name]", "Аномальная тревога", has_important_message = TRUE)
