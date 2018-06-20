tell application "System Events"
  tell splitter group 1 of window "Maestro 2" of application process "Apogee Maestro 2"
     if the value of checkbox "Mixer" is not 1
        click checkbox "Mixer"
     end if
     click checkbox 8 of scroll area 2
  end tell
end tell

