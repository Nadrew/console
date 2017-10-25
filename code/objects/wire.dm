obj/items
	wire
		desc = "This is just a simple piece of regular insulated wire."
		name = "wire"
		icon_state = "item_wire"
		var/amount = 1.0
		var/laying = 0.0
		var/obj/signal/old_lay = null
		var/w_color = "black"
		var/scolor = "black"

		hyper
			name = "hyper"
			icon_state = "item_hyperwire"
			w_color = "hyper"
			scolor = "hyper"
		var
			label
		New()
			..()
			if(!color) color = "black"
			if(!scolor) scolor = "black"
			if(src.type == /obj/signal/wire/hyper||src.type == /obj/items/wire/hyper)
				color = "hyper"
				scolor = "hyper"
				src.verbs -= /obj/items/wire/verb/Color_Wire
			src.update()
		verb
			Color_Wire()
				set src in usr
				if(!ismob(src.loc)) return
				var/n_color = input("What color do you want to make the wire?")as null|anything in list("red","green","blue","black")
				if(!n_color) return
				color = "[n_color]"
				scolor = "[n_color]"
				update()
			Label_Wire(T as text)
				set src in usr
				if(!ismob(src.loc)) return
				label = "[T]"
				var/n = "wire"
				if(src.type == /obj/signal/wire/hyper||src.type == /obj/items/wire/hyper) n = "hyper"
				if(!T)
					src.name = n
					label = null
				else
					src.name = "[n] '[label]'"
			stop_laying()
				if (src.laying)
					src.laying = 0
					usr << "Your done laying wire!"
				else
					usr << "You are not using this to lay wire..."
				return

			thread()
				set src in usr
				for(var/obj/items/wire/target in src.loc)
					if (target != src && src.type == target.type&&src.scolor==target.scolor)
						src.amount += target.amount
						src.color = target.color
						if (usr.equipped == target)
							target.rem_equip(usr)
						del(target)
				src.update()

		Write(F in view(usr.client))
			src.old_lay = null
			..(F)
		rem_equip()
			..()
			src.stop_laying()

		moved(mob/user as mob in view(usr.client), turf/old_loc as turf in view(usr.client))

			if ((src.laying && (src.old_lay && get_dist(src.old_lay, user) > 1)))
				src.laying = 0
			if ((src.laying && (src.amount >= 1 && src.old_lay)))
				var/obj/signal/wire/W = new /obj/signal/wire( user.loc )
				if (src.color)
					switch(src.color)
						if("blue")
							W.icon = 'icons/b_wire.dmi'
						if("green")
							W.icon = 'icons/g_wire.dmi'
						if("red")
							W.icon = 'icons/r_wire.dmi'
						if("hyper")
							W.icon = 'icons/hyperwire.dmi'
						if("black")
							W.icon = 'icons/wire.dmi'
				if (user.pos_status & 1)
					W.invisibility = 98
					W.pos_status = 1
					W.layer = 21
				if(label)
					W.name = "wire '[label]'"
					W.label = label
				var/t1 = src.old_lay.orient_to(W, user)
				var/t2 = W.orient_to(src.old_lay, user)
				if ((t1 && t2))
					src.old_lay = W
					src.amount--
					if (src.amount <= 0)
						src.laying = 0
						del(src)
						return
					src.update()
				else
					del(W)
					user << "<B>You were unable to connect the wire to the target!</B>"
					src.laying = 0
		proc
			wire(mob/target as mob|obj|turf|area in view(usr.client), mob/user as mob in view(usr.client))

				var/obj/signal/S = target
				if (!( istype(S, /obj/signal) ))
					return
				if ((!( S.pos_status & user.pos_status ) && S.loc != user.loc))
					user << "You must be on the same tile to bridge a connection into the vents."
					return
				if (!( src.laying ))
					src.laying = 1
					src.old_lay = S
					moved(user, null)
				else
					src.laying = 0
					if(S)
						if ((src.old_lay.orient_to(S) && S.orient_to(src.old_lay, user)))
							user << "Your done laying wire!"
						else
							src.old_lay.disconnectfrom(S)
							S.disconnectfrom(src.old_lay)
							..()

			update()

				if (src.amount > 1)
					src.icon_state = "spool_[src.scolor]wire"
					src.desc = "This is just spool of regular insulated wire. It consists of about [src.amount] unit\s of wire."
				else
					src.icon_state = "item_[src.scolor]wire"
					src.desc = "This is just a simple piece of regular insulated wire."



		MouseDrop(obj/items/wire/target in view(usr.client), t1 in view(usr.client), t2 in view(usr.client))

			if (!( target ))
				return
			if ((t1 != "Inventory" || (t2 != "Inventory" || src.type != target.type)))
				return
			else
				if (target != src)
					src.amount += target.amount
					if (usr.equipped == target)
						target.rem_equip(usr)
					del(target)
					src.update()


		attack_by(obj/P in view(usr.client), user as mob in view(usr.client))
			if ((istype(P, /obj/items/paint) && src.loc == user))
				var/i = input(user, "What color?", "Paint", null) in list( "black", "red", "blue", "green" )
				if ((src.loc == user && P.loc == user))
					src.color = i
					src.scolor = i
				src.update()
