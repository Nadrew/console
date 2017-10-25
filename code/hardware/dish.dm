obj/signal/antenna
	dish
		name = "Satellite Relay Uplink"
		icon_state = "dish"
		r_accept(string in view(usr.client), source in view(usr.client))
			var/list/ekeys = params2list(src.e_key)
			if(!ekeys) return 0
			if ((string in ekeys && istype(source, /obj/signal/antenna/dish)))
				return 1
			else
				return 0

		process_signal(obj/signal/structure/S, obj/source)
			..()
			if(!S) return
			S.loc = null
			S.master = src
			S.timer_down = 1
			if (src.broadcasting)
				del(S)
				return
			src.broadcasting = 1
			if (source == src.line1)
				for(var/obj/signal/C in world)
					if (C != src)
						var/list/my_ekeys = params2list(src.e_key)
						var/a = 0
						for(var/E in my_ekeys)
							if(C.r_accept(E,src))
								a = 1
						if (a)
							var/obj/signal/structure/S1 = new /obj/signal/structure(  )
							S.copy_to(S1)
							S1.timer_down = 1
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

