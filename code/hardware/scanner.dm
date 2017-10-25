obj
	signal
		scanner
			name = "Paper Scanner"
			icon = 'icons/computer.dmi'
			icon_state = "paper_scanner"
			var
				obj/signal/line1
			orient_to(obj/target,mob/user)
				if(ismob(src.loc))
					user << "Device must be on the ground to connect to it."
					return 0
				if(!line1)
					user << "Connected to scanner line."
					line1 = target
					return 1
				else
					return 0

			cut()
				if(line1)
					line1.disconnectfrom(src)
				line1 = null
			process_signal(obj/S)
				del(S)
			attack_by(obj/PA, mob/user)
				if(user.equipped)
					if(line1)
						if(istype(user.equipped,/obj/items/paper))
							var/obj/items/paper/P = user.equipped
							user << "Paper scanned and sent."
							var/obj/signal/structure/S = new()
							S.id = "-1"
							var/datum/file/normal/N = new()
							N.name = "scanner"
							N.text = P.format()
							S.cur_file = N
							line1.process_signal(S,src)
					if (istype(user.equipped, /obj/items/wire))
						var/obj/items/wire/I = user.equipped
						spawn(0)
							if (I)
								I.wire(src, user)

