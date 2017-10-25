obj
	electronic
		New()
			new /obj/items/monitor( src )
			new /obj/items/computer( src )
			new /obj/signal/computer/laptop( src )

		verb
			dispense(obj/O in src)
				set src in oview(1)

				flick("e_convey1", src)
				sleep(10)
				var/I = new O.type( src.loc )
				if(istype(I,/obj/signal))
					var/obj/signal/T = I
					T.place_locked = 0
					T.density = 0
					T.verbs += /obj/signal/proc/get_me
					T.verbs += /obj/signal/proc/drop_me
				usr << "[I] has been created!"
				step(I, NORTH)

obj
	conveyor
		New()
			new /obj/items/monitor( src )
			new /obj/items/lock_kit( src )
			new /obj/items/lock( src )
			new /obj/items/key( src )
			new /obj/items/toolbox( src )
			new /obj/items/ult_check( src )
			new /obj/items/not_check( src )
			new /obj/items/watch( src )
			new /obj/items/disk( src )
			new /obj/items/pen( src )
			new /obj/items/inv_pen( src )
			new /obj/items/book( src )
			new /obj/items/box( src )
			new /obj/signal/hub/mini(src)
			new /obj/signal/hub/router/mini(src)
			new /obj/signal/antenna(src)
			new /obj/signal/dir_ant(src)
			new/obj/signal/rackmount(src)
			..()

		verb/dispense(obj/O in src)
			set src in oview(1)

			flick("convey1", src)
			sleep(4)
			var/I = new O.type( src.loc )
			if(istype(I,/obj/signal))
				var/obj/signal/T = I
				T.place_locked = 0
				T.density = 0
				T.verbs += /obj/signal/proc/get_me
				T.verbs += /obj/signal/proc/drop_me
			usr << "[I] has been created!"
			step(I, NORTH)

		electronic
			New()

				new /obj/items/monitor( src )
				new /obj/items/computer( src )
				new /obj/items/bug_scan( src )
				new /obj/signal/hub/mini(src)
				new /obj/signal/hub/router/mini(src)
				new/obj/signal/antenna(src)
				new/obj/signal/dir_ant(src)
				new/obj/signal/rackmount(src)