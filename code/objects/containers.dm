obj/items
	toolbox
		New()
			new /obj/items/screwdriver( src )
			new /obj/items/wrench( src )
			..()

		attack_by(obj/items/I, mob/user)
			if (I)
				if(istype(I,/obj/items))
					I.unequip()
				else
					if(user.equipped == I)
						I.suffix = null
						user.equipped = null
						user << "\blue You unequipped [I.name]"
				user << "\blue You place [I] in [src]."
				I.loc = src

		verb/remove(obj/O in src)
			O.loc = src.loc
			usr << "\blue You remove [O] from [src]."


obj/boxrack
	attack_by(obj/items/I,mob/user)

		if (istype(I, /obj/items/box))
			if (src.contents.len < 9)
				I.unequip()
				user << "\blue You place [I] in [src]."
				I.loc = src
			else
				user << "\blue Not enough space!"
		else
			if (istype(I, /obj/items/lockpick))
				var/K = I
				var/obj/items/box/B = input(user, "Which box would you like to tamper with?", null, null)  as obj in src
				if ((istype(B, /obj/items/box) && (B.loc == src && (get_dist(src, user) <= 1 && user.contents.Find(K)))))
					if (istype(B.lock, /obj/items/lock))
						var/obj/items/lock/lk = B.lock
						lk.insert_object(K, user)
					else
						user << "\red It is not locked!"
			else
				if (istype(I, /obj/items/key))
					var/K = I
					var/obj/items/box/B = input(user, "Which box would you like to remove?", null, null)  as obj in src
					if ((istype(B, /obj/items/box) && (B.loc == src && (get_dist(src, user) <= 1 && user.contents.Find(K)))))
						if ((istype(B.lock, /obj/items/lock)))
							var/obj/items/lock/lk = B.lock
							if(lk.insert_key(K))
								lk.loc = src.loc
								B.lock = null
								B.loc = src.loc
								user << "\blue You remove and unlock the box!"
						else
							user << "\red The key doesn't work!!"

	attack_hand(mob/user in view(usr.client))

		var/obj/items/box/B = input(user, "Which box would you like to remove?", null, null)  as obj in src
		if ((istype(B, /obj/items/box) && (B.loc == src && get_dist(src, user) <= 1)))
			var/t = B.lock
			if ((istype(B.lock, /obj/items/lock) && (B.lock.manipulate(user) && (istype(B, /obj/items/box) && (B.loc == src && (B.lock == t && get_dist(src, user) <= 1))))))
				B.lock.loc = src.loc
				B.lock = null
				B.loc = src.loc
				user << "\blue You remove and unlock the box!"
	verb
		remove(obj/O in src)
			set src in view(1)

			if (istype(O, /obj/items/box))
				var/obj/items/box/B = O
				if (!( B.lock ))
					O.loc = src.loc
					usr << "\blue You remove [O] from [src]."
				else
					usr << "\red The box is locked!"
			else
				O.loc = src.loc
				usr << "\blue You remove [O] from [src]."

		label(msg as text)
			set src in view(1)

			if (msg)
				src.name = "box rack- '[msg]'"
			else
				src.name = "box rack"

obj
	filecabinet
		attack_by(obj/items/I in view(usr.client), mob/user in view(usr.client))

			if (I)
				if(istype(I,/obj/items))
					I.unequip()
					user << "\blue You place [I] in [src]."
					I.loc = src
				else
					user << "\red You cannot place [I] in [src]."

		verb
			remove(obj/O in src)
				set src in view(1)

				O.loc = src.loc
				usr << "\blue You remove [O] from [src]."

			label(msg as text)
				set src in view(1)

				if (msg)
					src.name = "file cabinet- '[msg]'"
				else
					src.name = "file cabinet"

	bulletin
		verb
			read()
				set src in oview(1)
				var/obj/items/paper/P = input("Which bulletin do you want to read?")as null|anything in contents
				if(!P) return
				if (istype(P, /obj/items/paper))
					usr << browse(P.format(), "window=[P.name]")

			remove(obj/P in src)
				set src in usr.loc

				if (!( src.lock ))
					P.loc = src.loc
				else
					usr << "\blue It's locked!"

		attack_hand(mob/user in view(usr.client))

			if (src.loc == user.loc)
				if (istype(src.lock, /obj/items/lock))
					var/t = src.lock
					if ((src.lock.manipulate(user) && (src.lock == t && src.loc == user.loc)))
						src.lock.loc = src.loc
						src.lock = null

		attack_by(obj/items/D in view(usr.client), mob/user in view(usr.client))

			if (src.loc == user.loc)
				if (istype(D, /obj/items/paper))
					if (src.lock)
						user << "The bulletin board is locked!"
					else
						D.unequip()
						D.loc = src
				else
					if (istype(D, /obj/items/key))
						var/K = D
						if (istype(src.lock, /obj/items/lock))
							if (src.lock.insert_key(K, user))
								src.lock.loc = src.loc
								src.lock = null
						else
							user << "\blue There is no lock!"
					else
						if (istype(D, /obj/items/lockpick))
							var/K = D
							if (src.lock)
								src.lock.insert_object(K, user)
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