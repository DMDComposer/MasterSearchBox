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
	WinActivate % Active_Title                                                                                 ;~ Bring focus back to another window found on the desktop
}

RunReload:
Reload
return
