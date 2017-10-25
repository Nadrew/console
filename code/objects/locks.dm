obj/items
	lockpick
		proc/show(mob/user in view(usr.client))
			var/stat = ("[src.cur_pos]" == (copytext(src.target, src.cur_pin, src.cur_pin + 1)) ? "Click" : "Clank")
			var/tex
			if (src.cur_lock)
				tex = "<B>Lockpick Status</B>:<BR>\nPin position: [src.cur_pin]<BR>\nStatus: [stat][(src.temp ? " [src.temp]" : null)]<BR>\n<HR>\n<B>Manipulate:</B><BR>\n<a href='?src=\ref[src];mani=left'>Jiggle Left</a> <a href='?src=\ref[src];mani=right'>Jiggle Right</a><BR>\n<a href='?src=\ref[src];mani=up'>[(src.cur_pin == 5 ? "Try Lock" : "Move Up")]</a><BR>\n<a href='?src=\ref[src];mani=down'>[(src.cur_pin == 1 ? "Remove" : "Move Down")]</a><BR>\n<HR>\n<a href='?src=\ref[src];exam=1'>Examine (Refresh)</A>"
			else
				tex = "It has not been inserted into a lock!"
			src.loc << browse("[tex]", "window=lockpick")

		Topic(href in view(usr.client), href_list in view(usr.client))

			if ((src.loc == usr && (src.cur_lock && (get_dist(usr, src.cur_lock.loc) <= 1 || usr == src.loc))))
				if (href_list["mani"])
					src.temp = null
					switch(href_list["mani"])
						if("left")
							if (text2num("[src.cur_pos]") < (text2num(copytext(src.target, src.cur_pin, src.cur_pin + 1))))
								src.temp = "clonk"
							else
								src.temp = "clock"
							src.cur_pos -= 1
							src.cur_pos = min(max(src.cur_pos, 0), 9)
							src.pin_loc = "[(src.cur_pin == 1 ? null : "[copytext(src.pin_loc, 1, src.cur_pin)]")][src.cur_pos][(src.cur_pin == 5 ? null : "[copytext(src.pin_loc, src.cur_pin + 1, 6)]")]"
						if("right")
							if (text2num("[src.cur_pos]") > (text2num(copytext(src.target, src.cur_pin, src.cur_pin + 1))))
								src.temp = "clonk"
							else
								src.temp = "clock"
							src.cur_pos += 1
							src.cur_pos = min(max(src.cur_pos, 0), 9)
							src.pin_loc = "[(src.cur_pin == 1 ? null : "[copytext(src.pin_loc, 1, src.cur_pin)]")][src.cur_pos][(src.cur_pin == 5 ? null : "[copytext(src.pin_loc, src.cur_pin, 5)]")]"
						if("up")
							if (src.cur_pin == 5)
								if (src.pin_loc == src.target)
									var/t_id = src.cur_lock.id
									var/turf/t_loc = src.loc
									usr << "\blue <B>The lock turns!</B>"
									if (t_loc)
										del(src.cur_lock)
										src.cur_lock = new /obj/items/lock( t_loc.loc )
										src.cur_lock.id = t_id
										src.cur_lock = null
							else
								src.cur_pin += 1
								src.cur_pos = text2num(copytext(src.pin_loc, src.cur_pin, src.cur_pin + 1))
						if("down")
							if (src.cur_pin == 1)
								if (src.cur_lock)
									src.cur_lock.cur_pick = null
									src.cur_lock = null
							else
								src.cur_pin -= 1
								src.cur_pos = text2num(copytext(src.pin_loc, src.cur_pin, src.cur_pin + 1))
						else
					src.show(usr)
				else
					if (href_list["exam"])
						src.show(usr)
			..()

		moved()
			if (src.cur_lock)
				src.cur_lock.cur_pick = null
				src.cur_lock = null
			src.loc << browse(null, "window=lockpick")



	lock
		proc
			insert_object(obj/items/lockpick/P in view(usr.client), mob/user in view(usr.client))
				if ((istype(P, /obj/items/lockpick) && !( src.cur_pick )))
					P.cur_lock = src
					P.cur_pin = 1
					P.cur_pos = 5
					P.pin_loc = "55555"
					P.target = "[src.id]"
					while(length(P.target) < 5)
						P.target = "0[P.target]"
					P.temp = null
					src.cur_pick = P
					spawn( 0 )
						src.cur_pick.show(user)
						return

			insert_key(obj/items/key/K as obj in view(usr.client), mob/user in view(usr.client))

				if (K.id == src.id)
					user << "\blue You remove the lock"
					if (src.cur_pick)
						src.cur_pick.cur_lock = null
						src.cur_pick = null
					return 1
				else
					user << "\blue The key doesn't fit"
					return null

			manipulate(mob/user in view(usr.client))
				return null

		attack_by(obj/L as obj in view(usr.client), mob/user in view(usr.client))

			if (istype(L, /obj/items/lock_kit))
				var/t = input(user, "What should be the pin positions?", "Lock Kit", null)  as num
				t = min(max(round(t), 1), 99999.0)
				if ((L.loc != usr || src.loc != usr))
					return
				src.id = t
		e_lock
			manipulate(mob/user in view(usr.client))
				var/i = input(user, "Please input access code", null, null)  as text
				if ("[i]" == "[src.id]")
					return 1
				else
					return null

			insert_object(i in view(usr.client), mob/user in view(usr.client))
				return null

			insert_key(i in view(usr.client), mob/user in view(usr.client))
				user << "\blue It is keypad locked."
				return null

			attack_by(obj/L as obj in view(usr.client), mob/user in view(usr.client))

				if (istype(L, /obj/items/lock_kit))
					var/t = input(user, "What should be the access code?", "Lock Kit", null)  as text
					if ((L.loc != usr || src.loc != usr))
						return
					src.id = t

	key
		attack_by(obj/L as obj in view(usr.client), mob/user in view(usr.client))
			if (istype(L, /obj/items/lock_kit))
				var/t = input(user, "What should be the new height levels?", "Lock Kit", null)  as num
				t = min(max(round(t), 1), 99999.0)
				if ((L.loc != usr || src.loc != usr))
					return
				src.id = t

		verb/label(msg as text)
			if (msg)
				src.name = "key- '[msg]'"
			else
				src.name = "key"



	box
		verb
			label(msg as text)
				set src in view(1)

				if (msg)
					src.name = "box- '[msg]'"
				else
					src.name = "box"

			remove(obj/O in src)

				if (!( src.lock ))
					O.loc = src.loc
					usr << "\blue You remove [O] from [src]."
				else
					usr << "\blue It's locked!"

		attack_hand(mob/user in view(usr.client))

			if (istype(src.lock, /obj/items/lock))
				var/t = src.lock
				var/d = src.loc
				if ((src.lock.manipulate(user) && (src.lock == t && src.loc == d)))
					src.lock.loc = src.loc
					src.lock = null

		attack_by(obj/items/D, mob/user)
			if (istype(D, /obj/items/key))
				var/K = D
				if (istype(src.lock, /obj/items/lock))
					if (src.lock.insert_key(K, user))
						src.lock.loc = src.loc
						src.lock = null
				else
					user << "\blue There is no lock!"
			else
				if (istype(D, /obj/items/lock))
					var/obj/items/K = D
					if (src.lock)
						user << "\blue There already is a lock!"
					else
						K.unequip()
						src.lock = K
						src.lock.loc = src
				else
					if (istype(D, /obj/items/lockpick))
						var/obj/items/K = D
						if (src.lock)
							src.lock.insert_object(K, user)
						else
							user << "\blue There is no lock!"
					else
						if ((D && !( src.lock )))
							if(istype(D,/obj/items))
								D.unequip()
							else
								if(user.equipped == D)
									D.suffix = null
									user.equipped = null
									user << "\blue You unequipped [D.name]"
							user << "\blue You place [D] in [src]."
						D.loc = src