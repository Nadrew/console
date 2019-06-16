var
	n_version = "N2.3"
	n_sub = ".1R"
	list/rsc_fonts = list('fonts/CALLIGRA.ttf')
	list/door_codes = list()
	motd = ""

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
		
		LoadAdmins()
		LoadConfig()	
		LoadMOTD()

		// Initialize with loaded config.
		for(var/obj/s)
			s.Initialize()

		LoadLabs()

		// Spawn a process to save the labs every 5 minutes.
		spawn(1)
			while(1)
				sleep(3000)
				SaveLabs()
datum
	var

		rname

obj
	layer = OBJ_LAYER
	var/list/bugs = list()


obj
	var
	obj/items/lock/lock


