// /obj/signal/microphone (DEF)

obj/signal
	microphone
		name = "microphone"
		icon = 'icons/computer.dmi'
		icon_state = "microphone_0"
		var/obj/signal/line1 = null
		var/state = 0.0
		disconnectfrom(S as obj in view(usr.client))

			if (S == src.line1)
				src.line1 = null

		cut()

			if (src.line1)
				src.line1.disconnectfrom(src)
			src.line1 = null

		orient_to(obj/target in view(usr.client), user as mob in view(usr.client))
			if(ismob(src.loc))
				user << "Device must be on the ground to connect to it."
				return 0
			if (src.line1)
				return 0
			else
				src.line1 = target
				return 1

		hear(msg in view(usr.client), atom/source as mob|obj|turf|area in view(usr.client), s_type in view(usr.client), c_mes in view(usr.client), r_src as mob|obj|turf|area in view(usr.client))

			if(!ismob(source)) return
			if ((src.state && src.line1))
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
				S1.source_id = "microphone"
				spawn( 0 )
					if (src.line1)
						src.line1.process_signal(S1, src)
					return

		process_signal(S as obj in view(usr.client), source as obj in view(usr.client))
			..()

			del(S)
		verb
			toggle()
				set src in oview(1)

				src.state = !( src.state )
				src.icon_state = "microphone_[src.state]"
				usr << (src.state ? "The microphone will now transmit voice data." : "Microphone has been turned off.")

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
				set src in oview(usr,1)
				set category = "items"
				src.invisibility = 0
				src.layer = OBJ_LAYER
				src.pos_status = 2
				cut()
				src.loc = usr

			drop()
				set src in usr
				set category = "items"

				if (usr.pos_status & 1)
					src.pos_status = 1
					src.invisibility = 98
					src.layer = 21
				src.loc = usr.loc


		proc
			moved()
				return 1
