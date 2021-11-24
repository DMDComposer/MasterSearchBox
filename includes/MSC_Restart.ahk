; MSC [standalone script]
; Purpose: Restart MSC
; This should prevent "Could not close the previous instance of this script. Keep waiting?"
; This can potentially happen when running the script from a cloud-folder (say dropbox)
; which could be slow with saving bundles.
; References:
; https://github.com/MSC/MSC/issues/127#issuecomment-496279719 and
; https://github.com/MSC/MSC/issues/114
; Bug fix: %A_AhkPath% https://github.com/MSC/MSC/issues/163

#NoEnv
#SingleInstance, force
SetBatchLines, -1
DetectHiddenWindows, On
SetTitleMatchMode, 2
;~ Menu, Tray, Icon, icons\MSC_suspended.ico ; while loading show suspended icon
Menu, Tray, Tip, Restarting Master Commands...

SetWorkingDir, %A_ScriptDir%\..

SplitPath, A_ScriptDir, , MSCFolder

WinClose, %MSCFolder%\Master Search Box.ahk
While WinExist("Master Search Box.ahk ahk_class AutoHotkey") {
	Sleep, 1000 
}
Run *RunAs %A_AhkPath% "%MSCFolder%\tmpscrpts\restarttmp.ahk"
Sleep 1000
FileDelete, %MSCFolder%\tmpscrpts\restarttmp.ahk
If !WinExist("AHK Studio ahk_exe AutoHotkeyU32.exe")
	Run *RunAs "C:\AHK Studio\AHK-Studio.ahk"
ExitApp
