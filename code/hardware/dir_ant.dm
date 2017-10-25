// /obj/signal/dir_ant (DEF)

obj/signal
	dir_ant
		name = "dir ant"
		icon = 'icons/computer.dmi'
		icon_state = "dir_ant"
		place_locked = 1
		density = 1
		var/obj/signal/line1 = null
		var/obj/signal/control = null
		orient_to(obj/target in view(usr.client), user as mob in view(usr.client))
			if(ismob(src.loc))
				user << "Device must be on the ground to connect to it."
				return 0
			if (!( src.line1 ))
				src.line1 = target
				user << "Connected to antenna:I/O"
				return 1
			else
				if (!( src.control ))
					user << "Connected to antenna:control"
					src.control = target
					return 1
				else
					return 0

		d_accept()
			return 1

		disconnectfrom(obj/target in view(usr.client))

			if (target == src.line1)
				src.line1 = null
			else
				if (target == src.control)
					src.control = null
		cut()
			if (src.line1)
				src.line1.disconnectfrom(src)
			if (src.control)
				src.control.disconnectfrom(src)
			src.line1 = null
			src.control = null

		process_radio(obj/signal/structure/S as obj in view(usr.client),atom/source)
			S.loc = src
			S.master = src
			spawn( 0 )
				if (src.line1)
					src.line1.process_signal(S, src)
				else
					del(S)
				return

		process_signal(obj/signal/structure/S as obj in view(usr.client), obj/source as obj in view(usr.client))
			..()
			S.loc = null
			S.master = src
			if (source == src.line1)
				var/turf/cur_tile = src.loc
				var/turf/next_tile = get_step(cur_tile,src.dir)
				var/obj/signal/dir_ant/found_ant = locate() in next_tile
				while(!found_ant && next_tile)
					var/turf/last_tile = next_tile
					next_tile = get_step(cur_tile,src.dir)
					cur_tile = last_tile
					found_ant = locate() in next_tile
				if(found_ant)
					var/obj/signal/structure/S1 = new()
					S.copy_to(S1)
					found_ant.process_radio(S1,src)
			else
				if (S.id == "direct")
					var/number = S.params
					if(dir2num(number))
						src.dir = dir2num(number)
				if (S.id == "turn")
					var/number = text2num(S.params)
					switch(number)
						if(45,90,18) src.dir = turn(src.dir, number)
				del(S)

		verb
			disconnect(t1 as num)
				set desc = "1 for I/O, 2 for control"

				if (t1 == 1)
					if (src.line1)
						src.line1.disconnectfrom(src)
					src.line1 = null
				else
					if (t1 == 2)
						if (src.control)
							src.control.disconnectfrom(src)
						src.control = null

			swap()
				set src in oview(1)
				var/temp = src.line1
				src.line1 = src.control
				src.control = temp
				usr << "I/O line (Now: [src.line1]) swapped with control (Now: [src.control])!"




