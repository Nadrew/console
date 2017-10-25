obj/signal/hub
	router
		name = "router"
		icon_state = "router"
		var/mode = "normal"
		var/m_data = null
		var/flags = 1.0
		process_signal(obj/signal/structure/S as obj in view(usr.client), obj/source as obj in view(usr.client))
			..()
			if(!S) return
			S.loc = src.loc
			var/number = 0
			var/list/L = list()
			if (source != src.line_control)
				if ((S.id == "-2" && (source != src.line_temp || src.mode == "normal")))
					L = splittext(S.source_id, ".")
					while(L.len < src.position)
						L += "0"
					if (source == src.line1)
						number = 0
					else
						if (source == src.line2)
							number = 20
						else
							if (source == src.line3)
								number = 40
							else
								if (source == src.line4)
									number = 60
								else
									number = 80
					L[src.position] = "[number]"
					S.source_id = jointext(L, ".")
					del(L)
				L = splittext(S.dest_id, ".")
				var/t_num = "0"
				if (L.len >= src.position)
					t_num = "[L[src.position]]"
				if (src.line_control)
					spawn( 0 )
						var/obj/signal/structure/S1 = new /obj/signal/structure(  )
						S1.dest_id = src.d_id
						S1.source_id = src.s_id
						S1.id = 1
						S1.params = "Received signal: [S.id] ([S.params]) from [S.source_id] to [S.dest_id]. Parsed: [t_num]"
						spawn( 0 )
							src.line_control.process_signal(S1, src)
							return
						return
				t_num = text2num(t_num)
				spawn( 0 )
					var/nflags = text2num(src.flags)
					if ((src.mode == "normal" || ((nflags & 2 && src.position >= L.len) || ((src.mode == "5>1" && !( src.line_temp )) || (src.mode == "5>1" && source == src.line_temp)))))
						var/n1 = src.multi + src.offset
						var/n2 = (src.multi * 2) + src.offset
						var/n3 = (src.multi * 3) + src.offset
						var/n4 = (src.multi * 4) + src.offset
						var/n5 = (src.multi * 5) + src.offset
						if ((t_num >= n1 && t_num < n2))
							if (src.line2)
								var/obj/signal/structure/S1 = new /obj/signal/structure(  )
								S.copy_to(S1)
								S1.strength--
								if (S1.strength <= 0)
									del(S1)
									return
								src.line2.process_signal(S1, src)
						else
							if ((t_num >= n2 && t_num < n3))
								if (src.line3)
									var/obj/signal/structure/S1 = new /obj/signal/structure(  )
									S.copy_to(S1)
									S1.strength--
									if (S1.strength <= 0)
										del(S1)
										return
									src.line3.process_signal(S1, src)
							else
								if ((t_num >= n3 && t_num < n4))
									if (src.line4)
										var/obj/signal/structure/S1 = new /obj/signal/structure(  )
										S.copy_to(S1)
										S1.strength--
										if (S1.strength <= 0)
											del(S1)
											return
										src.line4.process_signal(S1, src)
								else
									if ((t_num >= n4 && t_num < n5))
										if (src.line5)
											var/obj/signal/structure/S1 = new /obj/signal/structure(  )
											S.copy_to(S1)
											S1.strength--
											if (S1.strength <= 0)
												del(S1)
												return
											src.line5.process_signal(S1, src)
									else
										if ((t_num == n5 && nflags & 1))
											var/list/t1 = list( "line1", "line2", "line3", "line4", "line5" )
											for(var/x in t1)
												if (src.vars[x] == source)
													t1 -= x
												else

											for(var/x in t1)
												var/obj/signal/structure/S1 = new /obj/signal/structure(  )
												S.copy_to(S1)
												S1.strength--
												if (S1.strength <= 0)
													del(S1)
													return
												var/obj/signal/S2 = src.vars[x]
												spawn( 0 )
													if (S2)
														S2.process_signal(S1, src)
													return

										else
											if (src.line1)
												var/obj/signal/structure/S1 = new /obj/signal/structure(  )
												S.copy_to(S1)
												S1.strength--
												if (S1.strength <= 0)
													del(S1)
													return
												src.line1.process_signal(S1, src)
					else
						if ((src.line_temp && src.mode == "5>1"))
							var/obj/signal/structure/S1 = new /obj/signal/structure(  )
							S.copy_to(S1)
							S1.strength--
							if (S1.strength <= 0)
								del(S1)
								return
							src.line_temp.process_signal(S1, src)
					del(S)
					return
			else
				if (S.id == "pos")
					src.position = round(text2num(S.params))
					src.position = min(max(src.position, 1), 15)
					spawn( 0 )
						var/obj/signal/structure/S1 = new /obj/signal/structure(  )
						S1.dest_id = src.d_id
						S1.source_id = src.s_id
						S1.id = 1
						S1.params = "Position altered to [src.position]!"
						spawn( 0 )
							src.line_control.process_signal(S1, src)
							return
						return
				else
					if (S.id == "src")
						src.s_id = src.params
						spawn( 0 )
							var/obj/signal/structure/S1 = new /obj/signal/structure()
							S1.dest_id = src.d_id
							S1.source_id = src.s_id
							S1.id = 1
							S1.params = "Source id altered to [src.s_id]!"
							spawn( 0 )
								src.line_control.process_signal(S1, src)
								return
							return
					else
						if (S.id == "multi")
							src.multi = src.params
							var/obj/signal/structure/S1
							spawn(0)
								S1 = new()
								S1.dest_id = src.d_id
								S1.source_id = src.s_id
								S1.id = 1
								S1.params = "Destination id altered to [src.d_id]!"
								return
						else
							var/obj/signal/structure/S1 = new /obj/signal/structure()
							if (src.id == "offset")
								src.offset = S1.params
								spawn( 0 )
									S1 = new /obj/signal/structure(  )
									S1.dest_id = src.d_id
									S1.source_id = src.s_id
									S1.id = 1
									S1.params = "Destination id altered to [src.d_id]!"
									return
							else
								if (S.id == "dest")
									src.d_id = S1.params
									spawn( 0 )
										S1 = new /obj/signal/structure(  )
										S1.dest_id = src.d_id
										S1.source_id = src.s_id
										S1.id = 1
										S1.params = "Destination id altered to [src.d_id]!"
										return
								else
									if (S.id == "mode")
										src.mode = S.params
										spawn( 0 )
											S1 = new /obj/signal/structure(  )
											S1.dest_id = src.d_id
											S1.source_id = src.s_id
											S1.id = 1
											S1.params = "Mode altered to [src.mode] (it must be normal or 5>1 else router will not work)!"
											spawn( 0 )
												src.line_control.process_signal(S1, src)
												return
											return
									else
										if (S.id == "flags")
											src.flags = S.params
											spawn( 0 )
												S1 = new /obj/signal/structure(  )
												S1.dest_id = src.d_id
												S1.source_id = src.s_id
												S1.id = 1
												S1.params = "Flags altered to [src.flags]! Query for info."
												spawn( 0 )
													src.line_control.process_signal(S1, src)
													return
												return
										else
											if (S.id == "query")
												switch(S.params)
													if("pos")
														spawn( 0 )
															S1 = new /obj/signal/structure(  )
															S1.dest_id = src.d_id
															S1.source_id = src.s_id
															S1.id = 1
															S1.params = "Position is [src.position]!"
															spawn( 0 )
																src.line_control.process_signal(S1, src)
																return
															return
													if("src")
														spawn( 0 )
															S1 = new /obj/signal/structure(  )
															S1.dest_id = src.d_id
															S1.source_id = src.s_id
															S1.id = 1
															S1.params = "Source id is [src.s_id]!"
															spawn( 0 )
																src.line_control.process_signal(S1, src)
																return
															return
													if("dest")
														spawn( 0 )
															S1 = new /obj/signal/structure(  )
															S1.dest_id = src.d_id
															S1.source_id = src.s_id
															S1.id = 1
															S1.params = "Destination id is [src.d_id]!"
															spawn( 0 )
																src.line_control.process_signal(S1, src)
																return
															return
													if("mode")
														spawn( 0 )
															S1 = new /obj/signal/structure(  )
															S1.dest_id = src.d_id
															S1.source_id = src.s_id
															S1.id = 1
															S1.params = "Mode is is [src.mode]!"
															spawn( 0 )
																src.line_control.process_signal(S1, src)
																return
															return
													if("flags")
														var/t = null

														if (text2num(src.flags) & 1)
															t += "allow 100 (1),"
														if (text2num(src.flags) & 2)
															t += "bounce back (2),"
														spawn( 0 )
															S1 = new /obj/signal/structure(  )
															S1.dest_id = src.d_id
															S1.source_id = src.s_id
															S1.id = 1
															S1.params = (t ? "Current flags: [t] adds to [src.flags]" : "No flags! Available flags 1,2")
															spawn( 0 )
																src.line_control.process_signal(S1, src)
																return
															return
				del(S)