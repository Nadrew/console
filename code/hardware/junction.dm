obj/signal/wire_junction
	icon = 'icons/wire_junction.dmi'
	icon_state = "junction"
	name = "wiring junction"
	var
		obj/signal/line1
		obj/signal/line2
		obj/signal/line3
		obj/signal/line4
	verb
		get()
			set category = "items"
			set src in oview(usr,1)
			src.Move(usr)
		drop()
			set category = "items"
			set src in usr
			if(usr.equipped == src)
				src.unequip()
			src.Move(usr.loc)
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
	proc/moved()
		return 1
	process_signal(obj/signal/structure/S,obj/source)
		..()
		if(isnull(S))return
		S.loc = src.loc
		S.master = src
		if(line1)
			if(source!=line1)
				var/obj/signal/structure/S1 = new()
				S.copy_to(S1)
				S1.strength -= 5
				if(S1.strength <= 0)
					del(S1)
				else
					line1.process_signal(S1,src)
		if(line2)
			if(source!=line2)
				var/obj/signal/structure/S1 = new/obj/signal/structure
				S.copy_to(S1)
				S1.strength -= 5
				if(S1.strength <= 0)
					del(S1)
				else
					line2.process_signal(S1,src)
		if(line3)
			if(source!=line3)
				var/obj/signal/structure/S1 = new/obj/signal/structure
				S.copy_to(S1)
				S1.strength -= 5
				if(S1.strength <= 0)
					del(S1)
				else
					line3.process_signal(S1,src)
		if(line4)
			if(source!=line4)
				var/obj/signal/structure/S1 = new/obj/signal/structure
				S.copy_to(S1)
				S1.strength -= 5
				if(S1.strength <= 0)
					del(S1)
				else
					line4.process_signal(S1,src)
		del(S)
	orient_to(obj/target, mob/user)
		if(ismob(src.loc))
			user << "Device must be on the ground to connect to it."
			return 0
		if(!line1)
			line1 = target
			user << "Connected to junction 1"
			return 1
		if(!line2)
			line2 = target
			user << "Connected to junction 2"
			return 1
		if(!line3)
			line3 = target
			user << "Connected to junction 3"
			return 1
		if(!line4)
			line4 = target
			usr << "Connected to junction 4"
			return 1
		else
			return 0
	cut()
		if(line1)
			src.line1.disconnectfrom(src)
		if(line2)
			src.line2.disconnectfrom(src)
		if(line3)
			src.line3.disconnectfrom(src)
		if(line4)
			src.line4.disconnectfrom(src)
		src.line1 = null
		src.line2 = null
		src.line3 = null
		src.line4 = null
	Del()
		cut()
		..()
	Move()
		cut()
		..()