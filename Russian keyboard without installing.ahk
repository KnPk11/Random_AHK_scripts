; This script allows you to type Cyrillic letters without installing a Russian keyboard layout (in case you have a limited account)
; You might want to compile it to an executable to be able to run without installing ahk on the host machine

; v1.0

; Usage: Starts in an off state, press Alt + 3 to toggle on

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Suspend, on ; Open the program in an off state by default
Alt & 3::Suspend ; The toggle key combination
+3::Send №
+4::`;
+6:::
+7::?
+/::,

; '$' is used to make sure any key pressed doesn't invoke identical keys resulting in an endless loop (eg a::b sends b, which sends a, which sends b again, and so on...)
; If the caps lock is on
#If GetKeyState("CapsLock","T")
$`::Send Ё ; Send the uppercase version of the letter
$+`::Send ё ; Unless shift is pressed, then send the lowercase version
$q::Send Й
$+q::Send й
$w::Send Ц
$+w::Send ц
$e::Send У
$+e::Send у
$r::Send К
$+r::Send к
$t::Send Е
$+t::Send е
$y::Send Н
$+y::Send н
$u::Send Г
$+u::Send г
$i::Send Ш
$+i::Send ш
$o::Send Щ
$+o::Send щ
$p::Send З
$+p::Send з
$[::Send Х
$+[::Send х
$]::Send Ъ
$+]::Send ъ

$a::Send Ф
$+a::Send ф
$s::Send Ы
$+s::Send ы
$d::Send В
$+d::Send в
$f::Send А
$+f::Send а
$g::Send П
$+g::Send п
$h::Send Р
$+h::Send р
$j::Send О
$+j::Send о
$k::Send Л
$+k::Send л
$l::Send Д
$+l::Send д
$`;::Send Ж
$+`;::Send ж
$'::Send Э
$+'::Send э

$z::Send Я
$+z::Send я
$x::Send Ч
$+x::Send ч
$c::Send С
$+c::Send с
$v::Send М
$+v::Send м
$b::Send И
$+b::Send и
$n::Send Т
$+n::Send т
$m::Send Ь
$+m::Send ь
$,::Send Б
$+,::Send б
$.::Send Ю
$+.::Send ю

; If the caps lock is off
#If !GetKeyState("CapsLock","T")
$`::Send ё ; Send the lowercase version of the letter
$+`::Send Ё ; Unless shift is pressed, then pass the uppercase version
$q::Send й
$+q::Send Й
$w::Send ц
$+w::Send Ц
$e::Send у
$+e::Send У
$r::Send к
$+r::Send К
$t::Send е
$+t::Send Е
$y::Send н
$+y::Send Н
$u::Send г
$+u::Send Г
$i::Send ш
$+i::Send Ш
$o::Send щ
$+o::Send Щ
$p::Send з
$+p::Send З
$[::Send х
$+[::Send Х
$]::Send ъ
$+]::Send Ъ

$a::Send ф
$+a::Send Ф
$s::Send ы
$+s::Send Ы
$d::Send в
$+d::Send В
$f::Send а
$+f::Send А
$g::Send п
$+g::Send П
$h::Send р
$+h::Send Р
$j::Send о
$+j::Send О
$k::Send л
$+k::Send Л
$l::Send д
$+l::Send Д
$`;::Send ж
$+`;::Send Ж
$'::Send э
$+'::Send Э

$z::Send я
$+z::Send Я
$x::Send ч
$+x::Send Ч
$c::Send с
$+c::Send С
$v::Send м
$+v::Send М
$b::Send и
$+b::Send И
$n::Send т
$+n::Send Т
$m::Send ь
$+m::Send Ь
$,::Send б
$+,::Send Б
$.::Send ю
$+.::Send Ю

; Independent of caps lock symbols
$/::Send .
$+/::Send `,

; Sources
; https://autohotkey.com/board/topic/124519-remapping-key-without-overriding-hotkeys/