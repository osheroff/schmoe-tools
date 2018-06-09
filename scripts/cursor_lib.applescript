on list_position(this_item, this_list)
	repeat with i from 1 to the count of this_list
		if item i of this_list is this_item then return i
	end repeat
	return 0
end list_position

on changeTrim(target)
	tell application "System Events"
		global cursorMode
		
		
		tell application "Pro Tools" to activate
		tell process "Pro Tools"
			
			tell (first button whose name contains "Trim Tool") of group "Cursor Tool Cluster" of (first window whose name starts with "Edit:")
				if exists then
					if title is "Loop Trim Tool" then
						set cursorMode to "loop"
					else if title is "Trim Tool" then
						set cursorMode to "standard"
					else
						set cursorMode to "time"
					end if
				else
					return
				end if
			end tell
		end tell
		
		set cursorModeList to {"standard", "time", "loop"}
		set curIndex to my list_position(cursorMode, cursorModeList)
		set targetIndex to my list_position(target, cursorModeList)
		set nKeyPresses to targetIndex - curIndex
		
		if nKeyPresses < 0 then
			set nKeyPresses to nKeyPresses + 3
		end if
		
		
		log nKeyPresses
		repeat nKeyPresses times
			key code 97
		end repeat
		
	end tell
end changeTrim

changeTrim("time")