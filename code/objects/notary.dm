obj/items
	ult_check
		attack_by(obj/items/paper/P in view(usr.client), user in view(usr.client))
			if (!( istype(P, /obj/items/paper) ))
				return
			user << browse(P.format(1), "window=[P.name]")

	not_check
		attack_by(obj/P in view(usr.client), user in view(usr.client))
			if (!( istype(P, /obj/items/paper) ))
				return
			src.check(P, user)

		verb/change_id(t as text)
			src.id = t

		proc/check(obj/items/paper/P in view(usr.client), user in view(usr.client))
			var/yes = 0
			if (findtext(P.data, "[ascii2text(4)]", 1, null))
				var/L = splittext(P.data, "[ascii2text(4)]")
				for(var/t in L)
					if ((t && length(t) > 3))
						var/t_id = copytext(t, 1, 4)
						var/act_t = copytext(t, 4, length(t) + 1)
						if (t_id == "\[n\]")
							if (src.id == (copytext(act_t, findtext(act_t, ";", 1, null) + 1, length(act_t) + 1)))
								yes = 1
								user << "\blue Notoriety found as name: [copytext(act_t, 1, findtext(act_t, ";", 1, null))]"

			if (!( yes ))
				user << "\blue Unable to find correct notoriety."