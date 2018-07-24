; This script allows quickly navigating database objects (tables, stored procedures, views, functions) in the object explorer
; Useful for scripts that involve a lot of tables/SPs, etc. ALso very useful when generating long SQL upgrade scripts
; Usage: double-click an object name and activate the required shortcut

LAlt & F2::function_localDBsearch() ; mode for the locally installed SQL server - hooks to the program by window title
LAlt & F3::function_productionDBsearch() ; mode for the 'production' SQL server (administered remotely). Less reliable than the first mode.

function_localDBsearch(){
Clipboard := 
;MouseClick, left, , , 2
Send, ^c
ClipWait
SearchString := Clipboard
StringReplace, SearchString, SearchString, [, , All ; strip of []
StringReplace, SearchString, SearchString, ], , All
Stringleft, SearchString, SearchString, 100 ; limit to 100 characters
SetTitleMatchMode, 2
IfWinExist, Generate and Publish Scripts ; if the 'Generate and Publish Scripts' window is open, search there instead. For creating release scripts.
{
	WinActivate, Generate and Publish Scripts
	GoTo skipSQLManagementStudio
}
IfWinExist, Microsoft SQL Server Management ; under ordinary circumstances, navigate database object in the object explorer
{
	WinActivate, Microsoft SQL Server Management
	Send, {F8} ; shortcut needs to be active in SQL server to be able to activate the object explorer
}
skipSQLManagementStudio:
SearchString = dbo.+%SearchString% ; assuming a schema name .dbo
Send, %SearchString%
Sleep, 50
return
}

function_productionDBsearch(){
Clipboard := 
;MouseClick, left, , , 2
Send, ^c
ClipWait
SearchString := Clipboard
StringReplace, SearchString, SearchString, [, , All
StringReplace, SearchString, SearchString, ], , All
Stringleft, SearchString, SearchString, 100
SetTitleMatchMode, 2
IfWinExist, Remote Desktop Connection Manager ; Change this to the title of your remote connection manager
{
	WinActivate, Remote Desktop Connection Manager
	Send, {F8}
}
SearchString = dbo.+%SearchString%
Send, %SearchString%
Sleep, 50
;Send, {Space}
return
}