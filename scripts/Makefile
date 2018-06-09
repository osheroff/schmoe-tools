
all: Select_Standard_Trim_Tool.scpt Select_Loop_Trim_Tool.scpt Select_TCE_Trim_Tool.scpt

%.scpt: %.applescript schmoe_tools_lib.applescript
	osacompile -o $@ $< schmoe_tools_lib.applescript

install: all
	sudo rm -Rf "/Library/Scripts/Schmoe Tools Scripts"
	sudo mkdir -p "/Library/Scripts/Schmoe Tools Scripts"
	sudo cp -a *.scpt "/Library/Scripts/Schmoe Tools Scripts"

