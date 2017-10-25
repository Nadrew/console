// /obj/signal/intercom (DEF)

obj/signal
	intercom
		name = "intercom"
		icon = 'icons/computer.dmi'
		icon_state = "intercom"
		var/obj/signal/line1 = null
		var/state = 0.0
		hear(msg in view(usr.client), atom/source as mob|obj|turf|area in view(usr.client), s_type in view(usr.client), c_mes in view(usr.client), r_src as mob|obj|turf|area in view(usr.client))
			if(!ismob(source)) return
			if ((src.state && src.line1))
				var/datum/file/normal/sound/S = new /datum/file/normal/sound(  )
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
				S1.source_id = "intercom"
				spawn( 0 )
					if (src.line1)
						src.line1.process_signal(S1, src)
					return
			src.state = 0
			src.icon_state = "intercom"

		disconnectfrom(S as obj in view(usr.client))
			if (S == src.line1)
				src.line1 = null

		cut(user in view(usr.client))
			if (user)
				user << "You have to cut the wire for this component as it is extremely armored."
				return
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

		process_signal(obj/signal/S as obj in view(usr.client), obj/source as obj in view(usr.client))
			..()
			if (S.cur_file)
				var/datum/file/normal/sound/F = S.cur_file
				if (!( istype(F, /datum/file/normal/sound) ))
					del(S)
					return null
				var/message = "[(F.s_type == 1 ? "(tone)" : "\icon[locate(/mob)]<B>[F.s_source]</B>")]: '[F.text]' from \icon[src]"
				for(var/atom/A in view(src, null))
					A.hear(message, F.s_source, F.s_type, F.text, src)

				del(S)
			else
				if(S.params == "toggle")
					src.state = 1
					src.icon_state = "intercom_1"
				del(S)
				return null
			sleep(2)

		verb/talk()
			set src in oview(1)
			src.state = 1
			usr << "Please speak into the intercom."
			src.icon_state = "intercom_1"

