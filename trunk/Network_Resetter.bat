:: -----Program Info-----
:: Name: 		Network Resetter
::
:: Verson:		7.2.463
::
:: Description:	Fixes network connection by trying each of the following:
::				1) Reset IP Address
::				2) Disable connection, wait specified time, re-enable connection
::
:: Author:		Lectrode 
::				Website:	http://electrodexs.net
::				Email: 		stevenspchelp@gmail.com
::
:: Notes:		This is easiest read in a program such as Notepad++
::				and using the font "Curier New" size 10.
::				
::				Make sure the settings below are correct BEFORE
::				you run the program. (default settings should be
::				good for computers running Vista and Windows 7 and
::				using the *DEFAULT* wireless connection)
::
::				If it seems stuck on "Resetting IP Address"
::				don't worry about it. It should get past it within a 
::				few minutes. If it persists longer than 10 minutes,
::				email me and I'll help you. If this happens often, you
::				can disable it below under "Advanced Settings"
::
::				If after running the program it still won't connect, try
::				increasing the number of MINUTES to wait.
::
::				If you close the program while it is attempting to fix
::				your network connection, the network connection may still
::				be disabled. To fix this, re-run this program.
::				You can set MINUTES to 0 for a quick run. 
::
::				"This Operating System is not currently supported."
::				-The only thing you can do in this case is email me
::				the name of the Operating System and I'll try to add
::				support for it.
::				You can bypass the OS detection below in Advanced
::				Settings, but the program may exhibit unusual behavior.
::
::				"Could not find <network> | This program requires a valid
::				network connection | please open with notpad for more information"
::				-To fix this please correct the NETWORK setting below.
::				
::				Regardless of what the "Disclaimer" says, this program
::				does not change or modify anything "system threatening"
::				(aka it's perfectly safe)
::				Of course, this cannot be guaranteed if you get this from
::				anyone other than Lectrode (Steven Hoff).
::
:: Disclaimer:	This program is provided "AS-IS" and the author has no
::				responsibility for what may happen to your computer.
::				Use at your own risk.


:: -----Settings------
:SETTINGS

:: Number of minutes to wait before re-enabling
:: the network adapter (5-15 reccomended)
:: Integers Only! (aka 0,1,2,etc)
:: (anything else will be evaluated as "0")
SET MINUTES=10

:: Name of the Network to be reset
:: Network connections on your computer can be found at
:: Windows 7:	Control Panel (Large or Small icons) -> Network and Sharing Center -> Change Adapter Settings
:: Vista:		Control Panel (Classic view) -> Network and Sharing Center -> Manage Network Connections
:: Windows XP:	Control Panel (Classic view) -> Network Connections
SET NETWORK=Wireless Network Connection


:: CONTINUOUS MODE - Constant check and run
::  "1" for On, "0" for Off
:: Program will constantly run and will check your connection
:: every few minutes to ensure you are connected. If it 
:: detects that you have been disconected, it will automatically
:: attempt to repair your connection. If attempt fails, it will
:: keep retrying until it succeeds.
SET CONTINUOUS=0



::---------Advanced Settings-----------

:: Try to reset the IP Address
::  "1" for True, "0" for False
:: Unless you frequently get stuck on "Reseting IP address" you
:: should leave this enabled.
SET USE_IP_RESET=1

:: If CONTINUOUS is set to 1, this is how many minutes between
:: connection tests.
:: Integers Only! (aka 0,1,2,etc)
:: (anything else will be evaluated as "0")
SET CHECK_DELAY=3

:: Show ALL messages, even if they're unimportant
::  "1" for True, "0" for False
:: NOTE: Regardless of what you set this too, this program will 
:: always display important messages.
:: This option is mainly for people who like to follow along and
:: see exactly what the program is doing.
:: This is really only useful if SLWMSG is true.
SET SHOW_ALL_ALERTS=1

:: Slow Messages
::  "1" for True, "0" for False
:: When true, program will pause for every message it displays to 
:: allow the user to read them (run time will be longer)
SET SLWMSG=0


:: Start Program at user log on
::  "1" for True, "0" for False
:: When true, the program will start when you log on.
:: Especially usefull when running in CONTINUOUS Mode.
:: In order for this setting to take effect, you have
:: to run this program at least up to the point where
:: it tests your internet connection.
SET START_AT_LOGON=0


:: Start Minimized
::  "1" for True, "0" for False
:: When true, program will minimize itself when its run
:: This is especially usefull if you have the program running 
:: continuously and set to start at user log on.
SET START_MINIMIZED=0



:: Override OS Detection
::  "1" for True, "0" for False
:: The only time you would use this is if you are getting a 
:: "This Operating System is not currently supported" message.
:: This will force the program to continue running.
:: WARNING: Running this program on an unsupported OS may cause
:: this program to exhibit unusual behavior. 
SET OS_DETECT_OVERRIDE=0



:: Programmer Tool - Debugging
::  "1" for On, "0" for Off
:: Debugging mode disables actual functionality of this 
:: program (aka it won't fix your connection when debugging)
SET DEBUGN=0






:: *****************************************************************
:: ************ DON'T EDIT ANYTHING BEYOND THIS POINT! *************
:: *****************************************************************








:: --------Main Code---------

::Output only what program tells it to with "ECHO"
@ECHO OFF

:: Restart itself minimized if set to do so
:: But first check for proper value for 
:: START_MINIMIZED
CALL :TEST_STARTMINIMIZED
IF NOT %START_MINIMIZED%==1 GOTO :START_PROGRAM
IF NOT "%MINIMIZED%"=="" GOTO :START_PROGRAM
SET MINIMIZED=TRUE
START /MIN CMD /C "%~dpnx0"
EXIT

:START_PROGRAM



:: Set CMD window size
MODE CON COLS=81 LINES=30

::Set initial variables
SET isWaiting=0
SET THISFILEPATH=%~0
SET THISFILENAME=%~n0.bat



::Display program introduction
::Call it twice to last longer
CALL :PROGRAM_INTRO
:: CALL :PROGRAM_INTRO

::Initial CHECKS
SET currently=Checking validity of Settings...
SET currently2=
CALL :STATS
CALL :TEST_SLWMSG_VAL
CALL :TEST_SHOWALLALERTS_VAL
CALL :TEST_DEBUGN_VAL
CALL :TEST_CONTINUOUS_VAL
CALL :TEST_OSDETECTOVERRIDE_VAL
CALL :DETECT_OS
CALL :TEST_NETWORK_NAME
CALL :TEST_MINUTES_VAL
CALL :TEST_USEIP_VAL
CALL :TEST_CHECKDELAY_VAL
CALL :TEST_STARTATLOGON


::Copy to startup folder if set to start when 
::user logs on
CALL :CHECK_START_AT_LOGON


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
IF %DEBUGN%==0 IPCONFIG /RENEW >NUL

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
SET SpecificStatus=
SET isWaiting=1
CALL :STATS
::First Test
IF %DEBUGN%==0 (
	PING -n 1 www.google.com|FIND "Reply from " >NUL
	IF NOT ERRORLEVEL 1 goto :SUCCESS
	::First test failed, wait 12 seconds (enabling adapter takes a while)
	IF %SHOW_ALL_ALERTS%==1 SET currently=First test failed,
	IF %SHOW_ALL_ALERTS%==1 SET currently2=waiting a few seconds before trying again.
	CALL :STATS
	CALL :STATS
	CALL :STATS
	CALL :STATS
	::Second Test
	PING -n 1 www.google.com|FIND "Reply from " >NUL
	IF NOT ERRORLEVEL 1 goto :SUCCESS
	::Second Test failed. 
	SET isWaiting=0
	IF %SHOW_ALL_ALERTS%==1 SET currently=Both tests failed.
	IF %SHOW_ALL_ALERTS%==1 SET currently2=
	CALL :STATS
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
ECHO  *                  *Settings and documentation on how to use                 *
ECHO  *                   this program can be accessed via Notepad                 *
ECHO  *                                                                            *
ECHO  *                                                                            *
ECHO  ******************************************************************************
ECHO.
ECHO.
CALL :PINGER
GOTO :EOF

:STATS
CLS
						ECHO  ******************************************************************************
						ECHO  *      ******   Lectrode's Network Connection Resetter v7.2.463   ******     *
						ECHO  ******************************************************************************
IF "%DEBUGN%"=="1"		ECHO  *          *DEBUGGING ONLY! Set DEBUGN to 0 to reset connection*             *
IF "%CONTINUOUS%"=="1"	ECHO  *                                                                            *
IF "%CONTINUOUS%"=="1"	ECHO  *                              *Continuous Mode*                             *
						ECHO  *                                                                            *
						ECHO  * Connection:    "%NETWORK%"
						ECHO  *                                                                            *
						ECHO  * Current State: %currently%
						ECHO  *                %currently2%
						ECHO  *                                                                            *
						ECHO  * %SpecificStatus%
						ECHO  *                                                                            *
						ECHO  ******************************************************************************

IF "%SLWMSG%"=="1" (
	CALL :PINGER
) ELSE (
	IF "%isWaiting%"=="1" CALL :PINGER
)

GOTO :EOF




:PINGER
PING 127.0.0.1 >NUL
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

::Set HOURS to "" or "##:"
::(always 2 digits or nothing)
IF %HOURS%==0 (
	SET HOURS=
) ELSE (
	SET HOURS=%HOURS%:
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
	SET MINUTES2=%MINUTES2%:
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
	SET hrs=%hrs%:
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
	IF "%hrs%"=="" (
		SET mins=%mins%:
	) ELSE (
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

CALL :TEST_NETWORK_NAME
IF %DEBUGN%==0 IF %winVistaOrNewer%==1 NETSH INTERFACE SET INTERFACE "%NETWORK%" DISABLE
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

CALL :TEST_NETWORK_NAME
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
@ECHO off
CALL :STATS
cscript DisableNetwork.vbs
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
@ECHO off
CALL :STATS
cscript EnableNetwork.vbs
GOTO :EOF



:DETECT_OS

SET currently=Checking if Operating System is supported...
SET currently2=
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS

VER | FIND "2003" > NUL
IF %ERRORLEVEL% == 0 GOTO TOO_OLD

VER | FIND "XP" > NUL
IF %ERRORLEVEL% == 0 GOTO OLDVER

VER | FIND "2000" > NUL
IF %ERRORLEVEL% == 0 GOTO TOO_OLD

VER | FIND "NT" > NUL
IF %ERRORLEVEL% == 0 GOTO TOO_OLD

for /f "tokens=3*" %%i IN ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName ^| Find "ProductName"') DO set vers=%%i %%j

echo %vers% | find "Windows 7" > NUL
if %ERRORLEVEL% == 0 goto NewVer

echo %vers% | find "Windows Server 2008" > NUL
if %ERRORLEVEL% == 0 goto NewVer

echo %vers% | find "Windows Vista" > NUL
if %ERRORLEVEL% == 0 goto NewVer


:TOO_OLD
SET currently=Operating System is unsupported
SET currently2=
CALL :STATS
VER
CALL :PINGER
IF %OS_DETECT_OVERRIDE%==1 GOTO :RUN_ON_UNSUPPORTED
GOTO SYSTEM_TOO_OLD

:OldVer
SET currently=Operating System is WindowsXP (supported)
SET currently2=
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
SET winVistaOrNewer=0
GOTO :EOF

:NewVer
SET currently=Operating System is supported
SET currently2= (%vers%)
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
SET winVistaOrNewer=1
GOTO :EOF


:RUN_ON_UNSUPPORTED
SET currently=Attempting to run on UNSUPPORTED Operating System...
SET currently2=
SET SpecificStatus=
CALL :STATS
ECHO.
ECHO.
ECHO This may cuase unexpected behavior in this program.
ECHO Are you sure you want to do this?
SET /P usrInpt=[y/n] 
IF "%usrInpt%"=="y" GOTO :OldVer
IF "%usrInpt%"=="n" GOTO :SYSTEM_TOO_OLD
GOTO :RUN_ON_UNSUPPORTED



:CHECK_START_AT_LOGON
SET currently=Checking if set to start at user log on...
SET currently2=
SET SpecificStatus=
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF %START_AT_LOGON%==0 GOTO :DONT_STARTUP

SET currently=Program is set to start at user log on.
SET currently2=Copying self to Startup Folder...
SET SpecificStatus=
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
COPY %THISFILENAME% "%systemdrive%\Documents and Settings\%USERNAME%\Start Menu\Programs\Startup\NetworkResetterByLectrode.bat"
GOTO :EOF

:DONT_STARTUP
SET currently=Program is not set to start at user log on.
SET currently2=Removing copies of self in Startup folder (if any)
SET SpecificStatus=
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
DEL /F /Q "%systemdrive%\Documents and Settings\%USERNAME%\Start Menu\Programs\Startup\NetworkResetterByLectrode.bat"
GOTO :EOF




:TEST_NETWORK_NAME
SET currently=Checking if "%NETWORK%"
SET currently2=is a valid network connection name...
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF %DEBUGN%==0 NETSH INTERFACE SET INTERFACE NAME="%NETWORK%" NEWNAME="%NETWORK%"|FIND "name is not registered " >NUL
IF %DEBUGN%==0 IF NOT ERRORLEVEL 1 GOTO :NEED_NETWORK
GOTO :EOF

:TEST_MINUTES_VAL
SET currently=Checking if MINUTES is a valid number...
SET currently2=
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%MINUTES%"=="0" GOTO :EOF

SET /a num=MINUTES
IF "%num%"=="0" SET currently="%MINUTES%" is not a valid answer.
IF "%num%"=="0" SET currently2=Setting MINUTES to 10...
IF "%num%"=="0" CALL :STATS
IF "%num%"=="0" SET MINUTES=10
GOTO :EOF

:TEST_CONTINUOUS_VAL
SET currently=Checking if CONTINUOUS is a valid answer (0 or 1)...
SET currently2=
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%CONTINUOUS%"=="0" GOTO :EOF
IF "%CONTINUOUS%"=="1" GOTO :EOF
SET currently=CONTINUOUS does not equal "1" or "0"
SET currently2=
CALL :STATS
SET currently=Setting CONTINUOUS to "0"...
SET currently2=
CALL :STATS
SET CONTINUOUS=0
GOTO :EOF

:TEST_USEIP_VAL
SET currently=Checking if USE_IP_RESET is a valid answer (0 or 1)...
SET currently2=
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%USE_IP_RESET%"=="0" GOTO :EOF
IF "%USE_IP_RESET%"=="1" GOTO :EOF
SET currently=USE_IP_RESET does not equal "1" or "0"
SET currently2=
CALL :STATS
SET currently=Setting USE_IP_RESET to "1"...
SET currently2=
CALL :STATS
SET USE_IP_RESET=1
GOTO :EOF

:TEST_CHECKDELAY_VAL
SET currently=Checking if CHECK_DELAY is a valid number...
SET currently2=
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%CHECK_DELAY%"=="0" GOTO :EOF

SET /a num=CHECK_DELAY
IF "%num%"=="0" SET currently="%CHECK_DELAY%" is not a valid answer.
IF "%num%"=="0" SET currently2=Setting CHECK_DELAY to 3...
IF "%num%"=="0" CALL :STATS
IF "%num%"=="0" SET CHECK_DELAY=3
GOTO :EOF

:TEST_DEBUGN_VAL
SET currently=Checking if DEBUGN is a valid answer (0 or 1)...
SET currently2=
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%DEBUGN%"=="0" GOTO :EOF
IF "%DEBUGN%"=="1" GOTO :EOF
SET currently=DEBUGN does not equal "1" or "0"
SET currently2=
CALL :STATS
SET currently=Setting DEBUGN to "0"...
SET currently2=
CALL :STATS
SET DEBUGN=0
GOTO :EOF

:TEST_SLWMSG_VAL
SET currently=Checking if SLWMSG is a valid answer (0 or 1)...
SET currently2=
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%SLWMSG%"=="0" GOTO :EOF
IF "%SLWMSG%"=="1" GOTO :EOF
SET currently=SLWMSG does not equal "1" or "0"
SET currently2=
CALL :STATS
SET currently=Setting SLWMSG to "1"...
SET currently2=
CALL :STATS
SET SLWMSG=1
GOTO :EOF

:TEST_SHOWALLALERTS_VAL
SET currently=Checking if SHOW_ALL_ALERTS is a valid answer (0 or 1)...
SET currently2=
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%SHOW_ALL_ALERTS%"=="0" GOTO :EOF
IF "%SHOW_ALL_ALERTS%"=="1" GOTO :EOF
SET currently=SHOW_ALL_ALERTS does not equal "1" or "0"
SET currently2=
CALL :STATS
SET currently=Setting SHOW_ALL_ALERTS to "1"...
SET currently2=
CALL :STATS
SET SHOW_ALL_ALERTS=1
GOTO :EOF


:TEST_STARTMINIMIZED
SET currently=Checking if STARTMINIMIZED is a valid answer (0 or 1)...
SET currently2=
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%START_MINIMIZED%"=="0" GOTO :EOF
IF "%START_MINIMIZED%"=="1" GOTO :EOF
SET currently=START_MINIMIZED does not equal "1" or "0"
SET currently2=
CALL :STATS
SET currently=Setting START_MINIMIZED to "0"...
SET currently2=
CALL :STATS
SET START_MINIMIZED=0
GOTO :EOF


:TEST_STARTATLOGON
SET currently=Checking if START_AT_LOGON is a valid answer (0 or 1)...
SET currently2=
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%START_AT_LOGON%"=="0" GOTO :EOF
IF "%START_AT_LOGON%"=="1" GOTO :EOF
SET currently=START_AT_LOGON does not equal "1" or "0"
SET currently2=
CALL :STATS
SET currently=Setting START_AT_LOGON to "0"...
SET currently2=
CALL :STATS
SET START_AT_LOGON=0
GOTO :EOF


:TEST_OSDETECTOVERRIDE_VAL
SET currently=Checking if OS_DETECT_OVERRIDE is a valid answer (0 or 1)...
SET currently2=
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%OS_DETECT_OVERRIDE%"=="0" GOTO :EOF
IF "%OS_DETECT_OVERRIDE%"=="1" GOTO :EOF
SET currently=OS_DETECT_OVERRIDE does not equal "1" or "0"
SET currently2=
CALL :STATS
SET currently=Setting OS_DETECT_OVERRIDE to "0"...
SET currently2=
CALL :STATS
SET OS_DETECT_OVERRIDE=0
GOTO :EOF


:NEED_NETWORK
SET currently=Could not find "%NETWORK%"
SET currently2=
CALL :STATS
ECHO.
ECHO.
ECHO Would you like to view current network connections?
SET /P usrInpt=[y/n] 
IF "%usrInpt%"=="n" GOTO :DONT_DISPLAY_NETWORK_CONNECTIONS
IF "%usrInpt%"=="y" GOTO :DISPLAY_NETWORK_CONNECTIONS
GOTO :NEED_NETWORK
:DISPLAY_NETWORK_CONNECTIONS
SET currently2=Showing Network Connections...
CALL :STATS
IF %DEBUGN%==0 %SystemRoot%\explorer.exe /N,::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{21EC2020-3AEA-1069-A2DD-08002B30309D}\::{7007ACC7-3202-11D1-AAD2-00805FC1270E}


:DONT_DISPLAY_NETWORK_CONNECTIONS
CALL :STATS
ECHO.
ECHO.
ECHO Would you like to set the Network Name now?
SET /P usrInpt=[y/n] 
IF "%usrInpt%"=="n" GOTO :DONT_SET_NETWORK_NAME
IF "%usrInpt%"=="y" GOTO :SET_NETWORK_NAME
GOTO :DONT_DISPLAY_NETWORK_CONNECTIONS

:SET_NETWORK_NAME
SET currently2=Opening file to edit Settings...
CALL :STATS
IF %DEBUGN%==0 notepad "%THISFILEPATH%"

:PAST_SET_NETWORK_NAME
GOTO :SETTINGS

:DONT_SET_NETWORK_NAME
SET currently=The network was not found. This program requires 
SET currently2=a valid connection name to run. EXITING...
SET isWaiting=1
CALL :STATS
CALL :STATS
SET isWaiting=0
EXIT



:SYSTEM_TOO_OLD
SET currently=This Operating System is not currently supported.
SET currently2=EXITING...
SET SpecificStatus=
SET isWaiting=1
CALL :STATS
CALL :STATS
SET isWaiting=0
EXIT


:FAILED
IF %CONTINUOUS%==1 GOTO :CONTINUOUS_FAIL
SET currently=Unable to Connect to Internet.
SET currently2=
SET SpecificStatus=
SET isWaiting=1
CALL :STATS
SET isWaiting=0
ECHO Retry?
SET /P usrInpt=[y/n] 
IF "%usrInpt%"=="n" EXIT
IF "%usrInpt%"=="y" GOTO :FIX
GOTO :FAILED


:CONTINUOUS_FAIL
SET currently=Unable to Connect to Internet (Retrying...)
SET currently2=
SET SpecificStatus= 
SET isWaiting=1
CALL :STATS
SET isWaiting=0
GOTO :FIX


:SUCCESS
IF %CONTINUOUS%==1 GOTO :CONTINUOUS_SUCCESS
SET currently=Successfully Connected to Internet. EXITING...
SET currently2=
SET SpecificStatus= 
SET isWaiting=0
CALL :STATS
ECHO.
ECHO.
ECHO If you still cannot access the internet, you may need
ECHO to log into the network via Cisco or a similar program.
CALL :PINGER
CALL :PINGER
IF %DEBUGN%==1 PAUSE
EXIT

:CONTINUOUS_SUCCESS
SET currently=Successfully Connected to Internet.
SET currently2=
SET SpecificStatus= 
CALL :STATS
SET currently=Waiting to re-check Internet Connection...
SET currently2=
SET SpecificStatus=
SET /A delaymins=CHECK_DELAY
CALL :WAIT
GOTO :TEST