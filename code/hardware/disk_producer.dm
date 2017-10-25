obj
	signal
		disk_producer
			name = "Disk Mass Production"
			icon = 'icons/computer.dmi'
			icon_state = "massdisk"
			density = 1
			var
				obj/items/disk/cur_disk
				tmp/busy = 0
			attack_hand(mob/user)
				if(busy)
					user << "Please wait to use this machine."
					return
				if(!user.equipped)
					if(cur_disk)
						winshow(user,"disk_producer",1)
						winset(user,"disk_producer.dlabel","text=\"[cur_disk.label]\"")
						winset(user,"disk_producer.amount","text=\"5\"")
					else
						user << "There is nothing in the slot."
				else
					..()
			attack_by(obj/O,mob/user)
				if(busy)
					user << "Please wait to use this machine."
					return
				if(cur_disk)
					user << "There's already a disk in the slot, you must eject it first."
					return
				if(istype(O,/obj/items/disk))
					var/obj/items/disk/D = O
					D.unequip()
					D.Move(src)
					user << "Disk producer ready, double-click again to use."
					cur_disk = D
				else
					user << "It...doesn't seem to fit. Didn't you play with shaped blocks as a child?"
			verb
				eject()
					set category = null
					set src in oview(usr,1)
					if(src.cur_disk)
						if(busy)
							usr << "Error: The machine is busy."
							return
						src.cur_disk.loc = src.loc
						src.cur_disk = null
						winshow(usr,"disk_producer",0)
				produce()
					set hidden = 1
					set src in oview(usr,1)
					if(busy)
						winset(usr,"disk_producer.warning_label","text=\"Error: Busy\"")
						spawn(10)
							winset(usr,"disk_producer.warning_label","text=\"\"")
						return
					var
						d_label = winget(usr,"disk_producer.dlabel","text")
						d_amount = text2num(winget(usr,"disk_producer.amount","text"))
					if(!d_amount)
						winset(usr,"disk_producer.warning_label","text=\"Invalid amount\"")
						spawn(10)
							winset(usr,"disk_producer.warning_label","text=\"\"")
						return
					busy = 1
					icon_state = "massdisk_working"
					if(d_amount > 15) d_amount = 15
					winshow(usr,"disk_producer",0)
					usr << "Producing [d_amount] disk\s labeled: [d_label], please wait..."
					var/obj/items/box/B
					var/ct = d_amount
					while(ct)
						sleep(10)
						if(d_amount >= 10)
							B = new()
						var/obj/items/disk/D = new(src)
						var/datum/file/dir/cur = new()
						src.cur_disk.root.copy_to(cur)
						D.root = cur
						if(d_label)
							D.name = "disk - '[d_label]'"
						if(d_amount >= 10)
							D.loc = B
						else
							D.loc = src.loc
						ct--
					if(B)
						if(d_label)
							B.name = "box - '[d_label]'"
						B.loc = src.loc
					icon_state = "massdisk"
					usr << "Disk production done."
					busy = 0




