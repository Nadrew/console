obj
	items
		disk
			var
				label
			verb
				label(title as text)
					set src in usr

					if (title)
						label = title
						src.name = "disk- '[title]'"
					else
						src.name = "disk"
			New()
				..()
				src.root = new /datum/file/dir(  )
				src.root.disk_master = src
				src.root.name = "A:"