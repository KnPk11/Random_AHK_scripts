; This script/module shows a GUI with the current mouse position as a % of x & y coordinates
; Reuse it; change it to display pixel value or whatever you prefer

; v1.00


#SingleInstance ; Allow only single instance of the script to run at any time

CoordMode, Mouse, Screen ; Set mouse coordinates to be relative to the screen
SysGet, Mon1, Monitor, 1 ; Retrieves screen resolution, multi-monitor info
Gui, -Caption +ToolWindow +AlwaysOnTop +LastFound ; Create a GUI popup that displays the current coordinates
Gui, Margin, 1, 1 ; Set the margin/spacing used
Gui, Font, cRed ; Set thefont colour
Gui, Add, text, vVar, x:00000  y:00000 ; Define the initial text
Gui, Show, ,moving_GUI-= ; Show the GUI
SetTimer, watch_cursor, 1 ; Set the GUI update timer


watch_cursor:
MouseGetPos, nX, nY ; Get the current mouse position
; Logic to convert the coordinate numbers to %
1pctX := (Mon1Right / 100)
1pctY := (Mon1Bottom / 100)
nXP := ((nX + 1pctX * 2.5) / Mon1Right * 10 * 2)
nYP := ((nY + 1pctY * 2.5) / Mon1Bottom * 10 * 2)
nXP2 := Floor(nXP)
nYP2 := Floor(nYP)
nXP3 := nXP2 * 10 / 2
nYP3 := nYP2 * 10 / 2
nXP4 := Round(nXP3, 0)
nYP4 := Round(nYP3, 0)
If (StrLen(nXP4) = 1) ; 0 padding
nXP4 = 00%nXP4%
If (StrLen(nYP4) = 1)
nYP4 = 00%nYP4%
If (StrLen(nXP4) = 2)
nXP4 = 0%nXP4%
If (StrLen(nYP4) = 2)
nYP4 = 0%nYP4%
GuiControl,,Var,x:%nXP4%`%    y:%nYP4%`% ; Output mouse position in % values
RegExReplace(nXP4,"\d","",count) ; Calibrate the GUI position based on how long it is; how many digits are appear (5% vs 50%)
xOffset := (count * 5) ; Shift the GUI a little to ensure it's central along x-axis relative to the base of the mouse cursor, not the tip
If (nXP4 = 100 && nYP4 = 100) ; If mouse is in the bottom-right corner, shift the GUI top-left
{
	WinMove, moving_GUI, , nX - 55 - xOffset, nY - 20
	Return
}
If (nXP4 = 0 && nYP4 = 100) ; If mouse is in the bottom-left corner, shift the GUI top-right
{
	WinMove, moving_GUI, , nX + 5 - xOffset, nY - 20
	Return
}
IfEqual, nXP4, 0 ; If mouse is at the left edge of the screen, shift the GUI right
{
	WinMove, moving_GUI, , nX + 5 - xOffset, nY + 20
	Return
}
IfGreaterOrEqual, nXP4, 100 ; If mouse is at the right edge of the screen, shift the GUI left
{
	WinMove, moving_GUI, , nX - 55 - xOffset, nY + 20
	Return
}
IfGreaterOrEqual, nYP4, 100 ; If mouse is at the bottom edge of the screen, shift the GUI up
{
	WinMove, moving_GUI, , nX - 22 - xOffset, nY - 20
	Return
}
Else ; In all other cases don't shift the GUI
{
	WinMove, moving_GUI, , nX - 14 - xOffset, nY + 20
	Return
}

Esc::ExitApp ; Hotkey to terminate