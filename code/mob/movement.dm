mob/Move(NewLoc in view(usr.client))
	var/old_loc = src.loc
	. = ..()
	if(client)
		winshow(src,"disk_producer",0)
	if (.&&src.loc&&get_dist(old_loc, src.loc) <= 1 && src.equipped)
		if(hascall(src.equipped,"moved"))
			src.equipped.moved(src, old_loc)