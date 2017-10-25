obj/signal
	hub
		name = "hub"
		icon = 'icons/computer.dmi'
		icon_state = "hub"
		density = 1
		place_locked = 1
		var/offset = 0.0
		var/multi = 20.0
		var/s_id = "router"
		var/d_id = "0"
		var/obj/signal/line1 = null
		var/obj/signal/line2 = null
		var/obj/signal/line3 = null
		var/obj/signal/line4 = null
		var/obj/signal/line5 = null
		var/obj/signal/line_temp = null
		var/obj/signal/line_control = null
		var/position = 1.0
		process_signal(obj/signal/structure/S as obj in view(usr.client), obj/source as obj in view(usr.client))
			..()
			if(!S) return
			S.loc = src.loc
			if (source != src.line_control)
				var/list/L = list( "line1", "line2", "line3", "line4", "line5" )
				for(var/x in L)
					if (src.vars[x] == source)
						L -= x

				spawn(1)
					for(var/x in L)
						if(!S) return
						var/obj/signal/structure/S1 = new/obj/signal/structure()
						S.copy_to(S1)
						S1.strength--
						if (S1.strength <= 0)
							del(S1)
							return
						var/obj/signal/structure/S2 = src.vars[x]
						spawn( 0 )
							if (S2)
								S2.process_signal(S1, src)
							return
						sleep(1)

					del(S)
					return


		verb
			swap(n1 as num, n2 as num)
				set src in oview(1)
				set desc = "6=line_action, 7 = line_control"

				if (n1 == 6)
					n1 = "line_temp"
				else
					if (n1 == 7)
						n1 = "line_control"
					else
						if ((n1 > 0 && n1 <= 5))
							n1 = "line[round(n1)]"
						else
							return
				if (n2 == 6)
					n2 = "line_temp"
				else
					if (n2 == 7)
						n2 = "line_control"
					else
						if ((n2 > 0 && n2 <= 5))
							n2 = "line[round(n2)]"
						else
							return
				var/temp = src.vars[n1]
				src.vars[n1] = src.vars[n2]
				src.vars[n2] = temp
				var/obj/O1 = src.vars[n1]
				var/obj/O2 = src.vars[n2]
				usr << "[n1] (Now:[(O1 ? O1.name : "null")]) swapped with [n2] (Now:[(O2 ? O2.name : "null")])"

			disconnect()
				set src in oview(1)

				var/choice = input("Which line would you like to disconnect? 1-6 (6=control)", "Hub", null, null)  as num
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
						if (src.line_temp)
							src.line_temp.disconnectfrom(src)
						src.line_temp = null
					if(7.0)
						if (src.line_control)
							src.line_control.disconnectfrom(src)
						src.line_control = null

