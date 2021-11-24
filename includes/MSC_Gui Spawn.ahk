gui_spawn:
WinGetActiveTitle, Active_Title 															       ;~ Get Active Title before GUI Spawn
if gui_state != closed                                                                                          ;~ If the GUI is already open, close it.
{
	gui_destroy()
	Return
}
gui_state = main

MSC_Title      := "Master Script Commands"
MSC_Background := "#1d1f21"
MSC_Color      := "#c5c8c6"
MSC_Icon       := "MasterIcon"
MSC_Radius     := "50-50"
MSC_Font       := "Segoe UI"
MSC_FontSize   := Round(A_ScreenDPI/96*15)                                                                      ;~ Scalable Font Size, replace last number
MSC_Width      := (A_ScreenWidth/4) 												                 ;~ Scalable Width depending on screen size
MSC_Height     := (A_ScreenHeight/8) 												                 ;~ Scalable Width depending on screen size
MSC_Margin     := 16
MSC_IconSize   := IconW := IconH := 32

;~ IniRead, Img, C:\AHK Scripts\_Master Script\Resources\Icons.ini, Icons,% Icon,0							  ;~ Read Ini file of B64 Icons
;~ Images[Icon]:=Img

Img := Icon_MSCDefault

;~ Standard GUI
Gui, Margin, , % MSC_Margin
Gui, Color, 1d1f21, 282a2e
Gui, +AlwaysOnTop -SysMenu +ToolWindow -caption +Border hwndMSC_GUI									  ;~ Removes header/toolbar/menu from IE Window

IE := FixIE(11)
Gui,Add,ActiveX,vWB w%MSC_Height% h%MSC_IconSize% hwndhID,mshtml										  ;~ The final parameter "mshtml" is the name of the ActiveX component
FixIE(IE)
HTML=
(
	<body style='margin:0px; background-color:%MSC_Background%;color:%MSC_Color%;font-size:%MSC_FontSize%; font-family:%MSC_Font%;'>
		<div style='width:%MSC_Width%px;height:%IconH%px;%Gradient%;'>
			<img align='middle' style='width:%IconW%px;height:%IconH%px;'>
				<span style='Margin-Left:8px;'>%MSC_Title%</span>
			</img>
		</div>
	</body>
)
wb.Navigate("about:" HTML)                                                                                      ;~ Travel to the made up page variable "HTML" that we created above
while(wb.ReadyState!=4)
	Sleep,10
if (StrLen(Img)>1000)                                                                                           ;~ Dirty way of comparing B64 string vs simple ICO/PNG Dir Path String Length
	wb.Document.GetElementsByTagName("Img").Item[0].src:="data:image/png;base64," Img                          ;~ Giving the IMG tag the Base64 IMG
else
	wb.Document.GetElementsByTagName("Img").Item[0].src:= Img                                                  ;~ Giving IMG tag the PNG/ICO
Width := wb.Document.GetElementsByTagName("span").Item[0].GetBoundingClientRect().Width                         ;~ Getting auto width based on title length
Width := wb.Document.GetElementsByTagName("Div").Item[0].Style.Width := Width+StrLen(MSC_Title)+IconW           ;~ Grab div > style > width and the width = width set above + 84px
GuiControl, Move, % hID, % "Section " "w" Width "h" MSC_IconSize "x" ((MSC_Width-Width)/2)+(IconW/2)

Gui, Font, s10, Segoe UI
Gui, Add, Edit, xs w%MSC_Width% cc5c8c6 -E0x200 vMasterScriptCommands gFindus HWNDQueryEditField                ;~ Search edit field
SendMessage 0x1501, 1, "Search",, ahk_id %QueryEditField%                                                       ;~ EM_SETCUEBANNER -- Add "Search" blank to the edit field.

;~ Search Engine GUI Params
Gui, Add, Text, xs-(%IconW%/2) w%MSC_Width% -E0x200 %cYellow% +Center vGui_Search_title_var, %gui_search_title% ;~ Edit "What would you like to search?" Text
Gui, Add, Edit, xs w%MSC_Width% -E0x200 %cYellow% vgui_SearchEdit -WantReturn hWndhEdtValue2 
SendMessage 0x1501, 1, "Search",, ahk_id %hEdtValue2%                                                           ;~ EM_SETCUEBANNER -- Add "Search" blank to the edit field.
GuiControl, Hide, Gui_Search_title_var
GuiControl, Hide, gui_SearchEdit

;~ Gui Intellisense Listbox
Gui, Font, s10 cffffff, Consolas
Gui, Color, 0x1d1f21, 0x1d1f21
Gui, Add, ListBox, xs y100 w%MSC_Width% h%MSC_Height% vGui_Display -HScroll +VScroll +0x300000 -E0x200 Choose1 HWNDGUI_Intel_Edit_Field,									;~ Listbox
Gui +Delimiter`n 																															;~ Listbox will search through for line breaks instead of default "|"
GuiControl,, Gui_Display, 																       ;~ If Query field is blank then show NOTHING
GuiControl, Hide, Gui_Display 																												;~ Hide Intellisense Box until called upon
Gui, Add, Button, Hidden Default, OK
Gui, Show, AutoSize, MasterScriptCommands
MSC_RoundedEdges(MSC_GetGuiSize().w,MSC_GetGuiSize().h)
Return