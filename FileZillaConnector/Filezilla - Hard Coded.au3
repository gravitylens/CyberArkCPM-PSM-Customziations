#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
   run ("C:\Program Files\FileZilla FTP Client\filezilla.exe")
   Sleep (1000)
   ;WinWaitActive ("Welcome to FileZilla")
   if (WinActivate ("Welcome to FileZilla")) Then
   ControlClick ("Welcome to FileZilla","","Button1")
   EndIf
   Sleep (1000)
   ;WinWaitActive ("Check for Updates")
   if (WinActivate ("Check for Updates")) Then
   ControlClick ("Check for Updates","","Button4")
EndIf
 Sleep (1000)
   WinWaitActive ("FileZilla")
   ControlSetText ("FileZilla","","Edit1","10.0.0.20")
   ControlSetText ("FileZilla","","Edit2","root")
   ControlSetText ("FileZilla","","Edit3","Cyberark1")
   ControlSetText ("FileZilla","","Edit4","22")
   ControlClick ("FileZilla","","Button1")
   ;WinWaitActive ("Unknown host key")
    Sleep (1000)
   if (WinActivate ("Unknown host key")) Then
   ControlClick ("Unknown host key","","Button1")
EndIf
 Sleep (1000)
   ;WinWaitActive ("Remember passwords?")
   if (WinActivate ("Remember passwords?")) Then
   ControlClick ("Remember passwords?","","Button2")
   Sleep (1000)
   ControlClick ("Remember passwords?","","Button3")
   EndIf



