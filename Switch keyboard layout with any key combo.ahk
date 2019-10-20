; Allows assigning any custom key combination to switch keyboard layouts (Windows 10 has limited the key combinations)
; Also can be useful for machines with more than 2 layouts where Shift + Tab is not enough to quickly switch between two layouts (have to cycle through all layouts)
; You might want to compile it to an executable to be able to use as a standalone program

; v1.0

; Usage: Alt + 1,2,3...

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

<!1::function_en()
<!2::function_ru()

function_en()
{
	en := DllCall("LoadKeyboardLayout", "Str", "00000809", "Int", 1) ; English (UK) layout
	PostMessage 0x50, 0, %en%,, A
	Return
}

function_ru()
{
	ru := DllCall("LoadKeyboardLayout", "Str", "00000419", "Int", 1) ; Russian (Russia) layout
	PostMessage 0x50, 0, %ru%,, A
	Return
}