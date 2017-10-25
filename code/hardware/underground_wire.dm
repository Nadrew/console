mob
	var
		tmp
			obj/items/concealed_wire/con_using
			obj/signal/concealed_wire/p_wire
			viewing_under = 0
client
	Move()
		..()
		if(mob.viewing_under)
			images = list()
			mob.viewing_under = 0

obj
	items
		concealed_wire
			icon = 'icons/concealed_wiring.dmi'
			name = "underground wiring spool"
			var
				amount = 10
			unequip()
				..()
				if(usr.con_using)
					usr << "You have aborted the underground wiring process."
					del(usr.p_wire)
					usr.con_using = null
					usr.p_wire = null
					usr.client.images = list()
			moved(mob/user,turf/oldloc)
				if(user.con_using)
					var/turf/T = user.loc
					if(user.p_wire)
						if(user.p_wire.connected_wires.len > 50)
							user << "You stop placing underground wire and place a secondary terminal."
							var/obj/signal/concealed_wire/child = new(user.loc)
							child.connected_terminal = user.p_wire
							user.p_wire.connected_terminal = child
							child.working = 1
							child.connected_wires = user.p_wire.connected_wires.Copy(1,0)
							child.connected_wires -= child.loc
							child.connected_wires += user.p_wire.loc
							user.con_using = null
							user.p_wire = null
							user.client.images = list()
							return
						if(!(T in user.p_wire.connected_wires))
							user.p_wire.connected_wires += T
							user << image('icons/concealed_wiring.dmi',T,icon_state="hl",layer=99)
				..()
			attack_by(obj/D,mob/user)
				if(user.con_using)
					user << "You stop placing underground wire and place a secondary terminal."
					var/obj/signal/concealed_wire/child = new(user.loc)
					child.connected_terminal = user.p_wire
					user.p_wire.working = 1
					child.working = 1
					user.p_wire.connected_terminal = child
					child.connected_wires = user.p_wire.connected_wires.Copy(1,0)
					child.connected_wires -= child.loc
					child.connected_wires += user.p_wire.loc
					user.con_using = null
					user.p_wire = null
					user.client.images = list()
					return

				if(user.equipped == src)
					user << "You place a wiring terminal, now walk to your destination and then double-click this spool again."
					user.con_using = src
					var/obj/signal/concealed_wire/parent = new(user.loc)
					user.p_wire = parent


	signal
		concealed_wire
			name = "underground wiring terminal"
			icon = 'icons/concealed_wiring.dmi'
			verb
				view_wires()
					set src in oview(usr,1)
					usr.viewing_under = 1
					usr << "Viewing the wiring setup for [src]"
					usr.client.images = list()
					for(var/turf/T in connected_wires)
						usr << image('icons/concealed_wiring.dmi',T,icon_state="hl",layer=99)
				label(T as text)
					set src in oview(usr,1)
					if(!T) return
					name = "underground wiring terminal - '[T]'"
			var
				tmp
					working = 0
					obj/signal/line1
					list
						connected_wires = list()
					obj/signal/concealed_wire/connected_terminal
			orient_to(obj/target,mob/user)
				if(ismob(src.loc))
					user << "Device must be on the ground to connect to it."
					return 0
				if(!line1)
					user << "Connected to underground wire terminal"
					line1 = target
					return 1
				return 0

			process_signal(obj/signal/structure/S,obj/source)
				..()
				S.loc = src.loc
				S.master = src
				if(line1)
					if(line1 != source)
						var/obj/signal/structure/resend = new()
						S.copy_to(resend)
						line1.process_signal(resend,src)

					else
						if(connected_terminal)
							if(istype(connected_terminal,/obj/signal/wire/hyper))
								var/obj/signal/structure/S1 = new()
								S.copy_to(S1)
								S.invisibility = 101
								connected_terminal.process_signal(S1,connected_terminal)
							else
								for(var/turf/T in connected_wires)
									var/obj/signal/structure/S1 = new()
									S.copy_to(S1)
									S.invisibility = 101
									if((locate(connected_terminal) in T))
										S1.loc = connected_terminal.loc
										S1.master = connected_terminal
										if(connected_terminal.line1)
											var/obj/signal/structure/S3 = new()
											S1.copy_to(S3)
											connected_terminal.process_signal(S3,connected_terminal)
										del(S1)
										break

									del(S1)
									sleep(1)
				del(S)
			cut()
				if(!working) return
				if(line1)
					line1.disconnectfrom(src)
				line1 = null
				if(connected_terminal)
					src.connected_terminal.connected_terminal = null
					src.connected_terminal.cut()
					src.connected_terminal = null
				del(src)