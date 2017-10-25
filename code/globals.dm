var
	n_version = "N2.3"
	n_sub = ".0"
	list/rsc_fonts = list('fonts/CALLIGRA.ttf')

world
	mob = /mob
	turf = /turf/floor
	area = /area
	view = "18x18"
	hub = "Exadv1.console"
	name = "console"
	status = "Version N2.3"
	New()
		..()
		status = "Version [n_version][n_sub]"
datum
	var

		rname

obj
	layer = OBJ_LAYER
	var/list/bugs = list()


obj
	var
	obj/items/lock/lock


