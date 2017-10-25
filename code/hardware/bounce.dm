// /obj/signal/bounce (DEF)

obj/signal
	bounce
		name = "bounce"
		icon = 'icons/computer.dmi'
		icon_state = "bounce"
		var/obj/signal/line1 = null
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
			if (get_dist(src,user)<=1)
				if (src.line1)
					return 0
				else
					src.line1 = target
					return 1
			else
				user << "You are not close enough to connect to that device."
				return 0

		process_signal(S as obj in view(usr.client), source as obj in view(usr.client))
			..()

			spawn( 2 )
				if (src.line1)
					src.line1.process_signal(S, src)
				return
		verb
			get()
				set src in oview(usr,1)
				set category = "items"

				src.pos_status = 2
				src.invisibility = 0
				src.layer = OBJ_LAYER
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
