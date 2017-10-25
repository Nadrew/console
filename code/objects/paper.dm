obj/items
	paper
		Del()

			if (src.secret == 1)
				if (!( locate((/obj/items/paper in locate(67, 14, 1))) ))
					var/obj/items/paper/P = new /obj/items/paper( locate(67, 14, 1) )
					P.text = "...hheexx ttoo oocctt..."
					P.data = "[ascii2text(4)]\[i\]Prototyping New Objects by Exadv1"
					P.secret = 2
			..()

		attack_by(obj/P in view(usr.client), mob/user in view(usr.client))

			if (istype(P, /obj/items/pen))
				var/t = input(user, "Please type text to add:", "Pen and Paper", null)  as message
				if (((get_dist(src, user) <= 1 || src.loc == user) && P.loc == user))
					src.data += "[ascii2text(4)]\[w\][t] -[user]"
				else
					return
			else
				if (istype(P, /obj/items/inv_pen))
					var/t = input(user, "Please type text to add:", "Pen and Paper", null)  as message
					if (((get_dist(src, user) <= 1 || src.loc == user) && P.loc == user))
						src.data += "[ascii2text(4)]\[i\]<font face=calligrapher>[t] -[user]</font>"
					else
						return

		verb
			label(msg as text)
				if (msg)
					src.name = "paper- '[msg]'"
				else
					src.name = "paper"

			read()

				var/icon/I = new /icon( 'icons/alphanumeric.dmi', "sX" )
				usr << browse_rsc(I, "stamp")
				del(I)
				usr << browse("[src.format()]", "window=name;size=500x400")

		proc
			format(t9 in view(usr.client))
				var/ret
				if (findtext(src.data, "[ascii2text(4)]", 1, null))
					var/L = splittext(src.data, "[ascii2text(4)]")
					for(var/t in L)
						if ((t && length(t) > 3))
							var/t_id = copytext(t, 1, 4)
							var/act_t = copytext(t, 4, length(t) + 1)
							switch(t_id)
								if("\[t\]")
									var/te = copytext(t, 4, length(t) + 1)
									te = replacetext(te, "\n", "<BR>")
									te = replacetext(te, "<HR>", "HR")
									ret += "[te]<HR>"
								if("\[i\]")
									if ((t9 && t9 & 1))
										var/te = copytext(t, 4, length(t) + 1)
										te = replacetext(te, "\n", "<BR>")
										te = replacetext(te, "<HR>", "HR")
										ret += "<font color=#6D6D6D>[te]</font><HR>"
								if("\[w\]")
									var/te = copytext(t, 4, length(t) + 1)
									te = replacetext(te, "\n", "<BR>")
									te = replacetext(te, "<HR>", "HR")
									ret += "<font face=calligrapher>[te]</font><HR>"
								if("\[n\]")
									var/vn = copytext(act_t, 1, findtext(act_t, ";", 1, null))
									ret += "<IMG src=stamp>[vn]<HR>"
					return ret
				else
					if (copytext(src.data, 1, 2) != "[ascii2text(4)]")
						return src.data





obj
	copier
		attack_by(obj/items/paper/P in view(usr.client), mob/user in view(usr.client))

			if (istype(P, /obj/items/paper))
				var/obj/items/paper/O = new /obj/items/paper( src.loc )
				O.data = P.data
				if(findtext(O.data,"[ascii2text(4)]\[n\]"))
					var/n_f = findtext(O.data,"[ascii2text(4)]\[n\]")
					var/n_e = findtext(O.data,"\n",n_f)
					if(!n_e) n_e = length(O.data)
					var/n_c = copytext(O.data,n_f,n_e+1)
					O.data = replacetext(O.data,n_c,"")
				if (!( findtext(O.data, "[ascii2text(4)]\[i\]copy", 1, null) ))
					O.data += "[ascii2text(4)]\[i\]copy"
			else
				..()

	shredder
		attack_by(obj/P in view(usr.client), user in view(usr.client))

			if (!( istype(P, /obj/items/paper) ))
				return
			view(src, 3) << "\red [user] shreds [P]!"
			del(P)