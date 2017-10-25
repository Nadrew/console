datum
	task
		var
			name = "task"
			var/p_type = null
			var/source = null
			var/state = null
			var/code = null

			var/obj/signal/computer/master = null
			var/list/var_list = list()
			var/len = 0
		wp
			name = "wp"
			var/datum/file/normal/typing = null