
// The various Read() and Write() overrides needed to prevent rollbacks and item duplication.
// Here be dragons... - Nadrew
mob
	Write(savefile/F)
		if(F.name == "saves/players/[src.ckey].sav") ..(F)
obj
	Write(savefile/F)
		save_x = x
		save_y = y
		save_z = z
		..()
	Read(savefile/F)
		..()
		if(!istype(src,/obj/items))
			if(save_x && save_y && save_z)
				spawn(1) loc = locate(save_x,save_y,save_z)
	items
		Write(savefile/F)
			if(ismob(loc)) ..()
			if(istype(src,/obj/items/paper) && isobj(loc)) ..()
		Read(savefile/F)
			..()
	signal
		structure
			Write(savefile/F)
				return
		wire
			Write(savefile/F)
				var/tmp/obj/signal/wire
					old_line1
					old_line2
				if(line1)
					old_line1 = line1
					if(line1.loc.loc != src.loc.loc)
						src.cut()
				if(line2)
					old_line2 = line2
					if(line2.loc.loc != src.loc.loc)
						src.cut()
				..()
				spawn(10)
					if(old_line1) line1 = old_line1
					if(old_line2) line2 = old_line2
			Read(savefile/F)
				..()
				spawn(1)
					if(w_color)
						switch(w_color)
							if("red") icon = 'icons/r_wire.dmi'
							if("green") icon = 'icons/g_wire.dmi'
							if("blue") icon = 'icons/b_wire.dmi'
							if("hyper") icon = 'icons/hyperwire.dmi'
							else icon = 'icons/wire.dmi'
					spawn(20)
						update()

// The area itself, handles saving and loading.
area
	save_location
		name = "Save Me"
		icon = 'icons/save_loc.dmi'
		icon_state = "red"
		layer = TURF_LAYER+1
		var
			owner
			auto_save = 1
		New()
			..()
			// So I can see the areas while mapping, but not in-game.
			icon = null
			layer = AREA_LAYER
		proc
			Save()
				fdel("saves/labs/new/[ckey(src.name)].lab")
				var/savefile/F = new("saves/labs/new/[ckey(src.name)].lab")
				F["lab"] << src

			Load(mob/caller)
				var/save_name = "saves/labs/new/[ckey(src.name)].lab"
				if(!fexists(save_name))
					caller << "no save file...skipped"
					sleep(5)
					return
				var/mob/myowner
				var/list/mobs_in_me = list()
				for(var/client/C)
					if(C.ckey == ckey(owner)) myowner = C.mob
				for(var/mob/M in src)
					mobs_in_me += M
					M.save_x = M.x
					M.save_y = M.y
					M.save_z = M.z
				if(myowner) myowner.my_labs -= src
				var/savefile/F = new("[save_name]")
				for(var/obj/O in src)
					if(!istype(O,/obj/items))
						del(O)
				var/area/save_location/loaded
				F["lab"] >> loaded
				if(!loaded)
					caller << "failed"
					return
				if(myowner) myowner.my_labs += loaded
				for(var/mob/M in mobs_in_me)
					M.loc = locate(M.save_x,M.save_y,M.save_z)
				for(var/mob/M in loaded)
					if(!M.client) del(M)
				caller << "[loaded.name] successfully loaded."
				del(src)
				sleep(10)

atom
	movable
		var
			// Since atom.x, atom.y, and atom.z aren't saved I use these.
			save_x = 0
			save_y = 0
			save_z = 0


// For saving all of the labs in a loop.
proc
	SaveLabs()
		world.log << "<b>Beginning lab saving process!</b>"
		for(var/area/save_location/S in world)
			if(S.auto_save)
				world.log << "Saving lab: [S.name] ([S.contents.len])...\..."
				S.Save()
				sleep(1)
				world.log << "saved."
		world.log << "All labs saved successfully."

	LoadLabs()
		world.log << "<b>Beginning lab loading process!</b>"
		var/list/labs = list()
		for(var/area/save_location/S in world)
			labs.Add(S)
		for(var/area/save_location/S in labs)
			if(S.auto_save)
				world << "Loading lab [S.name]...\..."
				S.Load(world)
				sleep(1)
		world.log << "All labs loaded successfully."



// Lab owner commands
mob
	var/tmp/list/my_labs = list()
	labcontrol
		proc
			ForceLabDoor()
				set name = "Force Lab Door"
				set category = "Lab Commands"
				for(var/area/save_location/L in my_labs)
					if(ckey(L.owner) == src.ckey)
						var/obj/signal/box/B = locate() in L
						if(B)
							B.open()
			// SaveMyLab()
			// 	set name = "Save My Lab"
			// 	set category = "Lab Commands"
			// 	for(var/area/save_location/L in my_labs)
			// 		if(ckey(L.owner) == src.ckey)
			// 			src << "Saving lab: [L.name]"
			// 			L.Save()
			// 			sleep(10)
			// 	src << "Saving finished."
			// LoadMyLab()
			// 	set name = "Load My Lab"
			// 	set category = "Lab Commands"
			// 	for(var/area/save_location/L in my_labs)
			// 		if(ckey(L.owner) == src.ckey)
			// 			src << "Loading lab: [L.name]"
			// 			L.Load()
			// 			sleep(10)
			// 	src << "Loading finished."
			ClearAllWires()
				set name = "Clear All Wires"
				set category = "Lab Commands"
				switch(alert("WARNING: This will delete ALL wires located inside of your lab. Continue?","Warning","Yes","No"))
					if("No") return
				for(var/area/save_location/L in my_labs)
					if(ckey(L.owner) == src.ckey)
						src << "Deleting all wires in [L.name]"
						for(var/obj/signal/wire/W in L) del(W)
			ClearUnlabeledWires()
				set name = "Clear Unlabeled Wires"
				set category = "Lab Commands"
				for(var/area/save_location/L in my_labs)
					if(ckey(L.owner) == src.ckey)
						for(var/obj/signal/wire/W in L)
							if(!W.label) del(W)
				src << "Deleted all unlabeled wires in your lab."
			ClearWiresByLabel()
				set name = "Clear Wires By Label"
				set category = "Lab Commands"
				var/label_select = input("Which label do you want to search?")as null|text
				if(!label_select) return
				var/list/found = list()
				for(var/area/save_location/L in my_labs)
					if(ckey(L.owner) == src.ckey)
						for(var/obj/signal/wire/W in L)
							if(W.label == label_select) found += W
				if(!found.len)
					src << "No wires matching that label were found."
					return
				switch(alert("[found.len] wire\s found matching that label, do you want to delete them?","Continue?","Yes","No"))
					if("No") return
				for(var/obj/signal/wire/W in found) del(W)

	Login()
		..()
		var/has_lab = 0
		for(var/area/save_location/L in world)
			if(ckey(L.owner) == src.ckey)
				my_labs += L
				has_lab = 1
				for(var/V in typesof(/mob/labcontrol/proc))
					src.verbs += V
		if(has_lab)
			winset(src,"menu.lab_control","is-disabled=false")

// Happens on world creation. Loads Lab door_codes from a json.
world/proc/LoadConfig()
	world.log << "Door Code Config Loading"
	var/json = file2text("config/door_codes.json")
	if(!json)
		var/json_file = file("config/door_codes.json")
		if(!fexists(json_file))
			world.log << "Failed to load door codes. File likely corrupt."
	else
		door_codes = json_decode(json)
		world.log << "Door Code Config Loaded"

world/proc/LoadMOTD()
	world.log << "MOTD Loading"
	motd = file2text("config/motd.txt")
	if(!motd)
		motd = ""
		var/motd_file = file("config/motd.txt")
		if(!fexists(motd_file))
			world.log << "Failed to load MOTD."
	else
		world.log << "MOTD Loaded"
	return 0