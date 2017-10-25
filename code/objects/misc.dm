obj/items
	watch
		verb
			time()
				set src in usr

				usr << "\blue It is now [time2text(world.time, "hh:mm:ss")]. System clocks register [world.time]."

			full_time()
				set src in usr

				usr << "\blue [time2text(world.time, "DDD DD MMM (MM), YYYY - hh:mm:ss")]"



obj
	trashcan
		attack_by(obj/P in usr, mob/user)
			if(P.loc != user) return
			if(istype(P,/obj/items))
				var/obj/items/PQ = P
				PQ.unequip()
			view(src, 3) << "\red [user] throws away [P]!"
			P.loc = src
			sleep(300)
			if ((P && P.loc == src))
				del(P)

		verb/remove(obj/O in src)
			set src in oview(1)

			O.loc = src.loc
			view(src, 3) << "\red [usr] takes [O] from the garbage!"

obj
	plants
		hear(msg in view(usr.client), source as mob|obj|turf|area in view(usr.client), s_type in view(usr.client), c_mes in view(usr.client), r_src as mob|obj|turf|area in view(usr.client))

			for(var/atom/A in src.bugs)
				A.hear(msg, source, s_type, c_mes, r_src)


		attack_by(obj/items/I in view(usr.client), mob/user in view(usr.client))

			if ((src.contents.len < 2 && istype(I, /obj/items)))
				I.unequip()
				user << "\blue You hide [I] in [src]."
				I.loc = src
		DblClick()

			if (usr.equipped)
				..()
			else
				if (get_dist(src, usr) <= 1)
					usr << "\blue You dig through the dirt and find...\..."
					if (src.contents.len < 1)
						usr << "\blue Nothing!"
					else
						usr << "\blue Hidden items!"
						for(var/obj/O in src)
							O.loc = src.loc


		attack_by(obj/items/I in view(usr.client), mob/user in view(usr.client))

			if ((src.contents.len < 1 && istype(I, /obj/items)))
				I.unequip()
				user << "\blue You hide [I] in [src]."
				I.loc = src

	table
		New()

			..()
			src.t_type = src.icon_state

		attack_by(obj/items/I in view(usr.client), mob/user in view(usr.client))

			if (I)
				if(istype(I,/obj/items))
					I.unequip()
				else
					if(user.equipped == I)
						I.suffix = null
						user.equipped = null
						user << "\blue You unequip [I.name]"
				user << "\blue You place [I] on [src]."
				I.loc = src.loc

		secret
			DblClick()
				if (get_dist(usr, src) > 1)
					return
				if (src.density)
					src.density = 0
					src.icon_state = "s_[src.t_type]"
				else
					src.density = 1
					src.icon_state = "[src.t_type]"

	stool
		chair
			New()

				..()
				spawn( 1 )
					if (src.dir == NORTH)
						src.layer = 5
					return