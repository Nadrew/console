obj/signal
	box
		name = "box"
		icon = 'icons/computer.dmi'
		icon_state = "box"
		var/keycode = null
		var/doorcode_ref = null
		var/obj/door/connected = null
		id = "0"
		var/s_id = "0"
		var/d_id = "0"
		var/d_dir = 10.0
		var/obj/signal/line1 = null

		var
			open_lab = 0
		verb
			open()
				set src in usr.loc
				src.connected.receive("1")

			close()
				set src in usr.loc
				src.connected.receive("-1")

		New()
			if (!( src.connected ))
				src.connected = new /obj/door( get_step(src, src.d_dir) )
				src.connected.connected = src
				src.connected.dir = src.dir
				if(open_lab)
					connected.open()
			..()

		Initialize()
			// If doorcode_ref is present in the door_codes.json config then set the default keycode from it.
			if (doorcode_ref != null)
				if (door_codes[doorcode_ref] != null)
					src.keycode = door_codes[doorcode_ref]
			..()
			
		proc
			receive(code in view(usr.client))

				if (src.line1)
					var/obj/signal/structure/S1 = new /obj/signal/structure( src )
					S1.id = "dqry"
					S1.dest_id = src.d_id
					S1.source_id = src.s_id
					S1.params = code
					spawn( 0 )
						src.line1.process_signal(S1, src)
						return
				else
					if (src.keycode == code)
						spawn( 0 )
							src.connected.receive("0")
							return

		disconnectfrom(S as obj in view(usr.client))

			if (S == src.line1)
				src.line1 = null

		cut()

			if (src.line1)
				src.line1.disconnectfrom(src)
			src.line1 = null

		orient_to(obj/target in view(usr.client), user as mob in view(usr.client))

			if (target.loc == src.loc)
				if (src.line1)
					return 0
				else
					src.line1 = target
					return 1
			else
				user << "You must be on the same tile of this to operate it."

		process_signal(obj/signal/structure/S as obj in view(usr.client), obj/source as obj in view(usr.client))
			..()
			if(isnull(S))return
			spawn( 2 )
				if (S.id == "door")
					src.connected.receive(S.params)
				else
					if (S.id == "pass")
						src.keycode = S.params
					else
						if (S.id == "dest_id")
							src.d_id = S.params
						else
							if (S.id == "drc_id")
								src.s_id = S.params
				del(S)