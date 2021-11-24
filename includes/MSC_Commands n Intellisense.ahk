;~ The callback function when the text changes in the input field.
Findus:
Gui, Submit, NoHide
Gosub, GUI_Intellisense 															   ;~ Enable for GUI Intellisense
#Include Includes\UserCommands.ahk 												   ;~ Has to be here for Commands to execute
/*
	if ErrorLevel
		Msgbox, 48, % "ERROR "A_LastError, % DMD_GetErrorStr(A_LastError)
*/
Return

;~ Hidden Button when submitting the Listbox selection
ButtonOK:
Gui, Submit, NoHide
GuiControl,, MasterScriptCommands, % Trim(RegExReplace(StrSplit(Gui_Display, "`t").1, "\h\K\h+")) ;~ Give the name of our edit and what will go in it. Leave param 2 blank will retrieve it's contents
GuiControl,, Gui_Display, 														   ;~ Remove Intellisense so GUI Hides & Doesn't Overlap over Search Engine
Gosub, Findus
Return

;~ GUI for Intellisense
Gui_Intellisense:
GuiControl, Show, Gui_Display
Gui, Show, AutoSize
MSC_RoundedEdges(MSC_GetGuiSize().w,MSC_GetGuiSize().h)
Sifted_Text := Sift_Regex((MasterScriptCommands = "" ? Data = "" : Data := Data), MasterScriptCommands, Options)

/*
	resScores := {}
	Loop, Parse, Sifted_Text, `n, `r
	{
		command := StrSplit(A_LoopField, ",").1
		resScores[levenshtein_distance(command, MasterScriptCommands)] := A_LoopField  ;~ Object
	}
	;~ m(resScores)
	bestResult := resScores[resScores.MinIndex()]
	Sifted_Text := bestResult
;~ Sifted_Text := Sift_Ngram((MasterScriptCommands = "" ? Data = "" : Data := Data), MasterScriptCommands, .5,,1)
*/

Display     := st_columnize(Sifted_Text, "csv", 1,,A_Tab) ;~ justify everything correctly. 3 = center, 2= right, 1=left.
GuiControl,, Gui_Display, `n%Display%
if (MasterScriptCommands = " ")                           ;~ If Query field is blank then show NOTHING
{
	GuiControl,, Gui_Display, 														
	GuiControl, Hide, Gui_Display
	Gui, Show, AutoSize
	MSC_RoundedEdges(MSC_GetGuiSize().w,MSC_GetGuiSize().h)
}
Return
