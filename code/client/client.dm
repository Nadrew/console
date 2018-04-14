client
	command_text = "say "
	New()
		winset(src,null,"reset=true")
		winset(src,"default","is-maximized=true")
		world << "<B>[src] has logged in!</B>"
		src << "<font color=blue>Version: [n_version][n_sub]</font>"
		src << "<font color=red>Welcome to console [n_version][n_sub] -- Click <a href=?changes>here</a> for a list of changes."
		if (!fexists("saves/players/[src.ckey].sav"))
			..()
			new /obj/items/wirecutters( src.mob )
			new /obj/signal/computer/laptop( src.mob )
			new /obj/items/watch( src.mob )
			new /obj/items/toolbox( src.mob )
			new /obj/items/pen( src.mob )
			new /obj/items/GPS( src.mob )
			src.mob.save_version = "[n_version][n_sub]"
			src.mob.saving = "yes"
		else
			var/savefile/F = new("saves/players/[src.ckey].sav")
			F >> src.mob
			if (!( locate(/obj/items/wirecutters, src.mob) ))
				new /obj/items/wirecutters( src.mob )
			if (!( locate(/obj/items/GPS, src.mob) ))
				new /obj/items/GPS( src.mob )
			src.mob.saving = "yes"
		if((ckey in admins))
			for(var/V in typesof(/mob/admin/verb))
				mob.verbs += V
			for(var/H in typesof(/mob/Host/verb))
				mob.verbs += H
		else
			var/host_file_key
			if(fexists("config/host.txt"))
				host_file_key = file2text("config/host.txt")
			if((host_file_key && ckey(host_file_key) == src.ckey) || world.host == src.key || src.address == world.address || !src.address)
				for(var/H in typesof(/mob/Host/verb))
					mob.verbs += H


	Del()
		if ((src.mob && src.mob.saving == "yes"))
			var/savefile/F = new /savefile( "saves/players/[src.ckey].sav" )
			F << src.mob
		world << "<B>[src] has logged out!</B>"
		del(src.mob)
		..()

