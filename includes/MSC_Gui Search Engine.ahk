;~ /////////////////////////////////////////////////////////////////////////////////////////////////
;~ ////////////////////////////////////////                    /////////////////////////////////////
;~ //////////////////////////////////////// ;*[SEARCH ENGINES] /////////////////////////////////////
;~ ////////////////////////////////////////                    /////////////////////////////////////
;~ /////////////////////////////////////////////////////////////////////////////////////////////////

gui_change_title(Title,Subtitle := "What would you like to search?",Color := "",Icon := "") {
	;~ If parameter color is omitted, the message is assumed to be an error message, and given the color red.
	if (Icon = Space ? Icon := A_Dropbox "\AHK Scripts\_DMD Scripts\_Master Script\Resources\Master If Commands Icons\Cogwheel Settings.ico" : Icon := Icon)
		
	global WB, MSC_Title, gui_search_title, MSC_Background, MSC_Color, MSC_Icon, MSC_Radius, MSC_Font, MSC_FontSize, MSC_Width, MSC_Height, MSC_Margin, MSC_IconSize, IconW, IconH, Img
	
	Img := MSC_Icon  := Icon
	MSC_Color 	  := Color
	MSC_Title 	  := Title
	gui_search_title := Subtitle
	HTML=
	(
		<body style='margin:0px; background-color:%MSC_Background%;color:%MSC_Color%;font-size:%MSC_FontSize%; font-family:%MSC_Font%;'>
		<div style='width:%MSC_Width%px;height:%IconH%px;%Gradient%;'>
		<img align='middle' style='width:%IconW%px;height:%IconH%px;'>
		<span style='Margin-Left:8px'>%MSC_Title%</span>
		</img>
		</div>
		</body>
	)
	wb.Navigate("about:" HTML) 																	;~ Travel to the made up page variable "HTML" that we created above
	while(wb.ReadyState!=4)
		Sleep,10
	if (StrLen(Img)>1000)																		;~ Dirty way of comparing B64 string vs simple ICO/PNG Dir Path String Length
	{
		wb.Document.GetElementsByTagName("Img").Item[0].src:="data:image/png;base64," Img					;~ Giving the IMG tag the Base64 IMG
	}
	else
		wb.Document.GetElementsByTagName("Img").Item[0].src:= Img										;~ Giving IMG tag the PNG/ICO
	Width := wb.Document.GetElementsByTagName("span").Item[0].GetBoundingClientRect().Width 					;~ Getting auto width based on title length
	Width := wb.Document.GetElementsByTagName("Div").Item[0].Style.Width := Width+StrLen(MSC_Title)+IconW		;~ Grab div > style > width and the width = width set above + 84px
	
	if (Width < 90)
		Width := wb.Document.GetElementsByTagName("Div").Item[0].Style.Width := Width+StrLen(MSC_Title)+IconW+10	;~ If width is less than 90 add more white space at end otherwise title gets cut off
	GuiControl, Move, %hID%, % "Section " "w" Width "h" MSC_IconSize "x" ((MSC_Width-Width)/2)+(IconW/2)		;~ Moving HTML & Centering it Above Edit Field
	GuiControl, Show, WB 
}

gui_search_add_elements: 																          ;~ gui_search_add_elements: Add GUI controls to allow typing of a search query.
;~ Notify Variables has to be here because of the sequence order how the gui search works.
Title      := ""
Font       := "Segoe UI"
TitleFont  := "Segoe UI"
Icon       := A_ProgramFiles64 "\AutoHotkey\AutoHotkey.exe, 2" 								          ;~  Can be either an Integer to pull an icon from Shell32.dll or a full path to an EXE or full path to a dll.  You can add a comma and an integer to select an icon from within that file eg. {Icon:"C:\Windows\HelpPane.exe,2"}
Animate    := "Right,Slide" 															          ;~  Ways that the window will animate in eg. {Animate:""} Can be Bottom, Top, Left, Right, Slide, Center, or Blend (Some work together, and some override others)
ShowDelay  := 100
IconSize   := 64
TitleSize  := 14
Size       := 20
Radius     := 26
Time       := 2500
Background := "0x1d1f21"
Color      := "0xFFFFFF"
TitleColor := "0x00FF00"

;~ Hide GUI Intellisense
GuiControl,, Gui_Display, 																          ;~ If Query field is blank then show NOTHING
GuiControl, Hide, Gui_Display

;~ MSC Gui Spawn
GuiControl, Show, Gui_Search_title_var,
GuiControl, Text, Gui_Search_title_var, %gui_search_title%
GuiControl, Show, gui_SearchEdit
Gui, Add, Button, x-10 y-10 w1 h1 +default ggui_SearchEnter ;~ hidden button just to submit data to Subroutine
GuiControl, Disable, MasterScriptCommands
Gui, Show, AutoSize
MSC_RoundedEdges(MSC_GetGuiSize().w,MSC_GetGuiSize().h)
Return

gui_search(url) {
	global ;~ has to be here.
	if gui_state != search
	{
		gui_state = search ;~ if gui_state is "main", then we are coming from the main window and GUI elements for the search field have not yet been added.
		Gosub, gui_search_add_elements
	}
	
	MSC_Search := [] ;~ Initialize the Array
	for Key, Value in url
		MSC_Search.Push(Value)
}

gui_SearchEnter:
Gui, Submit
gui_destroy()
for Key, Value in MSC_Search
{
	DMD_Run(StrReplace(Value, "REPLACEME", uriEncode(gui_SearchEdit)))
	Search_Title := RegExReplace(Value, "s).*?(\d{12}).*?(?=\d{12}|$)", "$1`r`n")
	If (Title = "" ? Title := Search_Title : Title := Title)	
		Notify().AddWindow(gui_SearchEdit, {Title:Title, Font:Font, TitleFont:TitleFont, Icon:Icon, Animate:Animate, ShowDelay:ShowDelay, IconSize:IconSize, TitleSize:TitleSize, Size:Size, Radius:Radius, Time:Time, Background:Background, Color:Color, TitleColor:TitleColor})
}
return
/*
	Loop, % search_urls 
	{
		search_final_url := StrReplace(search_url%A_Index%, "REPLACEME", uriEncode(gui_SearchEdit))
		Run % search_final_url
		Search_Title:= RegExReplace(search_final_url, "s).*?(\d{12}).*?(?=\d{12}|$)", "$1`r`n")
		If (Title = "" ? Title := Search_Title : Title := Title)	
			Notify().AddWindow(gui_SearchEdit, {Title:Title, Font:Font, TitleFont:TitleFont, Icon:Icon, Animate:Animate, ShowDelay:ShowDelay, IconSize:IconSize, TitleSize:TitleSize, Size:Size, Radius:Radius, Time:Time, Background:Background, Color:Color, TitleColor:TitleColor})
	}
	Notify().AddWindow(gui_SearchEdit, {Title:"Searching For:", Font:"Segoe UI", TitleFont:"Segoe UI", Icon:A_ProgramFiles64 "\AutoHotkey\AutoHotkey.exe, 2", Animate:"Right, Slide", ShowDelay:100, IconSize:64, TitleSize:14, Size:20, Radius:26, Time:2500, Background:"0x1d1f21", Color:"0xFFFFFF", TitleColor:"0x00FF00"})
	search_urls := 0
	Return
	
*/