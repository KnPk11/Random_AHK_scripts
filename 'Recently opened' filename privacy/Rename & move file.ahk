; This script allows renaming & moving specific files prior to opening for confidentiality (without having to suspiciously clear & switch off recent file history)

; v 1.0.1

; Considerations:
; Files should be opened from within Windows explorer, not from Desktop, because the script copies file path from the explorer's address box (there must be a more native system way of renaming files)
; The script is currently unable to differentiate between files of identical names but different extensions
; Also the script doesn't work with network addresses such as \\path\
; The script is able to send correct Windows shortcuts only whily using an english keyboard, so it automatically switches to that before launching

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;#NoTrayIcon ; Hide tray icon
#SingleInstance force ; Allow only one script to run at anytime

OnExit, Exit

en := DllCall("LoadKeyboardLayout", "Str", "00000809", "Int", 1)
PostMessage 0x50, 0, %en%,, A
Input, Confirmation, T3 L10, , # ; Key to confirm activating the script; if not pressed quickly enough, the script exits without activating
If (Confirmation = "#")
{
	GoTo, Continue ; Continue execution
}
Else
{
	GoTo, Exit ; Else exit the script
}

Continue:
SetTimer, Exit, 10800000 ; Also auto-close the script after couple of hours after first runtime

RAlt:: ; Executes a separate script for the actual renaming
en := DllCall("LoadKeyboardLayout", "Str", "00000809", "Int", 1)
PostMessage 0x50, 0, %en%,, A
Run %A_ScriptDir%\rmprocess.exe
Return ; Back to the initial monitoring state

RAlt & Esc::ExitApp ; Key combo to shut the script down

; On exit check if the renamig script is by any chance active, and also shut it down
Exit:
Process, Close, rmprocess.exe
ExitApp
