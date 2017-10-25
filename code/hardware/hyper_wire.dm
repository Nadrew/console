obj
	signal
		wire
			hyper
				orient_to(S as obj in view(usr.client), user as mob in view(usr.client))
					if(ismob(src.loc))
						user << "Device must be on the ground to connect to it."
						return 0
					if ((!( istype(S, /obj/signal/wire/hyper) ) && (!( istype(S, /obj/signal/converter) ) && !( istype(S, /obj/signal/hub) ) && !( istype(S, /obj/signal/concealed_wire) ))))
						user << "There is not a usable connecter on this part!"
						return 0
					else
						return ..()


				process_signal(obj/signal/S as obj in view(usr.client), obj/source as obj in view(usr.client))
					..()
					if(!S) return
					S.loc = src.loc
					S.master = src
					if (source == src.line1)
						spawn( 0 )
							if (!( src.line2 ))
								del(S)
							else
								src.line2.process_signal(S, src)
							return
					else
						spawn( 0 )
							if (!( src.line1 ))
								del(S)
							else
								src.line1.process_signal(S, src)
							return

				cut(force=0)

					if (src.line1)
						src.line1.disconnectfrom(src)
					if (src.line2)
						src.line2.disconnectfrom(src)
					src.line1 = null
					src.line2 = null
					var/obj/items/wire/hyper/W = new /obj/items/wire/hyper( src.loc )
					if (src.pos_status & 1)
						W.layer = 21
						W.invisibility = 98
						W.pos_status = 1
					if(force)
						spawn(1) del(src)
					else del(src)
	items
		wire
			hyper
				moved(mob/user, turf/old_loc)

					if ((src.laying && (src.old_lay && get_dist(src.old_lay, user) > 1)))
						src.laying = 0
					if ((src.laying && src.amount >= 1))
						var/obj/signal/wire/hyper/W = new /obj/signal/wire/hyper( user.loc )
						if (user.pos_status & 1)
							W.invisibility = 98
							W.pos_status = 1
							W.layer = 21
						if(label)
							W.name = "hyper '[label]'"
							W.label = label
						var/t1 = src.old_lay.orient_to(W, user)
						var/t2 = W.orient_to(src.old_lay, user)
						if ((t1 && t2))
							src.old_lay = W
							src.amount--
							if (src.amount <= 0)
								src.laying = 0
								del(src)
								return
							src.update()
						else
							del(W)
							user << "<B>You were unable to connect the wire to the target!</B>"
							src.laying = 0