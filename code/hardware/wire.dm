obj/signal
	wire
		name = "wire"
		icon = 'icons/wire.dmi'
		var/s_tag = null
		var/direction = null
		var/obj/signal/line1 = null
		var/obj/signal/line2 = null
		anchored = 1.0
		hyper
			name = "hyper"
			icon = 'icons/hyperwire.dmi'

		var
			label
			w_color
		verb
			examine()
				set src in world

	/*	Read(savefile/F)
			..()

			if(istype(src,/obj/signal/wire/hyper))
				color = "hyper"
				icon = 'icons/hyperwire.dmi'
			update()*/
		/*Write(savefile/F)
			if(!color)
				switch("[icon]")
					if("b_wire.dmi") color = "blue"
					if("r_wire.dmi") color = "red"
					if("g_wire.dmi") color = "green"
					if("hyperwire.dmi") color = "hyper"
					else color = "black"
			var/s_icon = src.icon
			icon = null
			F["icon"] << "[s_icon]"
			..()
			icon = s_icon*/

		cut(force=0)
			if (src.line1)
				src.line1.disconnectfrom(src)
			if (src.line2)
				src.line2.disconnectfrom(src)
			src.line1 = null
			src.line2 = null
			var/obj/items/wire/W = new /obj/items/wire( src.loc )
			var
				n_state = "item_wire"
				acolor = "black"
			switch(src.icon)
				if('icons/b_wire.dmi')
					n_state = "item_bluewire"
					acolor = "blue"
				if('icons/r_wire.dmi')
					if(src.type == /obj/signal/wire/hyper)
						acolor = "hyper"
					else
						n_state = "item_redwire"
						acolor = "red"
				if('icons/g_wire.dmi')
					n_state = "item_greenwire"
					acolor = "green"
				if('icons/wire.dmi')
					n_state = "item_blackwire"
					acolor = "black"
				if('icons/hyperwire.dmi')
					n_state = "item_hyperwire"
					acolor = "hyper"
			W.icon_state = n_state
			W.scolor = acolor
			W.color = acolor
			if (src.pos_status & 1)
				W.layer = 21
				W.invisibility = 98
				W.pos_status = 1
			if(force)
				spawn(1) del(src)
			else
				del(src)
		proc
			update()
				var
					t1
					t2
				if ((!( src.line1 ) && !( src.line2 )))
					src.icon_state = "512"
					src.direction = null
					var
						n_state = "item_wire"
						acolor = "black"
					switch(src.icon)
						if('icons/b_wire.dmi')
							n_state = "item_bluewire"
							acolor = "blue"
						if('icons/r_wire.dmi')
							if(src.type == /obj/signal/wire/hyper)
								acolor = "hyper"
								color = "hyper"
							else
								n_state = "item_redwire"
								acolor = "red"
								color = "red"
						if('icons/g_wire.dmi')
							n_state = "item_greenwire"
							acolor = "green"
							color = "green"
						if('icons/wire.dmi')
							n_state = "item_blackwire"
							acolor = "black"
							color = "black"
						if('icons/hyperwire.dmi')
							n_state = "item_hyperwire"
							acolor = "hyper"
							color = "hyper"
					if(istype(src,/obj/signal/wire/hyper))
						var/obj/items/wire/hyper/H = new/obj/items/wire/hyper(src.loc)
						H.icon_state = n_state
						H.scolor = acolor
						H.color = acolor
					else
						var/obj/items/wire/W = new /obj/items/wire( src.loc )
						W.icon_state = n_state
						W.scolor = acolor
						W.color = acolor
						color = acolor
					del(src)
					return
				else
					if ((src.line1 && (src.line2 && (src.line1.loc == src.line2.loc && src.line1.loc == src.loc))))
						src.icon_state = "1"
						src.direction = 1
						return 1
				if (!( src.line1 ))
					t1 = 256
				else
					t1 = get_dir(src, src.line1)
				if (!( src.line2 ))
					t2 = 256
				else
					t2 = get_dir(src, src.line2)
				switch(t1)
					if(5.0)
						t1 = 16
					if(9.0)
						t1 = 32
					if(6.0)
						t1 = 64
					if(10.0)
						t1 = 128
					else
				switch(t2)
					if(5.0)
						t2 = 16
					if(9.0)
						t2 = 32
					if(6.0)
						t2 = 64
					if(10.0)
						t2 = 128
					else
				if ((src.line1 && src.line1.loc == src.loc))
					t2 = t2 << 1
					t1 = 0
				else
					if ((src.line2 && src.line2.loc == src.loc))
						t1 = t1 << 1
						t2 = 0
				src.direction = t1 + t2
				src.icon_state = "[src.direction]"
				if (src.direction == 512)
					src.icon_state = "512"
					src.direction = null
					new /obj/items/wire( src.loc )
					del(src)
					return
				return src.direction

		orient_to(obj/signal/target in view(usr.client),mob/user)
			if(ismob(src.loc))
				user << "Device must be on the ground to connect to it."
				return 0
			if (src.line1)
				if (src.line2)
					return 0
				else
					if(!originator)
						if(target.originator) src.originator = target.originator
						else src.originator = target
					src.line2 = target
			else
				if(!originator)
					if(target.originator) src.originator = target.originator
					else src.originator = target
				src.line1 = target
			src.update()
			return 1

		disconnectfrom(source as obj in view(usr.client))

			if (src.line1 == source)
				src.line1 = null
			else
				src.line2 = null
			src.update()
			return

		New()

			..()
			spawn( 50 )
				src.update()
				return
			return

		Del()

			for(var/obj/signal/structure/S in src.loc)
				if (S.master == src)
					del(S)

			if (src.line1)
				src.line1.disconnectfrom(src)
			if (src.line2)
				src.line2.disconnectfrom(src)
			src.line1 = null
			src.line2 = null
			..()
			return

		process_signal(obj/signal/S as obj in view(usr.client), obj/source as obj in view(usr.client))
			..()
			if(!S) return
			if(S.master)
				S.icon_state = S.master.icon_state
			S.loc = src.loc
			S.icon_state = src.icon_state
			S.master = src
			if(istype(source.loc,/obj/signal/rackmount)) source = source.loc
			if (source == src.line1)
				spawn( 1 )
					if (!( src.line2 ))
						del(S)
					else
						src.line2.process_signal(S, src)
					return
			else
				spawn( 1 )
					if (!( src.line1 ))
						del(S)
					else
						src.line1.process_signal(S, src)
					return



	items
		wire

