mob
	var/tmp
		showncode
	verb
		showcode(code as message)
			if(!code) return
			src.showncode = code
			switch(alert("Would you like to broadcast this to everyone, or just those in visual range?",,"Visual Range","Everyone"))
				if("Visual Range")
					view(src) << "Click <a href=?action=showcode&key=[src.ckey]>here</a> to view a showcode from [src.key]"
				else
					world << "Click <a href=?action=showcode&key=[src.ckey]>here</a> to view a showcode from [src.key]"

client
	Topic(href,href_list[])
		..()
		if(href_list)
			if(href_list["action"] == "showcode")
				var/k = href_list["key"]
				var/mob/s
				for(var/client/C)
					if(C.ckey == k) s = C.mob
				if(!s) return
				mob << browse("<HTML><HEAD><TITLE>Showcode from [k]</TITLE></HEAD><BODY><pre>[html_encode(s.showncode)]</pre></BODY>","window=showncode[k]&size=640x480")