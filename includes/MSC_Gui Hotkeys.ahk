;~ Up & Down Arrows for Listbox Selection
#If WinActive("ahk_id " MSC_GUI) && (getFokus() == QueryEditField || getFokus() == hEdtValue2)	;~ If GUI is in focus and Edit box is the main focus of the GUI
^Backspace:: 																	;~ Active Window's Delete Word Shorcut
Send, ^+{Left}{Delete}
Return

~Down::
~Up::
MSC_KeybindFocus()
Return

/*
	~Enter:: 																		;~ Press Enter from Editfield to Activate Listbox
	MSC_KeybindFocus(1)
	Return
*/