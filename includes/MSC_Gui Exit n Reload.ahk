;~ Automatically triggered on Escape key:
GuiEscape:
gui_destroy() 																			       ;~ Includes restoring previously active window
search_urls := 0
Return

#WinActivateForce
gui_destroy() { ;~ gui_destroy() Destroy the GUI after use.
	global gui_state, gui_search_title, Active_Title
	gui_state = closed
	gui_search_title = 	                                                                                       ;~ Forget search title variable so the next search does not re-use it in case the next search does not set its own:
	
	GuiControl,, Gui_Display,                                                                                  ;~ Reset Intellisense Gui to BLANK
	Gui, Destroy                                                                                               ;~ Hide GUI
	;~ Gui MSC: Hide                                                                                                  ;~ Hide GUI
	WinActivate % Active_Title                                                                                 ;~ Bring focus back to another window found on the desktop
}

RunReload:
Reload
Return

/*
	;~ DLL Call with restarttmp was causing Encoding issue with the GetCommandLineW (W for whitespace), just use reload.
	RunReload:
	Gosub, RunFile
	Run, %A_AhkPath% "Includes\MSC_Restart.ahk"
	ExitApp
	Sleep, 1000
	Return
	
	RunFile:                                                                                         ;~ Create restart file
	FileDelete, %TmpDir%\restarttmp.ahk
	While FileExist(TmpDir "\restarttmp.ahk")
		Sleep 100
	FileAppend, % "Run, *RunAs " DllCall( "GetCommandLineW", "Str" ), %TmpDir%\restarttmp.ahk, UTF-8 ;~ reload with command line parameters
	;~ if A_IsAdmin
		;~ FileAppend, % "Run, *RunAs " DllCall( "GetCommandLineW", "Str" ), %TmpDir%\restarttmp.ahk, UTF-8  ;~ reload with command line parameters
	;~ else
		;~ FileAppend, % "Run, " DllCall( "GetCommandLineW", "Str" ), %TmpDir%\restarttmp.ahk, UTF-8  ;~ reload with command line parameters
	Sleep 100
	Return
*/
