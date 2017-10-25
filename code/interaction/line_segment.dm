
obj
	dummy
		nosegment
	signal
		wire
			proc/segment(mob/M,obj/signal/wire/previous,seg_list)
				// This could probably be done better, it was a popular request to cut entire segments and this is how it turned out the first go.
				if(!previous)
					if(line1&&line2)
						seg_list += new/obj/dummy/nosegment
						return
				if(line1&&!istype(line1,/obj/signal/wire))
					seg_list += new/obj/dummy/nosegment
					return
				if(line2&&!istype(line2,/obj/signal/wire))
					seg_list += new/obj/dummy/nosegment
					return
				seg_list+=src
				if(line1)
					if(line1 != previous)
						if(istype(line1,/obj/signal/wire))
							var/obj/signal/wire/L1 = line1
							L1.segment(M,src,seg_list)

				if(line2)
					if(line2 != previous)
						if(istype(line2,/obj/signal/wire))
							var/obj/signal/wire/L2 = line2
							L2.segment(M,src,seg_list)


			verb
				Cut_Segment()
					set category = null
					set src in oview(1,usr)
					if(ismob(src.loc)) return
					var/list/my_seg = list()
					src.segment(usr,null,my_seg)
					if(locate(/obj/dummy/nosegment) in my_seg)
						usr << "Error: wire is not a segment"
						return
					for(var/obj/wdel in my_seg)
						if(istype(wdel,/obj/signal/wire))
							var/obj/signal/wire/mywire = wdel
							mywire.cut(1)








