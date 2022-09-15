set pmpass=Cyberark1
set pmnewpass=Ki9y39&5cfg
set pmextrapass1=Ki9y39&5cfg
REM set pmextrapass2=Cyberark1
REM set pmextrapass3=Cyberark1

set DebugLogFullParsingInfo=yes

type %1 > User.ini

bin\CyberArk.TPC.exe User.ini %2 syntaxcheck
REM bin\PMTerminal.exe User.ini %2 syntaxcheck
