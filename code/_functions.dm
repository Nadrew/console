#define DEBUG

proc
	dir2num(direction)
		switch(ckey(direction))
			if("north") return NORTH
			if("south") return SOUTH
			if("east") return EAST
			if("west") return WEST
			if("northeast") return NORTHEAST
			if("northwest") return NORTHWEST
			if("southeast") return SOUTHEAST
			if("southwest") return SOUTHWEST
			else return 0
	num2dir(direction)
		switch(direction)
			if(NORTH) return "north"
			if(SOUTH) return "south"
			if(EAST) return "east"
			if(WEST) return "west"
			if(SOUTHEAST) return "southeast"
			if(SOUTHWEST) return "southwest"
			if(NORTHEAST) return "northeast"
			if(NORTHWEST) return "northwest"


	stripHTML(string)

		if(findtext(string,"<"))
			var/found_open = findtext(string,"<")
			var/found_close = findtext(string,">",found_open)
			if(!found_close) return string
			while(found_open)
				var/html_content = copytext(string,found_open+1,found_close)
				string = replacetext(string,"<[html_content]>","")
				found_open = findtext(string,"<")
				found_close = findtext(string,">",found_open)
				sleep(1)
		//string = html_encode(string)
	//	var/list/macro_strip = list("n","t","black","silver","gray","grey","white","maroon","red","purple","fuchsia","magenta","green","lime","olive","gold","yellow","navy","blue","teal","aqua","cyan")
	//	for(var/M in macro_strip)
	//		string = replacetext(string,"\\[macro_strip]","")
		return string
