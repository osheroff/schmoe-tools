all: $(shell ls -1 *.applescript | grep -v schmoe_tools_lib | sed -e 's/applescript/scpt/g')

%.scpt: %.applescript schmoe_tools_lib.applescript
	osacompile -o $@ $< schmoe_tools_lib.applescript

install: all
	sudo rm -Rf "/Library/Scripts/Schmoe Tools Scripts"
	sudo mkdir -p "/Library/Scripts/Schmoe Tools Scripts"
	sudo cp -a *.scpt "/Library/Scripts/Schmoe Tools Scripts"

