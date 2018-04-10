obj
	zoom_plane
		plane = 0
		appearance_flags = PLANE_MASTER | PIXEL_SCALE
		screen_loc = "1,1"
		var/tmp
			zoomed = 0
			zooming = 0
		icon = 'icons/computer.dmi'
		icon_state = "on"
		layer = 99

client
	var/tmp/obj/zoom_plane/zoom
	New()
		..()
		zoom = new()
		screen += zoom


	MouseWheel()
		set waitfor = 0
		if(!zoom) zoom = new()
		if(zoom.zooming) return
		var/matrix/mat = matrix()
		if(zoom.zoomed)
			mat:Scale(1)
			zoom.zooming = 1
			animate(zoom,transform=mat,time=10)
			sleep(10)
			zoom.zooming = 0
			zoom.zoomed = 0
		else
			mat.Scale(2)
			zoom.zooming = 1
			animate(zoom,transform=mat,time=10)
			sleep(10)
			zoom.zooming = 0
			zoom.zoomed = 1