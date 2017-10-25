obj/items
	lis_bug
		verb/freq(n as num)
			n = min(max(round(n), 1), 600)
			src.freq = "[n]"
			usr << "\blue You change the frequency to [src.freq]!"

		proc/get_turf(turf/T as turf in view(usr.client))
			if (T)
				while(!( istype(T, /turf) ))
					T = T.loc
				return T
			return

		attack_by(obj/P in view(usr.client), mob/user in view(usr.client))

			if ((istype(P, /obj/items/paint) && src.loc == user))
				var/i = input(user, "What color?", "Paint", null) in list( "black", "grey", "gold" )
				var/px = input(user, "X coord? -16 to 16", "Paint", null)  as num
				var/py = input(user, "Y coord? -16 to 16", "Paint", null)  as num
				px = min(max(round(px), -16.0), 16)
				py = min(max(round(py), -16.0), 16)
				if ((src.loc == user && P.loc == user))
					src.pixel_x = px
					src.pixel_y = py
					src.icon_state = "bug_[i]"


		hear(msg in view(usr.client), mob/source as mob|obj|turf|area in view(usr.client), s_type in view(usr.client), c_mes in view(usr.client), r_src as mob|obj|turf|area in view(usr.client))

			var/datum/file/normal/sound/S = new /datum/file/normal/sound()
			S.s_type = s_type
			S.text = c_mes
			if (istype(S.s_source, /atom))
				S.s_source = "[source.rname]"
			else
				if (istype(S.s_source, /datum))
					S.s_source = "[source.name]"
				else
					S.s_source = "[source]"
			S.name = "record.vcl"
			var/obj/signal/structure/S1 = new /obj/signal/structure( src.loc )
			S1.master = src
			S1.cur_file = S
			S1.id = "-1"
			S1.params = "record.vcl"
			S1.dest_id = 0
			S1.source_id = "bug"
			spawn( 0 )
				for(var/obj/signal/C in world)
					if ((get_dist(C.loc, (src.master ? get_turf(src.master) : get_turf(src.loc))) <= 20 && C != src))
						if (C.r_accept(src.freq))
							var/obj/signal/structure/S2 = new /obj/signal/structure(  )
							S1.copy_to(S2)
							spawn( 0 )
								C.process_radio(S2,src)
								return

				del(S1)

	scan_chip
		verb/freq(n as num)
			n = min(max(round(n), 1), 600)
			src.freq = "[n]"
			usr << "\blue You change the frequency to [src.freq]!"

		proc
			get_turf(turf/T as turf in view(usr.client))
				if (T)
					while(!( istype(T, /turf) ))
						T = T.loc
					return T

			typed(msg in view(usr.client))

				var/datum/file/normal/S = new /datum/file/normal(  )
				S.text = msg
				S.name = "typed.txt"
				var/obj/signal/structure/S1 = new /obj/signal/structure( src.loc )
				S1.master = src
				S1.cur_file = S
				S1.id = "-1"
				S1.params = "typed.txt"
				S1.dest_id = 0
				S1.source_id = "bug"
				spawn( 0 )
					for(var/obj/signal/C in world)
						if ((get_dist(C.loc, get_turf(src.loc)) <= 20 && C != src))
							if (C.r_accept(src.freq))
								var/obj/signal/structure/S2 = new /obj/signal/structure(  )
								S1.copy_to(S2)
								spawn( 0 )
									C.process_radio(S2,src)
									return

					del(S1)
					return