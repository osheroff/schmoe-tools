script ProToolsApplescript
    property parent: class "NSObject"
    
    on list_position(this_item, this_list)
        repeat with i from 1 to the count of this_list
            if item i of this_list is this_item then return i
        end repeat
        return 0
    end list_position
    
    on changeTool(targetIndex, matchText, toolTitles, keyCode)
        tell application "System Events"
            global curIndex, smartToolOn
            -- display notification "here 1"


            tell application "Pro Tools" to activate

            tell group "Cursor Tool Cluster" of (first window whose name starts with "Edit:") of process "Pro Tools"
                tell (first button whose name is "Smart Tool")
                    if exists
                        set smartToolOn to (value is "selected")
                    
                        -- Object Grabber tool doesn't work with smart tool mode, so we just switch to it.
                        if keyCode is 100 and targetIndex is 3
                            set smartToolOn to false
                        end if
                    else
                        return
                    end if
                end tell
 

                -- bugger me, the value of selected is wrong for the loop/TCE tool - they always
                -- report themselves as selected.  so we have to hit F6 to get to the tool, always,
                -- and then cycle around if it was already selected
                tell application "System Events"
                    key code keyCode
                end tell
                
                tell (first button whose name contains matchText)
                    if not exists then
                        return
                    end if
                    
                    set curIndex to my list_position(title, toolTitles)
                    if curIndex is 0
                        display notification "error, could not find " & title & " in " & toolTitles
                        return
                    end if
                end tell -- button
                -- display notification "here 4"

            end tell -- pro tools

            set nKeyPresses to targetIndex - curIndex

            -- display notification "here 5"

            -- wrap around
            if nKeyPresses < 0 then
                set nKeyPresses to nKeyPresses + 3
            end if


            repeat nKeyPresses times
                key code keyCode
            end repeat

            if smartToolOn then
                -- go back to smart tool
                key code 26 using {command down}
            end if

            display notification "here 5"

        end tell -- system events
    end changeTool

    on changeTrim(targetIndex)
        my changeTool(targetIndex, "Trim Tool", { "Trim Tool", "Time Compression/Expansion Trim tool", "Loop Trim Tool" }, 97)
    end changeTrim

    on changeGrabber(targetIndex)
        my changeTool(targetIndex, "Grabber Tool", { "Grabber Tool (Time)", "Grabber Tool (Separation)", "Grabber Tool (Object)" }, 100)
    end changeGrabber


    on trimTool()
        my changeTrim(1)
    end trimTool

    on tceTool()
        my changeTrim(2)
    end tceTool

    on loopTool()
        my changeTrim(3)
    end 
end script
