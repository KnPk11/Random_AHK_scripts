; Stealthy system locker v1.1.2

; Forget about locking your PC when you leave your desk. This sneaky script will monitor your computer and lock if it detects usage after some inactivity
; If it detects sufficient mouse movement after a period of inactivity, it asks for a password/short key combo (allowing 5-10 seconds to type it), before promptly locking the machine

; Has two modes
; 1) Normal - a visual pop-up box to type in the password
; 2) Stealth - no clues whatsoever; the password needs to be typed blindly (blocks input to other applications), else the session gets locked abruptly

; Notes:
; The key combos occasionally don't work with certain programs in focus - maybe they're hijacking the keys
; Run, %comspec% /c powercfg /change /monitor-timeout-ac 0  ; Turn off screensavers (in minutes: 0 = immediate)

; USAGE
; -------------
; RAlt & F9:	Arm - start monitoring for mouse movement immediately (without waiting for inactivity)
; RAlt & F10:	Switch the screen off and start monitoring for movement immediately
; RAlt & Esc:	Exit the script (if the correct password is given)

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Persistent ; Prevent the script terminating once the last command is reached - always keep in memory
#SingleInstance force ; Allow only single instance of the script to run at any time
#NoTrayIcon ; Hide tray icon, else it'll be easy to kill the program

OnExit, exit_program ; If the program is terminated while the correct password is supplied, go to this procedure

; First phase - check the conditions before executing the second phase
start: 
idle_time = 60000 ; Amount of idle time before the second phase is activated
SetTimer, locker, 200 ; Continuoustly poll locker
Sleep, 1000
; Current lock system lock state
locker: 
{
	If DllCall("User32\OpenInputDesktop","int",0*0,"int",0*0,"int",0x0001L*1) ; Id Windows is not already locked (ctrl + alt + del screen behaves as if the system is locked)
	{
		IfGreater, A_TimeIdle, %idle_time% ; If enough idle time has passed. (A_TimeIdlePhysical doesn't seem to work with user input)
		{
			SetTimer, locker, off ; Switch the timer that checks the lock state off
			GoTo start2
		}
		Else
		{
			SetTimer, locker, off ; If not enough idle time has passed, restart the timer
			GoTo start
		}
	}
	Else
	{
		SetTimer, locker, off ; If the system is already locked, keep resetting the timer
		GoTo start
	}
}

; Second phase, compares mouse coordinates to the last coordinates, that's how it detects activity
start2:
MouseGetPos, X1, Y1 ; Initial mouse coordinates before triggering
{
	Loop:
	Sleep, 250
	MouseGetPos, X2, Y2 ; Get mouse coordinates again
	If (X2 > X1 - 75 && X2 < X1 + 75 && Y2 > Y1 - 75 && Y2 < Y1 + 75) ; Compare new coordinates to the old ones
	{
		GoTo Loop ; Tiny deviations are allowed, keep checking
	}
	Else
	{
		InputBox, password, "Your password", , HIDE, 200, 100, , , , 10,  ; Output a password box window
		;Input, password, T10 L4 C V, , -= ; Don't output any windows, user needs to type the correct key combination within x amoun of seconds
		If (password = "-=") ; Password is correct
		{
			Reload ; Restart monitoring
			ExitApp
		}
		Else ; Password incorrect
		{
			DllCall("LockWorkStation") ; Lock the computer
			Reload ; Restart monitoring
			ExitApp
		}
	}
}

; The key combos occasionally don't work with certain programs in focus - maybe they're hijacking the keys
RAlt & F9::start_monitoring_immediately() ; Arm - start monitoring for movement immediately (without waiting for inactivity)

start_monitoring_immediately()
{
	SetTimer, locker, off ; Jump straight to the second phase
	GoSub, start2
}

RAlt & F10::start_monitoring_immediately2() ; Switch the screen off and start monitoring for movement immediately

start_monitoring_immediately2()
{
	Sleep, 1000 ; Wait a little to ensire the screen is not immediately woken back by the ame key combo
	SendMessage, 0x112, 0xF170, 2,, Program Manager ; Turn the screen off
	SetTimer, locker, off ; Go to the second phase
	GoSub, start2
}

RAlt & Esc::Function_kill() ; Exit the program

Function_kill()
{
	ExitApp ; Check for the correct password before exiting the program
}

; Execute this on program exit
; Bear in mind that killing the process in the taskbar will instantly bypass the password
exit_program:
InputBox, password, "Your password", , HIDE, 200, 100, , , , 5,  ; Output a password box window
;Input, password, T5 L4 C V, , -= ; Don't output any windows, user needs to type the correct key combination within x amoun of seconds
If (password = "-=") ; Password is correct
{
	ExitApp ; Exit out
}
Else ; Password incorrect
{
	DllCall("LockWorkStation") ; Lock the computer
	Reload ; Restart monitoring
	ExitApp
}