
obj/vent
	outlet
		hear(msg in view(usr.client), atom/source as mob|obj|turf|area in view(usr.client), s_type in view(usr.client), c_msg in view(usr.client), atom/r_src as mob|obj|turf|area in view(usr.client))
			for(var/atom/A in view(src, null))
				if ((A == src || istype(A, /obj/vent))) continue
				else
					if ((source && (r_src.pos_status & 2 && A.pos_status & 1)))
						spawn( 0 )
							A.hear(msg, source, s_type, c_msg, src)
							return
					else
						if ((source && (r_src.pos_status & 1 && (A.pos_status & 2 && (get_dist(src, A) <= 1 || src.loc == A.loc)))))
							spawn( 0 )
								A.hear(msg, source, s_type, c_msg, src)
								return

		traverse(mob/M as mob in view(usr.client))

			. = ..()
			if (.)
				if (M.vblock)
					M.sight &= 65507
					M.vblock.layer = 1

		relay_move(mob/M as mob in view(usr.client))

			. = ..()
			if (.)
				if (M.vblock)
					M.sight |= 28
					M.vblock.layer = 20

		trapdoor
			verb
				open()
					set src in oview(1)

					if (usr.pos_status == 1)
						usr << "It doesn't open from the inside!"
						return
					src.open = 1
					src.icon_state = "trapdoor"
					src.represented.icon_state = "trapdoor"

				close()
					set src in oview(1)

					src.open = 0
					src.icon_state = "trap_closed"
					src.represented.icon_state = "trap_closed"

			DblClick()
				if (usr.loc != src.loc)
					return
				if (!( src.open ))
					usr << "It seems to be locked shut!"
					return
				if (usr.pos_status == 1)
					usr.pos_status = 2
					usr.invisibility = 0
					usr.see_invisible = 0
					usr.sight &= 65503
					usr.layer = MOB_LAYER
					usr.density = 1
					if (usr.client)
						for(var/obj/vent/V in world)
							usr.client.images -= V.represented
							//Foreach goto(109)
					usr << "<B>You crawl out of the vent system!</B>"
				else
					usr.pos_status = 1
					usr.invisibility = 99
					usr.see_invisible = 99
					usr.sight |= SEE_SELF
					usr.layer = 22
					usr.density = 0
					if (usr.client)
						for(var/obj/vent/V in world)
							usr.client.images -= V.represented
							usr.client.images += V.represented
							//Foreach goto(207)
					usr << "<B>You enter the tiny vent system!</B>"
					spawn( 1 )
						src.traverse(usr, src)
						return

obj/vent/ac/DblClick()

	src.status = !( src.status )
	if (no_wind)
		usr << "\blue The AC unit is still shutting down!"
		return
	if (!( src.status ))
		no_wind = 1
		sleep(1)
		src.icon_state = "ac_[src.status]"
		for(var/obj/vent/V in world)
			V.r_dir = V.r_dir2
			V.ac_on = null
			//Foreach goto(74)
		src.represented.icon_state = "ac_[src.status]"
		no_wind = null
	else
		src.icon_state = "ac_[src.status]"
		src.represented.icon_state = "ac_[src.status]"
		src.r_dir = src.r_dir / 2
		var/obj/vent/V = locate(/obj/vent, get_step(src.loc, SOUTH))
		if (V)
			spawn( 0 )
				V.ac_airflow(src)
				return

obj/vent/heater/DblClick()

	if (cooling)
		usr << "The heater must thoroughly cool down before you can turn it back on."
		return
	src.status = !( src.status )
	if (!( src.status ))
		cooling = 1
		src.icon_state = "heater_[src.status]"
		for(var/obj/vent/V in world)
			V.represented.icon = 'vents.dmi'
			sleep(1)
			//Foreach goto(67)
		src.represented.icon_state = "heater_[src.status]"
		cooling = null
	else
		src.icon_state = "heater_[src.status]"
		src.represented.icon_state = "heater_[src.status]"
		spawn( 0 )
			src.spread(src)
			return

obj/vent
	New()

		..()
		spawn( 5 )
			src.r_dir2 = src.r_dir
			return
		if (!( src.r_dir ))
			src.r_dir = src.dir
		src.represented = image('vents.dmi', src.loc, src.icon_state, 21, src.r_dir)

	ac_airflow(source as obj in view(usr.client))
		if (no_wind)
			return
		var/d_from = get_dir(src, source)
		if ((!( src.ac_on ) && (!( src.r_dir & (src.r_dir - 1) ) && get_dir(source, src) == (turn(src.r_dir / 2, 180)))))
			src.r_dir = 0
			return
		if ((src.r_dir & (src.r_dir - 1) || !( src.ac_on )))
			src.r_dir -= d_from
		src.ac_on = 1
		var/list/L = list(  )
		if (src.r_dir & 1)
			L += NORTH
		if (src.r_dir & 2)
			L += SOUTH
		if (src.r_dir & 4)
			L += EAST
		if (src.r_dir & 8)
			L += WEST
		for(var/t in L)
			var/obj/vent/V = locate(/obj/vent, get_step(src.loc, t))
			if ((!( no_wind ) && (V && (!( V.ac_on ) || V.r_dir & (src.r_dir - 1)))))
				spawn( 1 )
					V.ac_airflow(src)
					return
		for(var/atom/movable/A in src.loc)
			if(!isobj(A)||!ismob(A)) continue
			if ((!( no_wind ) && (A.pos_status & 1 && (!( istype(A, /obj/vent) ) && !( A.anchored )))))
				spawn( 1 )
					src.traverse(A, src)
					return

	proc
		relay_move(M as mob in view(usr.client), direction in view(usr.client))

			if (src.ac_on)
				return
			if (src.represented.icon == 'vents1.dmi')
				if (prob(90))
					M << "OUCH! It's EXCEPTIONALLY hot in here!"
				else
					M << "Ya, just so you know metal as in what these vents are made of conduct heat which is coming from the heater VERY WELL."
			if (!( src.r_dir & (src.r_dir - 1) ))
				direction = src.r_dir / 2
			else
				if (!( src.r_dir & direction ))
					return 0
			var/obj/vent/V = locate(/obj/vent, get_step(src.loc, direction))
			if (V)
				spawn( 1 )
					V.traverse(M, src)
					return
				return 1
			else
				return 0
			return

		traverse(mob/M as mob in view(usr.client), obj/source as obj in view(usr.client))

			if ((!( M ) || !( M.pos_status ) & 1))
				return
			if (M.loc != src.loc)
				step_towards(M, src)
			if (src.ac_on)
				var/list/L = list(  )
				if (src.r_dir & 1)
					L += NORTH
				if (src.r_dir & 2)
					L += SOUTH
				if (src.r_dir & 4)
					L += EAST
				if (src.r_dir & 8)
					L += WEST
				if (L.len)
					var/obj/vent/V = locate(/obj/vent, get_step(src.loc, pick(L)))
					if (V)
						spawn( 1 )
							V.traverse(M, src)
							return
						return 1
					else
						return 0
				return
			if (!( src.flags & 2 ))
				var/c_dir = get_dir(src, source)
				var/g_dir = src.r_dir - c_dir
				var/obj/vent/V = locate(/obj/vent, get_step(src.loc, g_dir))
				if (V)
					spawn( 1 )
						V.traverse(M, src)
						return
					return 1
				else
					return 0
			else
				return 1

		spread(source as obj in view(usr.client))

			if (cooling)
				return
			src.represented.icon = 'vents1.dmi'
			var/list/L = list(  )
			if (!( src.r_dir & (src.r_dir - 1) ))
				L += src.r_dir / 2
			else
				if (src.r_dir & 1)
					L += NORTH
				if (src.r_dir & 2)
					L += SOUTH
				if (src.r_dir & 4)
					L += EAST
				if (src.r_dir & 8)
					L += WEST
			for(var/t in L)
				var/obj/vent/V = locate(/obj/vent, get_step(src.loc, t))
				if ((!( cooling ) && (V && V.represented.icon != 'vents1.dmi')))
					spawn( 5 )
						V.spread(src)
						return

client/Move(null in view(usr.client), direction in view(usr.client))

	if (direction & (direction - 1))
		return
	if (src.mob.pos_status & 2)
		return ..()
	else
		var/obj/vent/V = locate(/obj/vent, src.mob.loc)
		if ((V && V.flags & 2))
			return V.relay_move(src.mob, direction)
		else
			return 0

mob/Login()
	..()
	src.layer = MOB_LAYER
	src.pos_status = 2
	src.density = 1
	src.sight = 0
	src.invisibility = 0
	src.see_invisible = 0
	src.client.screen.len = null
	if (src.vblock)
		del(src.vblock)
	src.vblock = new /obj/screen()
	src.client.screen += src.vblock
