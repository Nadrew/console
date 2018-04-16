image
	boom
		icon='icons/packet.dmi'
		icon_state="boom"
		layer = FLY_LAYER
		New()
			..()
			world<<src
			spawn(20)
				del(src)