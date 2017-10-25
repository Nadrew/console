mob
	var
		tmp
			computer_docked = 0
	verb
		window_command(T as text)
			set hidden = 1
			if(!T) return
			switch(T)
				if("computer_clear")
					var/cy = winget(src,"computer_window.operating_tab","current-tab")
					if(cy == "desktop_window") cy = "desktop"
					else cy = "laptop"
					src << output(null,"[cy]_window.computer_output")
					winset(src,"computer_window.computer_input","focus=\"true\"")
				if("computer_dock")
					var/is_docked = winget(src,"info_window.info_child","right")
					switch(is_docked)
						if("computer_docked")
							winset(src,"info_window.info_child","right=\"output_window\"")
							winset(src,"computer_window.dock_button","text=\"Dock\"")
							winset(src,"computer_main.computer_child","left=\"computer_window\"")
							winshow(src,"computer_main",1)
							computer_docked = 0
						else
							winset(src,"computer_docked.docked_child","left=\"computer_window\"")
							winset(src,"computer_docked.docked_child","right=\"output_window\"")
							winset(src,"info_window.info_child","right=\"computer_docked\"")
							winset(src,"computer_window.dock_button","text=\"Undock\"")
							winshow(src,"computer_main",0)
							computer_docked = 1
					winset(src,"computer_window.computer_input","focus=\"true\"")
				if("shutdown")
					var/cy = winget(src,"computer_window.operating_tab","current-tab")
					if(cy == "desktop_window") cy = "desktop"
					else cy = "laptop"
					switch(cy)
						if("desktop")
							if(using_computer)
								using_computer.power_off()
						else
							if(using_laptop)
								using_laptop.power_off()