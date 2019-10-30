; Updated: 2019-10-30

; Toggle pausing a script
`::pause, toggle

; Easily exit the script
{Escape}::ExitApp

; Easily reload the script with changes
+::Reload

; '$' is used to make sure any key pressed doesn't invoke identical keys resulting in an endless loop (eg a::b sends b, which sends a, which sends b again, and so on...)
$a::b

; Mouse functions
mouse_click(x, y)
{
    Random, n, 50, 200
    Random, s, 5, 20
    MouseMove, % x, % y, % s
    Send {LButton down}
    Sleep, %n%
    Send {LButton up}
}

; Kystroke functions
enter(key)
{
    Random, n, 50, 100
    Send {%key% down}
    Sleep, %n%
    Send {%key% up}
}

; Get pixel colour properties
MouseGetPos, x, y 
PixelGetColor, Pixel, % x, % y
MsgBox, %x%, %y%, %Pixel%

; Closing multiple nuisance windows
GroupAdd, Nuisance, This is an unregistered copy
GroupAdd, Nuisance, Microsoft Office Activation Wizard

Restart:
SetTitleMatchMode, Slow
WinWaitActive, ahk_group Nuisance
WinClose
GoTo Restart

; An alternative function for pausing the script
`::Function_Pause()

Function_Pause()
{
	If A_IsPaused = 0
		Pause, ON
		MsgBox, Paused
	If A_IsPaused != 0
		Pause, Off
		MsgBox, Unpaused
}

; Copy, reprocess in-memory, paste the new text. For example replace the line-breaks
`::function_tablename()

function_tablename()
{
	Send, {LButton 2}
	Send, ^c
	ClipWait
	replaced_string := StrReplace(Clipboard, "`r`n", "")
	Clipboard := replaced_string
    Send, ^v
}
