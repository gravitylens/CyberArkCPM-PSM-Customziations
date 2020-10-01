#AutoIt3Wrapper_UseX64=n
Opt("MustDeclareVars", 1)
AutoItSetOption("WinTitleMatchMode", 3) ; EXACT_MATCH!

;============================================================
;             PSM AutoIt Dispatcher Skeleton
;             ------------------------------
;
; Use this skeleton to create your own
; connection components integrated with the PSM.
; Areas you may want to modify are marked
; with the string "CHANGE_ME".
;
; Created : April 2013
; Cyber-Ark Software Ltd.
;============================================================
#include "PSMGenericClientWrapper.au3"

;=======================================
; Consts & Globals
;=======================================
Global Const $DISPATCHER_NAME									= "FZDisp" ; CHANGE_ME
Global Const $CLIENT_EXECUTABLE									= "C:\Program Files\FileZilla FTP Client\filezilla.exe" ; CHANGE_ME
Global Const $ERROR_MESSAGE_TITLE  								= "PSM " & $DISPATCHER_NAME & " Dispatcher error message"
Global Const $LOG_MESSAGE_PREFIX 								= $DISPATCHER_NAME & " Dispatcher - "

Global $TargetUsername
Global $TargetPassword
Global $TargetAddress
Global $TargetPort
Global $ConnectionClientPID = 0

;=======================================
; Code
;=======================================
Exit Main()

;=======================================
; Main
;=======================================
Func Main()

	; Init PSM Dispatcher utils wrapper
	ToolTip ("Initializing...")
	if (PSMGenericClient_Init() <> $PSM_ERROR_SUCCESS) Then
		Error(PSMGenericClient_PSMGetLastErrorString())
	EndIf

	LogWrite("successfully initialized Dispatcher Utils Wrapper")

	; Get the dispatcher parameters
	FetchSessionProperties()

	LogWrite("mapping local drives")
	if (PSMGenericClient_MapTSDrives() <> $PSM_ERROR_SUCCESS) Then
		Error(PSMGenericClient_PSMGetLastErrorString())
	EndIf

	LogWrite("starting client application")
	ToolTip ("Starting " & $DISPATCHER_NAME & "...")
	$ConnectionClientPID = Run($CLIENT_EXECUTABLE)
	if ($ConnectionClientPID == 0) Then
		Error(StringFormat("Failed to execute process [%s]", $CLIENT_EXECUTABLE, @error))
	EndIf

	; ------------------
	; Handle login here! ; CHANGE_ME
	; ------------------
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
   ControlSetText ("FileZilla","","Edit1",$TargetAddress)
   ControlSetText ("FileZilla","","Edit2",$TargetUsername)
   ControlSetText ("FileZilla","","Edit3",$TargetPassword)
   ControlSetText ("FileZilla","","Edit4",$TargetPort)
   ControlClick ("FileZilla","","Button1")
   ;WinWaitActive ("Unknown host key")
Sleep (1000)
   ;WinWaitActive ("Remember passwords?")
   if (WinActivate ("Remember passwords?")) Then
   ControlClick ("Remember passwords?","","Button2")
   Sleep (1000)
   ControlClick ("Remember passwords?","","Button4")
EndIf
 Sleep (1000)
   if (WinActivate ("Unknown host key")) Then
   ControlClick ("Unknown host key","","Button3")
EndIf
    ; Send PID to PSM so recording/monitoring can begin
	; Notice that until we send the PID, PSM blocks all user input.
	LogWrite("sending PID to PSM")
	if (PSMGenericClient_SendPID($ConnectionClientPID) <> $PSM_ERROR_SUCCESS) Then
		Error(PSMGenericClient_PSMGetLastErrorString())
	EndIf

	; Terminate PSM Dispatcher utils wrapper
	LogWrite("Terminating Dispatcher Utils Wrapper")
	PSMGenericClient_Term()

	Return $PSM_ERROR_SUCCESS
EndFunc

;==================================
; Functions
;==================================
; #FUNCTION# ====================================================================================================================
; Name...........: Error
; Description ...: An exception handler - displays an error message and terminates the dispatcher
; Parameters ....: $ErrorMessage - Error message to display
; 				   $Code 		 - [Optional] Exit error code
; ===============================================================================================================================
Func Error($ErrorMessage, $Code = -1)

	; If the dispatcher utils DLL was already initialized, write an error log message and terminate the wrapper
	if (PSMGenericClient_IsInitialized()) Then
		LogWrite($ErrorMessage, True)
		PSMGenericClient_Term()
	EndIf

	Local $MessageFlags = BitOr(0, 16, 262144) ; 0=OK button, 16=Stop-sign icon, 262144=MsgBox has top-most attribute set

	MsgBox($MessageFlags, $ERROR_MESSAGE_TITLE, $ErrorMessage)

	; If the connection component was already invoked, terminate it
	if ($ConnectionClientPID <> 0) Then
		ProcessClose($ConnectionClientPID)
		$ConnectionClientPID = 0
	EndIf

	Exit $Code
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: LogWrite
; Description ...: Write a PSMWinSCPDispatcher log message to standard PSM log file
; Parameters ....: $sMessage - [IN] The message to write
;                  $LogLevel - [Optional] [IN] Defined if the message should be handled as an error message or as a trace messge
; Return values .: $PSM_ERROR_SUCCESS - Success, otherwise error - Use PSMGenericClient_PSMGetLastErrorString for details.
; ===============================================================================================================================
Func LogWrite($sMessage, $LogLevel = $LOG_LEVEL_TRACE)
	Return PSMGenericClient_LogWrite($LOG_MESSAGE_PREFIX & $sMessage, $LogLevel)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: PSMGenericClient_GetSessionProperty
; Description ...: Fetches properties required for the session
; Parameters ....: None
; Return values .: None
; ===============================================================================================================================
Func FetchSessionProperties() ; CHANGE_ME
	if (PSMGenericClient_GetSessionProperty("Username", $TargetUsername) <> $PSM_ERROR_SUCCESS) Then
		Error(PSMGenericClient_PSMGetLastErrorString())
	EndIf

	if (PSMGenericClient_GetSessionProperty("Password", $TargetPassword) <> $PSM_ERROR_SUCCESS) Then
		Error(PSMGenericClient_PSMGetLastErrorString())
	EndIf

	if (PSMGenericClient_GetSessionProperty("Address", $TargetAddress) <> $PSM_ERROR_SUCCESS) Then
		Error(PSMGenericClient_PSMGetLastErrorString())
	 EndIf

	if (PSMGenericClient_GetSessionProperty("Port", $TargetPort) <> $PSM_ERROR_SUCCESS) Then
		Error(PSMGenericClient_PSMGetLastErrorString())
	EndIf
EndFunc
