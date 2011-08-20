:: -----Program Info-----
:: Name: 		Network Resetter
::
:: Verson:		5.1.406
::
:: Description:	Fixes network connection by trying each of the following:
::				1) Reset IP Address
::				2) Disable connection, wait specified time, re-enable connection
::
:: Author:		Lectrode 
::				Website:	http://electrodexs.net
::				Email: 		stevenspchelp@gmail.com
::
:: Notes:		Make sure the settings below are correct BEFORE
::				you run the program. (default settings should be
::				good for computers running Vista and Windows 7 and
::				using the *DEFAULT* wireless connection)
::
::				If it seems "stuck" on something to do with ipconfig
::				don't worry about it. It should get past it within a 
::				few minutes. If it persists longer than 10 minutes,
::				email me and I'll help you. If this happens often, you
::				can disable it below under "Settings"
::
::				If after running the program it still won't connect, try
::				increasing the number of MINUTES to wait.
::
::				If you close the program while it is attempting to fix
::				your network connection, the network connection may still
::				be disabled. To fix this, re-run this program.
::				You can set MINUTES to 0 for a quick run. 
::
::				The constant "Pinging 127.0.0.1 with 32 bits of data..."
::				is normal. It is the only way that this program language
::				can "sleep" or pause for a few seconds
::
::				"Could not find <network> | This program requires a valid
::				network connection | please open with notpade for more"
::				-To fix this please correct the NETWORK setting below.
::				
::				Regardless of what the "Disclaimer" says, this program
::				does not change or modify anything "system threatening"
::				(aka it's perfectly safe)
::				Of course, this can not be guaranteed if you get this from
::				anyone other than Lectrode.
::
:: Disclaimer:	This program is provided "AS-IS" and the author has no
::				responsibility for what may happen to your computer.
::				Use at your own risk.



:: -----Settings------

:: Number of minutes to wait before re-enabling
:: the network adapter (5-15 reccomended)
:: Integers Only! (aka 0,1,2,etc   NOT  "1.5")
SET MINUTES=10

:: Name of the Network to be reset
:: Network connections on your computer can be found at
:: Control Panel\Network and Internet\Network Connections
SET NETWORK=Wireless Network Connection


:: CONTINUOUS MODE - Constant check and run
::  "1" for True, "0" for false
:: Program will constantly run and will check your connection
:: every few minutes to ensure you are connected. If it 
:: detects that you have been disconected, it will automatically
:: attempt to repair your connection. If attempt fails, it will
:: keep retrying until it succeeds.
SET CONTINUOUS=0



::---------Advanced Settings-----------

:: Initially try to reset IP Address
::  "1" for True, "0" for false
:: Unless you frequently get an error stating "No operation can be
:: performed on <network> while it has its media disconnected" you
:: should leave this enabled.
SET USE_IP_RESET=1

:: If CONTINUOUS is set to 1, this is how many minutes between
:: connection tests.
SET CHECK_DELAY=3


:: Programmer Tool - Debugging
::  "1" for On, "0" for Off
:: Debugging mode disables actual functionality of this 
:: program (aka it won't fix your connection when debugging)
SET DEBUGN=0







:: ************ DON'T EDIT ANYTHING BEYOND THIS POINT! *************

:: --------Main Code---------

::Output only what program tells it to with "ECHO"
@ECHO OFF

:: Set CMD window size
MODE CON COLS=81 LINES=30

::Set isWaiting to 0
SET isWaiting=0


::Display program introduction
::Called twice to last longer
CALL :PROGRAM_INTRO
CALL :PROGRAM_INTRO

::Initial CHECKS
SET currently=Checking validity of Settings...
SET currently2=
CALL :STATS
CALL :DETECT_OS
CALL :TEST_NETWORK_NAME
CALL :TEST_MINUTES_VAL

::TEST internet connection
CALL :TEST


::":FIX" is called if ":TEST" fails
:FIX

::Call the fix methods
::Each mothod calls ":TEST" after it runs
IF %USE_IP_RESET%==1 CALL :MAIN_CODE_RESET_IP
CALL :MAIN_CODE_NETWORK_RESET

::If it gets here, none of the fixes above worked
GOTO :FAILED


::MAIN_CODE_RESET_IP method
:MAIN_CODE_RESET_IP

::Set & Display Status
SET currently2=
SET currently=Releasing IP Address
CALL :STATS

::Release IP Address
IF %DEBUGN%==0 IPCONFIG /RELEASE

::Set & Display Status
SET currently2=
SET currently=Flushing DNS Cache
CALL :STATS

::Flush DNS Cache
IF %DEBUGN%==0 IPCONFIG /FLUSHDNS

::Set & Display Status
SET currently=Renewing IP Address
SET currently2=(May get error messages, but you can ignore them)
CALL :STATS

::Renew IP Address
IF %DEBUGN%==0 IPCONFIG /RENEW

::TEST internet connection
CALL :TEST

::If it gets here, Resetting IP didn't fix the problem
SET currently2=
SET currently=Resetting IP did not fix the problem
CALL :STATS

::End of MainCodeResetIP method
GOTO :EOF



::Method for Network Connection Reset
:MAIN_CODE_NETWORK_RESET

::Disable network connection
CALL :DISABLE_NW

::Set status
SET currently2=
SET currently=Waiting to re-enable "%NETWORK%"


::Cycle through updating time until limit is reached
::limit is stored in delaymins
SET delaymins=%MINUTES%
CALL :WAIT

::Once done waithing, Enable network connection
CALL :ENABLE_NW

::TEST internet connection
CALL :TEST

::Calculate Minutes to be displayed
SET /A mins="TTLSCNDS/60"

::Set and Display Status
SET currently2=
SET currently=Waiting %mins% minutes did not fix the problem
CALL :STATS

::END of Network Reset Method
GOTO :EOF

:: ":TEST" Method
:TEST
SET currently2=
SET currently=Testing Internet Connection...
SET isWaiting=1
CALL :STATS
::First Test
IF %DEBUGN%==0 (
	PING -n 1 www.google.com|FIND "Reply from " >NUL
	IF NOT ERRORLEVEL 1 goto :SUCCESS
	::First test failed, wait 12 seconds (enabling adapter takes a while)
	CALL :STATS
	CALL :STATS
	CALL :STATS
	CALL :STATS
	::Second Test
	PING -n 1 www.google.com|FIND "Reply from " >NUL
	IF NOT ERRORLEVEL 1 goto :SUCCESS
	::Second Test failed. Go back to 
	::where ":TEST" was called from
)
SET isWaiting=0
SET currently2=
SET currently=Internet Connection not detected
CALL :STATS
GOTO :EOF

::Display Program Introduction Method
:PROGRAM_INTRO
CLS
ECHO  ******************************************************************************
ECHO  *                                                                            *
ECHO  *                                                                            *
ECHO  *                  *Settings can be changed via Notepad                      *
ECHO  *                                                                            *
ECHO  *                                                                            *
ECHO  ******************************************************************************
ECHO.
ECHO.
PING 127.0.0.1
GOTO :EOF

:STATS
CLS
						ECHO  ******************************************************************************
						ECHO  *      ******   Lectrode's Network Connection Resetter v5.0.402   ******     *
						ECHO  ******************************************************************************
IF %DEBUGN%==1 			ECHO  *          *DEBUGGING ONLY! Set DEBUGN to 0 to reset connection*             *
IF %CONTINUOUS%==1 		ECHO  *                                                                            *
IF %CONTINUOUS%==1 		ECHO  *                              *Continuous Mode*                             *
						ECHO  *                                                                            *
						ECHO  * Connection:    "%NETWORK%"
						ECHO  *                                                                            *
						ECHO  * Current State: %currently%
						ECHO  *                %currently2%
						ECHO  *                                                                            *
						ECHO  * %SpecificStatus%
						ECHO  *                                                                            *
						ECHO  ******************************************************************************

IF %DEBUGN%==1 (
	CALL :PINGER
	ECHO Debugn On
) ELSE (
	IF %isWaiting%==1 CALL :PINGER
)

GOTO :EOF




:PINGER
PING 127.0.0.1
GOTO :EOF

:WAIT
::Set "isWaiting" to 1
SET isWaiting=1

::calculate number of PINGS
SET /A PINGS="(delaymins*60)/3"

::Calculate total time
SET /A TTLSCNDS="PINGS*3"
SET /A HOURS="(TTLSCNDS/3600)"
SET /A MINUTES2="(TTLSCNDS-(HOURS*3600))/60"
SET /A SECONDS="TTLSCNDS-((HOURS*3600)+(MINUTES2*60))"

::Set HOURS to "","##:", or "0#:"
::(always 2 digits or nothing)
IF %HOURS%==0 (
	SET HOURS=
) ELSE (
	IF %HOURS% LEQ 9 (
		SET HOURS=0%HOURS%:
	) ELSE (
		SET HOURS=%HOURS%:
	)
)

::Set MINUTES2 to "","##:", "00:", or "0#:"
::(always 2 digits or nothing)
::(always 2 digits if HOURS>0)
IF %MINUTES2%==0 (
	IF "%HOURS%"=="" (
		SET MINUTES2=
	) ELSE (
		SET MINUTES2=00:
	)
) ELSE (
	IF %MINUTES2% LEQ 9 (
	SET MINUTES2=0%MINUTES2%:
	) ELSE (
	SET MINUTES2=%MINUTES2%:
	)
)

::Set SECONDS to "##" or "0#"
::(always 2 digits)
IF %SECONDS% LEQ 9 SET SECONDS=0%SECONDS%


::Set Ticker to 0
SET ticker=0

SET /A PINGS="delaymins*60/3"

:WAITING
::Set "Time left"
SET /A left="PINGS-ticker"
SET /A ttlscndslft="left*3"
SET /A hrs="ttlscndslft/3600"
SET /A mins="(ttlscndslft-(hrs*3600))/60"
SET /A scnds="(ttlscndslft-((hrs*3600)+(mins*60)))"

::Bump ticker
SET /A ticker+=1


::Set hrs to "","##:", or "0#:"
::(always 2 digits or nothing)
IF %hrs%==0 (
	SET hrs=
) ELSE (
	IF %hrs% LEQ 9 (
		SET hrs=0%hrs%:
	) ELSE (
		SET hrs=%hrs%:
	)
)

::Set mins to "","##:", "00:", or "0#:"
::(always 2 digits or nothing)
::(always 2 digits if HOURS>0)
IF %mins%==0 (
	IF "%hrs%"=="" (
		SET mins=
	) ELSE (
		SET mins=00:
	)
) ELSE (
	IF NOT "%mins%"=="" (
		IF %mins% LEQ 9 (
			SET mins=0%mins%:
		) ELSE (
			SET mins=%mins%:
		)
	)
)

::Set SECONDS to "##" or "0#"
::(always 2 digits)
IF %scnds% LEQ 9 SET scnds=0%scnds%

::Update TimeStamp
SET SpecificStatus=Time Left:  %hrs%%mins%%scnds% of %HOURS%%MINUTES2%%SECONDS%

::Displays status on screen
CALL :STATS

::Cycle through "WAITING" again if waiting time 
::has not been reached
IF %ticker% LEQ %PINGS% ( GOTO :WAITING )
SET isWaiting=0
GOTO :EOF


:DISABLE_NW
SET currently2=
SET currently=Disabling "%NETWORK%"...
CALL :STATS

::DETECT_OS sets winVistaOrNewer to 1 or 0
CALL :DETECT_OS


IF %DEBUGN%==0 IF %winVistaOrNewer%==1 NETSH INTERFACE SET INTERFACE "%NETWORK%" DISABLE|FIND "name is not registered " >NUL
IF NOT ERRORLEVEL 1 GOTO :INTERFACE_NOT_FOUND


IF %DEBUGN%==0 IF %winVistaOrNewer%==0 CALL :DISABLE_OLD_OS
SET currently2=
SET currently="%NETWORK%" Disabled
CALL :STATS
GOTO :EOF


:ENABLE_NW
SET currently2=
SET currently=Enabling "%NETWORK%"
SET SpecificStatus= 
CALL :STATS

::DETECT_OS sets winVistaOrNewer to 1 or 0
CALL :DETECT_OS


IF %DEBUGN%==0 IF %winVistaOrNewer%==1 NETSH INTERFACE SET INTERFACE "%NETWORK%" ENABLE
IF %DEBUGN%==0 IF %winVistaOrNewer%==0 CALL :ENABLE_OLD_OS

SET currently2=
SET currently="%NETWORK%" Enabled
CALL :STATS
GOTO :EOF


:DISABLE_OLD_OS
@ECHO on
ECHO Const ssfCONTROLS = 3 >>DisableNetwork.vbs
ECHO sConnectionName = "%NETWORK%" >>DisableNetwork.vbs
ECHO sEnableVerb = "En&able" >>DisableNetwork.vbs
ECHO sDisableVerb = "Disa&ble" >>DisableNetwork.vbs
ECHO set shellApp = createobject("shell.application") >>DisableNetwork.vbs
ECHO set oControlPanel = shellApp.Namespace(ssfCONTROLS) >>DisableNetwork.vbs
ECHO set oNetConnections = nothing >>DisableNetwork.vbs
ECHO for each folderitem in oControlPanel.items >>DisableNetwork.vbs
ECHO   if folderitem.name = "Network Connections" then >>DisableNetwork.vbs
ECHO         set oNetConnections = folderitem.getfolder: exit for >>DisableNetwork.vbs
ECHO end if >>DisableNetwork.vbs
ECHO next >>DisableNetwork.vbs
ECHO if oNetConnections is nothing then >>DisableNetwork.vbs
ECHO msgbox "Couldn't find 'Network Connections' folder" >>DisableNetwork.vbs
ECHO wscript.quit >>DisableNetwork.vbs
ECHO end if >>DisableNetwork.vbs
ECHO set oLanConnection = nothing >>DisableNetwork.vbs
ECHO for each folderitem in oNetConnections.items >>DisableNetwork.vbs
ECHO if lcase(folderitem.name) = lcase(sConnectionName) then >>DisableNetwork.vbs
ECHO set oLanConnection = folderitem: exit for >>DisableNetwork.vbs
ECHO end if >>DisableNetwork.vbs
ECHO next >>DisableNetwork.vbs
ECHO Dim objFSO >>DisableNetwork.vbs
ECHO if oLanConnection is nothing then >>DisableNetwork.vbs
ECHO msgbox "Couldn't find %NETWORK%" >>DisableNetwork.vbs
ECHO msgbox "This program requires a valid Network Connection name to work properly" >>DisableNetwork.vbs
ECHO msgbox "Please close the program and open it with notepad for more information" >>DisableNetwork.vbs
ECHO Set objFSO = CreateObject("Scripting.FileSystemObject") >>DisableNetwork.vbs
ECHO objFSO.DeleteFile WScript.ScriptFullName >>DisableNetwork.vbs
ECHO Set objFSO = Nothing >>DisableNetwork.vbs
ECHO wscript.quit >>DisableNetwork.vbs
ECHO end if >>DisableNetwork.vbs
ECHO bEnabled = true >>DisableNetwork.vbs
ECHO set oEnableVerb = nothing >>DisableNetwork.vbs
ECHO set oDisableVerb = nothing >>DisableNetwork.vbs
ECHO s = "Verbs: " & vbcrlf >>DisableNetwork.vbs
ECHO for each verb in oLanConnection.verbs >>DisableNetwork.vbs
ECHO s = s & vbcrlf & verb.name >>DisableNetwork.vbs
ECHO if verb.name = sEnableVerb then >>DisableNetwork.vbs
ECHO set oEnableVerb = verb >>DisableNetwork.vbs
ECHO bEnabled = false >>DisableNetwork.vbs
ECHO end if >>DisableNetwork.vbs
ECHO if verb.name = sDisableVerb then >>DisableNetwork.vbs
ECHO set oDisableVerb = verb >>DisableNetwork.vbs
ECHO end if >>DisableNetwork.vbs
ECHO next >>DisableNetwork.vbs
ECHO if bEnabled then >>DisableNetwork.vbs
ECHO oDisableVerb.DoIt >>DisableNetwork.vbs
ECHO end if >>DisableNetwork.vbs
ECHO wscript.sleep 2000 >>DisableNetwork.vbs
ECHO Set objFSO = CreateObject("Scripting.FileSystemObject") >>DisableNetwork.vbs
ECHO objFSO.DeleteFile WScript.ScriptFullName >>DisableNetwork.vbs
ECHO Set objFSO = Nothing >>DisableNetwork.vbs
cscript DisableNetwork.vbs
@ECHO off
GOTO :EOF


:ENABLE_OLD_OS
@ECHO on
ECHO Const ssfCONTROLS = 3 >>EnableNetwork.vbs
ECHO sConnectionName = "%NETWORK%" >>EnableNetwork.vbs
ECHO sEnableVerb = "En&able" >>EnableNetwork.vbs
ECHO sDisableVerb = "Disa&ble" >>EnableNetwork.vbs
ECHO set shellApp = createobject("shell.application") >>EnableNetwork.vbs
ECHO set oControlPanel = shellApp.Namespace(ssfCONTROLS) >>EnableNetwork.vbs
ECHO set oNetConnections = nothing >>EnableNetwork.vbs
ECHO for each folderitem in oControlPanel.items >>EnableNetwork.vbs
ECHO   if folderitem.name = "Network Connections" then >>EnableNetwork.vbs
ECHO         set oNetConnections = folderitem.getfolder: exit for >>EnableNetwork.vbs
ECHO end if >>EnableNetwork.vbs
ECHO next >>EnableNetwork.vbs
ECHO if oNetConnections is nothing then >>EnableNetwork.vbs
ECHO msgbox "Couldn't find 'Network Connections' folder" >>EnableNetwork.vbs
ECHO wscript.quit >>EnableNetwork.vbs
ECHO end if >>EnableNetwork.vbs
ECHO set oLanConnection = nothing >>EnableNetwork.vbs
ECHO for each folderitem in oNetConnections.items >>EnableNetwork.vbs
ECHO if lcase(folderitem.name) = lcase(sConnectionName) then >>EnableNetwork.vbs
ECHO set oLanConnection = folderitem: exit for >>EnableNetwork.vbs
ECHO end if >>EnableNetwork.vbs
ECHO next >>EnableNetwork.vbs
ECHO Dim objFSO >>EnableNetwork.vbs
ECHO if oLanConnection is nothing then >>EnableNetwork.vbs
ECHO msgbox "Couldn't find %NETWORK%" >>EnableNetwork.vbs
ECHO msgbox "This program requires a valid Network Connection name to work properly" >>EnableNetwork.vbs
ECHO msgbox "Please close the program and open it with notepad for more information" >>EnableNetwork.vbs
ECHO Set objFSO = CreateObject("Scripting.FileSystemObject") >>EnableNetwork.vbs
ECHO objFSO.DeleteFile WScript.ScriptFullName >>EnableNetwork.vbs
ECHO Set objFSO = Nothing >>EnableNetwork.vbs
ECHO wscript.quit >>EnableNetwork.vbs
ECHO end if >>EnableNetwork.vbs
ECHO bEnabled = true >>EnableNetwork.vbs
ECHO set oEnableVerb = nothing >>EnableNetwork.vbs
ECHO set oDisableVerb = nothing >>EnableNetwork.vbs
ECHO s = "Verbs: " & vbcrlf >>EnableNetwork.vbs
ECHO for each verb in oLanConnection.verbs >>EnableNetwork.vbs
ECHO s = s & vbcrlf & verb.name >>EnableNetwork.vbs
ECHO if verb.name = sEnableVerb then >>EnableNetwork.vbs
ECHO set oEnableVerb = verb >>EnableNetwork.vbs
ECHO bEnabled = false >>EnableNetwork.vbs
ECHO end if >>EnableNetwork.vbs
ECHO if verb.name = sDisableVerb then >>EnableNetwork.vbs
ECHO set oDisableVerb = verb >>EnableNetwork.vbs
ECHO end if >>EnableNetwork.vbs
ECHO next >>EnableNetwork.vbs
ECHO if bEnabled = false then >>EnableNetwork.vbs
ECHO oEnableVerb.DoIt >>EnableNetwork.vbs
ECHO end if >>EnableNetwork.vbs
ECHO wscript.sleep 2000 >>EnableNetwork.vbs
ECHO Set objFSO = CreateObject("Scripting.FileSystemObject") >>EnableNetwork.vbs
ECHO objFSO.DeleteFile WScript.ScriptFullName >>EnableNetwork.vbs
ECHO Set objFSO = Nothing >>EnableNetwork.vbs
cscript EnableNetwork.vbs
@ECHO off
GOTO :EOF



:DETECT_OS
VER | FIND "2003" > NUL
IF %ERRORLEVEL% == 0 GOTO OLDVER

VER | FIND "XP" > NUL
IF %ERRORLEVEL% == 0 GOTO OLDVER

VER | FIND "2000" > NUL
IF %ERRORLEVEL% == 0 GOTO OLDVER

VER | FIND "NT" > NUL
IF %ERRORLEVEL% == 0 GOTO OLDVER

for /f "tokens=3*" %%i IN ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName ^| Find "ProductName"') DO set vers=%%i %%j

echo %vers% | find "Windows 7" > NUL
if %ERRORLEVEL% == 0 goto NewVer

echo %vers% | find "Windows Server 2008" > NUL
if %ERRORLEVEL% == 0 goto NewVer

echo %vers% | find "Windows Vista" > NUL
if %ERRORLEVEL% == 0 goto NewVer


:OldVer
SET winVistaOrNewer=0
GOTO :EOF

:NewVer
SET winVistaOrNewer=1
GOTO :EOF

:TEST_NETWORK_NAME
NETSH INTERFACE SET INTERFACE NAME="%NETWORK%" NEWNAME="%NETWORK%"|FIND "name is not registered " >NUL
IF NOT ERRORLEVEL 1 GOTO :NEED_NETWORK
GOTO :EOF

:TEST_MINUTES_VAL
GOTO :EOF


:NEED_NETWORK
SET currently="%NETWORK%" was not found. 
SET currently2=
CALL :STATS
ECHO Would you like to view current network connections?
CHOICE
IF ERRORLEVEL 2 GOTO :DONT_DISPLAY_NETWORK_CONNECTIONS
%SystemRoot%\explorer.exe /N,::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{21EC2020-3AEA-1069-A2DD-08002B30309D}\::{7007ACC7-3202-11D1-AAD2-00805FC1270E}

:DONT_DISPLAY_NETWORK_CONNECTIONS

pause
GOTO :EOF



:FAILED
SET currently=Unable to Connect to Internet.
SET currently2=
IF %winVistaOrNewer%==0 SET currently=Unable to Connect to Internet. Could not 
IF %winVistaOrNewer%==0 SET currently2=reset network (Unsupported on this system)
SET SpecificStatus= 
IF %CONTINUOUS%==1 CALL :STATS
IF %CONTINUOUS%==1 SET currently2=
IF %CONTINUOUS%==1 SET currently=Unable to Connect to Internet (Retrying...)
SET isWaiting=1
CALL :STATS
SET isWaiting=0
IF %CONTINUOUS%==1 CALL :PINGER
IF %CONTINUOUS%==1 GOTO :FIX
SET /P goAgain=Retry? (y or n)

IF NOT %goAgain%==y EXIT
GOTO :FIX

:SUCCESS
SET isWaiting=0
SET currently2=
IF %CONTINUOUS%==0 SET currently=Successfully Connected to Internet. EXITING...
IF %CONTINUOUS%==1 SET currently=Successfully Connected to Internet.
SET SpecificStatus= 
CALL :STATS
CALL :PINGER
IF %CONTINUOUS%==1 SET currently=Connected to Internet. Waiting to re-check...
IF %CONTINUOUS%==1 CALL :STATS
IF %CONTINUOUS%==1 SET delaymins=%CHECK_DELAY%
IF %CONTINUOUS%==1 CALL :WAIT
IF %CONTINUOUS%==1 GOTO :TEST
IF %DEBUGN%==1 PAUSE
EXIT

