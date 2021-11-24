; Ensure Window is off unless specificed by command. Important for certain AHK scripts for this to be off
DetectHiddenWindows, Off
; A note on how this works:
; The function name "gui_search()"
; What you actually specify as the parameter value is a command to Run. It does not have to be a URL.
; Before the command is Run, the word REPLACEME is replaced by your input.
; It does not have to be a search url, that was just the application I had in mind when I originally wrote it.
; So what this does is that it Runs chrome with the arguments "-incognito" and the google search URL where REPLACEME in the URL has been replaced by your input.	

Switch MasterScriptCommands
{
	Case "Test A": { ; Testing A
		gui_destroy()
		Notify().AddWindow(MSC_Title(MasterScriptCommands, DIR), {Title:"Master Script Commands", Font:"Sans Serif", TitleFont:"Sans Serif", Icon:"C:\AHK Scripts\_Master Script\Resources\Master If Commands Icons\Cogwheel Settings.ico, 1", Animate:"Right, Slide", ShowDelay:100, IconSize:64, TitleSize:14, Size:20, Radius:26, Time:2500, Background:"0xFFFFFF", Color:"0x282A2E", TitleColor:"0xFF0000"})
	}
	Case "Test B": { ; Testing B
		gui_destroy()
		Notify().AddWindow(MSC_Title(MasterScriptCommands, DIR), {Title:"Master Script Commands", Font:"Sans Serif", TitleFont:"Sans Serif", Icon:"C:\AHK Scripts\_Master Script\Resources\Master If Commands Icons\Cogwheel Settings.ico, 1", Animate:"Right, Slide", ShowDelay:100, IconSize:64, TitleSize:14, Size:20, Radius:26, Time:2500, Background:"0xFFFFFF", Color:"0x282A2E", TitleColor:"0xFF0000"})
	}
	Case "Test C": { ; Testing C
		gui_destroy()
		Notify().AddWindow(MSC_Title(MasterScriptCommands, DIR), {Title:"Master Script Commands", Font:"Sans Serif", TitleFont:"Sans Serif", Icon:"C:\AHK Scripts\_Master Script\Resources\Master If Commands Icons\Cogwheel Settings.ico, 1", Animate:"Right, Slide", ShowDelay:100, IconSize:64, TitleSize:14, Size:20, Radius:26, Time:2500, Background:"0xFFFFFF", Color:"0x282A2E", TitleColor:"0xFF0000"})
	}
	Case "Test Search": { ; Testing Search
		gui_Change_Title("Autohotkey Google Search",,"#00FF00",Icon_AHK)
		gui_search("https://www.google.com/search?num=50&safe=off&site=&source=hp&q=autohotkey%20REPLACEME&btnG=Search&oq=&gs_l=")
	}
}