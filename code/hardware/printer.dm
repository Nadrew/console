obj/signal
	printer
		name = "printer"
		icon = 'icons/computer.dmi'
		icon_state = "printer"
		density = 1
		var/obj/signal/line1 = null
		var/printing = null
		verb/paper()
			set src in oview(1)

			if (!( src.printing ))
				var/obj/items/paper/P = new /obj/items/paper( src.loc )
				usr << "You now have a blank paper\icon[P]."
			else
				usr << "\blue You are already printing!"

		disconnectfrom(S as obj in view(usr.client))

			if (S == src.line1)
				src.line1 = null

		cut()

			if (src.line1)
				src.line1.disconnectfrom(src)
			src.line1 = null

		orient_to(obj/target in view(usr.client), mob/user as mob in view(usr.client))
			if(ismob(src.loc))
				user << "Device must be on the ground to connect to it."
				return 0
			if (src.line1)
				return 0
			else
				src.line1 = target
				return 1

		process_signal(obj/signal/S as obj in view(usr.client), obj/source as obj in view(usr.client))
			..()
			if(isnull(S))return
			
			S.loc = null
			S.master = src
			if (src.printing)
				S.id = "pr_fail"
				S.dest_id = S.source_id
				S.source_id = "printer"
				S.params = "printing"
				if (S.cur_file)
					del(S.cur_file)
				spawn( 2 )
					if (src.line1)
						src.line1.process_signal(S, src)
					return
			else
				if ((S.id != "[-1.0]" || (!( istype(S.cur_file, /datum/file/normal) ) || S.cur_file.flags & 1)))
					S.id = "pr_fail"
					S.dest_id = S.source_id
					S.source_id = "printer"
					S.params = "err_ftype"
					if (S.cur_file)
						del(S.cur_file)
					spawn( 2 )
						if (src.line1)
							src.line1.process_signal(S, src)
						return
				else
					src.printing = 1
					var/obj/items/paper/P = new /obj/items/paper(  )
					P.data = "[ascii2text(4)]\[t\][S.cur_file.text]"
					P.name = "paper- '[S.params]'"
					sleep(30)
					P.loc = src.loc
					src.printing = null
					S.id = "pr_success"
					S.dest_id = S.source_id
					S.source_id = "printer"
					S.params = "success"
					if (S.cur_file)
						del(S.cur_file)
					spawn( 2 )
						if (src.line1)
							src.line1.process_signal(S, src)
						return