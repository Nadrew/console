var/tmp/change_css
world
	New()
		..()
		change_css = file2text('code/changelog/changes.css')
client
	Topic(href)
		..()
		if(href=="changes")
			mob << browse({"
<HTML>
<HEAD>
<TITLE>Changes</TITLE>
<style type="text/css">
[change_css]
</style>
<script language="javascript">
var current_version = "[n_version]";
function expand(version){
	var n = document.getElementById("changes_"+version);
	if(!version) version = "[n_version]";
	if(version == current_version){
		if(n.className == "change_shown") n.className = "change_hidden";
		else n.className = "change_shown";
		current_version = version;
	}
	else if(n){
		n.className = "change_shown";
		var od = document.getElementById("changes_"+current_version);
		od.className = "change_hidden"
		current_version = version;

	}
}
</script>
</HEAD>
<center><b><u>Click a version to expand its contents</u></b></center><br>
<b><a onclick="expand('N2.3')">Changes for N2.3</a></b><br>
<div id="changes_N2.3" class="change_shown">
- Adds security cameras.<br>
- Refactored the source code to be more organized and faster. (For open-sourcing)<br>
- Fixes some minor logic hiccups with ExCode's math functions.<br>
<br>
</div>
<hr>
<b><a onclick="expand('N2.2')">Changes for N2.2</a></b><br>
<div id="changes_N2.2" class="change_hidden">
- Registry files can now override global commands, so /sys/registry/help.com will execute if the help command is used.<br>
-- Same rules apply as other registry scripts, if no file is found the default action of that command will execute.
<br>
</div>
<hr>
<b><a onclick="expand('N2.1')">Changes for N2.1</a></b><br>
<div id="changes_N2.1" class="change_hidden">
- Fixes a bug with excode's eval and one-sided operations.<br>
<br>
- Adds bitwise operators &, |, and ^ to the eval excode function. Also adds the != alias <><br>
</div>
<hr>
<b><a onclick="expand('N2.0')">Changes for N2.0</a></b><br>
<div id="changes_N2.0" class="change_hidden">
- Fixed an issue with the 'flags' for routers causing a runtime error.<br>
<br>
- Added the ability for hosts to save and load labs at will.<br>
<br>
- Changed environment variables to retain casing and _ and -, getenv also does the same conversion and sets the dump variable to null if there's no environment variable of that name.<br>
<br>
- Fixed books not saving their pages properly.<br>
<br>
- Fixed the 'processes' command not showing the actual id of processes, and added some errors and whatnot to the various 'tasks' related commands.<br>
<br>
- Changed signs, they now have actual text on them; they come with a box you can connect to and change the text using 'extern source dest text \[text\]', limited to 16 characters.<br>
<br>
- Added conveyor belts, you can make parts under the 'make' tab -- double-click the item in your inventory to start the process.<br>
-- After finishing your belt connect one or both ends to a computer and extern the 'activate' packet to it.<br>
-- extern 'delay' \[num\] (1-15) to change the movement delay.<br>
<br>
- Completely redid the map, this will make labs being used far less isolated and more consistent across users.<br>
<br>
- All lab saves have been wiped to prevent conflicts with the new map.<br>
<br>
- Added a 'Force Lab Door' command to lab owners, this will force the door in your lab open.<br>
<br>
- Fixed the \[bracket_l\] and \[bracket_r\] keywords, they will display escaped brackets that are ignored by the parser.<br>
<br>
- Added the 'args' ExCode function.<br>
<br>
- Added a lab for Lcooper.<br>
<br>
- Fixed 'verbose' not properly accepting the 'none' argument.<br>
<br>
</div>
<hr>
<b><a onclick="expand('N1.9')">Changes for N1.9</a></b><br>
<div id="changes_N1.9" class="change_hidden">
- Added some content to the 'Basic Computing' book.<br>
- Added the router tutorial Davesoft created to the game interface under 'Help'.<br>
- Added embedded expressions to ExCode, you can now display variables using the \[variable\] format.<br>
- Added a 'clear' command for all computers, it will clear the screen.<br>
- Changed the saving/loading system for labs, hopefully it solves some issues.<br>
- Updated the map, added labs for W12W, Robconnoly, Tomeno, and Rockdtben<br>
- Added a 'Mass Add' button to computer interfaces.<br>
- Lab owners now have a command to delete any wires lacking a label inside of their lab.<br>
- Fixed communicating through charged teleport pads. If the pad has a valid destination and is charged you can speak through the teleport.<br>
- Fixed infared signalers and their beams being teleported by teleport pads inappropriately.<br>
</div>
<hr>
<b><a onclick="expand('N1.8')">Changes for N1.8</a></b><br>
<div id="changes_N1.8" class="change_hidden">
- Added teleports to select labs. (You all know how to use them already)<br>
- Added the 'out_level' variable to computers, it will contain the last thing output by the system. Access it like err_level.<br>
</div>
<hr>
<b><a onclick="expand('N1.7')">Changes for N1.7</a></b><br>
<div id="changes_N1.7" class="change_hidden">
- getenv in excode now returns a list of all environment variables if only one argument is supplied (which will be the variable to dump the list)<br>
<br>
- Fixed a bug with rackmounts that caused them to behave oddly with saved computers.<br>
<br>
- Fixed a bug with replacetext that could cause the server to crash.<br>
<br>
- Fixed a bug with rackmounts that caused wires that started at the rackmount to fail to send data properly.<br>
<br>
- Fixed a bug with timestamp and timer that caused them to display a console message even when an argument was supplied.<br>
<br>
- Fixed a bug with makedir that caused it to fail when making directories on a disk.<br>
<br>
- Fixed a few issues with the auto-label system rackmounts use. And also made it easier to label systems in your inventory.<br>
<br>
- If two infared beams crossed and you entered one while standing in the other it would fail to trigger. This also fixes another issue with only one signaler triggering for crossed beams.<br>
<br>
- Certain objects were not able to be dropped due to their density.<br>
<br>
- Fixed a bug with unequipping underground terminals that would cause various things not to be properly reset.<br>
<br>
- Added rackmounts, which allow you to mount multiple computers to a single system.<br>
-- Just equip a computer in your inventory and double-click the rackmount to mount the computer to it.<br>
<br>
- Added the setenv Excode function, for speed-sake. Check the reference.<br>
<br>
- Updated the interface to make use of some new BYOND features. This means you need version 430.1005 of BYOND or higher.<br>
<br>
- Added the getenv Excode function to accompany the new environment variable system. Check the excode reference for more details.<br>
<br>
- Computers now have environment variables, they can be set or obtained using the getenv and setenv commands.<br>
-- setenv \[variable\] \[value\] (When value is empty the variable is removed)<br>
-- getenv \[variable\] (When left empty a list of variables and their values is shown.)<br>
<br>
- Changed the format of the unarc command, it now takes three arguments.<br>
-- unarc \[file\] \[directory\] \[password\]<br>
--- directory is the directory you want to extract the files to using '.' will extract to the current directory.<br>
--- Leaving the last two arguments blank will result in extraction to the current directory.<br>
<br>
- The playback system wasn't handling certain HTML properly due to the change that removed html from output.<br>
<br>
- Added a limited ExCode reference manual to the help system, it's just a quick guide to the excode functions, their use and their format.<br>
-- If you find mistakes, lemme know.<br>
-- I didn't include some functions like list functions, as I want to fiddle with that system a little bit first.<br>
-- Tutorials to include with the official help files are welcome!<br>
<br>
- The same labs that auto-load on world startup now auto-save on world shutdown and about once every hour.<br>
-- Ask me if you want your lab added to or removed from the list.<br>
<br>
- You no longer have to be on the same tile as a bounce to connect to it.<br>
<br>
- Certain items were coming out of the dispenser locked in place.<br>
<br>
- Fixed a couple of runtime errors associated with packet handling.<br>
<br>
- The ascii function wasn't working in some cases.<br>
<br>
- Computer and say command output no longer displays HTML as-is, it is now html_encode()'d.<br>
<br>
- The unarc command wasn't handling directories properly. <b>Note:</b> unarc still doesn't handle directories inside of directories properly, don't make them too complex.<br>
<br>
</div>
<hr>
<b><a onclick="expand('N1.6')">Changes for N1.6</a></b><br>
<div id="changes_N1.6" class="change_hidden">
- Added a few more items to the dispensers.<br>
<br>
- Added the 'arc' and 'unarc' computer commands, they allow you to create and extract zip-like archive files.<br>
-- arc \[file\] \[archive_file\] \[password\]<br>
-- unarc \[archive_file\] \[password\]<br>
-- The file being the file you want to add to the archive.<br>
-- The archive_file being the file you want to make an archive.<br>
-- The password being the password to set/use for adding/removing files.<br>
<br>
- Added the ascii function to ExCode, it works exactly like char but backwards.<br>
<br>
- The if function was not handling variable-based == comparisons properly in some cases.<br>
<br>
- Laptops weren't properly removing suffix when unequipped.<br>
<br>
- The /sys/shutdown.sys file is now executed when a computer is shutdown, if it exists. All non-saved systems include the file by default.<br>
<br>
- You can now operate laptops and desktops at the same time, the console window will split them into tabs as needed.<br>
<br>
- Added the uppertext and lowertext ExCode functions, they both take the same arguments.<br>
-- Format: uppertext;string;variable<br>
-- string being the string you want to alter, variable being where to put the results.<br>
<br>
- Fixed a few issues with the findtext function.<br>
<br>
- Antennas, and dishes, can now send/receive on multiple e_keys simple format the e_key as 'num_1&num_2&num_3' they support up to 5.<br>
<br>
- Added the md5 function to ExCode.<br>
-- Format: md5;string;variable<br>
-- string is the string/variable you want to hash, variable is the variable the result is dumped to.<br>
<br>
- Redesigned mass disk producers.<br>
-- Equip a disk and double-click the mass disk producer.<br>
-- With nothing equipped double-click the producer again.<br>
-- In the interface that pops up fill out the information and click 'Produce'<br>
-- Tada, you have disks (or in amounts > 10 a box of disks)<br>
-- Amounts over 15 aren't accepted.<br>
-- This means I've placed disk producers in more labs now that they're not so complex.<br>
<br>
- Labeling a laptop no longer names it 'computer -...' (Relabel to see the effects)<br>
<br>
- Laptops were not properly unequipping in various cases.<br>
<br>
- Cut segment was not properly working on hyperwire.<br>
<br>
- Added two more free labs.<br>
</div>
<hr>
<b><a onclick="expand('N1.5')">Changes for N1.5</a></b><br>
<div id="changes_N1.5" class="change_hidden">
- Fixed cut segment.<br>
<br>
- There are now a few 'free' labs, these labs don't save and start with open doors, first to get to them can use them.<br>
<br>
- You can now equip laptops.<br>
<br>
- Added a 'ckey' ExCode function. Format is ckey;variable;other_variable<br>
-- variable being the variable to convert.<br>
-- other_variable being the variable you want to dump the result to.<br>
<br>
- Antennas now have a maximum range of 50 tiles as opposed to 14.<br>
<br>
- Fixed a bug that prevented maximum length underground terminals from being removable.<br>
<br>
- Added speed increases to the ExCode parser and directional antenna signal transfer rate.<br>
<br>
- The console window now better handles the input element.<br>
<br>
- Added mini hubs and routers to various labs, these work exactly like the normal hubs and routers except they're unlockable and can handle about half as many packets at once.<br>
<br>
- You can now unlock antennas, relays, and directional antennas using the wrench, when unlocked you can pick up and move the object. Use the wrench on it again to lock it back in place.<br>
<br>
- Computers now retain their label when being packed up.<br>
<br>
- Expanded the e_key limit to 65,000<br>
<br>
- The saving system was mistakenly saving objects connected to other objects inside of saved areas, this has been remedied by disconnecting any outside connections previous to the save, and restoring them afterwards.<br>
<br>
- Bulletin boards had a malformed removed command which allowed people to select any object within view and effectively summon it.<br>
<br>
- Underground wiring spools are no longer saved with labs.<br>
<br>
- Underground wiring spools were poorly handling running out of wire.<br>
<br>
- Fixed a problem that was causing satellite relays to only send a signal to a very limited range of devices.<br>
<br>
- Fixed a few input focus issues with the console window, it now gives the input focus after various operations.<br>
<br>
- Lab saving wasn't properly working for multi-area labs.<br>
<br>
- The restart computer command was causing the console window to act up.<br>
<br>
- Lab saving no longer saves various types of items, like paper, keys, locks, etc...<br>
<br>
- You can now cut segments of wire. A segment is any length of wire not connected to anything on either side.<br>
<br>
- Fixed another instance where a black wire could result from cutting a colored wire.<br>
<br>
- Lab owners can now delete all of the wires in their lab at once, either by label or in general.<br>
<br>
- New 4.0 interface, when using a computer the display now appears in a seperate window.<br>
-- If you close the window you can always reshow it using the operate command.<br>
-- You can also 'dock' the window, which will show the computer console above the output area.<br>
<br>
- Basic lab saving is in and has been tested, lab owners now have commands to save and load their labs as they wish. (None of it is automated)
</div>
<hr>
<b><a onclick="expand('N1.4')">Changes for N1.4</a></b><br>
<div id="changes_N1.4" class="change_hidden">
- Copiers no longer copy notoriety stamps.<br>
<br>
- You can now color wire without paint using the color wire command.<br>
<br>
- You can now label wire, any laid wire will be labeled the same as the spool it came from.<br>
<br>
- Signal objects now have a timer to how long they can exist, this timer is reset each time the signal travels, but should prevent signals that end up left-over sitting in hubs/routers after a complex routine.<br>
<br>
- There is now a limit to how many signals things can process at any given time, this should eliminate server crashing wiring loops. <i>I tried some pretty nuts cross-hub wiring crazies and it didn't even make my CPU spike, it was cool looking, but it didn't hurt the system -- huzzah!</i><br>
<br>
- You can now throw away an item in your inventory regardless of type.<br>
<br>
- Infared signalers now have a new parameter format, extern 0 0 power \[number\].<br>
<br>
- Added the ++ and -- operators to the eval function, only works on numbers of course.<br>
<br>
- The rand function's return value was being lost along the parsing process.<br>
<br>
- Fixed an issue with underground terminals that could cause the server to crash.<br>
<br>
- shell.scr was not functioning correctly.<br>
<br>
- Changed the changes system, obviously. Added a changes command for quick access.<br>
<br>
- search.exe and scr_compiler.exe weren't working correctly.<br>
<br>
- Added a disk mass-production system to certain labs.<br>
--- Use 'send' to send files to it, each file is added.<br>
--- Use 'extern 0 0 amount \[number\] to change the amount of disks to create.<br>
--- Use 'extern 0 0 0 \[cmd\]' to send commands, 'create' to create your disks, 'clear' to clear the file list.<br>
--- Amounts over 5 will result in a box of disks being created.<br>
--- No amounts over 15 are accepted.<br>
--- 'extern 0 0 label \[text\]' will change the default label of the disks/box.<br>
--- 'extern 0 0 makedir \[dir\]' will make a directory on the machine.<br>
--- 'extern 0 0 cd \[dir\]' will navigate to a directory on the machine.<br>
<br>
- echo_var wasn't working properly.
</div>
<hr>
<b><a onclick="expand('N1.3')">Changes for N1.3</a></b><br>
<div id="changes_N1.3" class="change_hidden">
Added underground wiring terminals, this is basically a way to reduce the amount of clutter and object use.<br>
&nbsp;&nbsp;They can be made under the make menu and here's how they work: Equip the item, double-click it to start placing.<br>
&nbsp;&nbsp;As you move you'll notice the tiles you step on become darker, this indicates that you've placed wire there.<br>
&nbsp;&nbsp;When the desired path is reached, simply double click the item again and you'll have what you need.<br>
&nbsp;&nbsp;Connect wires into both terminals created by the process and sending signal to one will result in it being received at the other, after traveling, of course.<br>
&nbsp;&nbsp;There's a limit of 50 unique wires between each terminal.<br>
&nbsp;&nbsp;You may connect both wire and hyperwire to the terminals.<br>
&nbsp;&nbsp;The only way to remove these items and wire paths is to cut the terminal with wirecutters.<br>
&nbsp;&nbsp;The item will never vanish from your inventory unless you drop it, you should only need one.<br>
<br>
- Made the wiring junction and infared scanner equippable.<br>
<br>
- Paper printed using the printer will now have the file name of what was printed as the paper's label.<br>
<br>
- You could not connect to an infared signaler again after disconnecting it from something.<br>
<br>
- Fixed an issue that caused routers not to respond to various external commands.<br>
<br>
- Shutters are now controlled using boxes like doors are.<br>
<br>
- In some instances cutting hyperwire would cause a regular wire to appear.<br>
<br>
- Various items didn't unequip when another was equipped.<br>
<br>
- Created a lab for Oronar.<br>
<br>
- Added the 'ls' and 'dir' commands, both work indentical to 'display' (dir is no longer used for the secret).<br>
<br>
- You will not set off a signal for infared devices if you move from a turf within the beam to another within the beam.<br>
<br>
- Created a lab for Semereh.<br>
</div>
<hr>
<b><a onclick="expand('N1.2')">Changes for N1.2</a></b><br>
<div id="changes_N1.2" class="change_hidden">
- Added a wiring junction (can be made under the 'make' command tab) this is basically a portable hub, to use it simply drop it and connect wires to it. Each one has four connectors.<br>
<br>
- Window shutters can now be attached to wires, they work much like doors except no control box. The 'toggle' parameter replaces the 'door' parameter and it'll send sqry instead of dqry when accessed.<br>
<br>
- Added a paper scanning device, you can connect this to something and send data from a piece of paper. To scan a piece of paper simply equip it and double click the scanner.<br>
<br>
- Added an infared signaler device, it will emit a beam five tiles long in the direction it is pointed. If anyone passes through the beam a signal will be emitted, either through a connected wire or as a message to everyone in view.<br>
</div>
<hr>
<b><a onclick="expand('N1.1')">Changes for N1.1</a></b><br>
<div id="changes_N1.1" class="change_hidden">
- Fixed playback.exe, it wasn't properly playing sound files.<br>
<br>
- Fixed a few map issues here and there.<br>
<br>
- Fixed an issue that prevented cut colored wires from properly threaded.<br>
<br>
- Added a lab for Lyndonarmitage1. (Replaced DaveSoft) and a lab for W12W (Replaced the Intercorps Dev area)<br>
<br>
- Fixed the copytext, findtext and replacetext ExCode functions.<br>
<br>
- You no longer have to be standing on the same tile as a microphone or bounce to 'get' it, it can now be done from one tile away as well.<br>
<br>
- Hyperwire's color has been changed so it doesn't match painted wire.<br>
<br>
- Fixed a bug that caused sending files to fail to pass along proper data, causing it to fail in most cases (not all.)<br>
<br>
- Fixed a bug in the copy command that caused wildcard copies to fail.<br>
<br>
- Made it impossible for microphones/intercoms to pick up sounds out of computers, and other intercoms/microphones.<br>
<br>
- Added an 'echo_var' command (format: echo_var;variable) that will echo the value of variable to your terminal, makes debugging much easier.<br>
<br>
- Fixed an issue where getfile+eval was no longer appending newlines properly.<br>
<br>
- You can now equip microphones to place them inside of things or on tables.<br>
<br>
- Added 'play.com' to the registry directory, this links to playback.exe for quick sound playing (only affects new computers, not saved laptops)<br>
<br>
- Raised the maximum e_key to 6500.
</div>
<hr>
<b><a onclick="expand('N1.0')">Changes for N1.0</a></b><br>
<div id="changes_N1.0" class="change_hidden">
- FINALLY made it so if you equip something while something else is equipped it won't just unequip the old item it'll equip the new item as well.<br>
<br>
- Added ExCode function 'rand' (format rand;low;high;variable) this allows for easy generation of random numbers.<br>
<br>
- Cutting painted wires now leaves pieces of the proper color.<br>
<br>
- Threading wire will now thread wires of the same color only.<br>
<br>
- Added a lab for Derantell<br>
<br>
- Removed the vents, all they do is make getting into labs uninvited easier -- I realize they could be used for wiring, but nobody ever used them for that.<br>
<br>
- Updated the required version to play to a later 4.0 version, this allows me to do a little more with icons and whatnot.<br>
<br>
- Updated directional antenna, you may now send a direction instead of a number using the 'direct' parameter, any direction is valid.<br>
<br>
-- They may also be pointed in diagonal directions now as well, the 'turn' parameter still works as previously.</div>"},"window=changes;size=640x480")