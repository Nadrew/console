obj
	bookcase
		name = "bookcase"
		icon = 'icons/misc.dmi'
		icon_state = "bookcase"
		opacity = 1
		density = 1
		var
			secret = 0
		verb/take()
			set src in oview(1)

			var/list/C = list(  )
			C["Basic Computing"] = "tutorial.txt"
			C["custom"] = "custom"
			var/choice = input("Which book would you like to take?", "Bookcase", null, null)  as null|anything in C
			if (!( choice ))
				return
			var/fname = C["[choice]"]
			if (fname == "custom")
				fname = input("What is the filename?", "Bookcase", null, null)  as text|null
				fname = replacetext(fname,"..","")
				fname = replacetext(fname,"/","")
				fname = replacetext(fname,"\\","")
				if(secret&&fname == secret)
					if(src.density)
						src.density = 0
						src.opacity = 0
						src.icon_state = "bookcase_open"
					else
						src.density = 1
						src.opacity = 1
						src.icon_state = "bookcase"
				if ((!( fname ) || !( fexists("saves/books/[fname]") )))
					return
			var/booktext = file2text("saves/books/[fname]")
			var/list/L = splittext(booktext, "\[page\]")
			var/obj/items/book/book = new /obj/items/book( usr )
			book.name = "book- '[choice]'"
			for(var/t in L)
				var/t1 = findtext(t, "\[body\]", 1, null)
				if (t1)
					var/obj/items/paper/P = new /obj/items/paper( book )
					var/title = copytext(t, 1, t1)
					P.name = "paper- '[title]'"
					P.data = "\[[title]\][copytext(t, t1 + 6, length(t) + 1)]"
