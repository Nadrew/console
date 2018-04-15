obj
	signal
		shutter_box
			name = "Shutter Control"
			icon = 'icons/computer.dmi'
			icon_state = "box"
			var/obj/signal/line1
			var/range = 5
			verb
				open()
					set src in view(1,usr)
					for(var/obj/shutter/ST in view(src,range))
						if(ST.icon_state != "open")
							ST.Open()
				close()
					set src in view(1,usr)
					for(var/obj/shutter/ST in view(src,range))
						if(ST.icon_state == "open")
							ST.Open()

			New()
				..()
				icon += rgb(0,0,75)
			orient_to(obj/target,mob/user)
				if(ismob(src.loc))
					user << "Device must be on the ground to connect to it."
					return 0
				if(line1)
					return 0
				else
					if(src.loc != user.loc)
						user << "You must be standing on the same tile as [src] to connect wires."
						return 0
					else
						line1 = target
						user << "Connected to shutter control box."
						return 1
			cut()
				if(line1)
					line1.disconnectfrom(src)
				line1 = null
			process_signal(obj/signal/structure/S,obj/source)
				..()
				if(isnull(S))return
				S.loc = src.loc
				S.master = src
				if(S.id == "toggle")
					for(var/obj/shutter/ST in view(src,range))
						ST.Open()
				if(S.id == "open")
					for(var/obj/shutter/ST in view(src,range))
						ST.Open(1)

				del(S)
	shutter
		name = "Window Shutter"
		icon = 'icons/shutter.dmi'
		icon_state = "closed"
		density = 1
		opacity = 1
		layer = OBJ_LAYER-1
		var
			pcode

		proc
			Open(var/force)
				if(icon_state == "open"||force==2)
					icon_state = "closed"
					opacity = 1
					density = 1
				else
					icon_state = "open"
					opacity = 0
					density = 0
