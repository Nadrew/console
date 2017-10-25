mob
	verb
		make_junction()
			set category = "make"
			set name = "make wiring junction"
			new/obj/signal/wire_junction(usr)
		make_underground()
			set category = "make"
			set name = "make underground wiring spool"
			if((locate(/obj/items/concealed_wire) in usr))
				usr << "You only need one of these."
			else
				new/obj/items/concealed_wire(usr)

		changes()
			set category = "Help"
			client.Topic("changes")

		forum()
			set category = "Help"
			usr << "The forum has been opened in your default web browser."
			usr << link("http://www.byond.com/forum/Nadrew/consoleForums")

		report_bug()
			set category = "Help"
			usr << "The bug report forum has been opened in your default web browser."
			usr << link("http://www.byond.com/forum/?forum=120237")

		make_conveyor_parts()
			set category = "make"
			var/obj/items/ConveyorParts/C = locate() in usr
			if(C)
				C.stack++
				C.suffix = "\[[C.stack]\]"
			else
				new/obj/items/ConveyorParts(usr)
		makebook()
			set category = "make"

			new /obj/items/book( usr )
			return
		make_disk()
			set category = "make"

			new /obj/items/disk( usr )
			return

		make_wire()
			set category = "make"

			var/obj/items/wire/W = new /obj/items/wire( usr )
			W.amount = 20
			W.update()

		make_hyper_wire()
			set category = "make"

			var/obj/items/wire/hyper/W = new /obj/items/wire/hyper( usr )
			W.amount = 20
			W.update()

		who()

			usr << "<B>Players:</B>"
			for(var/mob/M in world)
				usr << "\t[M]"

			return

		shout(msg as text)

			world << "\icon[src]<B>[usr.name]</B> shouts, '[html_encode(copytext(msg,1,301))]'"
			return

		say(msg as text)
			set desc = "Use say \[help\] for prefixes!"

			if (msg == "\[help\]")
				usr << "Say prefixes:\n\[s\] - shout (global and unrecordable - will be phased out eventually)\n\[w\] - whisper (oview(1))\n\[t\] - 'table' (Type say \[help\]\[t\] for a diagram)"
				return
			else
				if (msg == "\[help\]\[t\]")
					usr << "\[t\] Prefix diagram:\nXXXXX\nXOOOX Basically an extension of whisper 2 rows ahead.\nXOOOX / (will go over table)\nXOOOX\nXOSOX\nXOOOX\nXXXXX\n\nX=no hear, O = Hear, S - Subject facing North"
					return
			var/prefix = copytext(msg, 1, 4)
			msg = html_encode(copytext(msg,1,255))
			switch(prefix)
				if("\[s\]")
					msg = copytext(msg, 4, length(msg) + 1)
					world << "\icon[src]<B>[usr.name]</B> shouts, '[msg]'"
				if("\[w\]")
					msg = copytext(msg, 4, length(msg) + 1)
					for(var/atom/A in view(usr, 1))
						if (A.pos_status & src.pos_status)
							A.hear("\icon[src]<B>[usr.name]</B> whispers, '<I>[msg]</I>'", src, 2, msg, src)

				if("\[t\]")
					msg = copytext(msg, 4, length(msg) + 1)
					var/T = get_step(src, src.dir)
					var/L = view(usr, 1)
					var/see = 1
					if (istype(T, /turf))
						for(var/atom/A in T)
							if (A.opacity)
								see = null

					else
						see = null
					var/list/I = list(  )
					if (see)
						see = 1
						var/U = get_step(T, src.dir)
						if (istype(U, /turf))
							for(var/atom/A in U)
								if (A.opacity)
									see = null

						else
							see = null
						if (see)
							I = view(U, 1)
						else
							I = view(T, 1)
					L -= I
					var/S = L + I
					for(var/atom/A in S)
						if (A.pos_status & src.pos_status)
							A.hear("\icon[src]<B>[usr.name]</B> says, '[msg]'", src, 2, msg, src)


				else
					for(var/atom/A in view(usr, null))
						if (A.pos_status & src.pos_status)
							A.hear("\icon[src]<B>[usr.name]</B> says, '[msg]'", src, 2, msg, src)
					for(var/obj/signal/teleport_pad/TP in view(src))
						if(TP.charged&&TP.primed)
							var/obj/signal/teleport_pad/T2 = locate("teleport_[TP.charged_destination]") in world
							if(T2)
								if(T2.charged&&T2.primed)
									for(var/mob/M in view(T2))
										M.hear("\icon[T2] <b>[usr.name]</b> says, '[msg]'",src,2,msg,src)

			return

		whisper(msg as text)

			for(var/atom/A in view(usr, 1))
				if (A.pos_status & src.pos_status)
					A.hear("\icon[src]<B>[usr.name]</B> whispers, '<I>[msg]</I>'", src, 2, msg, src)

			return

		mass_add(params as message )
			set category = "computers"
			var/obj/signal/computer/using
			switch(winget(src,"computer_window.operating_tab","current-tab"))
				if("desktop_window") using = using_computer
				if("laptop_window") using = using_laptop
			if (using)
				if (get_dist(src, using) > 1)
					if(using == using_computer) src.using_computer = null
					else src.using_laptop = null
				else
					using.process(params)
					winset(src,"computer_window.computer_input","focus=true")
			return

		command(params as text)
			set hidden = 1
			set name = ">"
			var/obj/signal/computer/using
			switch(winget(src,"computer_window.operating_tab","current-tab"))
				if("desktop_window") using = using_computer
				if("laptop_window") using = using_laptop
			if (using)
				if ((get_dist(src, using) > 1))
					if(using == using_computer) src.using_computer = null
					if(using == using_laptop) using_laptop = null
				else
					using.process(params)
			return




obj
	signal
		hub
			verb
				check_connections()
					set src in oview(1)
					var/connections = 0
					usr << "<b>Connections for [src.name]</b>"
					if(line1)
						usr << "Line 1: [line1.name]"
						connections++
					if(line2)
						usr << "Line 2: [line2.name]"
						connections++
					if(line3)
						usr << "Line 3: [line3.name]"
						connections++
					if(line4)
						usr << "Line 4: [line4.name]"
						connections++
					if(line5)
						usr << "Line 5: [line5.name]"
						connections++
					if(line_temp)
						usr << "TEMP: [line_temp.name]"
						connections++
					if(line_control)
						usr << "CONTROL: [line_control.name]"
						connections++
					if(connections <= 0)
						usr << "<i>No connections</i>"
					usr << "Total: [connections]"

obj
	items
		wire
			Click()
				if(isturf(src.loc))
					if(get_dist(src,usr) <= 1)
						src.Move(usr)

