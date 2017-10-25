obj
	items
		verb
			get()
				set src in oview(1)
				set category = "items"

				src.pos_status = 2
				src.invisibility = 0
				src.layer = OBJ_LAYER
				src.loc = usr
				return

			drop()
				set src in usr
				set category = "items"

				if (usr.pos_status & 1)
					src.pos_status = 1
					src.invisibility = 98
					src.layer = 21
				if (src == usr.equipped)
					src.rem_equip(usr)
				src.loc = usr.loc
				return

			equip()
				set src in usr
				set category = "items"
				var/s = 0
				if (usr.equipped)
					if(usr.equipped == src) s = 1
					if(istype(usr.equipped,/obj/items))
						usr.equipped.rem_equip(usr)
					else
						usr.equipped.suffix = null
						usr << "\blue You have unequipped [src]!"
						usr.equipped = null
				if(!s)
					src.add_equip(usr)
				return

			unequip()
				set src in usr
				set category = "items"

				if (usr.equipped)
					usr.equipped.rem_equip(usr)
				else
					usr << "\blue <B>You do not have anything equipped!</B>"
					return
				return

			examine()
				set src in view(1)
				set category = "items"

				usr << "\icon[src] <B>[src]</B>\n\t[src.desc]"
				return
		proc
			rem_equip(mob/user as mob in view(usr.client))

				user.equipped = null
				src.suffix = null
				user << "\blue <B>You have unequipped [src]!</B>"
				return 1
				return

			add_equip(mob/user as mob in view(usr.client))

				user.equipped = src
				src.suffix = "\[equipped\]"
				user << "\blue <B>You have equipped [src]!</B>"
				return 1
				return

			moved(user as mob in view(usr.client), old_loc as turf in view(usr.client))



		attack_by(obj/items/D in view(usr.client), mob/user as mob in view(usr.client))

			if (istype(D, /obj/items/lis_bug))
				if (src.b_flags & 1)
					var/obj/items/lis_bug/S = D
					S.loc = src
					S.rem_equip(user)
					S.master = src
					src.bugs += S
			else
				if (istype(D, /obj/items/scan_chip))
					if (src.b_flags & 2)
						var/obj/items/scan_chip/S = D
						S.loc = src
						S.rem_equip(user)
						src.bugs += S
				else
					if (istype(D, /obj/items/bug_scan))
						for(var/obj/items/lis_bug/I in src.bugs)
							src.bugs -= I
							I.master = null
							I.loc = src.loc
						for(var/obj/items/scan_chip/I in src.bugs)
							src.bugs -= I
							I.loc = src.loc
		hear(msg in view(usr.client), source as mob|obj|turf|area in view(usr.client), s_type in view(usr.client), c_mes in view(usr.client), r_src as mob|obj|turf|area in view(usr.client))

			for(var/atom/A in src.bugs)
				A.hear(msg, source, s_type, c_mes, r_src)