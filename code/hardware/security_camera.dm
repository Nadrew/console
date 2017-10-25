// Just messin' with vis_contents, won't compile earlier than 512.

#if DM_VERSION >= 512
obj
	signal
		camera
			name = "camera"
			icon = 'icons/camera.dmi'
			icon_state = "camera"
			dir = SOUTH
			var/obj/signal/camera_screen/connected
			var
				camera_id

			New()
				spawn(10)
					var/obj/signal/camera_screen/found = locate("cam_screen_[camera_id]") in world
					if(found)
						connected = found
						found.connected = src
						found.Activate()

		camera_screen
			name = "camera screen"
			var
				camera_id
				obj/signal/camera/connected

			icon = 'icons/camera_screen.dmi'
			New()
				..()
				tag = "cam_screen_[camera_id]"
			layer = MOB_LAYER+1
			proc/Activate()
				var/image/screen = image(loc=src)
				var/matrix/scaled = matrix()
				scaled.Scale(0.6)
				scaled.Translate(16,2)
				screen.layer = src.layer+1
				screen.transform = scaled
				screen.vis_contents += connected.loc
				screen.vis_contents += get_step(connected,connected.dir)
				screen.vis_contents += get_step(connected,connected.dir|EAST)
				screen.vis_contents += get_step(connected,connected.dir|WEST)
				screen.vis_contents += get_step(connected,EAST)
				screen.vis_contents += get_step(connected,WEST)
				world << screen
				underlays += image('icons/camera_screen.dmi',"screen",layer=TURF_LAYER+1)

#else
	#warn BYOND v512 or higher is required to use vis_contents.
#endif