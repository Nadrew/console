datum
	file
		var
			name = "file"
			flags = 0.0
			special_flags = 0
			datum/file/dir/parent = null
			obj/signal/computer/master = null
			disk_master = null
			len = 0
			s_type
			s_source
			tmp
				is_override = 0
		proc/copy_to(datum/file/F)
		dir
			name = "dir"

			var/list/files = list()
		normal
			name = "normal"
			var/text = null
			executable
				name = "executable"
				var/function = null
				flags = 3.0
				var/list/var_list = list()
				var/sys_stat
				compiler
					name = "compiler"
				dialer
					name = "dialer"
				playback
					name = "playback"
				resequencer
					name = "resequencer"
				scr_compile
					name = "scr_compile"
				script
					name = "script"
				search
					name = "search"
				trunicate
					name = "trunicate"
				word_process
					name = "word process"
			sound
				name = "sound"
				flags = 3.0