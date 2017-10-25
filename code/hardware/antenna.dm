obj/signal
	antenna
		name = "antenna"
		icon = 'icons/computer.dmi'
		icon_state = "antenna"
		density = 1
		place_locked = 1
		var/broadcasting = null
		var/obj/signal/line1 = null
		var/obj/signal/control = null
		var/e_key = "1"
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
			return

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

		r_accept(string in view(usr.client), source in view(usr.client))
			var/list/ekeys = params2list(src.e_key)
			if(!ekeys) return 0
			if (string in ekeys)
				return 1
			else
				return 0

		process_signal(obj/signal/structure/S, obj/source)
			..()
			if(istype(src,/obj/signal/antenna/dish)) return
			S.loc = null
			S.master = src
			if (src.broadcasting)
				del(S)
				return
			src.broadcasting = 1
			if (source == src.line1)
				for(var/obj/signal/C in world)
					if ((get_dist(C.loc, src.loc) <= 50 && C != src))
						var/a = 0
						var/list/my_ekeys = params2list(src.e_key)
						for(var/E in my_ekeys)
							if(C.r_accept(E,src))
								a = 1
						if (a)
							var/obj/signal/structure/S1 = new /obj/signal/structure()
							S.copy_to(S1)
							S1.strength -= 2
							if (S1.strength <= 0)
								del(S1)
								return
							missile(/obj/radio, src.loc, C.loc)
							spawn( 0 )
								C.process_radio(S1,src)
								return

			else
				if (S.id == "e_key")
					var/number
					var/list/my_ekeys = params2list(S.params)
					if(my_ekeys.len > 5) my_ekeys.Cut(6)
					for(var/E in my_ekeys)
						var/b = 0
						if(my_ekeys.Find(E) < my_ekeys.len) b = 1
						E = text2num(E)
						E = round(min(max(1, E), 65000))
						number += "[E]"
						if(b) number += ";"
					src.e_key = "[number]"
			del(S)
			sleep(5)
			src.broadcasting = null
			return

		process_radio(obj/signal/structure/S as obj in view(usr.client),atom/source)
			S.loc = src
			S.master = src
			spawn( 0 )
				if (src.line1)
					src.line1.process_signal(S, src)
				else
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
