obj
	items
		GPS
			icon = 'icons/gps.dmi'
			name = "GPS Locator"
			Click()
				if(ismob(loc))
					usr << "[loc.x],[loc.y]"
				else
					usr << "[x],[y]"