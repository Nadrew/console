mob
	var
		tmp
			reference_shown = 0
	verb
		ExCode_Reference()
			set category = "Help"
			var/yy = 1
			if(!reference_shown)
				for(var/Reference/Excode/E in Reference_List)
					src << output("<b><a href=\"byond://?src=\ref[E]&action=show\">[E.title]</a></b>","excode_reference.topic_grid:1,[yy]")
					yy++
				reference_shown = 1
			winshow(src,"excode_reference",1)


var
	list
		Reference_List = list()

world
	New()
		..()
		var/Reference/Excode/exref = new()
		exref.BuildReference()
Reference
	var
		title
		format
		arguments
		extra_content
	Excode
		Topic(href,href_list[])
			if(href_list["action"] == "show")
				var/argument_display
				var/list/arg_list = params2list(arguments)
				for(var/A in arg_list)
					argument_display += "    [A]<br>"
				usr << output(null,"excode_reference.reference_output")
				usr << output("<b><font size=+1>[title]</font></b><br><br><b>Format:</b> [format]<br><br><b>Arguments:</b><br>[argument_display]<hr>[extra_content]","excode_reference.reference_output")
		proc
			BuildReference()
				var/list/n_list = InfoList()
				for(var/Reference/Excode/E in n_list)
					if(E.title&&E.format&&E.arguments&&E.extra_content)
						Reference_List += E
			InfoList()
				var/list/r_list = list()
				for(var/E in typesof(/Reference/Excode)-/Reference/Excode)
					var/Reference/Excode/ne = new E
					r_list += ne
				return r_list

			GetInfo(Reference/Excode/topic)
				if(!topic) return 0

		args
			title = "args"
			format = "args;variable"
			arguments = "variable: The variable to dump the program's entire argument string into."
			extra_content = "The args function allows you to get the program arguments in a simple string format (arg1 arg2 arg3 etc...)"
		ascii
			title = "ascii"
			format = "ascii;variable;string"
			arguments = "variable: The variable you want to dump your results to;string: The string you want to convert into a number."
			extra_content = "The ascii function allows you to convert ascii strings into their number counterpart."
		char
			title = "char"
			format = "char;variable;number"
			arguments = "variable: The variable you want to dump your results to;number: The number you wish to convert."
			extra_content = "The char function allows you to convert a number into its ascii counterpart."

		ckey
			title = "ckey"
			format = "ckey;var_string;var_result"
			arguments = "var_string: The variable containing the string you want to convert.;var_result: The variable to dump your results."
			extra_content = "The ckey function allows you to convert a variable into its canonical form. Eg: 'Hello World!' becomes 'helloworld'"

		comment
			title = "comment"
			format = "comment;string"
			arguments = "string: The string you want to comment out."
			extra_content = "The comment function allows you to comment your code, commented code is ignored by the parser."

		copytext
			title = "copytext"
			format = "copytext;variable;string;start;end"
			arguments = "variable: The variable to dump the results;string: The string to cut.;start: Where to start cutting;end: Where to end cutting."
			extra_content = "The copytext function allows you to take a string, cut a portion out of it and dump the portion into another variable."

		dumpfile
			title = "dumpfile"
			format = "dumpfile;path;variable"
			arguments = "path: The file path (location) of the file.;variable: The variable to dump the file content to."
			extra_content = "The dumpfile function allows you to dump the contents of a file into a variable."

		dumppath
			title = "dumppath"
			format = "dumppath;file;variable"
			arguments = "file: The file handler (obtained with getfile) variable.;variable: The variable to dump the path to."
			extra_content = "The dumppath function allows you to dump the path of a file handler into another variable."
		echo_var
			title = "echo_var"
			format = "echo_var;variable"
			arguments = "variable: The variable you want to echo."
			extra_content = "The echo_var function allows you to easily echo the value of a variable, helpful for quick debugging."
		end
			title = "end"
			format = "end;err_level"
			arguments = "err_level: Sets the system err_level to the given value."
			extra_content = "The end function will terminate your program as soon as the function is called and set err_level."
		eval
			title = "eval"
			format = "eval;variable;operation;value"
			arguments = "variable: The variable you want to change.;operation: The mathematical operation you want to perform (+=,-=,*=,/*,++,--);value: The value you want to alter the variable with."
			extra_content = "The eval function allows you to perform mathematical operations on a variable, you can also use it to append a string to another string."
		findtext
			title = "findtext"
			format = "findtext;variable;string;find;start;end"
			arguments = "variable: The variable to dump your result.;string: The string to search.;find: The string to look for.;start: The starting point to look from (default: 1);end: The last point to look at (default: string.length+1)"
			extra_content = "The findtext function allows you to return the position of the first instance of a string within another string."
		getenv
			title = "getenv"
			format = "getenv;environment_var;variable"
			arguments = "environment_var: The environment variable to get the value of.;variable: The variable to dump the results to."
			extra_content = "The getenv function allows you to get the value of one of the system's environment variables.<br>(If only a single argument is supplied a list of environment variables will be dumped into the variable given as the single argument)"
		getfile
			title = "getfile"
			format = "getfile;variable;path"
			arguments = "variable: The variable to dump the file handler.;path: The path to the file."
			extra_content = "The getfile function allows you to create a file handler variable which allows you to easily write to a file using the eval function."
		goto_stuff
			title = "goto"
			format = "goto;id"
			arguments = "id: The id you wish to send your code to."
			extra_content = "The goto function allows you to skip around your code by moving between various set id's."
		id
			title = "id"
			format = "id;string"
			arguments = "string: The name of the id you want to set."
			extra_content = "The id function allows you to set id's in your code to move to in various cases."
		if_stuff
			title = "if"
			format = "if;variable;condition;other_variable;id"
			arguments = "variable: The variable or string to check;condition: The conditional expression to use (>,>=,<,<=,==,!=);other_variable: The variable or string to check against.;id: The id to go to if the condition passes."
			extra_content = "The if function (or statement) works much like any other language, it checks one thing against another, and if the condition is met it goes to a certain id in your code."
		init_list
			title = "init_list"
		length
			title = "length"
			format = "length;variable;other_variable"
			arguments = "variable: The variable you want to dump the length into.;other_variable: The variable you want to check the length of"
			extra_content = "The length function allows you to check the length of a string or list."
		list_moveup
			title = "list_moveup"
		lowertext
			title = "lowertext"
			format = "lowertext;variable;other_variable"
			arguments = "variable: The variable to change.;other_variable: The variable to dump your results."
			extra_content = "The lowertext function allows you to change a string into its lower-case form."
		md5
			title = "md5"
			format = "md5;variable;other_variable"
			arguments = "variable: The variable to hash.;other_variable: The variable to put the results."
			extra_content = "The md5 function allows you to hash a string or variable using the md5 system."
		rand_stuff
			title = "rand"
			format = "rand;lbound;ubound;variable"
			arguments = "lbound: The lowest the random number can be.;ubound: The highest the random number can be.;variable: The variable to dump the result."
			extra_content = "The rand function allows you to generate a random number within a specified range."
		replacetext
			title = "replacetext"
			format = "replacetext;variable;string;needle;replacement"
			arguments = "variable: The variable to dump the result.;string: The string to search.;needle: The string to locate.;replacement: The string to replace needle with."
			extra_content = "(I know, it's weird-formatted, didn't want to break old code) The replacetext function allows to to find and replace a string within a string."
		set_stuff
			title = "set"
			format = "set;variable;value"
			arguments = "variable: The variable you want to change.;value: The new value of the variable."
			extra_content = "The set function allows you to set the value of a variable."
		setenv
			title = "setenv"
			format = "setenv;variable;value"
			arguments = "variable: The environment variable you want to change/add.;value: The value of the variable."
			extra_content = "The setenv function allows you to set and remove environment variable, using a value of null will remove the variable. <b>(Note: Variables are stripped of non-standard characters excluding - and _)</b>"
		shell
			title = "shell"
			format = "shell;command"
			arguments = "command: The command you want to execute."
			extra_content = "The shell function allows you to execute commands directly at console-level."
		uppertext
			title = "uppertext"
			format = "uppertext;variable;other_variable"
			arguments = "variable: The variable you want to change.;other_variable: The variable to dump the result."
			extra_content = "The uppertext function allows you to change a string into its upper-case form."




