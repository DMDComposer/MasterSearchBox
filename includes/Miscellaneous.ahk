/*
	; Allow normal CapsLock functionality to be toggled by Alt+CapsLock:
	!CapsLock::
	GetKeyState, capsstate, CapsLock, T ;(T indicates a Toggle. capsstate is an arbitrary varible name)
	if capsstate = U
		SetCapsLockState, AlwaysOn
	else
		SetCapsLockState, AlwaysOff
	return
*/

MSC_RoundedEdges(w,h){
	Global MSC_Radius, MSC_GUI
	GUI +LastFound
	WinSet, Region, 0-0 w%w% h%h% R%MSC_Radius%
}

levenshtein_distance( s, t )
{
  n := strlen(s)
  m := strlen(t)

  if( n != 0 and m != 0 )
  {

    m++
    n++
    d0 = 0 ; Because A_index starts at 1, we emulate a for loop by hardcoding the first repetition

    Loop, %n%
      d%A_Index% := A_Index

    ; I would emulate the first repetition here, but it just sets d0 = 0
    Loop, %m%
    {
      temp1 := A_Index * n
      d%temp1% := A_Index
    }
    B_Index := 0
    Loop, %n%
    {
      B_Index++
      Loop, %m%
      {
        temp1 := B_Index
        temp2 := A_Index
        StringMid, tempA, s, temp1, 1
        StringMid, tempB, t, temp2, 1
        ;MsgBox, Comparing %tempA% and %tempB%
        if( tempA == tempB )
          cost := 0
        else
          cost := 1
        temp1 := A_Index * n + B_Index
        temp2 := (A_Index - 1) * n + B_Index
        temp3 := A_Index * n + B_Index - 1
        temp4 := (A_Index - 1) * n + B_Index - 1
        d%temp1% := minimum( d%temp2%+1 , d%temp3%+1 , d%temp4%+cost )
      } ;Loop, m
    } ;Loop, n
    temp1 := n*m - 1
    distance := d%temp1%
    return distance
  } ;if
  else
    return -1
}

minimum( a, b, c )
{
	min := a
	if(b<min)
		min := b
	if(c<min)
		min := c
	return min
}


; A function to escape characters like & for use in URLs.
uriEncode(str) {
	f = %A_FormatInteger%
	SetFormat, Integer, Hex
	If RegExMatch(str, "^\w+:/{0,2}", pr)
		StringTrimLeft, str, str, StrLen(pr)
	StringReplace, str, str, `%, `%25, All
	Loop
		If RegExMatch(str, "i)[^\w\.~%/:]", char)
			StringReplace, str, str, %char%, % "%" . SubStr(Asc(char),3), All
	Else Break
		SetFormat, Integer, %f%
	Return, pr . str
}

MoveWindowtoCenter(Window:="A"){
	WinGet, winState, MinMax, %Window%
	If (winState = -1) {
		WinRestore % Window
		WinActivate
		WinExist(Window)
		WinGetPos,,, sizeX, sizeY
		WinMove, (A_ScreenWidth/2)-(sizeX/2), (A_ScreenHeight/2)-(sizeY/2)
	}
	
	else if (winState = 1) {
		WinRestore % Window
		WinExist(Window)
		WinGetPos,,, sizeX, sizeY
		WinMove, (A_ScreenWidth/2)-(sizeX/2), (A_ScreenHeight/2)-(sizeY/2)
		WinMaximize
	}
	
	else if (winState = 0) {
		WinExist(Window)
		WinActivate
		WinGetPos,,, sizeX, sizeY
		WinMove, (A_ScreenWidth/2)-(sizeX/2), (A_ScreenHeight/2)-(sizeY/2)
	}
	Return
}

Command_Gui(Info){
	Static VectorImage:= ComObjCreate("WIA.Vector"),wb,Images:=[]
	for a,b in {Title:"",Background:"#666666",Color:"#FFFFFF",SleepTimer:"-1500",Icon:"",Gradient:""}
		if(!Info[a])
			Info[a]:=b
	if((!Img:=Images[Info.Icon])&&Info.Icon){
		IniRead, Img, C:\AHK Scripts\_Master Script\Resources\Icons.ini, Icons,% Info.Icon,0
		Images[Info.Icon]:=Img
	}
	Gui,Destroy
	Gui, +LastFound +AlwaysOnTop -Caption +ToolWindow hwndCGUI			;~ avoids a taskbar button and an alt-tab menu item.
	Gui,Margin,0,0
	IE:=FixIE(11)
	Gui,Add,ActiveX,vwb w400 h64 hwndID,mshtml
	FixIE(IE)
	Background:=Info.Background,Color:=Info.Color,Gradient:=(Info.Gradient?"background: linear-gradient" Info.Gradient:""),Title:=Info.Title
	HTML=
	(
	<body style='margin:0px; background-color:%Background%;color:%Color%;font-size: 42.66px; font-family:MS Shell Dlg'>
		<div style='width:%A_ScreenWidth%px;%Gradient%;'>
			<img align='middle'>
				<span style='Margin-Left:8px'>%Title%</span>
			</img>
		</div>
	</body>
	)
	wb.Navigate("about:" HTML)
	while(wb.ReadyState!=4)
		Sleep,10
	;~ m(wb.Document.GetElementsByTagName("div").item[0].OuterHTML)
	/*
		Gui, Color, % Trim(GUIColor,"#") 							;~ Change Color of Gui
		Gui, Font, s32 										;~ Set a large font size (32-point).
		Gui,Add,Text,% "x+15 yp+7 c" Trim(GUITextColor,"#"),%GUITitle%   ;~ Change color of Text | GUITitle "x+m creates new position based off previous control plus the margin"
	*/
	;~ m(wb.Document.Body.OuterHTML)
	wb.Document.GetElementsByTagName("Img").Item[0].src:="data:image/png;base64," Img
	Width:=wb.Document.GetElementsByTagName("span").Item[0].GetBoundingClientRect().Width
	wb.Document.GetElementsByTagName("Div").Item[0].Style.Width:=Width+84
	GuiControl, Move, %ID%, % "w" Width+84
	SysGet,Monitor,MonitorWorkArea
	Y:=MonitorBottom-104,X:=MonitorLeft
	Gui, Show, % "x" X " y882 y" Y " w" Width+84 " NoActivate"  		;~ NoActivate avoids deactivating the currently active window.
	SetTimer, Gui_Close, % Info.Sleeptimer 							;~ Sets timer until GUI disappears
	Return
}

Gui_Close(){
	Gui, Destroy
	Return
}

Base64ToComByteArray(B64){  									; By SKAN / Created: 21-Aug-2017 / Topic: goo.gl/dyDxBN 
	static CRYPT_STRING_BASE64:=0x1
	local Rqd:=0,BLen:=StrLen(B64),ByteArray:=""
	if(DllCall("Crypt32.dll\CryptStringToBinary","Str",B64,"UInt",BLen,"UInt",CRYPT_STRING_BASE64,"UInt",0,"UIntP",Rqd,"Int",0,"Int",0))
		ByteArray:=ComObjArray(0x11,Rqd),DllCall( "Crypt32.dll\CryptStringToBinary", "Str",B64, "UInt",BLen, "UInt",CRYPT_STRING_BASE64, "Ptr",NumGet( ComObjValue( ByteArray ) + 8 + A_PtrSize ), "UIntP",Rqd, "Int",0, "Int",0 )
	return ByteArray
}

FixIE(Version=0){
	static Key:="Software\Microsoft\Internet Explorer\MAIN\FeatureControl\FEATURE_BROWSER_EMULATION",Versions:={7:7000,8:8888,9:9999,10:10001,11:11001}
	Version:=Versions[Version]?Versions[Version]:Version
	if(A_IsCompiled)
		ExeName:=A_ScriptName
	else
		SplitPath,A_AhkPath,ExeName
	RegRead,PreviousValue,HKCU,%Key%,%ExeName%
	if(!Version)
		RegDelete,HKCU,%Key%,%ExeName%
	else
		RegWrite,REG_DWORD,HKCU,%Key%,%ExeName%,%Version%
	return PreviousValue
}

Focus_Send(Info){
	for a,b in {Window:"",Keys:"",Title:"",Background:"#666666",Color:"White",TitleMatchMode:"Fast",Focus:"0",Icon:"",Gradient:"",Sleep:"-1500"}
		if(!Info[a])
			Info[a]:=b
	Static Mode:=A_TitleMatchMode
	if(Info.Focus){
		WinGetActiveTitle, FocusWindow
	}
	if(Info.TitleMatchMode){
		SetTitleMatchMode, % Info.TitleMatchMode
	}	
	if(WinExist(Info.Window)){
		WinActivate,% Info.Window
		WinWaitActive,% Info.Window
		if(Info.Title){
			Command_Gui({Title:Info.Title,Background:Info.Background,Color:Info.Color,SleepTimer:Info.Sleep,Icon:Info.Icon,Gradient:Info.Gradient})
		}		
		if(Info.Keys){
			Send,% Info.Keys
		}
	}
	SetTitleMatchMode,%Mode% ;~ Resets TitleMatchMode	
	if(Info.Focus)
		WinActivate,%FocusWindow%
	Return
}

AHKPastebin(Content,Name:="",Notify:=1,Run:=0){
	HTTP:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	HTTP.Open("POST","https://p.ahkscript.org/", False)
	HTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
	HTTP.Send("code=" UriEncode(Content) "&name=" UriEncode(Name) "&channel=#ahkscript")
	if HTTP.Status()!=200{ ;~ If not okay
		MsgBox Something went wrong
		Return
	}
	If (Notify)
		Notify().AddWindow(Content,{Time:3000,Icon:300,Background:"0x1100AA",Icon:14,Title:"Added to pastebin at: " HTTP.Option(1),TitleSize:18,size:14,TitleColor:"0xFF0000"})
	If (Run)
		Run % HTTP.Option(1) ;~ URL
	Return HTTP.Option(1) ;~ Return URL
}

Toggle_App(app, location) 
{
	if WinExist(app)   
	{
		if !WinActive(app)
			WinActivate
		else
			WinMinimize
	}
	else if location != ""
		Run, % location
}

st_columnize(data, delim="csv", justify=1, pad=" ", colsep=" | ")
{		
	widths:=[]
	dataArr:=[]
	
	if (instr(justify, "|"))
		colMode:=strsplit(justify, "|")
	else
		colMode:=justify
	; make the arrays and get the total rows and columns
	loop, parse, data, `n, `r
	{
		if (A_LoopField="")
			continue
		row:=a_index
		
		if (delim="csv")
		{
			loop, parse, A_LoopField, csv
			{
				dataArr[row, a_index]:=A_LoopField
				if (dataArr.maxindex()>maxr)
					maxr:=dataArr.maxindex()
				if (dataArr[a_index].maxindex()>maxc)
					maxc:=dataArr[a_index].maxindex()
			}
		}
		else
		{
			dataArr[a_index]:=strsplit(A_LoopField, delim)
			if (dataArr.maxindex()>maxr)
				maxr:=dataArr.maxindex()
			if (dataArr[a_index].maxindex()>maxc)
				maxc:=dataArr[a_index].maxindex()
		}
	}
	; get the longest item in each column and store its length
	loop, %maxc%
	{
		col:=a_index
		loop, %maxr%
			if (strLen(dataArr[a_index, col])>widths[col])
				widths[col]:=strLen(dataArr[a_index, col])
	}
	; the main goodies.
	loop, %maxr%
	{
		row:=a_index
		loop, %maxc%
		{
			col:=a_index
			stuff:=dataArr[row,col]
			len:=strlen(stuff)
			difference:=abs(strlen(stuff)-widths[col])
			
			; generate a repeating string about the length of the longest item
			; in the column.
			loop, % ceil(widths[col]/((strlen(pad)<1) ? 1 : strlen(pad)))
				padSymbol.=pad
			
			if (isObject(colMode))
				jmustify:=colMode[col]
			; justify everything correctly.
			; 3 = center, 2= right, 1=left.
			if (strlen(stuff)<widths[col])
			{
				if (justify=3)
					stuff:=SubStr(padSymbol, 1, floor(difference/2)) . stuff
					. SubStr(padSymbol, 1, ceil(difference/2))
				else
				{
					if (justify=2)
						stuff:=SubStr(padSymbol, 1, difference) stuff
					else ; left justify by default.
						stuff:= stuff SubStr(padSymbol, 1, difference) 
				}
			}
			out.=stuff ((col!=maxc) ? colsep : "")
		}
		out.="`r`n"
	}
	stringTrimRight, out, out, 2 ; remove the last blank newline
	return out
}

/*
	DMD_Ini2Obj(Ini_File){ 
		; return 2D-array from INI-file: https://www.autohotkey.com/boards/viewtopic.php?p=256940&sid=7630b8496d3e9b93f364b58ecbf35914#p256940
		Result := []
		IniRead, SectionNames, % INI_File
		for each, Section in StrSplit(SectionNames, "`n") {
			IniRead, OutputVar_Section, % INI_File, % Section 
			for each, Haystack in StrSplit(OutputVar_Section, "`n")
				RegExMatch(Haystack, "(.*?)=(.*)", $)
			  , Result[Section, $1] := $2
		}
		Return Result
	}
	
*/

RemoveExtraSpaces(string) {
	Return Trim(RegExReplace(string, "\h\K\h+"))
}

/*
	DMD_RunShortcut(Program, Icon:="C:\Program Files\AutoHotkey\AutoHotkey.exe", IconNumber:=2){
		SplitPath, Program, Name, Dir, EXT, NNE, Drive 												; for each item in array, split the path to corresponding variables
		ShortcutDir := "C:\AHK Scripts\_DMD Scripts\Run Shortcuts"
		Shortcut    := ShortcutDir . "\" . NNE . ".lnk"
		UI_Path     := (A_PtrSize != 4 ? "C:\Program Files\AutoHotkey\AutoHotkeyU64_UIA.exe" : "C:\Program Files\AutoHotkey\AutoHotkeyA32_UIA.exe") ;~ If AHK in 64 than run 64, else run 32 bit
		If FileExist(Shortcut){
			FileGetShortcut, % Shortcut, vTarget, vDir, vArgs, vDesc, vIcon, vIconNum, vRunState
			if StrReplace(vArgs, chr(34), "") != Program ;~ Does the path = the destintation of the shortcut (removing the double quotes from command)
			{
				FileDelete, % Shortcut
				While FileExist(Shortcut) ;~ Wait for file to be removed before creating
					Sleep, 100			
				FileCreateShortcut, % UI_Path, % Shortcut, % Dir, % Chr(34) Program Chr(34),, % Icon,, % IconNumber		; Shortcut UI has to go first to tell it to launch UI on to target Shortcut
				While !FileExist(Shortcut) 																;~ Wait til file exists to Run
					Sleep, 100
			}
			Run, % Shortcut
			Return 																			;~ Makes it so if the file exist the script ends here, otherwise it'll continue below
		}
		FileCreateShortcut, % UI_Path, % Shortcut, % Dir, % Chr(34) Program Chr(34),, % Icon,, % IconNumber		; Shortcut UI has to go first to tell it to launch UI on to target Shortcut
		While !FileExist(Shortcut) 																;~ Wait til file exists to Run
			Sleep, 100
		Run, % Shortcut
	}
	
*/
MSC_GetGuiSize(){
	WinGetPos, x, y, w, h, MasterScriptCommands
	Return {x:x,y:y,w:w,h:h}
}

MSC_KeybindFocus(Enter := 0){
	Global GUI_Intel_Edit_Field, QueryEditField
	ControlFocus, , ahk_id %GUI_Intel_Edit_Field%
	Gui, Submit, NoHide
	if(Enter == 1)
		SendInput, {Enter}
	ControlFocus, , ahk_id %QueryEditField%
}

getFokus(){
	GuiControlGet, hmm, Focus
	GuiControlGet, out, Hwnd , % hmm
	return out
}

MSC_Title(MasterScriptCommands, Dir){
	Static oArray := []
	Loop, read, % Dir
	{
		StringCaseSense, Off 
		If SubStr(A_LoopReadLine, 1, 1) != ";" 								;~ Do not display commented commands
		{
			If A_LoopReadLine contains MasterScriptCommands =		
			{
				
				Trimmed 	:= StrSplit(A_LoopReadLine,"MasterScriptCommands = ") 	;~ Find each line with a "command =" in it
				Comment 	:= StrSplit(A_LoopReadLine, "`;~ ")	
				;~ oData 	.= SubStr(Trimmed.2,1,3) A_Space SubStr(Trimmed.2,7) 		;~ Trim line down to just command + comment
				;~ oData 	.= "`n" 										;~ Breaking each command into a new line
				oArray.Push(StrSplit(Trimmed.2,Chr(34)).2)					;~ Show Command 3 Digit Number				
				oArray.Push(Comment.2)									;~ Only show Title no ";~"
			}
			
		}
	}
	for a, b in oArray { 												;~ For Next Loop
		if (b = MasterScriptCommands)
		{
			Return oArray[A_Index+1]
		}
	}
}

HttpQuery(url) {
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", url, true)
	whr.Send()
	whr.WaitForResponse()
	status := whr.status
	if (status != 200)
		throw "HttpQuery error, status: " . status
	Return whr.ResponseText
}

EncodeDecodeURI(str, encode := true, component := true) {
	static Doc, JS
	if !Doc {
		Doc := ComObjCreate("htmlfile")
		Doc.write("<meta http-equiv=""X-UA-Compatible"" content=""IE=9"">")
		JS := Doc.parentWindow
	}
	Return JS[ (encode ? "en" : "de") . "codeURI" . (component ? "Component" : "") ](str)
}