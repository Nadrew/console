obj/signal/computer
	proc/execute(command, params, datum/task/source)

		var/list/command_list = splittext(params, "[ascii2text(2)]")
		if (src.status != "on")
			return
		if (src.sys_stat >= 2)
			add_to_log("[command] ([replacetext(params, "[ascii2text(2)]", " ")])")
		if (!( src.level ))
			src.level = src.root
		if (src.parse2file("/sys/registry/[command].com"))
			parse_string("run /sys/registry/[command].com [replacetext(params, "[ascii2text(2)]", " ")]", source)
			return
		switch(command)
			if("clear")
				src.clear_messages()
			if("setenv")
				if(command_list.len < 2)
					src.show_message("setenv: Takes two arguments.")
				else
					var
						variable = command_list[1]
						value = command_list[2]
					if(!variable)
						src.show_message("setenv: Invalid variable.")
						return
					if(!value)
						if(variable in environment) environment -= variable
					else
						src.environment[variable] = value
			if("getenv")
				if(command_list.len < 1||!command_list[1])
					if(!environment.len)
						src.show_message("getenv: No environment variables have been set.")
						return
					var/envshow
					for(var/E in environment)
						envshow+="[E]=[environment[E]];"
					src.show_message("getenv: [envshow]")
				else
					var/variable = command_list[1]
					if(variable in environment)
						src.show_message("getenv: [variable] = [environment[variable]]")
					else
						src.show_message("getenv: [variable] is not set.")
			if("unarc")
				if(command_list.len < 1)
					src.show_message("unarc: Takes at least one argument")
				else
					var/datum/file/archive/arc = src.parse2file(command_list[1])
					if(!istype(arc,/datum/file/archive))
						src.show_message("unarc: Not an archive file.")
					else
						if(arc.password)
							if(command_list.len >= 3)
								if(arc.password != command_list[3])
									src.show_message("unarc: Password invalid.")
									return
							else
								src.show_message("unarc: Unable to open archive, it is password protected.")
								return
						for(var/datum/file/F in arc.files)
							var/datum/file/dir/p_dir = src.level
							if(command_list.len >= 2)
								if(command_list[2] != ".")
									var/datum/file/dir/e_dir = parse2file(command_list[2])
									if(!e_dir)
										src.show_message("unarc: [command_list[2]] does not exist.")
										return
									if(!istype(e_dir,/datum/file/dir))
										src.show_message("unarc: [command_list[2]] is not a directory.")
										return
									p_dir = e_dir
							var/datum/file/check_file = src.parse2file(F.name)
							if(check_file)
								src.show_message("unarc: [F.name] exists, overwriting...")
								del(check_file)
							src.show_message("unarc: Inflating [F.name]")
							var/datum/file/new_file = new F.type
							F.copy_to(new_file)
							p_dir.files += new_file
							new_file.parent = p_dir
							new_file.master = src
							if(istype(new_file,/datum/file/dir))
								var/datum/file/dir/ndir = new_file
								for(var/datum/file/subfile in ndir.files)
									subfile.master = src
									subfile.parent = ndir
							if(p_dir.disk_master) new_file.disk_master = p_dir.disk_master
						src.show_message("unarc: Unarc successful.")
			if("arc")
				if(command_list.len < 2)
					src.show_message("arc: Takes at least two arguments.")
				else
					var
						datum/file/addition = src.parse2file(command_list[1])
						datum/file/archive/arc_file = src.parse2file(command_list[2])
					if(!addition)
						if(command_list[1] != "*")
							src.show_message("arc: File not found.")
							return
					if(addition == src.root)
						src.show_message("arc: Cannot store /root directly, use \"arc * \[file\]\" inside of /root instead.")
						return
					if(command_list[1] == command_list[2])
						src.show_message("arc: Now that wouldn't work so well...")
						return
					if(findtext(command_list[2],"/"))
						src.show_message("arc: Archive files can only be created in the current directory. (Will fix soon.)")
						return
					if(!arc_file)
						var/datum/file/dir/p_dir = src.level
						var/datum/file/archive/new_arc = new()
						new_arc.name = command_list[2]
						new_arc.master = src
						new_arc.parent = p_dir
						if(p_dir.disk_master) new_arc.disk_master = p_dir.disk_master
						p_dir.files += new_arc
						arc_file = src.parse2file(command_list[2])
					if(arc_file.password)
						src.show_message("arc: Unable to add file to the archive (Password protected)")
						return
					if(command_list.len >= 3)
						if(!arc_file.password)
							arc_file.password = command_list[3]
							src.show_message("arc: Archive password set successfully.")
						else
							src.show_message("arc: Archive password could not be set. (Old password?)")
							src.show_message("arc: Archiving failed.")
							return
					if(command_list[1] != "*")
						var/datum/file/new_f = new addition.type
						var/datum/file/exist_file = arc_file.Exists(addition.name)
						if(exist_file)
							src.show_message("arc: [addition.name] exists in archive, overwriting...")
							del(exist_file)
						addition.copy_to(new_f)
						arc_file.AddFile(new_f)
						src.show_message("arc: [addition.name] archived successfully.")
					else
						for(var/datum/file/F in src.level.files)
							if(F.name != arc_file.name)
								var/datum/file/new_f = new F.type
								F.copy_to(new_f)
								arc_file.AddFile(new_f)
								src.show_message("arc: [F.name] archived successfully.")
			/*if("sndsrc")
				if(command_list.len < 1||command_list.len > 1)
					src.show_message("sndsrc: Takes a single argument.")
				else
					var/datum/file/normal/sound/snd = src.parse2file(command_list[1])
					if(!istype(snd,/datum/file/normal/sound))
						src.show_message("Invalid file type")
					else
						src.show_message("[snd.s_source],[snd.text]")*/
			if("root")
				src.level = src.root
			if("processes")
				if(tasks.len <= 0)
					src.show_message("No processes found")
					return
				for(var/datum/task/T in src.tasks)
					switch(T.state)
						if(1.0)
							src.show_message("[src.tasks.Find(T)](P): [T.source]")
						if(2.0)
							src.show_message("[src.tasks.Find(T)](F): [T.source]")
						if(3.0)
							src.show_message("[src.tasks.Find(T)](B): [T.source]")
						else

			if("terminate","kill")
				var/number = round(text2num(command_list[1]))
				if ((number > src.tasks.len || number < 1))
					src.show_message("Invalid task input. ([number])")
					return
				del(src.tasks[number])
			if("bios")
				var/field = null
				var/param = null
				if (command_list.len >= 2)
					param = command_list[2]
				if (command_list.len >= 1)
					field = command_list[1]
				if (!( field ))
					src.show_message("BIOS needs arguments to function. Try help as an argument.")
					return
				else
					switch(field)
						if("bios_1")
							if (param)
								if (param == "none")
									src.bios1 = null
								else
									src.bios1 = param
									show_message("BIOS level 1 set to [src.bios1]")
							else
								show_message("BIOS level 1: [src.bios1]")
						if("bios_2")
							if (param)
								if (param == "none")
									src.bios2 = null
								else
									src.bios2 = param
									show_message("BIOS level 2 set to [src.bios2]")
							else
								show_message("BIOS level 2: [src.bios2]")
						if("bios_3")
							if (param)
								if (param == "none")
									src.bios3 = null
								else
									src.bios3 = param
									show_message("BIOS level 3 set to [src.bios3]")
							else
								show_message("BIOS level 3: [src.bios3]")
						if("pass_1")
							if (param)
								if (param == "none")
									src.b_p1 = null
								else
									src.b_p1 = param
									show_message("BIOS pass 1 set.")
							else
								if (src.b_p1)
									show_message("BIOS level 1 password is set.")
								else
									show_message("No BIOS level 1 password is set.")
						if("pass_2")
							if (param)
								if (param == "none")
									src.b_p2 = null
								else
									src.b_p2 = param
									show_message("BIOS pass 2 set.")
							else
								if (src.b_p2)
									show_message("BIOS level 2 password is set.")
								else
									show_message("No BIOS level 2 password is set.")
						if("pass_3")
							if (param)
								if (param == "none")
									src.b_p3 = null
								else
									src.b_p3 = param
									show_message("BIOS pass 3 set.")
							else
								if (src.b_p3)
									show_message("BIOS level 3 password is set.")
								else
									show_message("No BIOS level 3 password is set.")
						if("reset")
							if (param == "true")
								src.bios1 = "A:/boot.sys"
								src.bios2 = "/sys/boot.sys"
								src.bios3 = null
								src.b_p1 = null
								src.b_p2 = null
								src.b_p3 = null
							else
								src.show_message("The parameter must be true in order to reset to default.")
						if("help")
							src.show_message("Available arguements: (parameters can be left blank.)")
							show_message(" bios_1/bios_2/bios_3 \[path/file\] for boot levels.")
							show_message("  bios_1/bios_2/bios_3 none will clear it.")
							show_message(" pass_1/pass_2/pass_3 \[password\] for boot levels.")
							show_message("  pass_1/pass_2/pass_3 none will clear it.")
							show_message(" reset \[true\] to reset to default data")
							show_message(" help will show this again.")
						else
			if("back")
				var/datum/file/normal/t2 = src.parse2file(command_list[1])
				show_message("Executing in background [jointext(command_list, " ")]", 1)
				if (!( t2 ))
					show_message("ERROR: Unable to find [command_list[1]]")
					return
				else
					if (istype(t2, /datum/file/normal))
						var/list/L = list()
						var/x = null
						x = 2
						while(x <= command_list.len)
							L += command_list[x]
							x++
						spawn( 0 )
							t2.execute(jointext(L, "[ascii2text(2)]"), 1)
							return
			if("run")
				var/datum/file/normal/t2 = src.parse2file(command_list[1])
				show_message("Executing [jointext(command_list, " ")]", 1)
				if (!( t2 ))
					show_message("ERROR: Unable to find [command_list[1]]")
					return
				else
					t2.text = replacetext(t2.text,"\[space\]"," ")
					if ((istype(t2, /datum/file/normal) && (!( src.cur_prog ) || (src.cur_prog && source == src.cur_prog))))
						src.recursion++
						if (src.recursion > 10)
							show_message("ALERT: You have exceeeded the maximum available programs to run at once. Now terminating programs!")
							for(var/datum/task/T in src.tasks)
								if (T.state != 3)
									del(T)

							return
						var/list/L = list()
						var/x = null
						x = 2
						while(x <= command_list.len)
							L += command_list[x]
							x++
						if (istype(source, /datum/task))
							source.state = 2
						src.cur_prog = t2
						t2.execute(jointext(L, "[ascii2text(2)]"))
						var/datum/task/T = null
						for(var/datum/task/A in src.tasks)
							if (A.state == 2)
								T = A

						src.cur_prog = T
						if (istype(T, /datum/task))
							T.state = 1
						src.recursion--
			if("console")
				if (src.sys_stat == 2)
					src.sys_stat = 3
					show_message("Console Loaded and operating!")
				else
					if (src.sys_stat == 3)
						show_message("Console already operating!")
					else
						show_message("Invalid command: [command]")
			if("drive")
				if (src.disk)
					src.level = src.disk.root
				else
					show_message("Cannot find a disk!")
			if("eject")
				src.eject_disk()
			if("verbose")
				var/t3 = jointext(command_list, "[ascii2text(2)]")
				if (t3 == "on")
					src.verbose = 1
				else if(t3 == "none")
					src.verbose = -3
				else if (t3 == "off")
					src.verbose = 0
				else
					src.verbose = !( src.verbose )
				if (src.verbose == 1)
					show_message("You are now receiving all console messages!")
				else if(verbose == -3)
					show_message("No console messages")
					verbose = -2
				else
					show_message("Certain console messages are now being omitted!")
			if("cd_p")
				var/list/t3 = jointext(command_list, "[ascii2text(2)]")
				var/datum/file/t4 = src.parse2file(t3)
				if (!( istype(t4, /datum/file) ))
					show_message("ERROR: Invalid file/directory: [t3]")
					return
				src.level = t4.parent
				show_message("You are now in: [get_path(src.level)]")
			if("cd")
				var/t3 = jointext(command_list, "[ascii2text(2)]")
				if (t3 == ".")
					show_message("Current Directory: [get_path(src.level)]")
				else
					if (t3 == "..")
						if (!( src.level ))
							src.level = src.root
						if ((src.level != src.root && (!( src.disk ) || (src.disk && src.level != src.disk.root))))
							src.level = src.level.parent
							show_message("You are now in /[src.level]/")
						else
							src.show_message("You are already at the root!")
					else
						var/t4 = src.parse2file(t3)
						if (!( istype(t4, /datum/file/dir) ))
							show_message("ERROR: Invalid directory: [t3]")
							return
						src.level = t4
						show_message("You are now in: [get_path(src.level)]")
			if("timer")
				if (!params)
					src.show_message("Timer: [world.time]")
				src.err_level = "[world.time]"
			if("timestamp")
				if(!params)
					src.show_message("Time: [time2text(world.realtime, "MM/DD/YYYY hh:mm:ss")]")
				src.err_level = "[time2text(world.realtime, "MM/DD/YYYY hh:mm:ss")]"
			if("file_add")
				var/datum/file/normal/t2 = src.parse2file(command_list[1])
				if (!( t2 ))
					show_message("ERROR: File Not Found: [command_list[1]]")
					return
				else
					if ((!( istype(t2, /datum/file/normal) ) || t2.flags & 2))
						src.show_message("Invalid file type... It must be a text type file")
						return
					else
						var/msg = ""
						var/x = null
						x = 2
						while(x <= command_list.len)
							msg += "[command_list[x]][(x != command_list.len ? " " : "")]"
							x++
						msg = replacetext(msg, "\[semi\]", ";")
						msg = replacetext(msg, "\[newline\]", "\n")
						msg = replacetext(msg, "\[space\]"," ")
						msg = replacetext(msg,"\[bracket_l\]","\[")
						msg = replacetext(msg,"\[bracket_r\]","\]")
						t2.text += msg
			if("file_exists")
				var/t2 = src.parse2file(command_list[1])
				if (!( t2 ))
					show_message("File ([command_list[1]]) does not exist!", 1)
					src.err_level = "false"
					return
				else
					show_message("[get_path(t2)] exists!", 1)
					src.err_level = "true"
			if("file_clear")
				var/datum/file/normal/t2 = src.parse2file(jointext(command_list, "[ascii2text(2)]"))
				if (!( t2 ))
					show_message("ERROR: File Not Found: [jointext(command_list, "[ascii2text(2)]")]")
					return
				else
					if ((!( istype(t2, /datum/file/normal) ) || t2.flags & 1))
						src.show_message("Invalid file type... It must be a text type file")
						return
					else
						t2.text = null
						src.show_message("Text cleared.")
			if("restart")
				src.show_message("Restarting computer...")
				sleep(10)
				stop(0)
				spawn( 5 )
					start(0)
					return
			if("shutdown")
				src.show_message("Shutting down...")
				sleep(10)
				stop()
			if("del")
				var/t3 = jointext(command_list, "[ascii2text(2)]")
				if(t3 == "/" || t3 == "/root" || t3 == "root/")
					src.show_message("You may not delete a core directory. (It would destroy the hard disk permanently.)")
					return
				if (t3 == "*")
					for(var/datum/file/x in src.level.files)
						del(x)

				else
					var/t2 = src.parse2file(jointext(command_list, "[ascii2text(2)]"))
					if (!( t2 ))
						show_message("ERROR: File Not Found: [jointext(command_list, "[ascii2text(2)]")]")
						return
					else
						if ((t2 == src.root || (src.disk && t2 == src.disk.root)))
							src.show_message("You may not delete a core directory. (It would destroy the hard disk permanently.)")
							return
						else
							if (istype(t2, /datum/file))
								del(t2)
			if("echo")
				var/t5 = ""
				for(var/x in splittext(params, "[ascii2text(2)]"))
					t5 += "[x] "

				src.show_message(t5)
			if("send")
				if (command_list.len < 3)
					src.show_message("ERROR: Not enough parameters (need 3)!")
					return
				var/datum/file/t2 = src.parse2file(command_list[3])
				if (!( istype(t2, /datum/file) ))
					return
				var/obj/signal/structure/S = new /obj/signal/structure(  )
				var/s_id = command_list[1]
				var/s_main = 1
				if (findtext(s_id, ":", 1, null))
					var/te1 = findtext(s_id, ":", 1, null)
					if ((copytext(s_id, te1 + 1, length(s_id) + 1)) == "1")
						s_main = null
						s_id = copytext(s_id, 1, te1)
				S.source_id = s_id
				S.dest_id = command_list[2]
				S.id = "-1"
				S.params = S.name
				var/datum/file/t4 = new t2.type(  )
				t2.copy_to(t4)
				if ((t2 == src.root || (src.disk && src.disk.root == t2)))
					t4.name = "r_copy"
				S.params = t4.name
				S.cur_file = t4
				if (s_main)
					send_out(S, src.line1)
				else
					send_out(S, src.line2)
			if("extern")
				if (command_list.len < 4)
					src.show_message("ERROR: Not enough parameters (need 4)!")
					return
				var/obj/signal/structure/S = new /obj/signal/structure(  )
				var/s_id = command_list[1]
				var/s_main = 1
				var/d_id = command_list[2]
				if (findtext(s_id, ":", 1, null))
					var/te1 = findtext(s_id, ":", 1, null)
					if ((copytext(s_id, te1 + 1, length(s_id) + 1)) == "1")
						s_main = null
					s_id = copytext(s_id, 1, te1)
				S.source_id = s_id
				S.dest_id = d_id
				S.id = command_list[3]
				var/list/L = list()
				var/x = null
				x = 4
				while(x <= command_list.len)
					L += command_list[x]
					x++
				S.params = jointext(L, " ")
				if (s_main)
					send_out(S, src.line1)
				else
					send_out(S, src.line2)
			if("backup")
				if (command_list.len < 2)
					src.show_message("ERROR: Not enough parameters (need 2)!")
					return
				var/list/L = splittext(command_list[1], "/")
				if (L[L.len] != "*")
					var/datum/file/dir/t2 = src.parse2file(command_list[1])
					var/t3 = command_list[2]
					if ((!( t3 ) || !( t2 )))
						src.show_message("ERROR: Not a valid parameter.")
						return
					if (t2.name == t3)
						src.show_message("ERROR: The backup name must be different!.")
						return
					if (src.get_file2(t3, t2.parent))
						show_message("File name already in use! Please select a new one!")
						return
					if ((t2 == src.root || (src.disk && src.disk.root == t2)))
						src.show_message("You may not perform this operation on a root file.")
						return
					else
						var/datum/file/t4 = new t2.type(  )
						t4.parent = t2.parent
						t4.disk_master = t2.disk_master
						t2.copy_to(t4)
						t4.set_master(t2.master)
						t4.name = t3
						t2.parent.files += t4
			if("copy")
				if (command_list.len < 2)
					src.show_message("ERROR: Not enough parameters (need 2)!")
					return
				var/datum/file/dir/t3 = parse2file(command_list[2])
				var/list/L = splittext(command_list[1], "/")
				if (L[L.len] != "*")
					var/datum/file/dir/t2 = src.parse2file(command_list[1])
					if ((!( istype(t2, /datum/file) ) || !( istype(t3, /datum/file/dir) )))
						src.show_message("ERROR: Invalid path or file.")
						return
					if (t2.parent == t3)
						src.show_message("ERROR: You cannot copy onto yourself.")
						return
					if (src.get_file2(t2.name, t3))
						show_message("File name already in use...Overwriting...")
						var/F = src.get_file2(t2.name, t3)
						del(F)
					if (t2 == t3)
						src.show_message("I don't understand why your doing this but enjoy yourself. (Easter Egg) =\]")
					if ((t2 == src.root || (src.disk && src.disk.root == t2)))
						for(var/datum/file/t6 in t2.files)
							var/F = src.get_file2(t6.name, t3)
							if (F)
								del(F)
							var/datum/file/t4 = new t6.type(  )
							t4.disk_master = t3.disk_master
							t6.copy_to(t4)
							t4.parent = t3
							t4.set_master(t3.master)
							t3.files += t4

					else
						var/datum/file/t4 = new t2.type(  )
						t4.parent = t3
						t4.disk_master = t3.disk_master
						t2.copy_to(t4)
						t4.set_master(t3.master)
						t3.files += t4
				else
					L -= L[L.len]
					command_list[1] = jointext(L, "/")
					var/datum/file/dir/t2 = src.parse2file(command_list[1])
					var/datum/file/dir/t3z = parse2file(command_list[2])
					if ((!( istype(t2, /datum/file/dir) ) || !( istype(t3z, /datum/file/dir) )))
						src.show_message("ERROR: Invalid path.")
						return
					for(var/datum/file/t6 in t2.files)
						var/F = src.get_file2(t6.name, t3z)
						if (F)
							del(F)
						var/datum/file/t4 = new t6.type(  )
						t4.disk_master = t3z.disk_master
						t6.copy_to(t4)
						t4.parent = t3
						t4.set_master(t3.master)
						t3z.files += t4

			if("makedir")
				var/t2 = src.parse2file(jointext(command_list, "[ascii2text(2)]"))
				if (t2)
					show_message("ERROR: Directory already exists: [jointext(command_list, "[ascii2text(2)]")]")
					return
				else
					var/D = src.level
					var/list/L = splittext(command_list[1], "/")
					if ((L && L.len > 1))
						if ((L[1] == "root" || !( L[1] )))
							D = src.root
							command_list[1] = ""
							var/t = null
							t = 2
							while(t <= L.len)
								command_list[1] += (t != L.len ? "[L[t]]/" : "[L[t]]")
								t++
						else
							if (L[1] == "A:")
								if (src.disk)
									D = src.disk.root
									var/pa
									for(var/E in L)
										if(L.Find(E) == 1) continue
										pa += "[E][L.Find(E)!=L.len?"/":""]"
									command_list[1] = pa
								else
									show_message("ERROR: No disk in drive!")
									return
					src.makedir(command_list[1], D)
			if("comment")
				return
			if("make")
				var/datum/file/t2 = src.parse2file(command_list[1])
				var/t6 = command_list[1]
				if (t2)
					show_message("ERROR: Name already taken: [jointext(command_list, "[ascii2text(2)]")]")
					return
				else
					var/datum/file/dir/D = src.level
					if (findtext(command_list[1], "/", 1, null))
						var/list/L = splittext(command_list[1], "/")
						t6 = L[L.len]
						L[L.len] = null
						var/temp = jointext(L, "/")
						D = src.parse2file(temp)
						if (!( D ))
							show_message("ERROR: Invalid directory!")
							return
					if ((t6 == "root" || (findtext(t6, "/", 1, null) || findtext(t6, ":", 1, null))))
						src.show_message("ERROR: you are using a reserved name or character. (root,/,:)")
						return
					src.show_message("Creating file: [((D && D != src.level) ? src.get_path(D) : "")][t6]")
					t2 = new /datum/file/normal(  )
					t2.name = t6
					t2.parent = D
					if (D.disk_master)
						t2.disk_master = D.disk_master
					t2.master = src
					D.files += t2
			if("read")
				var/datum/file/normal/t2 = src.parse2file(command_list[1])
				if (istype(t2, /datum/file/normal))
					if (t2.flags & 1)
						src.show_message("ERROR: Unable to read file!")
						return
					src.show_message("[t2.name]:")
					src.show_message("\t [t2.text]")
				else
					show_message("Error: Invalid Filename.")
					return
			if("error")
				src.err_level = command_list[1]
				show_message("Error level (or message) changed to [src.err_level] !", 1)
			if("delay")
				var/timer = null
				if (!( params ))
					timer = 10
				else
					timer = min(max(round(text2num(params)), 0), 600)
				while(timer >= 0)
					sleep(1)
					timer--
			if("hide")
				var/datum/file/normal/t2 = src.parse2file(jointext(command_list, "[ascii2text(2)]"))
				if (!( t2 ))
					show_message("ERROR: File Not Found: [jointext(command_list, "[ascii2text(2)]")]")
					return
				else
					if ((t2 == src.root || (src.disk && t2 == src.disk.root)))
						src.show_message("You may not hide a core directory.")
						return
					else
						if (istype(t2, /datum/file))
							src.show_message("[jointext(command_list, "[ascii2text(2)]")] has been hid!", 1)
							t2.flags |= 4
			if("reveal")
				var/datum/file/normal/t2 = src.parse2file(jointext(command_list, "[ascii2text(2)]"))
				if (!( t2 ))
					show_message("ERROR: File Not Found: [jointext(command_list, "[ascii2text(2)]")]")
					return
				else
					if (istype(t2, /datum/file))
						show_message("[jointext(command_list, "[ascii2text(2)]")] has been revealed!", 1)
						t2.flags &= 65531
			if("display","ls","dir")
				show_message("Displaying files in /[src.level]")
				for(var/datum/file/F in src.level.files)
					if (!( F.flags & 4 ))
						if (istype(F, /datum/file/dir))
							src.show_message("\t [F]\t(DIR)")
						else
							src.show_message("\t [F]")
			if("display_num","dir_num","ls_num")
				src.show_message("dir_num: [src.level.files.len] file\s")

			if("rename")
				if (command_list.len < 2)
					src.show_message("ERROR: Need at least 2 parameters.")
					return
				var/datum/file/t2 = src.parse2file(command_list[1])
				if (t2)
					if (src.get_file2(command_list[2], t2.parent))
						show_message("ERROR: Name already in use")
						return
					if ((command_list[2] == "root" || (findtext(command_list[2], "/", 1, null) || findtext(command_list[2], ":", 1, null))))
						src.show_message("ERROR: Invalid Character or name (root,/,:)")
						return
					t2.name = command_list[2]
			if("help")
				if (!( params ))
					src.show_message("Please use: help \[text\] on one of these topics.")
					show_message("Console Commands:")
					show_message(" append   cd       console   copy    del")
					show_message(" delay    display  drive     echo    eject")
					show_message(" make     makedir  restart   read    rename")
					show_message(" root     run      shutdown  write")
					show_message(" arc      unarc    clear")
					show_message("Special Commands: (OS)")
					show_message(" file_    send     extern    error   e_key")
					show_message(" hide     reveal   timestamp timer   bios")
					show_message("System Data:")
					show_message(" directories  programs    logs    scripts")
					show_message(" scripts-2    registry    shell   tasks")
				else
					switch(params)
						if("arc")
							src.show_message("Syntax: arc \[file\] \[archive\] \[password\]")
							src.show_message(" This will add \[file\] to the \[archive\] archive file protecting it with \[password\] (optional)")
						if("unarc")
							src.show_message("Syntax: unarc \[archive\] \[output_dir\] \[password\]")
							src.show_message(" This will extract the files from \[archive\] to the directory \[output_dir\] (use \".\" for the current directory), \[password\] may be required to succeed.")
						if("append")
							src.show_message("Syntax: append \[filename\]")
							show_message(" This appends to the current file using wp.exe. It does not make a new file or work on executables. (see append)")
						if("bios")
							src.show_message("Syntax: bios \[field\] \[param\]")
							show_message(" This enables alteration of bios settings. Please use bios help for field and param information.")
							show_message(" When a computer boots up it attempts bios1 first. If it has a pass then it asks. If your wrong or bios1 can't be found (or no entry in field) then it goes on to bios2. If it fails goto bios3 then if another failure it shuts down.")
						if("clear")
							src.show_message("Syntax: clear")
							src.show_message("Clears the console screen.")
						if("console")
							src.show_message("Syntax: console")
							show_message(" This is usually not used. The only place it can be used is in boot.sys. This will activate the console to allow you to actually use the computer. Without it the computer will not accept external input. You need to have an os running before this will work.")
						if("cd")
							src.show_message("Syntax: cd \[directory\]")
							show_message(" This will move you to the current directory.")
							show_message("Start the directoy with a / or with root/ and it")
							show_message(" goes down to the root. start with A:/ and it")
							show_message(" goes to the disk drive")
							show_message("  Ex: /sys/registry goes to registry. You could also ")
							show_message("    use root/sys/registry to do this.")
							show_message("  Ex: A:/ goes to the floppy drive")
							show_message("  Ex: A:/files goes to the files directory on A:")
							show_message(" Ex: files  goes to the files subdirectory of the current level")
							show_message("  Ex: files/c This goes to the c directory in ")
							show_message("      files in the current level you are in")
							show_message(" .. goes to the parent, . displays the current directory.")
							show_message("Use cd_p instead of cd and it will go to the parent.")
						if("copy")
							src.show_message("Syntax: copy \[file/directory\] \[directory\]")
							show_message(" This copes the file to the directory")
							show_message("  If the file is a root directory it")
							show_message("  will copy each individual file in it")
							show_message("   try copy /root /tmp and see.")
							show_message("You can copy between drives.")
							show_message("Be carfeul and cautious.")
							show_message(" This command is very strange.")
						if("del")
							src.show_message("Syntax: del \[directory or file\]")
							show_message(" This deletes the directory or file.")
							show_message(" * will delete everything in the directory.")
						if("delay")
							src.show_message("Syntax: delay \[number\]")
							show_message(" This delays execution for number 1/10ths of a second..")
							show_message("  There is a minimum value of 0 and max of 600 (1 minute).")
						if("display")
							src.show_message("Syntax: display")
							show_message(" This displays the directorys entire contents.")
							show_message(" If it is a directory it will display (DIR) by the name.")
						if("drive")
							src.show_message("Syntax: drive")
							show_message(" This changes directory to the A: drive")
						if("echo")
							src.show_message("Syntax: echo \[text\]")
							show_message(" This echoes the text to the console.")
							show_message(" You cannot include any semi-colons. This will signal a new command.")
						if("eject")
							src.show_message("Syntax: eject")
							show_message(" Ejects a disk in the disk drive.")
						if("hide")
							src.show_message("Syntax: hide \[file\]")
							show_message(" Hides the file.")
						if("timer")
							src.show_message("Syntax: timer \[opt\]")
							show_message(" Sets the error level to the current time.")
							show_message(" The presence of an argument displays no console message")
						if("timestamp")
							src.show_message("Syntax: timestamp \[opt\]")
							show_message(" Sets the error level to the current time/date.")
							show_message(" The presence of an argument displays no console message")
						if("make")
							src.show_message("Syntax: make \[file name to make\]")
							show_message(" This will make the file. You need to add the extension yourself.")
						if("makedir")
							src.show_message("Syntax: makedir \[directory to make\]")
							show_message(" This will create the new directory.")
						if("restart")
							src.show_message("Syntax: restart")
							show_message(" This restarts the computer. (see shutdown)")
						if("read")
							src.show_message("Syntax: read \[file\]")
							show_message(" This displays the file. Does not work on executables.")
						if("rename")
							src.show_message("Syntax: rename \[file or directory\] \[new name\]")
							show_message(" Renames the file. ")
						if("reveal")
							src.show_message("Syntax: reveal \[file\]")
							show_message(" Reveals the file.")
						if("root")
							src.show_message("Syntax: root")
							show_message(" This takes you directly to the root directory.")
						if("run")
							src.show_message("Syntax: run \[file(script) or executable\]")
							show_message(" This runs the script (see scripts) or executes the executable.")
						if("shutdown")
							src.show_message("Syntax: shutdown")
							show_message(" This shutsdown the computer. (see restart)")
						if("write")
							src.show_message("Syntax: write \[file\]")
							show_message(" This overwrites the current file using wp.exe. It does not make a new file or work on executables. (see append)")
						if("file_")
							src.show_message("These are a set of commands dealing with files.")
							show_message(" Syntax: file_clear \[text file\]")
							show_message("  Clears all text.")
							show_message(" Syntax: file_exists \[file\]")
							show_message("  Tells you if file exists.")
							show_message(" Syntax: file_add \[text file\] \[text\]")
							show_message("  Adds text to file. Use \[semi\] for a semicolon")
						if("extern")
							src.show_message("Syntax: extern \[src_id\] \[dest_id\] \[id\] \[params\]")
							show_message(" This sends a simple packet along the wire.")
							show_message("The id is important.")
							show_message("Do not use -2 right now")
							show_message("Do not use -1 as it is reserved")
							show_message("0 tries to execute shell.scr \[src_id\] \[params\] do not use any ;")
							show_message("Anything besides 0 or -1 executes")
							show_message(" packet\[id\].scr \[src_id\] \[params\]")
							show_message("If this packet is not there:")
							show_message(" It makes packet\[id\].dat with text \[src_id\];\[params\]")
							show_message(" ")
							show_message("dest_id is important. Many hardware components will parse it.")
							show_message(" Ask the network administrater for ids for what you want to do.")
						if("send")
							src.show_message("Syntax: send \[src_id\] \[dest_id\] \[file\]")
							show_message(" See extern for data of the _id's")
							show_message("Sends the file to the /tmp directory.")
							show_message("Follow up by a shell to use the file.")
						if("e_key")
							src.show_message("Syntax: e_key \[number\]")
							show_message(" *Only available on laptops!*")
							show_message("New number for encryption key")
							show_message("If a computer or antenna gets ")
							show_message(" a signal and the keys are different.")
							show_message(" Then it will discard the packet. (too garbled)")
						if("tasks")
							src.show_message("Every program when executed by the kernel is placed")
							show_message("on the program stack. When you use the run command")
							show_message("you lock up the console which prevents future running")
							show_message("of it. However you can have the primary program")
							show_message("execute another program (via run) This then converts")
							show_message("the running program into a freeze state. Then it")
							show_message("executes the new program.Once that program ceases it will")
							show_message("receive control. See background for additional data")
						if("background")
							src.show_message("To address certain problems a new multi-tasking kernel has")
							show_message("been programmed. You can use the back command to make a ")
							show_message("program execute in the background. It will receive all")
							show_message("packet and input data like normal. However it will not")
							show_message("ever lock up the console. You cannot be sure the sequence")
							show_message("at which command will be transfered.")
							show_message("processes: lists all proccesses, their ids and the file")
							show_message("  that spawned them. It will show their state")
							show_message("   Background, Frozen, or Primary")
							show_message("terminate \[id\]: (not that ids will shift up when a ")
							show_message("  process ends.) This destroys the process instantly.")
						if("directories")
							src.show_message("The default system directories are:")
							show_message(" usr - Store files here")
							show_message(" bin - Store programs here")
							show_message(" sys - Do not touch or delete!")
							show_message(" log - (see logs)")
							show_message(" tmp - Store temporary files here.")
						if("programs")
							src.show_message("The default programs:")
							show_message(" bin/wp.exe - This stands for word processor. ")
							show_message("  This takes 1 param, a file name. ")
							show_message("  Use the write and append commands. Do not run this")
							show_message("  in the background (it's acts strangely)")
							show_message(" sys/kernel.sys - This should be run first on start up.")
							show_message(" sys/os.sys - This should be run after the kernel.")
						if("scripts")
							src.show_message("You can make scripts in 2 ways - each using the same syntax.")
							show_message("They go in the form of:")
							show_message("command param param;command param param; (etc.)")
							show_message("There can be NO extra spaces. Semi-colons seperate commands.")
							show_message(" Spaces seperate commands and params.")
							show_message("To run a command line script just type it in.")
							show_message(" For a file script use the run command on it.")
							show_message("NOT: There is a limit to how many programs/scripts")
							show_message(" a computer can run at once.")
							show_message(" After around 5 it will shut off!")
						if("scripts-2")
							src.show_message("File scripts can have parameters.")
							show_message(" In the coding they must be in the form arg1,arg2")
							show_message(" There is a maximum of 9 possibilities.")
							show_message("Also there is a special args form.")
							show_message(" It is parsed after everything else and")
							show_message(" takes the rest of the parameters.")
							show_message("you can use the same arguement once.")
							show_message("If no arguments are supplied then")
							show_message("you will be stuck with arg in the script.")
							show_message("Other replacements:")
							show_message("  sys_level: replaces all of these with")
							show_message("the current directory level at script start")
							show_message("This is vital because you may somehow modify the registry.")
						if("logs")
							src.show_message("The operating system logs all console actions:")
							show_message(" The logs are located in root/log")
							show_message(" Every start-up a new file is created and the time")
							show_message("  is marked. Shutdown is also marked.")
							show_message("They are normal text files.")
							show_message("Caution: If a log file is deleted, it is just recreated.")
							show_message(" However it is given a new start-up time too.")
							show_message(" There should always be a console command")
							show_message("  unless something strange happened.")
							show_message("Watch out for doctored logs.")
							show_message("The log with the highest number is usually the newest log.")
							show_message("Also always make sure there is a root/log directory.")
							show_message(" Logs will not be kept if there isn't.")
						if("registry")
							src.show_message("This folder is located in root/sys")
							show_message(" In this folder you can place files that define your own commands.")
							//show_message("These commands do NOT take precedence over the core commands.")
							show_message("All files must be in the form \[name\].com")
							show_message(" They cannot be executables, only scripts.")
							show_message("They retain all their arguments.")
							show_message("Example create.com text would be make arg1;write arg1")
							show_message("then just type create \[file name\]")
						if("shell")
							src.show_message("To give external shell access just create a")
							show_message("file called shell.scr in usr. The computer")
							show_message("will automatically transfer packet data directly to")
							show_message("the comand line IF it is of id 0.")
						else
							src.show_message("Unknown entry: [params]")
			else
				if (src.parse2file("/sys/registry/[command].com"))
					parse_string("run /sys/registry/[command].com [replacetext(params, "[ascii2text(2)]", " ")]", source)
				else src.show_message("Unknown command: [command]")
		if (!( src.level ))
			src.level = src.root