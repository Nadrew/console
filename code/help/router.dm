mob
	verb
		RouterHelp()
			set category = "Help"
			usr << browse_rsc('tut/router.swf',"router.swf")
			usr << output("<HTML><iframe src=\"router.swf\" width=100% height=100%></HTML>","router_help.router_browser")
			winshow(usr,"router_help")