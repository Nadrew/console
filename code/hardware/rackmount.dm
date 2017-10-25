obj
	signal
		rackmount
			icon = 'icons/rackmount.dmi'
			icon_state = "0"
			name = "Rackmount"
			density = 1
			var
				max_mounts = 4
				list
					mounts = list()
					connected = list()

			orient_to(obj/signal/wire/target,mob/user)
				if(ismob(src.loc))
					user << "Device must be on the ground to connect to it."
					return 0
				if(!mounts.len)
					user << "There are no systems mounted to this rack."
					return 0
				var/obj/signal/computer/select = input(user,"Which system do you want to connect to?")as null|anything in mounts
				if(!select) return 0
				if(!select.line1)
					connected += target
					connected[target] = select
					select.line1 = target
					user << "Connected to I/O port of [select.name]"
					return 1
				else if(!select.line2)
					connected += target
					connected[target] = select
					select.line2 = target
					user << "Connected to peripheral port of [select.name]"
					return 1
				else return 0
			process_signal(obj/signal/structure/S,obj/source)
				..()
				if(!S) return
				var/obj/signal/computer/signal_system = connected[source]
				if(signal_system)
					if(signal_system.line1 == source||signal_system.line2 == source)
						var/obj/signal/structure/S2 = new()
						S.copy_to(S2)
						signal_system.process_signal(S2,source)
					del(S)
			verb
				unmount_system()
					set src in view(1)
					set category = "computers"
					if(!mounts.len)
						usr << "There are no systems mounted to this rack."
						return
					var/obj/signal/computer/select = input(usr,"Which system do you want to unmount?")as null|anything in mounts
					if(!select) return
					mounts -= select
					select.status = "no_m"
					for(var/obj/signal/S in connected)
						if(connected[S] == select)
							S.cut()
							connected -= S
					var/obj/items/computer/nc = new(src.loc)
					nc.com = select
					select.loc = nc
					if(select.label)
						nc.name = "computer- '[select.label]'"
					icon_state = "[mounts.len]"
					var/s = 1
					for(var/obj/signal/computer/S in mounts)
						if(findtext(S.name,"computer- 'mount"))
							S.label = "mount [s]"
							S.name = "computer- 'mount [s]'"
							s++

				boot()
					set src in view(1)
					set category = "computers"
					if(!mounts.len)
						usr << "There are no systems mounted to this rack."
						return
					var/obj/signal/computer/select = input(usr,"Which system do you want to boot?")as null|anything in mounts
					if(!select) return
					select.boot()
				operate()
					set src in view(1)
					set category = "computers"
					if(!mounts||!mounts.len)
						usr << "There are no systems mounted to this rack."
						return
					var/obj/signal/computer/select = input(usr,"Which system do you want to operate?")as null|anything in mounts
					if(!select) return
					select.temp_user = usr
					select.operate()
				eject()
					set src in view(1)
					set category = "computers"
					if(!mounts.len)
						usr << "There are no systems mounted to this rack."
						return
					var/obj/signal/computer/select = input(usr,"Which system do you want to eject a disk from?")as null|anything in mounts
					if(!select) return
					select.eject()
				power_off()
					set src in view(1)
					set category = "computers"
					if(!mounts.len)
						usr << "There are no systems mounted to this rack."
						return
					var/obj/signal/computer/select = input(usr,"Which system do you want to power off?")as null|anything in mounts
					if(!select) return
					select.power_off()
				label(T as text)
					set src in view(1)
					set category = "computers"
					if(!T) name = "Rackmount"
					else name = "Rackmount- '[T]'"
			disconnectfrom(obj/source)
				if(source in connected)
					connected -= source
					for(var/obj/signal/computer/C in mounts)
						if(C.line1 == source||C.line2 == source)
							C.disconnectfrom(source)
			cut()
				for(var/obj/signal/C in mounts)
					C.cut()
				connected = list()
			New()
				..()
				if(ismob(src.loc))
					connected = list()
			attack_by(obj/items/selected,mob/user)
				if(istype(selected,/obj/items/computer))
					var/obj/items/computer/valid_system = selected
					if(mounts.len >= max_mounts)
						user << "This rackmount is full."
					else
						user << "Successfully mounted the system to the rackmount."
						if(ckey(valid_system.com.name) == "computer")
							valid_system.com.label = "mount [mounts.len+1]"
							valid_system.com.name = "computer- '[valid_system.com.label]'"
						mounts += valid_system.com
						valid_system.com.status = "off"
						valid_system.com.loc = src
						icon_state = "[mounts.len]"
						del(valid_system)
						var/s = 1
						for(var/obj/signal/computer/S in mounts)
							if(findtext(S.name,"computer- 'mount"))
								S.label = "mount [s]"
								S.name = "computer- 'mount [s]'"
								s++

				else
					if(istype(selected,/obj/items/disk))
						if(!mounts.len)
							user << "There are no systems mounted to this rack."
							return
						var/obj/signal/computer/sel = input("Which computer do you want to insert the disk into?")as null|anything in mounts
						if(!sel) return
						sel.insert_disk(selected)
					else if(istype(selected,/obj/items/wire))
						..()
					else if(istype(selected,/obj/items/wrench))
						..()
					else
						user << "You can only mount computers to this device."
