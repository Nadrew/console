atom
	proc
		attack_by(using as obj in view(usr.client), user as mob in view(usr.client))

			return

		attack_hand(user as mob in view(usr.client))

			return

	DblClick()

		if (usr.equipped)
			if (get_dist(src, usr) <= 1)
				spawn( 0 )
					if (usr)
						src.attack_by(usr.equipped, usr)
					return
		else
			spawn( 0 )
				if (usr)
					src.attack_hand(usr)
				return
			..()
		return