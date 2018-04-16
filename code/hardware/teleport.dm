atom
	movable
		var
			tmp
				has_teleported = 0

obj
	signal
		teleport_pad
			icon = 'icons/teleport.dmi'
			icon_state = "active_0"
			name = "Teleport Pad"
			var
				destination
				identifier
				tmp
					active = 0
					charged = 0
					primed = 0
					charged_destination
				obj/signal/wire/line1
			proc
				Engage(loop=1,dest_or=null)
					var/dest = destination
					if(dest_or) dest = dest_or
					var/obj/signal/teleport_pad/T = locate("teleport_[dest]") in world
					if(T && !ismob(T.loc) && T.identifier)
						if(!T.active)
						/*	T.active = 1
							T.charged = 1
							T.primed = 1
							T.icon_state = "active_3"*/
							for(var/atom/movable/A in src.loc)
								spawn(1)
									if(istype(A,/obj/signal/structure)) continue
									if(A == src) continue
									if(istype(A,/obj/signal/infared))
										var/obj/signal/infared/I = A
										if(I.active) continue
									if(istype(A,/obj/signal/wire)) continue
									if(istype(A,/obj/infared)) continue
									if(istype(A,/obj/door)) continue
									if(istype(A,/obj/signal/box)) continue
									if(istype(A,/Conveyor)) continue
									if(istype(A,/obj/signal/sign_box)) continue
									if(A)
										if(A.has_teleported) continue
										A.loc = T.loc
										A.has_teleported = 1
										spawn(10)
											if(A)
												A.has_teleported = 0
							if(loop)
								T.Engage(0,src.identifier)
							/*for(var/atom/movable/A in T.loc)
								spawn(1)
									if(istype(A,/obj/signal/structure)) continue
									if(A == T) continue
									if(A)
										if(A.has_teleported) continue
										A.loc = src.loc
										A.has_teleported = 1
										spawn(4)
											if(A)
												A.has_teleported = 0
							T.active = 0
							T.charged = 0
							T.primed = 0
							T.icon_state = "active_0"
							if(T.line1)
								var/obj/signal/structure/S1 = new /obj/signal/structure( src )
								S1.id = "teleporter"
								S1.params = "incoming"
								T.line1.process_signal(S1,src)*/
					active = 0
					charged = 0
					primed = 0
					icon_state = "active_0"
			orient_to(obj/target, user as mob)

				if (get_dist(src,user) <= 1)
					if (src.line1)
						return 0
					else
						src.line1 = target
						return 1
				else
					user << "You must be closer to connect a wire to that!"
					return 0
			process_signal(obj/signal/structure/S,atom/source)
				..()
				if(!S) return
				
				S.loc = src.loc
				S.master = src
				if(source != line1)
					del(S)
					return
				if(S.id == "prime")
					primed = !primed
					icon_state = "active_[primed]"
					if(!primed) charged = 0
					var/obj/signal/structure/S1 = new /obj/signal/structure( src )
					S1.id = "teleporter"
					S1.params = "primed_[primed]"
					if(line1)
						line1.process_signal(S1,src)
				if(S.id == "charge")
					if(primed)
						var/obj/signal/teleport_pad/T = locate("teleport_[destination]") in world
						icon_state = "active_2"
						charged = 1
						charged_destination = destination
						if(T)
							if(!T.active)
								T.primed = 1
								T.charged = 1
								T.icon_state = "active_2"
								T.charged_destination = identifier
						var/obj/signal/structure/S1 = new /obj/signal/structure( src )
						S1.id = "teleporter"
						S1.params = "charged"

						if(line1)
							line1.process_signal(S1,src)
					else
						var/obj/signal/structure/S1 = new /obj/signal/structure( src )
						S1.id = "teleporter"
						S1.params = "charge_failed"
						if(line1)
							line1.process_signal(S1,src)
						flick("not_primed",src)
				if(S.id == "activate")
					if(primed&&charged)
						icon_state = "active_3"
						active = 1
						Engage()
						var/obj/signal/structure/S1 = new /obj/signal/structure( src )
						S1.id = "teleporter"
						S1.params = "outgoing:[destination]"
						if(line1)
							line1.process_signal(S1,src)
				if(S.id == "deactivate")
					primed = 0
					charged = 0
					active = 0
					icon_state = "active_0"
					var/obj/signal/structure/S1 = new /obj/signal/structure( src )
					S1.id = "teleporter"
					S1.params = "deactivate"
					if(line1)
						line1.process_signal(S1,src)
				if(S.id == "dest")
					if(S.params)
						destination = "[S.params]"
						var/obj/signal/structure/S1 = new /obj/signal/structure( src )
						S1.id = "teleporter"
						S1.params = "dest_change:[destination]"
						if(line1)
							line1.process_signal(S1,src)
				if(S.id == "ident")
					if(S.params)
						identifier = S.params
						tag = "teleport_[identifier]"
						var/obj/signal/structure/S1 = new /obj/signal/structure( src )
						S1.id = "teleporter"
						S1.params = "ident_change:[identifier]"
						if(line1)
							line1.process_signal(S1,src)
				del(S)
			New()
				..()
				tag = "teleport_[identifier]"
				icon_state = "active_0"
			Read()
				..()
				tag = "teleport_[identifier]"
				icon_state = "active_0"
