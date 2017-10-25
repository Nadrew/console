obj/items
	name = "items"
	icon = 'icons/items.dmi'
	var/b_flags = 0.0

	book
		name = "book"
		icon_state = "book"
		var/flags = null
	box
		name = "box"
		icon_state = "box"
	bug_scan
		name = "electronic scanner"
		icon_state = "b_scan"
		b_flags = 1.0
	computer
		name = "computer"
		icon_state = "cpu"
		var/obj/signal/computer/com = null
		verb
			label(T as text)
				set src in view(1)
				set category = "computers"
				if(!T)
					name = "computer"
					if(com)
						com.label = null
						com.name = "computer"
				else
					name = "computer- '[T]'"
					if(com)
						com.label = T
						com.name = "computer- '[T]'"
		New(loca in view(usr.client), obj/C as obj in view(usr.client))

			if (!( C ))
				src.com = new /obj/signal/computer( src )
				src.com.icon_state = "removed"
				src.com.status = "no_m"
			else
				src.com = C

		attack_by(W as obj in view(usr.client), mob/user in view(usr.client))

			if (!( istype(W, /obj/items/wrench) ))
				user << "You have to use a wrench"
			if (!( isturf(src.loc) ))
				user << "The computer cannot be deployed inside an object."
				return
			else
				src.com.loc = src.loc
				del(src)
				return
	disk
		desc = "You can store and transfer files using these!"
		name = "disk"
		icon = 'icons/computer.dmi'
		icon_state = "disk"
		var/datum/file/dir/root = null
		b_flags = 2.0
	inv_pen
		name = "invisible pen"
		icon_state = "inv_pen"
	key
		name = "key"
		icon_state = "key"
		var/id = 1.0
	lis_bug
		name = "listening bug"
		icon_state = "bug_black"
		var/freq = null
		var/master = null
	lock
		name = "lock"
		icon_state = "lock"
		var/id = 1.0
		var/obj/items/lockpick/cur_pick = null
		e_lock
			name = "keypad lock"
			icon_state = "e_lock"
			id = "1"
	lock_kit
		name = "lock kit"
		icon_state = "lock_kit"
	lockpick
		name = "lockpick/tension wrench"
		icon_state = "lockpick"
		var/obj/items/lock/cur_lock = null
		var/cur_pin = 1.0
		var/cur_pos = 5.0
		var/pin_loc = "55555"
		var/target = null
		var/temp = null
	monitor
		name = "monitor"
		icon = 'icons/computer.dmi'
		icon_state = "monitor"
		density = 1
	not_check
		name = "notoriety check"
		icon_state = "not_check"
		var/id = null
	paint
		name = "paint"
		icon_state = "paint"
	paper
		name = "paper"
		icon_state = "paper"
		var/data = null
		var/secret = null
	pen
		name = "pen"
		icon_state = "pen"
	scan_chip
		name = "scan chip"
		icon_state = "scan_chip"
		var/freq = null
	screwdriver
		name = "screwdriver"
		icon_state = "screwdriver"
	toolbox
		name = "toolbox"
		icon_state = "toolbox"
	ult_check
		name = "ultraviolet check"
		icon_state = "ult_check"
	watch
		name = "watch"
		icon_state = "watch"
	wirecutters
		desc = "You can cut wire with these. Just equip them and double click on the target wire!"
		name = "wirecutters"
		icon_state = "wirecutters"
	wrench
		name = "wrench"
		icon_state = "wrench"