obj
	signal
		var
			tmp
				unlockable = 0
		antenna
			unlockable = 1
		dir_ant
			unlockable = 1
		rackmount
			unlockable = 1
		proc
			get_me()
				set name = "get"
				set category = "items"
				set src in oview(usr,1)
				if(!isturf(src.loc)) return
				if(src.place_locked)
					usr << "[src.name] is locked in place."
					src.verbs -= /obj/signal/proc/get_me
					src.verbs -= /obj/signal/proc/drop_me
					return
				src.cut()
				src.Move(usr)
			drop_me()
				set name = "drop"
				set category = "items"
				set src in usr
				if(!ismob(src.loc)) return
				src.loc = usr.loc