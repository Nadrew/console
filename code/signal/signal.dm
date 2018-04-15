obj/signal
	proc
		process_radio(structure as obj in view(usr.client),atom/source)
			return

		r_accept(string in view(usr.client))
			return 0

		d_accept()

			return 0

	var
		id
		dest_id
		datum/file/normal/cur_file
		params
		source_id
		atom/master
		datum/file/normal/file
		place_locked = 1
		list/lines = list()
		tmp
			max_lines = 1
			swapable = 0
			obj/signal/originator
			signal_hit = 0
			max_signal = 300
			max_signal = 150
	process_signal(obj/signal/structure/S,atom/source)
		if(signal_hit>=max_signal)
			del(S)
		signal_hit++
		spawn(20)
			signal_hit--
			if(signal_hit<0) signal_hit = 0

	structure
		var
			tmp
				life_time = 6
				last_loc
				timer_down = 0
		New()
			..()
			spawn(1)
				LifeTimer()
		proc
			LifeTimer()
				if(timer_down) return
				while(life_time&&!timer_down)
					sleep(10)
					if(loc!=last_loc)
						life_time = 6
						last_loc = loc
					life_time--
				if(!timer_down) del(src)
	attack_by(obj/W as obj in view(usr.client), mob/user as mob in view(usr.client))

		if (istype(W, /obj/items/wirecutters))
			if ((user.pos_status & 1 && (user.loc != src.loc || src.pos_status & 1)))
				user << "You can only cut from inside a vent if the wire that is right above you!"
				return

			if(istype(src,/obj/signal/concealed_wire))
				var/obj/signal/concealed_wire/W2 = src
				if(!W2.working)
					user << "That terminal isn't active yet, you cannot cut the wires."
					return
				switch(alert(user,"Warning, this will completely remove both terminals, continue?",,"Yes","No"))
					if("No")
						return

			src.cut(user)
		else if (istype(W, /obj/items/wire))
			var/obj/items/wire/I = W
			spawn( 0 )
				if (I)
					I.wire(src, user)
				return
		else if(istype(W,/obj/items/wrench))
			if(src.unlockable)
				if(place_locked)
					user << "You unlock [src.name] from its place."
					place_locked = 0
					density = 0
					src.verbs += /obj/signal/proc/get_me
					src.verbs += /obj/signal/proc/drop_me
				else
					user << "You lock [src.name] in place."
					place_locked = 1
					density = initial(density)
					src.verbs -= /obj/signal/proc/get_me
					src.verbs -= /obj/signal/proc/drop_me
			else
				..()
		else
			..()
	proc
		process_signal(obj/S)
			..()
		orient_to(obj/target)
		disconnectfrom(obj/source)
		cut()
	New()
		..()
		if(swapable)
			verbs += /obj/signal/proc/swap_line
		var/ml = 1
		while(ml <= max_lines)
			lines += "[ml]"
			lines["[ml]"] = null
			ml++
		switch(src.type)
			if(/obj/signal/antenna,/obj/signal/antenna/dish,/obj/signal/dir_ant)
				src.verbs += /obj/signal/proc/get_me
				src.verbs += /obj/signal/proc/drop_me

	Move()
		if(lines.len)
			for(var/obj/signal/S in lines)
				S.cut()
		..()

	proc
		swap_line()
			set name = "swap"
			set src in oview(1,usr)
			var/l1 = input("What is the first line you want to swap?")as null|num
			if(!l1) return
			var/l2 = input("What is the second line you want to swap?")as null|num
			if(!l2) return
			if(l1 <= 0||l1 > max_lines||l2 <= 0||l2 > max_lines)
				usr << "Line range was invalid, try again."
				return
			lines.Swap(l1,l2)
			usr << "Swapped line [l1] (now: [lines["[l1]"]]) with line [l2] (now: [lines["[l2]"]])"