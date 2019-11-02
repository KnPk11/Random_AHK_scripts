; v 1.0.1

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#MaxThreads 10 ; How many simultaneous copies of this script are allowed to run (files opened)
#SingleInstance off ; Each file uses a different thread
#NoTrayIcon

; Get file's properties
; ====================================
Clipboard = ; Empty the clipboard
Send, {F2} ; Highlight the file name
Send, ^c ; Copy the name to clipboard
ClipWait ; Wait for clipboard to be populated for reliability
original_filename := Clipboard
Sleep, 100
Send, {Escape} ; Exit working with the filename
;Send, !d ; Move to the explorer address bar and select everything (Windows 7)
Send, ^l ; Move to the explorer address bar and select everything (Windows 10)
Clipboard = 
Send, ^c ; Copy the file location
ClipWait
original_location := Clipboard
drive_root := RegExMatch(original_location, "^[A-Z]:", Drive) ; Get the root drive folder for the current drive
temp_location = %Drive%
If Drive = ; If wasn't able to identify the drive, exit the script
{
    ExitApp
}
Send, {Escape}
Sleep, 100

; Check what sort of a file we're working with
; =================================================
filetype_array := ["docx","doc","xlsx","xls","txt","jpg","jpeg","png","bmp","mp4","mov","flv","avi", "flv","mp3","wmv","wav","aac","ogg"] ; Supported file extensions (more can be added)
k = 1
; The script can't launch a file without knowing what extension it has; currently all extensions are tried before file existence is confirmed with one of them (unable to differentiate between files of different extensions)
Loop % filetype_array.Length()
{
    extension := filetype_array[k] ; Try every extension
    original_file = %original_location%\%original_filename%.%extension% ; Address, name and extension of our file as a string
    IfExist, %original_file% ; If the file exists with that extension (and name & address)
        GoTo generate_name ; Move to the next section
    k := k + 1
}

IfNotExist, %original_file% ; If no file has been found, exit the script
    ExitApp

; Generate random numbers for our random filename
; ========================================================
generate_name:
	; Generate based from a calendar
    Random, Year, 2006, 2017 
    Random, Month, 01, 12
    If (StrLen(Month) = 1)
        Month = 0%Month% ; Pad with a leading 0
    Random, Day, 01, 30
    If (StrLen(Day) = 1)
        Day = 0%Day%
    file_date = %Year%-%Month%-%Day% ; Final date string
    
	; Generate a random filename from alpha-numerical characters
    Random, l, 3, 6 ; Define filename length
    loop, %l%
    {
        k := 0
        If k < %l%
        {
            Random, choice, 1, 2 ; Randomly chose either one of the following groups
            If choice = 1
            {
                Random, Name_output , 48, 57 ; ASCII-chars for numbers: 1-9
            }
            If choice = 2
            {
                Random, Name_output , 97, 122 ; ASCII-chars for letters: a-z
            }
            Character := Chr(Name_output) ; Convert to the regular character
            random_name = %random_name%%Character% ; Add a string from those random alpha-numerical chars
            k := k + 1
        }
        Else Break ; When the filename length is reached move to the next section
        }
    
    Random, num, 1, 100 ; Generate a random number
    
    ; An array of pre-defined file names to combine with our random generated strings/numbers earlier on
	; Different prefixes are better suited for different extension types
    ; =============================================================
    If (extension = "docx" || extension = "doc")
    {
        array_filename := ["Document1", "Untitled document", "New document", "to-do list", "programs", "Conference notes", "email"]
    }
    Else If (extension = "xlsx" || extension = "xls")
    {
        array_filename := ["Book1", "New spreadsheet", "Finances", "Untitled", "Data", "Finances", "Calculation"]
    }
    Else If (extension = "txt")
    {
        array_filename := ["Untitled", "New text document", "to-do list", "notes"]
    }
    Else If (extension = "jpg" || extension = "jpeg" || extension = "png" || extension = "bmp")
    {
        array_filename := ["snippet[" . num . "]","img_"file_date, "image-"random_name, file_date . "-" . random_name, "image", "Untitled"]
    }
    Else If (extension = "mp4" || extension = "mov" || extension = "flv" || extension = "avi")
    {
        array_filename := ["mov-"random_name, "vid_"file_date, "rec_"file_date, random_name, "video-"num]
    }
    Else If (extension = "mp3" || extension = "wmv" || extension = "wav" || extension = "aac" || extension = "ogg")
    {
        array_filename := ["audio_"random_name, "rec_"file_date, random_name . "-" . num, "Untitled"]
    }
    Else
    {
        array_filename := ["file"] ; Exception
    }
    
check_again:
    
    ; Determining the new filename - the array values have a high to low change of being selected beginning to end
    distribution_value := distribution_random(0,100)
    If distribution_value < 51
        distribution_value := 100 - distribution_value ; Numbers 50 to 100
    
    array_max := array_filename.Length()
    difference := 50/array_max ; Percentage spread of each entry in the filename array
    
    step = 50
    step2 := step + difference
    array_item := 1
    loop, %array_max% ; For all the sample filename items in our array
    {
        ; Does our randomly generated number fall within the initial step values assigned to the first item in the array?
        ; If not, check for the next step values; this will determine what item we'll end up selecting from the array
        If (distribution_value >= step && distribution_value <= step2)
        {
            goto, decide_name
        }
        If (distribution_value > 100) ; Just in case
        {
            array_item := array_max
            goto, decide_name
        }
        step := step + difference
        step2 := step2 + difference
        array_item += 1
    }
    
decide_name: ; Apply the chosen (from the array) filename
    temp_filename := array_filename[array_item]
    temporary_file = %temp_location%\%temp_filename%.%extension% ; Full filepath of the newly renamed file
    
	; Create a log file for troubleshooting
    FormatTime, CurrentDateTime,, yyyy.MM.dd hh.mm.ss ; Date format in the log
    IfNotExist, %temporary_file% ; If another file with an identical name doesn't exist at destionation
    {
        Try ; Try moving our file to the new destination
        {
            FileMove, %original_file%, %temporary_file%
        }
        Catch
        {
            temporary_file = %temp_location%\Documents\%temp_filename%.%extension% ; If not possible to move (maybe due to permissions), create a new folder called "Documents" and place it there
            try
            {
                FileCreateDir, %temp_location%\Documents\
                Sleep, 100
                FileMove, %original_file%, %temporary_file% ; Try moving again
            }
        }
        FileAppend, %CurrentDateTime%: %original_file% -> %drive%\%temp_filename%.%extension%, %original_file%.log ; Create a log file with an identical filename for troubleshooting (logs date when renamed, old/new filename and locations)
    }
    Else
    {
        GoTo check_again ; If another file with an identical name already exists at destination, generate another random name
    }
    
    Sleep, 50
    
	; Exceptions for a few filetypes that govern how they should be opened
    If (extension = "txt")
        GoTo, text_file
    If (extension = "jpg" || extension = "jpeg")
        GoTo, image_file
    
    Run, %temporary_file% ; Open our impersonated file using its standard application
    
    Sleep, 5000
    
    ; Reverting the changes
    ; ========================================================
tryagain:
    Sleep, 2000
    Try
    {
        FileMove, %temporary_file%, %original_file% ; Moves the file back to the original place and renames to the original name as soon as it's no longer locked by the program that was using it
    }
    Catch
    {
        GoTo, tryagain ; If can't move the file, it must still be locked, keep re-trying
    }
    
    FileDelete, %original_file%.log ; If moved back and renamed, we can delete the log file
    
    Sleep, 3000 ; Wait a little before attempting to remove the "Documents" directory (if it was used)
    FileRemoveDir, %temp_location%\Documents, 0 ; Remove the empty "Documents" folder if it exists. 0: do not remove files and sub-directories contained in DirName. In this case, if DirName is not empty, no action will be taken
    ExitApp ; Can exit the script
    
    
    
    ; Exception for .txt files as they're not locked by the application
    ; ========================================
text_file:
txt:
    Run, notepad.exe %temporary_file% ; Open in notepad
    WinWait, %temp_filename%.%extension%, , 5 ; Wait a little before we start monitoring for the title bar name containing the filename
    If ErrorLevel ; If no match is found
        GoTo, again ; Ask user
    Else ; If detected as having opened, start monitoring for closure
        GoTo, wait_close ; Close the file
    
    ; Exception for images as they're not locked by the application
    ; ========================================
image_file:
jpg:
    Run, %temporary_file% ; Open in default application
    WinWait, %temp_filename%.%extension%, , 5
    If ErrorLevel
        GoTo, again
    Else
        GoTo, wait_close
    
    
    ; Dealing with not being able to open the file
    ; ==============================================
again:  ; Ask the user whether to wait a little londer
    MsgBox, 4, , Wait a little longer for the file to open?
    IfMsgBox, Yes
    {
        Sleep, 5000 ; Allow extra time to finally open the file
        GoTo, %extension% ; Restart monitoring for file open for the relevant extension
    }
    IfMsgBox, No
    {
        Try
        {
            FileMove, %temporary_file%, %original_file% ; Revert the filename and location changes
            ExitApp
        }
        Catch
        {
            MsgBox, Unable to revert file location & name ; Let the user know if reverting also failed
        }
    }

    ; Waiting for the file to close
wait_close:
    Sleep, 1000
    WinWaitClose, %temp_filename%.%extension% ; Monitor based on the title bar
    
    ; After the file is closed
    ; ====================================================
    Sleep, 2000 ; Wait a little longer for safety
    Try
    {
        FileMove, %temporary_file%, %original_file% ; Move the file back & revert filename
        FileDelete, %original_file%.log ; If successfully reverted, delete the log file
    }
    Catch
    {
        MsgBox, Unable to revert the filename ; If unsuccessful, display an error and keep the log file to assist recovery
    }
    
    Sleep, 3000 ; Wait a little before removing the empty folder or else it might not delete
    FileRemoveDir, %temp_location%\Documents, 0 ; Remove the empty "Documents" folder if it exists
    
    ExitApp ; Exit this script
    


    ; Experimental: random number based on a Gaussian distribution
    ; https://autohotkey.com/board/topic/64617-normaly-distributed-random-number/
    ; ==================================================================
    ; distribution_random(x,y,int=1) 
    ; { ; x lower y upper int for integer return
    ;     Loop 10
    ;     {
    ;         Random, var,0.0,1 ; Generate a float between 0 and 1
    ;         Num+=var
    ;     }
    ;     Norm := (int) ? Round((y+x)/2+((Num-5)*(y-x))/5) : (y+x)/2+((Num-5)*(y-x))/5 ; Apply the equation
    ;     Return Norm < x ? x : Norm > y ? y : Norm
    ; }
