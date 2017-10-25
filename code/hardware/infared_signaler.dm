mob
	var
		tmp
			obj/infared/beam/in_beam
	Move()
		. = ..()
		if(.)
			var/fb = 0
			for(var/obj/infared/beam/B in src.loc)
				fb = 1
				if(in_beam != B.master)
					if(B.master)
						B.master.Signal()
						in_beam = B.master
			if(!fb) in_beam = null
obj
	signal
		infared
			density = 1
			name = "Infared Signaler"
			desc = "Emits a beam in any given direction and sends a signal when the beam is passed."
			icon = 'icons/infared.dmi'
			var
				range = 5
				active = 0
				beam_hidden = 0
				list/beams = list()
				obj/signal/line1
			proc
				Signal()
					if(line1)
						var/obj/signal/structure/S = new()
						S.id = "signaler"
						line1.process_signal(S,src)
					else
						view(src) << "\icon[src]: *BEEP*"
				moved()
					return 1
			process_signal(obj/signal/structure/S)
				var
					id = S.id
					list/params = splittext(S.params,ascii2text(2))
				if(id == "power")
					if(params.len >= 1)
						if(params[1] == "0")
							src.activate()
						else if(params[1] == "1")
							if(!src.active)
								src.activate()
						else
							if(src.active)
								src.activate()
				if(id == "rotate")
					src.rotate()
				if(id == "visible")
					for(var/obj/infared/beam/B in beams)
						if(beam_hidden)
							B.invisibility = 0
						else
							B.invisibility = 101
					beam_hidden = !beam_hidden
				if(id == "range")
					if(!active)
						var/new_range = text2num(params[1])
						if(new_range <= 0) new_range = 2
						if(new_range > 5) new_range = 5
						range = new_range
				del(S)
			orient_to(obj/target,mob/user)
				if(ismob(src.loc))
					user << "Device must be on the ground to connect to it."
					return 0
				if(src.loc == user) return 0
				if(!line1)
					user << "Connected to infared signaler"
					line1 = target
					return 1
				else
					return 0
			cut()
				if(line1)
					line1.disconnectfrom(src)
				line1 = null
			Move()
				if(!ismob(loc))
					cut()
				..()
			Del()
				cut()
				..()
			verb

				equip()
					set src in usr
					set category = "items"
					var/s = 0
					if (usr.equipped)
						if(usr.equipped == src) s = 1
						if(istype(usr.equipped,/obj/items))
							usr.equipped.rem_equip(usr)
						else
							usr.equipped.suffix = ""
							usr << "\blue <B>You have unequipped [usr.equipped]!</B>"
							usr.equipped = null
					if(!s)
						usr.equipped = src
						usr << "\blue <B>You have equipped [src]!</B>"
						src.suffix = "\[equipped\]"
				unequip()
					set src in usr
					set category = "items"
					if(usr.equipped == src)
						src.suffix = ""
						usr.equipped = null
						usr << "\blue <B>You have unequipped [src]!</B>"
				get()
					set src in oview(1,usr)
					set category = "items"
					if(active)
						src << "You must deactivate it first."
					else
						src.Move(usr)
				drop()
					set src in usr
					set category = "items"
					if(usr.equipped == src)
						src.unequip()
					src.loc = usr.loc
				rotate()
					set src in oview(1,usr)
					if(active)
						usr << "You must deactivate it first."
					else
						src.dir = turn(src.dir,90)
				activate()
					set src in oview(1,usr)
					if(active)
						for(var/obj/infared/beam/B in beams)
							del(B)
						active = 0
						icon_state = ""
					else
						icon_state = "on"
						active = 1
						var
							r = 1
							xx = src.x
							yy = src.y
						switch(src.dir)
							if(NORTH) yy++
							if(SOUTH) yy--
							if(EAST) xx++
							if(WEST) xx--
						while(r <= range)
							var/turf/N = locate(xx,yy,src.z)
							if(!N||N.density)
								r = range+1
								return
							for(var/atom/O in N)
								if(ismob(O)) continue
								if(O.density)
									r = range+1
									return
							var/obj/infared/beam/B = new(locate(xx,yy,src.z))
							B.dir = get_dir(B,src)
							B.master = src
							switch(src.dir)
								if(NORTH) yy++
								if(SOUTH) yy--
								if(EAST) xx++
								if(WEST) xx--
							beams+=B
							r++

obj
	infared
		icon = 'icons/infared.dmi'
		icon_state = "beam"
		layer = MOB_LAYER+1
		beam
			name = ""
			var
				obj/signal/infared/master