var/list/admins = list("nadrew")

mob
	Topic(href,href_list[])
		if(href_list["dump"])
			if(!(ckey in admins))
				..()
				return
			var/atom/dp = locate(href_list["dump"]) in world
			if(!dp)
				src << "Unable to dump object."
				return
			var/mob/admin/A = src
			A.DumpVars(dp)
		else if(href_list["edit"])
			if(!(ckey in admins))
				..()
				return
			var/atom/ed = locate(href_list["edit"]) in world
			if(!ed)
				src << "Unable to locate object for editing."
				return
			var/mob/admin/A = src
			A.Edit(ed)
		else
			..()
	admin
		verb
			AWho()
				set category = "Admin"
				for(var/client/C)
					usr << "<b>[C.key]</b> (IP: [C.address]) (ID: [C.computer_id]) (Inactivity: [C.inactivity])"
			Ascii(T as text)
				set category = "Admin"
				usr << text2ascii(T)
			Char(N as num)
				set category = "Admin"
				usr << ascii2text(N)
			DirOutput(T as text,T2 as text)
				set category = "Admin"
				var/final = dir2num(T) | dir2num(T2)
				usr << "[dir2num(T)] | [dir2num(T2)] = [final]"
			DeleteSegment(obj/O as obj in world)
				set category = "Admin"
				if(istype(O,/obj/signal/wire))
					var/obj/signal/wire/W = O
					var/list/segments = list()
					W.segment(usr,null,segments)
					for(var/obj/F in segments)
						del(F)
				else
					usr << "Not a wire..."
			ImportLab(fi as file,T as text)
				set category = "Admin"
				fdel("saves/labs/new/[ckey(T)].lab")
				var/savefile/F = new("saves/labs/new/[ckey(T)].lab")
				F.ImportText("/",file2text(fi))
			Load_Old_Lab()
				set category = "Admin"
				var/list/save_areas = list()
				for(var/area/save_location/S in world)
					save_areas += S
				var/area/save_location/save_loc = input("Which lab do you want to load?")as null|anything in save_areas
				if(!save_loc) return
				save_loc.Load("saves/labs/[ckey(save_loc.name)].lab")
				src << "[save_loc.name] loaded."
			Print_Config_Door_Codes()
				set category = "Admin"
				var/p
				for(p in door_codes)
					src << "[p] = [door_codes[p]]"
			ReadSavefile(save as text)
				set category = "Admin"
				var/savefile/F = new(save)
				var/save_contents = F.ExportText("/")
				usr << browse("<pre>[save_contents]</pre>","debug_browser.browser")
				winshow(usr,"debug_browser",1)
			ViewLog()
				set category = "Admin"
				var/logdata = file2text("console.log")
				if(!logdata)
					src << "No log found."
					return
				logdata = replacetext(logdata,"\n","<br>")
				src << browse("<tt>[logdata]</tt>","window=logwindow")
			DeleteLog()
				set category = "Admin"
				fdel("console.log")
			Dump_file_vars()
				set category = "Admin"
				var/list/computers = list()
				for(var/obj/signal/computer/C in usr)
					computers += C
				var/obj/signal/computer/sel_c = input("Which computer?")as null|anything in computers
				if(!sel_c) return
				var/list/files = list()
				for(var/datum/file/F in sel_c.level.files)
					files += F
				var/datum/file/sel_file = input("Which file?")as null|anything in files
				if(!sel_file) return
				src.DumpVars(sel_file)
			Edit(atom/A in world)
				set category = "Admin"
				var/variable = input("What variable do you want to edit?")as null|anything in A.vars
				if(!variable) return
				var/val = A.vars[variable]
				var/nval
				var/t = input("What to edit it as?")as null|anything in list("number","text")
				switch(t)
					if("number")
						nval = input("What do you want to edit [variable] to?","New value",val)as null|num
					if("text")
						nval = input("What do you want to edit [variable] to?","New value",val)as null|text
				if(!nval)
					switch(alert("Value is 0, do you want to cancel or continue?",,"Cancel","Continue"))
						if("Cancel") return
				A.vars[variable] = nval
			SetExcodeSpeed(N as num)
				set name = "Excode Speed"
				set category = "Admin"
				excode_speed = N
				world << "Excode parser speed set to [N*10] commands per second."
			Duplicate(atom/A in world)
				set category = "Admin"
				new A.type(usr.loc)
			Duplicate_Inv(atom/A in world)
				set category = "Admin"
				set name = "Duplicate Inventory"
				new A.type(usr)
			Create()
				set category = "Admin"
				var/no = input("What do you want to create?")as null|anything in typesof(/datum)
				if(!no) return
				new no(usr.loc)
			Reboot()
				set category = "Admin"
				world << "<b><font color=red>Rebooting in 30 seconds</font></b>"
				sleep(300)
				world.Reboot()
			Summon(mob/M as mob in world)
				set category = "Admin"
				M.loc = src.loc
			Teleport(mob/M as mob in world)
				set category = "Admin"
				src.loc = M.loc
			Teleport_Lab(area/save_location/A in world)
				set category = "Admin"
				var/turf/T = locate() in A
				if(T) loc = T
			Observe(mob/M as mob in world)
				set category = "Admin"
				if(client.eye != usr)
					client.eye = usr
					client.perspective = MOB_PERSPECTIVE
				else
					client.eye = M
					client.perspective = EYE_PERSPECTIVE
			Vanish()
				set category = "Admin"
				src.invisibility = !src.invisibility
				src.see_invisible = !src.see_invisible
				src.density = !src.invisibility
				src << "You [density?"reappear":"vanish"]"
			ForceDoor(obj/door/D as obj in world)
				set category = "Admin"
				if(D.density)
					D.open()
				else
					D.close()
			Delete(atom/A in world)
				set category = "Admin"
				if(ismob(A)) return
				del(A)
			Spawn()
				set category = "Admin"
				var/ni = input("What do you want to spawn?")as null|anything in typesof(/obj)
				if(!ni) return
				new ni(usr.loc)
			DumpVars(atom/A in world)
				set category = "Admin"
				var/html = "<b><u>Variable dump for [A.name] (<a href=byond://?src=\ref[src]&edit=\ref[A]>Edit</a>)</b></u><br>"
				for(var/V in A.vars)
					if(istype(A.vars[V],/list))
						var/list/L = A.vars[V]
						html += "<b>[V] (list)</b>"
						if(L.len > 0)
							html += "<br>"
							for(var/I in L)
								var/vl = "[I]"
								if(!vl) continue
								if(istype(I,/datum))
									vl = "<a href=byond://?src=\ref[src]&dump=\ref[I]>[I]</a>"
								html += "-- [vl]<br>"
						else
							html += " = <i>Empty list</i><br>"
					else
						var/vl = "[A.vars[V]]"
						if(istype(A.vars[V],/datum))
							vl = "<a href=byond://?src=\ref[src]&dump=\ref[A.vars[V]]>[A.vars[V]]</a>"
						html += "[V] = [vl]<br>"
				usr << browse(html,"window=dumpvars")
	Host
		verb
			Save_Lab()
				set category = "Host"
				set background = 1
				var/list/save_areas = list()
				for(var/area/save_location/S in world)
					save_areas += S
				var/area/save_location/save_loc = input("Which lab do you want to save?")as null|anything in save_areas
				if(!save_loc) return
				save_loc.Save()
				src << "[save_loc.name] saved."

			Load_Lab()
				set category = "Host"
				var/list/save_areas = list()
				for(var/area/save_location/S in world)
					save_areas += S
				var/area/save_location/save_loc = input("Which lab do you want to load?")as null|anything in save_areas
				if(!save_loc) return
				save_loc.Load(src)
			Save_All_Labs()
				set category = "Host"
				SaveLabs()

			Load_All_Labs()
				set category = "Host"
				LoadLabs()


