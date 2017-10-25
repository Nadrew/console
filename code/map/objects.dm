obj
	stool
		name = "stool"
		icon = 'icons/chairs.dmi'
		icon_state = "stool"
		chair
			name = "chair"
			icon_state = "chair"
	table
		name = "table"
		icon = 'icons/table.dmi'
		icon_state = "alone"
		density = 1
		var/t_type = null
		layer = TURF_LAYER
		secret
			layer = TURF_LAYER+2
	trashcan
		name = "trashcan"
		icon = 'icons/misc.dmi'
		icon_state = "trashcan"
		density = 1


	window
		name = "window"
		icon = 'icons/misc.dmi'
		icon_state = "window"
		density = 1
		layer = TURF_LAYER

	plants
		name = "potted plant"
		icon = 'icons/objects.dmi'
		icon_state = "s_plant"
		density = 1
		large
			name = "large plant"
			icon_state = "l_plant"

	alphanumeric
		name = "alphanumeric"
		icon = 'icons/alphanumeric.dmi'
		layer = TURF_LAYER

	boxrack
		name = "boxrack"
		icon = 'icons/objects.dmi'
		icon_state = "box_rack"
		opacity = 1
		density = 1
	bulletin
		name = "bulletin board"
		icon = 'icons/objects.dmi'
		icon_state = "bullitin"
	conveyor
		name = "conveyor"
		icon = 'icons/objects.dmi'
		icon_state = "convey"
		electronic
			name = "electronic conveyor"
			icon_state = "e_convey"
	copier
		name = "copier"
		icon = 'icons/computer.dmi'
		icon_state = "copier"
		density = 1
	door
		name = "door"
		icon = 'icons/door.dmi'
		icon_state = "door1_1"
		opacity = 1
		density = 1
		var/obj/door/connected = null
		var/operating = null
	electronic
		name = "electronic"
		icon = 'icons/objects.dmi'
		icon_state = "e_convey"
	filecabinet
		name = "filecabinet"
		icon = 'icons/objects.dmi'
		icon_state = "file_cabinet"
		density = 1

	shredder
		name = "shredder"
		icon = 'icons/computer.dmi'
		icon_state = "shredder"
	sign
		name = "sign"
		icon = 'icons/misc.dmi'
		icon_state = "sign"