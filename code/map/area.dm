area
	start
		name = "Start"
		icon = 'icons/save_loc.dmi'
		icon_state = "green"
		layer = TURF_LAYER+1
		New()
			..()
			// So I can see the start area while mapping, but not in-game.
			icon = null
			layer = AREA_LAYER