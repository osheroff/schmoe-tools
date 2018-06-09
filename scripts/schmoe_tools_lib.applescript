on list_position(this_item, this_list)
	repeat with i from 1 to the count of this_list
		if item i of this_list is this_item then return i
	end repeat
	return 0
end list_position

on changeTrim(target)
	tell application "System Events"
		global cursorMode, smartToolOn, trimToolSelected
		
		tell application "Pro Tools" to activate

		tell group "Cursor Tool Cluster" of (first window whose name starts with "Edit:") of process "Pro Tools"
			tell (first button whose name is "Smart Tool") 
				if exists then
					set smartToolOn to (value is "selected")
				else
					return
				end if
			end tell

			-- bugger me, the value of selected is off for the loop/TCE tool - they always
			-- report themselves as selected.  so we have to hit F6 and then cycle all the way if
			-- it was already selected
			tell application "System Events" 
				key code 97
			end tell

			tell (first button whose name contains "Trim Tool") 
				if not exists then 
					return 
				end if

				if title is "Loop Trim Tool" then
					set cursorMode to "loop"
				else if title is "Trim Tool" then
					set cursorMode to "standard"
				else
					set cursorMode to "time"
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
		
		repeat nKeyPresses times
			key code 97
			delay 0.01
		end repeat
		
		if smartToolOn then
			-- go back to smart tool
			key code 26 using {command down}
		end if

		-- display notification "cursorMode: " & cursorMode & ", nKeyPresses: " & nKeyPresses & ", smartToolOn: " & smartToolOn as string & ", trimToolSelected: " & trimToolSelected as string
	end tell
end changeTrim
