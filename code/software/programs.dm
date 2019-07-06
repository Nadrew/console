// TODO: Organize this better, it's still heavily Exadv-type code, still better than SS13...

datum/task/wp/parse(params in view(usr.client))

	var/t1 = splittext(params, "[ascii2text(2)]")
	var/t2
	for(var/t2x in t1)
		t2 = t2x
	if (!( t2 ))
		src.master.show_message("You must specifiy the filename as a parameter.!")
		del(src)
	var/datum/file/normal/t3 = src.master.parse2file(t2)
	if (!( istype(t3, /datum/file/normal) ))
		src.master.show_message("Invalid file type!")
		del(src)
	if (t3.flags & 2)
		src.master.show_message("ERROR: Unable to write to file!")
		del(src)
	else
		src.master.show_message("You may now type the modification into the console. Type in JUST \[stop\] to stop! Type \[show\] to show the file or \[clear\] to clear the file.")
		src.typing = t3
		while((src.typing && src.master.sys_stat > 0))
			sleep(10)
		src.master.show_message("Now dumping to console. Thank you for using this program!")
		del(src)

datum/task/wp/process(string in view(usr.client))

	if(src.typing)
		if (string == "\[stop\]")
			src.typing = null

		else
			if(string == "\[clear\]")
				src.typing.text = null
				src.master.show_message("All text cleared!")
			else
				if(string == "\[show\]")
					src.master.show_message("[src.typing.text]")
				else
					if(istype(src.typing, /datum/file/normal))
						src.typing.text += "[string]"
						src.master.show_message("writing-> [string]")
					else
						src.typing = null
						del(src)

datum/task/proc/get_data(string in view(usr.client))
	if (string == "null")
		return null
	if ((src.master && string == "err_level"))
		return src.master.err_level
	if((src.master && string == "out_level"))
		return src.master.out_level
	if (copytext(string, 1, 2) == "\"")
		return copytext(string, 2, length(string) + 1)
	else
		var/temp = findtext(string, ":", 1, null)
		if (!( temp ))
			var/thing = src.var_list["[string]"]
			return thing
		else
			if (istype(src.var_list["[copytext(string, 1, temp)]"], /list))
				var/L = src.var_list["[copytext(string, 1, temp)]"]
				return L["[src.get_data(copytext(string, temp + 1, length(string) + 1))]"]

datum/task/proc/set_data(var/varname, var/value)
	var/temp = findtext(varname, ":", 1, null)
	if (!( temp ))
		if (istype(src.var_list["[varname]"], /list))
			del(src.var_list["[varname]"])
		src.var_list["[varname]"] = value
	else
		if (istype(src.var_list["[copytext(varname, 1, temp)]"], /list))
			var/L = src.var_list["[copytext(varname, 1, temp)]"]
			L["[get_data(copytext(varname, temp + 1, length(varname) + 1))]"] = value
			src.var_list["[copytext(varname, 1, temp)]"] = L

datum/task/proc/process(string in view(usr.client))

	var/L = src.var_list["input"]
	if (!( istype(L, /list) ))
		L = list(  )
	var/count = 1
	while(L["[count]"] != null)
		count++
	if ((count == 1 && L["1"] == null))
		count = 1
	else
		count++
	L["[count]"] = string
	src.var_list["input"] = L




datum/file/proc/set_master(C as obj in view(usr.client))

	src.master = C

datum/file/proc/buildparent()

	if (!( src.parent ))
		return null
	else
		var/temp = src.parent.buildparent()
		return "[(temp ? "[temp]/" : "")][src.parent]"

datum/file/proc/merge()


datum/file/proc/add()


datum/file/proc/compare()

datum/file/proc/show_search()



datum/file/normal/proc/process()


datum/file/normal/proc/execute(params in view(usr.client), flag in view(usr.client))

	var/list/L = splittext(params, "[ascii2text(2)]")
	var/n_text = src.text
	var/counter = 1
	n_text = replacetext(n_text, "sys_level", src.master.get_path(src.master.level))
	n_text = replacetext(n_text, "sys_timer", world.time)
	n_text = replacetext(n_text, "sys_timestamp", "[time2text(world.realtime, "MM/DD/YYYY hh:mm:ss")]")
	var/r_text
	while((findtext(n_text, "arg[counter]", 1, null) && L.len >= counter))
		n_text = replacetext(n_text, "arg[counter]", L[counter])
		counter++
	if ((findtext(n_text, "args", 1, null) && L.len >= counter))
		while(counter <= L.len)
			if (counter != L.len)
				r_text += "[L[counter]] "
			else
				r_text += "[L[counter]]"
			counter++
		n_text = replacetext(n_text, "args", r_text)
	if (n_text)
		var/datum/task/T = new /datum/task(  )
		T.source = src.name
		T.code = n_text
		T.p_type = 1
		if (flag)
			T.state = 3
		else
			T.state = 1
			src.master.cur_prog = T
		T.master = src.master
		T.parse()
		del(T)

datum/file/normal/show_search()

	src.master.show_message("File: [src.name]")

datum/file/normal/compare(datum/file/normal/F in view(usr.client))

	if (!( istype(F, /datum/file/normal) ))
		return 0
	if (F.text == src.text)
		return 1


datum/file/normal/merge(datum/file/normal/F in view(usr.client))

	if ((istype(F, /datum/file/normal) && (!( F.flags & 1 ) && !( src.flags & 2 ))))
		src.text += F.text


datum/file/normal/add(data)

	if (istype(data, /list))
	else
		if (istype(data, /datum))
			src.merge(data)
		else
			if (!( src.flags & 2 ))
				data = replacetext(data,"\\n","\n")
				src.text += data


datum/file/normal/sound/compare(datum/file/normal/sound/F in view(usr.client))

	if (!( istype(F, /datum/file/normal/sound) ))
		return 0
	if ((F.text == src.text && (F.s_type == src.s_type && F.s_source == src.s_source)))
		return 1
	else
		return 0


datum/file/normal/sound/copy_to(datum/file/normal/sound/S in view(usr.client))

	S.name = src.name
	S.s_type = src.s_type
	S.s_source = src.s_source
	S.text = src.text
	S.flags = src.flags

datum/file/normal/sound/merge(datum/file/normal/sound/F in view(usr.client))

	if (istype(F, /datum/file/normal/sound))
		if ((F.s_type == src.s_type && F.s_source == src.s_source))
			src.text += F.text

datum/file/normal/executable/search/execute(datum/file/t3)

	var/datum/file/dir/t4 = src.master.parse2file(t3)
	if (!( istype(t4, /datum/file/dir) ))
		src.master.show_message("ERROR: Invalid directory: [t3]")
		return
	src.master.show_message("Searching... [src.master.get_path(t4)]")
	for(var/datum/file/F in t4.files)
		src.master.show_message("Found: [F.name] in [src.master.get_path(t4)][F.flags&4?" (HIDDEN)":""]")


datum/file/normal/executable/compare(datum/file/normal/executable/F in view(usr.client))

	if (!( istype(F, /datum/file/normal/executable) ))
		return 0
	if ((F.text == src.text && F.function == src.function))
		return 1
	else
		return 0

datum/file/normal/executable/script/execute(params in view(usr.client), flag in view(usr.client))

	var/list/L = splittext(params, "[ascii2text(2)]")
	var/n_text = src.text
	var/counter = 1
	n_text = replacetext(n_text, "sys_level", src.master.get_path(src.master.level))
	n_text = replacetext(n_text, "sys_timer", world.time)
	n_text = replacetext(n_text, "sys_timestamp", "[time2text(world.realtime, "MM/DD/YYYY hh:mm:ss")]")
	while((findtext(n_text, "arg[counter]", 1, null) && L.len >= counter))
		n_text = replacetext(n_text, "arg[counter]", L[counter])
		counter++
	if ((findtext(n_text, "args", 1, null) && L.len >= counter))
		var/r_text
		while(counter <= L.len)
			if (counter != L.len)
				r_text += "[L[counter]] "
			else
				r_text += "[L[counter]]"
			counter++
		n_text = replacetext(n_text, "args", r_text)
	if (n_text)
		var/datum/task/T = new /datum/task(  )
		T.source = src.name
		T.code = n_text
		T.p_type = 1
		if (flag)
			T.state = 3
		else
			T.state = 1
			src.master.cur_prog = T
		T.master = src.master
		T.parse()
		del(T)

datum/file/normal/executable/copy_to(datum/file/normal/executable/E in view(usr.client))

	E.name = src.name
	E.function = src.function
	E.text = src.text
	E.flags = src.flags


datum/file/normal/executable/trunicate/execute(params in view(usr.client))

	var/list/t1 = splittext(params, "[ascii2text(2)]")
	if (t1.len < 2)
		src.master.show_message("You need 2 parameters.!")
		return
	var/datum/file/normal/sound/t3 = src.master.parse2file(t1[1])
	if (!( istype(t3, /datum/file/normal/sound) ))
		src.master.show_message("Invalid file type! It must be a sound file!")
		return
	else
		var/numeral = text2num(t1[2])
		if ((numeral + 1) >= length(t3.text))
			return
		t3.text = copytext(t3.text, 1, numeral + 1)

datum/file/normal/executable/resequencer/execute(params in view(usr.client))

	var/list/t1 = splittext(params, "[ascii2text(2)]")
	if (t1.len < 2)
		src.master.show_message("You need 2 parameters.!")
		return
	var/datum/file/normal/sound/t3 = src.master.parse2file(t1[1])
	if ((!( istype(t3, /datum/file/normal/sound) ) || t3.s_type != 2))
		src.master.show_message("Invalid file type! It must be a voice file!")
		return
	else
		var/list/strings = splittext(t3.text, " ")
		if (strings.len <= 1)
			src.master.show_message("Either there are no words to resequence or only one word! (This can only resequence distinctly seperated phrases (with spaces).")
		var/datum/file/dir/D = src.master.parse2file(t1[2])
		if (!( istype(D, /datum/file/dir) ))
			src.master.show_message("Arguement 2 must be a valid directory!")
			return
		for(var/t in strings)
			var/datum/file/normal/sound/S = new /datum/file/normal/sound(  )
			S.text = t
			t = replacetext(t, ";", "*")
			t = replacetext(t, "/", "*")
			t = replacetext(t, ":", "*")
			t = replacetext(t, "\\", "*")
			var/F = src.master.get_file2("[t].vcl", D)
			if (F)
				del(F)
			S.name = "[t].vcl"
			S.parent = D
			S.s_type = t3.s_type
			S.s_source = t3.s_source
			if (D.disk_master)
				S.disk_master = D.disk_master
			S.master = src.master
			D.files += S

		var/F = src.master.get_file2("(space).vcl", D)
		if (F)
			del(F)
		var/datum/file/normal/sound/S = new /datum/file/normal/sound(  )
		S.text = " "
		S.name = "(space).vcl"
		S.parent = D
		S.s_type = t3.s_type
		S.s_source = t3.s_source
		if (D.disk_master)
			S.disk_master = D.disk_master
		S.master = src.master
		D.files += S


datum/file/normal/executable/scr_compile/execute(params in view(usr.client))

	var/t1 = splittext(params, "[ascii2text(2)]")
	var/t2
	for(var/t2x in t1)
		t2 = t2x
	if (!( t2 ))
		src.master.show_message("You must specify the filename as a parameter!")
		return
	var/datum/file/normal/t3 = src.master.parse2file(t2)
	if (!( istype(t3, /datum/file/normal) ))
		src.master.show_message("Invalid file type!")
		return
	if (t3.flags & 2)
		src.master.show_message("ERROR: Unable to write to file!")
		return
	else
		var/datum/file/normal/executable/script/t4 = new /datum/file/normal/executable/script(  )
		t4.text = t3.text
		t4.name = t3.name
		t4.parent = t3.parent
		t4.master = t3.master
		t4.disk_master = t3.disk_master
		t3.parent.files += t4
		del(t3)
		src.master.show_message("Script [t4.name] compiled!")


datum/file/normal/executable/compiler/execute(params)
	var/list/params_list = splittext(params, "[ascii2text(2)]")
	var/file_name
	if(params_list.len > 0 && params_list[1]) file_name = params_list[1]
	var/override_flags
	if(params_list.len >= 3 && params_list[3]) override_flags = params_list[3]
	if (!(file_name))
		src.master.show_message("You must specify the filename as a parameter!")
		return
	var/datum/file/normal/file_object = src.master.parse2file(file_name)
	if (!(istype(file_object, /datum/file/normal)))
		src.master.show_message("Invalid file type!")
		return

	if (file_object.flags & 2)
		src.master.show_message("ERROR: Unable to write to file!")
		return

	else
		var/datum/file/normal/executable/compiled_file = new /datum/file/normal/executable()
		compiled_file.text = file_object.text
		compiled_file.name = file_object.name
		compiled_file.parent = file_object.parent
		compiled_file.master = file_object.master
		compiled_file.disk_master = file_object.disk_master
		file_object.parent.files += compiled_file
		if(override_flags)
			src.master.show_message("<font color=red>OVERRIDE:</font> Compiler flag altered to [override_flags]",show_color=1)
			compiled_file.special_flags = text2num(override_flags)
		del(file_object)
		src.master.show_message("Executable [compiled_file.name] compiled!")


datum/file/normal/executable/dialer/execute(params in view(usr.client))

	var/list/t1 = splittext(params, "[ascii2text(2)]")
	if (t1.len < 2)
		src.master.show_message("Need 2 parameters!")
		return
	var/datum/file/normal/sound/t2 = src.master.parse2file(t1[1])
	var/t6 = t1[1]
	var/t5 = t1[2]
	var/x = null
	x = 1
	while(x <= length(t5))
		var/te = copytext(t5, x, x + 1)
		if ((!( "[text2num(te)]" == "[te]" ) && (te != "#" && te != "*")))
			src.master.show_message("ERROR: Invalid character [x]! Must be a digit or # or * !")
			return
		x++
	if (t2)
		src.master.show_message("ERROR: Name already taken: [jointext(t1, "[ascii2text(2)]")]")
		return
	else
		var/datum/file/dir/D = src.master.level
		if (findtext(t1[1], "/", 1, null))
			var/list/L = splittext(t1[1], "/")
			t6 = L[L.len]
			L[L.len] = null
			var/temp = jointext(L, "/")
			D = src.master.parse2file(temp)
			if (!( D ))
				src.master.show_message("ERROR: Invalid directory!")
				return
		if ((t6 == "root" || (findtext(t6, "/", 1, null) || findtext(t6, ":", 1, null))))
			src.master.show_message("ERROR: you are using a reserved name or character. (root,/,:)")
			return
		t2 = new /datum/file/normal/sound(  )
		t2.name = t6
		t2.parent = D
		t2.s_type = 1
		t2.s_source = "phone"
		t2.text = t5
		if (D.disk_master)
			t2.disk_master = D.disk_master
		t2.master = src.master
		D.files += t2
		src.master.show_message("Sound file ([((D && D != src.master.level) ? src.master.get_path(D) : "")][t6]) created:", 1)

datum/file/normal/executable/playback/execute(params)

	var/list/t1 = splittext(params, "[ascii2text(2)]")
	var/t2
	for(var/t2x in t1)
		t2 += t2x
	if (!( t2 ))
		src.master.show_message("You must specifiy the filename as a parameter.!")
		return
	var/datum/file/normal/sound/t3 = src.master.parse2file(t2)
	if (!( istype(t3, /datum/file/normal/sound) ))
		src.master.show_message("Invalid file type!")
		return
	else
		if (t3.s_type == 1)
			src.master.show_message("(tone): '[t3.text]'", 0, src, t3.s_type, t3.text)
		else
			if (t3.s_type == 2)
				src.master.show_message("\icon[locate(/mob)]<B>[t3.s_source]</B>: '[t3.text]'", 0, t3.s_source, t3.s_type, t3.text)

datum/file/normal/executable/word_process/execute(params in view(usr.client), flag in view(usr.client))

	var/datum/task/wp/T = new /datum/task/wp(  )
	src.master.tasks += T
	T.source = src.name
	if (flag)
		T.state = 3
	else
		T.state = 1
	T.master = src.master
	T.parse(params)
	del(T)

datum/file/normal/executable/execute(params in view(usr.client), flag in view(usr.client))

	switch(src.function)
		if(1.0)
			if (src.master.sys_stat == 0)
				src.master.sys_stat = 1
				src.master.show_message("System Kernel Loaded and Operating!")
			else
				src.master.show_message("ERROR: Kernel already loaded")
		if(2.0)
			if (src.master.sys_stat == 0)
				src.master.show_message("ERROR: A kernel is needed to load the OS.")
			else
				if (src.master.sys_stat == 1)
					src.master.sys_stat = 2
					src.master.show_message("Operating System Loaded and Operating!")
					src.master.parse_string("root;cd log;root;cd sys")
					if (src.master.level.name == "log")
						src.master.cur_log = new /datum/file/normal(  )
						src.master.cur_log.name = "[world.time].log"
						src.master.cur_log.parent = src.master.level
						src.master.cur_log.master = src.master
						src.master.cur_log.text = "Startup Record Time [time2text(world.realtime, "MM/DD/YYYY hh:mm:ss")];"
						src.master.level.files += src.master.cur_log
				else
					src.master.show_message("ERROR: Operating system already loaded")
		else
			var/list/L = splittext(params, "[ascii2text(2)]")
			var/list/I = list(  )
			var/x = null
			x = 1
			while(x <= L.len)
				I["[x]"] = "[L[x]]"
				x++
			var/datum/task/T = new /datum/task(  )
			src.master.tasks += T
			T.var_list["arg"] = I
			T.source = src.name
			T.code = src.text
			if (flag)
				T.state = 3
			else
				T.state = 1
				src.master.cur_prog = T
			T.master = src.master
			T.special_flags = src.special_flags
			T.parse()
			del(T)
	sleep(10)

datum/file/normal/copy_to(datum/file/normal/N in view(usr.client))

	N.name = src.name
	N.text = src.text
	N.flags = src.flags

datum/file/normal/Del()

	if (src.master)
		if(!src.is_override)
			src.master.show_message("Deleting: [src]")
	..()

datum/file/dir/show_search()

	src.master.show_message("Dir: [src.name]")
	var/counter = 0
	for(var/datum/file/F in src.files)
		if (F.flags & 4)
			counter++
		else
			show_search()

	if (counter)
		src.master.show_message("[counter] hidden file\s detected!")

datum/file/dir/copy_to(datum/file/dir/D in view(usr.client))

	D.name = src.name
	D.flags = src.flags
	for(var/datum/file/F in src.files)
		var/datum/file/normal/t1 = new F.type(  )
		t1.parent = D
		t1.disk_master = D.disk_master
		F.copy_to(t1)
		D.files += t1


datum/file/dir/set_master(C as obj in view(usr.client))

	..()
	src.master = C
	for(var/datum/file/F in src.files)
		F.set_master(C)


datum/file/dir/Del()

	if (src.master)
		src.master.show_message("Deleting directory: [src.name]")
	for(var/datum/file/x in src.files)
		del(x)

	..()
