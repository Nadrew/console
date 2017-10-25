obj
	signal
		structure
			name = "structure"
			icon = 'icons/packet.dmi'
			//icon_state = "structure"
			var/strength = 10
			source_id = 0
			dest_id = 0
			id = 0
			orient_to()
				return 0

			proc
				copy_to(obj/signal/S as obj in view(usr.client))
					S.source_id = src.source_id
					S.dest_id = src.dest_id
					S.id = src.id
					S.params = src.params
					if (src.cur_file)
						var/datum/file/F = new src.cur_file.type()
						src.cur_file.copy_to(F)
						S.cur_file = F