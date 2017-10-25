obj/signal
	switchboard
		name = "switchboard"
		icon = 'icons/computer.dmi'
		icon_state = "sboard"
		density = 1

		var/obj/signal/line1 = null
		var/obj/signal/line2 = null
		var/obj/signal/line3 = null
		var/obj/signal/line4 = null
		var/obj/signal/line5 = null
		var/obj/signal/line6 = null
		var/obj/signal/line7 = null
		var/obj/signal/line8 = null
		var/obj/signal/line9 = null
		var/obj/signal/line10 = null
		var/list/c_stat = list()
		proc
			ret_str(obj/signal/S as obj in view(usr.client))

				if (S.cur_file)
					var/datum/file/normal/sound/F = S.cur_file
					if ((!( istype(F, /datum/file/normal/sound) ) || F.s_type != 1))
						return null
					else
						return F.text

			ret_line(S as obj in view(usr.client))

				if (src.line1 == S)
					return "line1"
				if (src.line2 == S)
					return "line2"
				if (src.line3 == S)
					return "line3"
				if (src.line4 == S)
					return "line4"
				if (src.line5 == S)
					return "line5"
				if (src.line6 == S)
					return "line6"
				if (src.line7 == S)
					return "line7"
				if (src.line8 == S)
					return "line8"
				if (src.line9 == S)
					return "line9"
				if (src.line10 == S)
					return "line10"

		process_signal(obj/signal/S, obj/source)
			..()

			S.master = src
			S.loc = src.loc
			del(S)


		orient_to(obj/target in view(usr.client), user as mob in view(usr.client))
			if(ismob(src.loc))
				user << "Device must be on the ground to connect to it."
				return 0
			if (!( src.line1 ))
				src.line1 = target
				user << "Connection port: Line 1 (1)"
			else
				if (!( src.line2 ))
					src.line2 = target
					user << "Connection port: Line 2 (2)"
				else
					if (!( src.line3 ))
						src.line3 = target
						user << "Connection port: Line 3 (3)"
					else
						if (!( src.line4 ))
							src.line4 = target
							user << "Connection port: Line 4 (4)"
						else
							if (!( src.line5 ))
								src.line5 = target
								user << "Connection port: Line 5 (5)"
							else
								if (!( src.line6 ))
									src.line6 = target
									user << "Connection port: Line 6 (6)"
								else
									if (!( src.line7 ))
										src.line7 = target
										user << "Connection port: Line 7 (7)"
									else
										if (!( src.line8 ))
											src.line8 = target
											user << "Connection port: Line 8 (8)"
										else
											if (!( src.line9 ))
												src.line9 = target
												user << "Connection port: Line 9 (9)"
											else
												if (!( src.line10 ))
													src.line10 = target
													user << "Connection port: Line 10(10)"
												else
													return 0
			return 1

		disconnectfrom(source as obj in view(usr.client))

			if (src.line1 == source)
				src.line1 = null
			else
				if (src.line2 == source)
					src.line2 = null
				else
					if (src.line3 == source)
						src.line3 = null
					else
						if (src.line4 == source)
							src.line4 = null
						else
							if (src.line5 == source)
								src.line5 = null
							else
								if (src.line6 == source)
									src.line6 = null
								else
									if (src.line7 == source)
										src.line7 = null
									else
										if (src.line8 == source)
											src.line8 = null
										else
											if (src.line9 == source)
												src.line9 = null
											else
												if (src.line10 == source)
													src.line10 = null

		cut()

			if (src.line1)
				src.line1.disconnectfrom(src)
			if (src.line2)
				src.line2.disconnectfrom(src)
			if (src.line3)
				src.line3.disconnectfrom(src)
			if (src.line4)
				src.line4.disconnectfrom(src)
			if (src.line5)
				src.line5.disconnectfrom(src)
			if (src.line6)
				src.line6.disconnectfrom(src)
			if (src.line7)
				src.line7.disconnectfrom(src)
			if (src.line8)
				src.line8.disconnectfrom(src)
			if (src.line9)
				src.line9.disconnectfrom(src)
			if (src.line10)
				src.line10.disconnectfrom(src)
			src.line1 = null
			src.line2 = null
			src.line3 = null
			src.line4 = null
			src.line5 = null
			src.line6 = null
			src.line7 = null
			src.line8 = null
			src.line9 = null
			src.line10 = null

		verb
			disconnect()
				set src in oview(1)

				var/choice = input("Which line would you like to disconnect? 1-10", "Hub", null, null)  as num
				switch(choice)
					if(1.0)
						if (src.line1)
							src.line1.disconnectfrom(src)
						src.line1 = null
					if(2.0)
						if (src.line2)
							src.line2.disconnectfrom(src)
						src.line2 = null
					if(3.0)
						if (src.line3)
							src.line3.disconnectfrom(src)
						src.line3 = null
					if(4.0)
						if (src.line4)
							src.line4.disconnectfrom(src)
						src.line4 = null
					if(5.0)
						if (src.line5)
							src.line5.disconnectfrom(src)
						src.line5 = null
					if(6.0)
						if (src.line6)
							src.line6.disconnectfrom(src)
						src.line6 = null
					if(7.0)
						if (src.line7)
							src.line7.disconnectfrom(src)
						src.line7 = null
					if(8.0)
						if (src.line8)
							src.line8.disconnectfrom(src)
						src.line8 = null
					if(9.0)
						if (src.line9)
							src.line9.disconnectfrom(src)
						src.line9 = null
					if(10.0)
						if (src.line10)
							src.line10.disconnectfrom(src)
						src.line10 = null
