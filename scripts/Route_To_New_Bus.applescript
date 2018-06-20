tell application "System Events"
	global curIndex, smartToolOn

	tell application "Pro Tools" to activate

	tell group "Room.04 - Audio Track" of (first window whose name starts with "Edit:") of process "Pro Tools"
		tell group "Audio IO" 
			tell the first pop up button whose title starts with "Audio Output Path" 
				click
			end tell
		end tell
	end tell
end tell
