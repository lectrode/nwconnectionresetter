:: -----Program Info-----
:: Name: 		Network Resetter
::
:: Verson:		11.4.901
::
:: Description:	Fixes network connection by trying each of the following:
::				1) Reset Network Connection (Quick Reset)
::				2) Reset IP Address
::				3) Reset Network Connection (Slow Reset)
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
::				network connection | please open with notepad for more information"
::				-To fix this please correct the NETWORK setting below.
::				
::				Regardless of what the "Disclaimer" says, this program
::				does not change or modify anything "system threatening"
::				(aka it's perfectly safe)
::				Of course, this cannot be guaranteed if you get this from
::				anyone other than Lectrode.
::
:: Disclaimer:	This program is provided "AS-IS" and the author has no
::				responsibility for what may happen to your computer.
::				Use at your own risk.



:: -----Main Settings------

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



::------------Misc Settings------------

:: Auto-Retry
::  "1" for On, "0" for Off
:: If the connection fixes fail in regular mode (not
:: CONTINUOUS), this makes the program continue to attempt
:: to fix the connection until it either succeeds or the 
:: program is closed
SET AUTO_RETRY=0

:: If CONTINUOUS is set to 1, this is how many minutes between
:: connection tests.
:: Integers Only! (aka 0,1,2,etc)
:: (anything else will be evaluated as "0")
SET CHECK_DELAY=1


:: Show ALL messages, even if they're unimportant
::  "1" for True, "0" for False
:: NOTE: Regardless of what you set this too, this program will 
:: always display important messages.
:: This option is mainly for people who like to follow along and
:: see exactly what the program is doing.
:: This is really only useful if SLWMSG is true.
SET SHOW_ALL_ALERTS=1


:: Show Advanced Testing Output
::  "1" for True, "0" for False
:: When true, will show more details reguarding testing 
:: the internet
SET SHOW_ADVANCED_TESTING=0


:: Slow Messages
::  "1" for True, "0" for False
:: When true, program will pause for every message it displays to 
:: allow the user to read them (run time will be longer)
SET SLWMSG=0


:: Timer Refresh Rate (Update every # seconds)
:: Integers greater than 0 Only! (aka 1,2,3,etc)
:: (anything else will be evaluated as "1")
:: (1-10 recommended)
SET TIMER_REFRESH_RATE=1


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
:: When true, program will minimize itself when it is run
:: This is especially usefull if you have the program running 
:: continuously and set to start at user log on.
SET START_MINIMIZED=0




::---------Advanced Settings-----------

:: Omit ALL user input
::  "1" for True, "0" for False
:: Instead of asking the user (you) for varification or to
:: adjust a setting, this program will assume that all settings
:: are intentional and will continue with whatever settings are
:: available.
:: Situations this effects:
:: -Failed first connection attempt: Continues with either exit
::  or retry, depending on what AUTO_RETRY is set to.
:: -Invalid Network Name: Continues without the NETWORK_RESET fixes
:: -All fixes disabled: Continues without any fixes. Check 
::  internet connection only
:: -About to run on unsupported OS: Continue running without
::  user varification
SET OMIT_USER_INPUT=0

:: Skip Initial Network Connection Test
:: "1" for True, "0" for False
:: Select this if you want the program to immediately attempt to 
:: fix your connection without testing the connection first
SET SKIP_INITIAL_NTWK_TEST=0

:: Try to reset the IP Address
::  "1" for True, "0" for False
:: Unless you frequently get stuck on "Reseting IP address" you
:: should leave this enabled.
SET USE_IP_RESET=1

:: Try to reset the Network Connection (Quick Reset)
::  "1" for True, "0" for False
:: In most cases this should be left enabled.
SET USE_NETWORK_RESET_FAST=1

:: Try to reset the Network Connection (Slow Reset)
::  "1" for True, "0" for False
:: Slow Reset works more often than Quick Reset.
:: Quick reset is tried first if it is enabled.
:: In most cases this should be left enabled.
SET USE_NETWORK_RESET=1


:: Don't test Network Name more than once
:: "1" for True, "0" for False
:: Setting to True is ideal on most computers as long as the 
:: Network Connection name does not change
SET ONLY_ONE_NETWORK_NAME_TEST=1


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






:: *************Main Code**************


:: -------------------Initialize Program--------------------


@ECHO OFF

:: Restart as administrator
:: DOES NOT CURRENTLY WORK!!!
IF "%HasBeenRunAsAdmin%"=="" (
	SET HasBeenRunAsAdmin=1
	REM RUNAS /user;admin "%~dpnx0"
	REM EXIT
)

:: Restart itself minimized if set to do so
IF "%restartingProgram%"=="" (
	IF "%START_MINIMIZED%"=="1" (
		IF "%MINIMIZED%"=="" (
			SET MINIMIZED=1
			START /MIN CMD /C "%~dpnx0"
			EXIT
		)
	)
)


:: Set CMD window size
MODE CON COLS=81 LINES=30

::Set initial variables
SET THISFILEPATH=%~0
SET THISFILENAME=%~n0.bat
SET restartingProgram=
SET has_tested_ntwk_name_recent=0

::Display program introduction
::Call it twice to last longer
CALL :PROGRAM_INTRO

::Initial CHECKS
SET currently=Checking validity of Settings...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
CALL :TEST_SLWMSG_VAL
CALL :TEST_SHOWALLALERTS_VAL
CALL :TEST_DEBUGN_VAL
CALL :TEST_CONTINUOUS_VAL
CALL :TEST_OSDETECTOVERRIDE_VAL
CALL :TEST_USENETWORKRESET
CALL :TEST_USENETWORKRESETFAST
CALL :TEST_USEIP_VAL
CALL :TEST_OMITUSERINPUT
CALL :TEST_FIXES_VALS

IF %USE_NETWORK_RESET%==1 (
	CALL :DETECT_OS
	CALL :TEST_NETWORK_NAME 1
	CALL :TEST_MINUTES_VAL
) ELSE (
	IF %USE_NETWORK_RESET_FAST%==1 (
		CALL :DETECT_OS
		CALL :TEST_NETWORK_NAME 1
		CALL :TEST_MINUTES_VAL
	)
)
CALL :TEST_TIMERREFRESHRATE_VAL
CALL :TEST_CHECKDELAY_VAL
CALL :TEST_STARTATLOGON
CALL :TEST_STARTMINIMIZED
CALL :TEST_AUTORETRY_VAL
CALL :TEST_SHOWADVANCEDTESTING
CALL :TEST_SKIPINITIALNTWKTEST_VAL
CALL :TEST_ONLYONENETWORKNAMETEST


::Copy to startup folder if set to start when 
::user logs on
CALL :CHECK_START_AT_LOGON

:: -----------------END INITIALIZE PROGRAM------------------



:: ------------------TO FIX OR NOT TO FIX-------------------
IF %Using_Fixes%==0 GOTO :CHECK_CONNECTION_ONLY
:: ----------------END TO FIX OR NOT TO FIX-----------------


:: -------------INITIAL NETWORK CONNECTION TEST-------------
:: BRANCH (SUCCESS || FIX)
:: Determine if connection needs to be fixed

IF %SKIP_INITIAL_NTWK_TEST%==1 GOTO :FIX

CALL :TEST isConnected
IF %isConnected%==1 GOTO :SUCCESS
GOTO :FIX
:: -----------END INITIAL NETWORK CONNECTION TEST-----------



:PROGRAM_INTRO
:: ----------------------PROGRAM INTRO----------------------
:: Displays notice for 3 seconds
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
:: ---------------------END PROGRAM INTRO--------------------


:STATS
:: ---------------------PROGRAM STATUS-----------------------
CLS
						ECHO  ******************************************************************************
						ECHO  *      ******   Lectrode's Network Connection Resetter v11.4.901  ******     *
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
:: ---------------------END PROGRAM STATUS----------------------



:TEST
SETLOCAL
:: ------------------TEST INTERNET CONNECTION-------------------
:: RETURN (isConnected= (1 || 0) )

SET currently=Testing Internet Connection...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS


SET main_tests=0



:TEST_INIT
IF %DEBUGN%==1 GOTO :TEST_FAILED

IF %SHOW_ADVANCED_TESTING%==1 ECHO Setting Initial Variables...
SET founds=0
SET times=0
SET nots=0
SET totalTests=0
SET fluke_test_eliminator=5
SET maxTestLimit=15

IF %SHOW_ADVANCED_TESTING%==1 ECHO Attempting to locate www.google.com...
:TEST_TESTING
FOR /F "delims=" %%a IN ('PING -n 1 www.google.com') DO @SET ping_test=%%a

ECHO %ping_test% |FINDSTR "request could not find" >NUL
IF NOT ERRORLEVEL 1 GOTO :TEST_NOT_CONNECTED

ECHO %ping_test% |FINDSTR "Minimum " >NUL
IF NOT ERRORLEVEL 1 GOTO :TEST_CONNECTED

GOTO :TEST_TIMED_OUT





:TEST_CONNECTED
SET /A totalTests+=1
IF %SHOW_ADVANCED_TESTING%==1 ECHO %totalTests%: Found Connection
SET /A founds+=1
SET times=0
SET nots=0
IF %founds% GEQ %fluke_test_eliminator% GOTO :TEST_SUCCEEDED
GOTO :TEST_TESTING


:TEST_NOT_CONNECTED
SET /A totalTests+=1
IF %SHOW_ADVANCED_TESTING%==1 ECHO %totalTests%: Did not find Connection
SET /A nots+=1
SET founds=0
SET times=0
IF %nots% GEQ %fluke_test_eliminator% GOTO :TEST_FAILED
GOTO :TEST_TESTING


:TEST_TIMED_OUT
SET /A totalTests+=1
IF %SHOW_ADVANCED_TESTING%==1 ECHO %totalTests%: Request Timed Out
SET /A times+=1
SET founds=0
SET nots=0
IF %times% GEQ %fluke_test_eliminator% GOTO :TEST_EXCEEDED_TEST_LIMIT
IF %totalTests% GEQ %maxTestLimit% GOTO :TEST_EXCEEDED_TEST_LIMIT
GOTO :TEST_TESTING


:TEST_FAILED
:: DEBUGGING || FAILED A TEST
SET /A main_tests=main_tests+1

IF %SLWMSG%==1 CALL :PINGER

SET currently=Internet Connection not detected
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS

ENDLOCAL&SET %~1=0
GOTO :EOF

:TEST_EXCEEDED_TEST_LIMIT
IF %SLWMSG%==1 CALL :PINGER
IF NOT %SLWMSG%==1 IF %SHOW_ADVANCED_TESTING%==1 CALL :PINGER 1

SET currently=Unable to varify internet connectivity. This is a
SET currently2=poor quality connection. Internet browsing may be slow.
SET SpecificStatus=
SET isWaiting=1
CALL :STATS
SET isWaiting=0

ENDLOCAL&SET %~1=1
GOTO :EOF

:TEST_SUCCEEDED
IF %SLWMSG%==1 CALL :PINGER
IF NOT %SLWMSG%==1 IF %SHOW_ADVANCED_TESTING%==1 CALL :PINGER 1

ENDLOCAL&SET %~1=1
GOTO :EOF
:: ----------------END TEST INTERNET CONNECTION-----------------




:FIX
:: ------------------FIX INTERNET CONNECTION--------------------
:: BRANCH (SUCCESS || FAILED)
:: Call the different methods of fixing
:: This allows for different fixes to be added later


:: *****RESET NETWORK CONNECTION FAST*****

IF %USE_NETWORK_RESET_FAST%==0 GOTO :END_RESET_NETORK_FAST_MAIN
	CALL :FIX_RESET_NETWORK_FAST
	CALL :TEST isConnected
	IF %isConnected%==1 GOTO :SUCCESS

	::FIX FAILED
	SET currently=Quickly reseting the Network Connection
	SET currently2=did not fix the problem
	SET SpecificStatus=
	SET isWaiting=0
	CALL :STATS
:END_RESET_NETORK_FAST_MAIN
:: ***END RESET NETWORK CONNECTION FAST***


:: *****RESET IP ADDRESS*****
IF %USE_IP_RESET%==0 GOTO :END_RESET_IP_MAIN
	CALL :FIX_RESET_IP
	CALL :TEST isConnected
	IF %isConnected%==1 GOTO :SUCCESS
	
	::FIX FAILED
	SET currently=Resetting IP did not fix the problem
	SET currently2=
	SET SpecificStatus=
	SET isWaiting=0
	CALL :STATS
	
:END_RESET_IP_MAIN
:: ***END RESET IP ADDRESS***


:: *****RESET NETWORK CONNECTION*****

IF %USE_NETWORK_RESET%==0 GOTO :END_RESET_NETORK_MAIN
	CALL :FIX_RESET_NETWORK
	CALL :TEST isConnected
	IF %isConnected%==1 GOTO :SUCCESS

	::FIX FAILED
	SET /A mins="TTLSCNDS/60"
	SET currently=Disabling Network for %mins% minutes
	SET currently2=did not fix the problem
	SET SpecificStatus=
	SET isWaiting=0
	CALL :STATS
:END_RESET_NETORK_MAIN
:: ***END RESET NETWORK CONNECTION***



::FIXES FAILED
GOTO :FAILED
:: -----------------END FIX INTERNET CONNECTION------------------




:FIX_RESET_IP
:: -------------------FIX: RESET IP ADDRESS----------------------
:: Fix internet connection by reseting the IP address

SET currently=Releasing IP Address
SET currently2=*May take a couple minutes*
SET SpecificStatus=
SET isWaiting=0
CALL :STATS

::Release IP Address
IF %DEBUGN%==0 IPCONFIG /RELEASE >NUL


::Flush DNS Cache
SET currently=Flushing DNS Cache
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS

IF %DEBUGN%==0 IPCONFIG /FLUSHDNS >NUL


::Renew IP Address
SET currently=Renewing IP Address
SET currently2=*May take a couple minutes*
SET SpecificStatus=
SET isWaiting=0
CALL :STATS

IF %DEBUGN%==0 IPCONFIG /RENEW >NUL

:: CANNOT TEST HERE
:: Checking network connection here causes unecessary recursion
GOTO :EOF
:: -----------------END FIX: RESET IP ADDRESS--------------------



:FIX_RESET_NETWORK_FAST
:: -------------FIX: RESET NETWORK CONNECTION FAST---------------
::Disable Network, Enable Network
CALL :DISABLE_NW
CALL :ENABLE_NW

:: CANNOT TEST HERE
:: Checking network connection here causes unwanted recursion 

GOTO :EOF
:: -----------END FIX: RESET NETWORK CONNECTION FAST-------------



:FIX_RESET_NETWORK
:: ---------------FIX: RESET NETWORK CONNECTION------------------
::Disable Network, Wait, Enable Network

::Disable network connection
CALL :DISABLE_NW

SET currently=Waiting to re-enable "%NETWORK%"
SET currently2=
SET SpecificStatus=

::Wait specified time
SET delaymins=%MINUTES%
CALL :WAIT

::Enable network connection
CALL :ENABLE_NW


:: CANNOT TEST HERE
:: Checking network connection here causes unwanted recursion 

GOTO :EOF
:: -------------END FIX: RESET NETWORK CONNECTION----------------


:PINGER
:: ------------------------PROGRAM SLEEP-------------------------
:: SLEEP
:: Program sleeps for %1 seconds
IF "%1"=="" SET pN=3
IF NOT "%1"=="" SET pN=%1
PING -n 2 -w 1000 127.0.0.1>NUL
PING -n %pN% -w 1000 127.0.0.1>NUL
GOTO :EOF
:: ------------------------END PROGRAM SLEEP---------------------


:WAIT
SETLOCAL
:: -----------------------PROGRAM TIMER--------------------------

:: ******INITIALIZE TIMER*****

::Calculate total time
SET /A PINGS="(delaymins*60)/TIMER_REFRESH_RATE"
SET /A TTLSCNDS="PINGS*TIMER_REFRESH_RATE"
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

:: ****END INITIALIZE TIMER***


:WAITING
:: *****TICKING TIMER*****


::Calculate remaining time
SET /A left="PINGS-ticker"
SET /A ttlscndslft="left*TIMER_REFRESH_RATE"
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

::Display updated TimeStamp
SET isWaiting=0
CALL :STATS
CALL :PINGER %TIMER_REFRESH_RATE%

::Cycle through "WAITING" again if waiting time 
::has not been reached
IF %ticker% LEQ %PINGS% GOTO :WAITING
ENDLOCAL

SET has_tested_ntwk_name_recent=0
GOTO :EOF
:: ---------------------END PROGRAM TIMER------------------------



:DISABLE_NW
:: -----------------DISABLE NETWORK CONNECTION-------------------
::Determine OS and disable via a compatible method

SET currently=Disabling "%NETWORK%"...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS

IF %ONLY_ONE_NETWORK_NAME_TEST%==0 CALL :TEST_NETWORK_NAME
IF %DEBUGN%==0 IF %winVistaOrNewer%==1 NETSH INTERFACE SET INTERFACE "%NETWORK%" DISABLE
IF %DEBUGN%==0 IF %winVistaOrNewer%==0 CALL :DISABLE_OLD_OS

SET currently="%NETWORK%" Disabled
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
GOTO :EOF
:: ---------------END DISABLE NETWORK CONNECTION-----------------


:ENABLE_NW
:: ------------------ENABLE NETWORK CONNECTION-------------------
::Determine OS and enable via a compatible method

SET currently=Enabling "%NETWORK%"
SET currently2=
SET SpecificStatus=
SET isWaiting=0 
CALL :STATS

:: TEST_NETWORK_NAME (EXIT || RETURN)
IF %ONLY_ONE_NETWORK_NAME_TEST%==0 CALL :TEST_NETWORK_NAME
IF %DEBUGN%==0 IF %winVistaOrNewer%==1 NETSH INTERFACE SET INTERFACE "%NETWORK%" ENABLE
IF %DEBUGN%==0 IF %winVistaOrNewer%==0 CALL :ENABLE_OLD_OS

SET currently="%NETWORK%" Enabled
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
GOTO :EOF
:: ----------------END ENABLE NETWORK CONNECTION-----------------


:DISABLE_OLD_OS
:: ----------------DISABLE CONNECTION FOR WINXP------------------
:: No known way to disable from cmd line. Instead, we must
:: create a temp vbs file that disables it and deletes 
:: itself when its run
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
SET isWaiting=0
CALL :STATS
cscript DisableNetwork.vbs
GOTO :EOF
:: --------------END DISABLE CONNECTION FOR WINXP----------------


:ENABLE_OLD_OS
:: -----------------ENABLE CONNECTION FOR WINXP------------------
:: No known way to enable from cmd line. Instead, we must
:: create a temp vbs file that enables it and deletes 
:: itself when its run
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
SET isWaiting=0
CALL :STATS
cscript EnableNetwork.vbs
GOTO :EOF
:: ---------------END ENABLE CONNECTION FOR WINXP----------------



:DETECT_OS
:: -------------------DETECT OPERATING SYSTEM--------------------
:: SAFE BRANCH (EXIT || RETURN)
:: RETURN (winVistaOrNewer (1 || 0) )
:: Detect OS and return compatibility

SET currently=Checking if Operating System is supported...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS

:: Get OS name
VER | FIND "2003" > NUL
IF %ERRORLEVEL% == 0 GOTO :UNSUPPORTED
VER | FIND "XP" > NUL
IF %ERRORLEVEL% == 0 GOTO :OLDVER
VER | FIND "2000" > NUL
IF %ERRORLEVEL% == 0 GOTO :UNSUPPORTED
VER | FIND "NT" > NUL
IF %ERRORLEVEL% == 0 GOTO :UNSUPPORTED
FOR /F "tokens=3*" %%i IN ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName ^| Find "ProductName"') DO set vers=%%i %%j
ECHO %vers% | find "Windows 7" > NUL
IF %ERRORLEVEL% == 0 GOTO :NewVer
ECHO %vers% | find "Windows Server 2008" > NUL
IF %ERRORLEVEL% == 0 GOTO :NewVer
ECHO %vers% | find "Windows Vista" > NUL
IF %ERRORLEVEL% == 0 GOTO :NewVer


:UNSUPPORTED
:: INTERNAL BRANCH (RUN_ON_SUPPORTED || SYSTEM_UNSUPPORTED)
SET currently=Operating System is unsupported
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
ECHO.
ECHO.
ECHO This OS is unsupported:
VER
CALL :PINGER
IF %OS_DETECT_OVERRIDE%==1 GOTO :RUN_ON_UNSUPPORTED
CALL :PINGER
GOTO :SYSTEM_UNSUPPORTED

:OldVer
:: RETURN winVistaOrNewer (0)
SET currently=Operating System is supported
SET currently2=(WindowsXP)
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
SET winVistaOrNewer=0
GOTO :EOF

:NewVer
:: RETURN winVistaOrNewer (1)
SET currently=Operating System is supported
SET currently2= (%vers%)
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
SET winVistaOrNewer=1
GOTO :EOF


:RUN_ON_UNSUPPORTED
:: INTERNAL BRANCH (CONTINUE_RUN_ANYWAY || SYSTEM_UNSUPPORTED)
SET currently=Attempting to run on UNSUPPORTED Operating System...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
IF %OMIT_USER_INPUT%==1 GOTO :CONTINUE_RUN_ANYWAY
ECHO.
ECHO.
ECHO This may cuase unexpected behavior in this program.
ECHO Are you sure you want to do this?
SET /P usrInpt=[y/n] 
IF "%usrInpt%"=="y" GOTO :CONTINUE_RUN_ANYWAY
IF "%usrInpt%"=="n" GOTO :SYSTEM_UNSUPPORTED
GOTO :RUN_ON_UNSUPPORTED

:CONTINUE_RUN_ANYWAY
:: RETURN winVistaOrNewer (0)
SET currently=Continuing to run program. OS is treated
SET currently2=as though it were WindowsXP
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
SET winVistaOrNewer=0
GOTO :EOF
:: -----------------END DETECT OPERATING SYSTEM------------------



:CHECK_START_AT_LOGON
:: --------------------CHECK START AT LOG ON---------------------
:: Copies self to Startup Folder if START_AT_LOGON==1
:: Else Deletes "NetworkResetterByLectrode.bat" in 
:: Startup Folder

SET currently=Checking if set to start at user log on...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF %START_AT_LOGON%==0 GOTO :DONT_STARTUP

SET currently=Program is set to start at user log on.
SET currently2=Copying self to Startup Folder...
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
COPY %THISFILENAME% "%systemdrive%\Documents and Settings\%USERNAME%\Start Menu\Programs\Startup\NetworkResetterByLectrode.bat" >NUL
GOTO :EOF

:DONT_STARTUP
SET currently=Program is not set to start at user log on.
SET currently2=Removing copies of self in Startup folder, if any
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
TYPE NUL > "%systemdrive%\Documents and Settings\%USERNAME%\Start Menu\Programs\Startup\NetworkResetterByLectrode.bat"
DEL /F /Q "%systemdrive%\Documents and Settings\%USERNAME%\Start Menu\Programs\Startup\NetworkResetterByLectrode.bat" >NUL

GOTO :EOF
:: ------------------END CHECK START AT LOG ON-------------------



:TEST_NETWORK_NAME
:: ----------------------TEST NETWORK NAME-----------------------
:: SAFE BRANCH (EXIT || RETURN)

IF NOT "%~1"=="1" IF %has_tested_ntwk_name_recent% GEQ 1 GOTO :EOF
SET /A has_tested_ntwk_name_recent+=1

SET currently=Checking if "%NETWORK%"
SET currently2=is a valid network connection name...
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF %DEBUGN%==0 NETSH INTERFACE SET INTERFACE NAME="%NETWORK%" NEWNAME="%NETWORK%"|FIND "name is not registered " >NUL
IF %DEBUGN%==0 IF NOT ERRORLEVEL 1 GOTO :NEED_NETWORK
GOTO :EOF
:: --------------------END TEST NETWORK NAME---------------------


:TEST_MINUTES_VAL
:: ----------------------TEST MINUTES VALUE----------------------
:: Makes certain MINUTES has a valid value
:: Sets to 10 if invalid

SET currently=Checking if MINUTES is a valid number...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%MINUTES%"=="0" GOTO :EOF

SET /a num=MINUTES
IF "%num%"=="0" (
	SET currently="%MINUTES%" is not a valid answer.
	SET currently2=Setting MINUTES to 10...
	SET SpecificStatus=
	SET isWaiting=0
	CALL :STATS
	SET MINUTES=10
)
GOTO :EOF
:: --------------------END TEST MINUTES VALUE--------------------


:TEST_CONTINUOUS_VAL
:: ---------------------TEST CONTINUOUS VALUE--------------------
:: Makes certain CONTINUOUS has a valid value
:: Sets to 0 if invalid

SET currently=Checking if CONTINUOUS has a valid value (0 or 1)...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%CONTINUOUS%"=="0" GOTO :EOF
IF "%CONTINUOUS%"=="1" GOTO :EOF
SET currently=CONTINUOUS does not equal "1" or "0"
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET currently=Setting CONTINUOUS to "0"...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET CONTINUOUS=0
GOTO :EOF
:: -------------------END TEST CONTINUOUS VALUE------------------


:TEST_USENETWORKRESET
:: -----------------TEST USE_NETWORK_RESET VALUE-----------------
:: Makes certain USE_NETWORK_RESET has a valid value
:: Sets to 1 if invalid

SET currently=Checking if USE_NETWORK_RESET has a valid value (0 or 1)...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%USE_NETWORK_RESET%"=="0" GOTO :EOF
IF "%USE_NETWORK_RESET%"=="1" GOTO :EOF
SET currently=USE_NETWORK_RESET does not equal "1" or "0"
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET currently=Setting USE_NETWORK_RESET to "1"...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET USE_NETWORK_RESET=1
GOTO :EOF
:: ---------------END TEST USE_NETWORK_RESET VALUE---------------


:TEST_USENETWORKRESETFAST
:: ---------------TEST USE_NETWORK_RESET_FAST VALUE--------------
:: Makes certain USE_NETWORK_RESET_FAST has a valid value
:: Sets to 1 if invalid

SET currently=Checking if USE_NETWORK_RESET_FAST has a valid 
SET currently2=value (0 or 1)...
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%USE_NETWORK_RESET_FAST%"=="0" GOTO :EOF
IF "%USE_NETWORK_RESET_FAST%"=="1" GOTO :EOF
SET currently=USE_NETWORK_RESET_FAST does not equal "1" or "0"
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET currently=Setting USE_NETWORK_RESET_FAST to "1"...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET USE_NETWORK_RESET_FAST=1
GOTO :EOF
:: -------------END TEST USE_NETWORK_RESET_FAST VALUE------------


:TEST_USEIP_VAL
:: -------------------TEST USE_IP_RESET VALUE--------------------
:: Makes certain USE_IP_RESET has valid value
:: Sets to 1 if invalid

SET currently=Checking if USE_IP_RESET has a valid value (0 or 1)...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%USE_IP_RESET%"=="0" GOTO :EOF
IF "%USE_IP_RESET%"=="1" GOTO :EOF
SET currently=USE_IP_RESET does not equal "1" or "0"
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET currently=Setting USE_IP_RESET to "1"...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET USE_IP_RESET=1
GOTO :EOF
:: -----------------END TEST USE_IP_RESET VALUE------------------


:TEST_CHECKDELAY_VAL
:: -------------------TEST CHECK_DELAY VALUE---------------------
:: Makes certain CHECK_DELAY has valid value
:: Sets to 3 if invalid

SET currently=Checking if CHECK_DELAY is a valid number...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%CHECK_DELAY%"=="0" GOTO :EOF

SET /a num=CHECK_DELAY
IF "%num%"=="0" (
	SET currently="%CHECK_DELAY%" is not a valid value.
	SET currently2=Setting CHECK_DELAY to 3...
	SET SpecificStatus=
	SET isWaiting=0
	CALL :STATS
	SET CHECK_DELAY=3
)
GOTO :EOF
:: -----------------END TEST CHECK_DELAY VALUE-------------------


:TEST_DEBUGN_VAL
:: ---------------------TEST DEBUGN VALUE------------------------
:: Makes certain DEBUGN has valid value
:: Sets to 0 if invalid

SET currently=Checking if DEBUGN is a valid value (0 or 1)...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%DEBUGN%"=="0" GOTO :EOF
IF "%DEBUGN%"=="1" GOTO :EOF
SET currently=DEBUGN does not equal "1" or "0"
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET currently=Setting DEBUGN to "0"...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET DEBUGN=0
GOTO :EOF
:: -------------------END TEST DEBUGN VALUE----------------------


:TEST_SLWMSG_VAL
:: ---------------------TEST SLWMSG VALUE------------------------
:: Makes certain SLWMSG has valid value
:: Sets to 1 if invalid

SET currently=Checking if SLWMSG has a valid value (0 or 1)...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%SLWMSG%"=="0" GOTO :EOF
IF "%SLWMSG%"=="1" GOTO :EOF
SET currently=SLWMSG does not equal "1" or "0"
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET currently=Setting SLWMSG to "1"...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET SLWMSG=1
GOTO :EOF
:: -------------------END TEST SLWMSG VALUE----------------------


:TEST_SHOWALLALERTS_VAL
:: ----------------TEST SHOW_ALL_ALERTS VALUE--------------------
:: Makes certain SHOW_ALL_ALERTS has valid value
:: Sets to 1 if invalid

SET currently=Checking if SHOW_ALL_ALERTS has a valid value (0 or 1)...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%SHOW_ALL_ALERTS%"=="0" GOTO :EOF
IF "%SHOW_ALL_ALERTS%"=="1" GOTO :EOF
SET currently=SHOW_ALL_ALERTS does not equal "1" or "0"
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET currently=Setting SHOW_ALL_ALERTS to "1"...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET SHOW_ALL_ALERTS=1
GOTO :EOF
:: --------------END TEST SHOW_ALL_ALERTS VALUE------------------



:TEST_TIMERREFRESHRATE_VAL
:: ---------------TEST TIMER_REFRESH_RATE VALUE------------------
:: Makes certain TIMER_REFRESH_RATE has valid value
:: Sets to 3 if invalid

SET currently=Checking if TIMER_REFRESH_RATE has a valid 
SET currently2=value (1,2,3,etc)...
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS

SET /a num=TIMER_REFRESH_RATE
IF "%num%"=="0" (
	SET currently="%TIMER_REFRESH_RATE%" is not a valid value.
	SET currently2=Setting TIMER_REFRESH_RATE to 3...
	SET SpecificStatus=
	SET isWaiting=0
	CALL :STATS
	SET TIMER_REFRESH_RATE=3
)
IF %TIMER_REFRESH_RATE% GTR 0 GOTO :EOF
SET currently="%TIMER_REFRESH_RATE%" is not a valid value.
SET currently2=Setting TIMER_REFRESH_RATE to 3...
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET TIMER_REFRESH_RATE=3
GOTO :EOF
:: -------------END TEST TIMER_REFRESH_RATE VALUE----------------



:TEST_STARTMINIMIZED
:: ----------------TEST START_MINIMIZED VALUE--------------------
:: Makes certain START_MINIMIZED has valid value
:: Sets to 0 if invalid

SET currently=Checking if STARTMINIMIZED has a valid value (0 or 1)...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%START_MINIMIZED%"=="0" GOTO :EOF
IF "%START_MINIMIZED%"=="1" GOTO :EOF
SET currently=START_MINIMIZED does not equal "1" or "0"
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET currently=Setting START_MINIMIZED to "0"...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET START_MINIMIZED=0
GOTO :EOF
:: --------------END TEST START_MINIMIZED VALUE------------------


:TEST_STARTATLOGON
:: ----------------TEST START_AT_LOGON VALUE---------------------
:: Makes certain START_AT_LOGON has valid value
:: Sets to 0 if invalid

SET currently=Checking if START_AT_LOGON has a valid value (0 or 1)...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%START_AT_LOGON%"=="0" GOTO :EOF
IF "%START_AT_LOGON%"=="1" GOTO :EOF
SET currently=START_AT_LOGON does not equal "1" or "0"
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET currently=Setting START_AT_LOGON to "0"...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET START_AT_LOGON=0
GOTO :EOF
:: --------------END TEST START_AT_LOGON VALUE-------------------


:TEST_OMITUSERINPUT
:: ----------------TEST OMIT_USER_INPUT VALUE--------------------
:: Makes certain OMIT_USER_INPUT has valid value
:: Sets to 0 if invalid

SET currently=Checking if OMIT_USER_INPUT has a valid value (0 or 1)...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%OMIT_USER_INPUT%"=="0" GOTO :EOF
IF "%OMIT_USER_INPUT%"=="1" GOTO :EOF
SET currently=OMIT_USER_INPUT does not equal "1" or "0"
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET currently=Setting OMIT_USER_INPUT to "0"...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET OMIT_USER_INPUT=0
GOTO :EOF
:: --------------END TEST OMIT_USER_INPUT VALUE------------------



:TEST_SKIPINITIALNTWKTEST_VAL
:: ------------TEST SKIP_INITIAL_NTWK_TEST VALUE-----------------
:: Makes certain SKIP_INITIAL_NTWK_TEST has valid value
:: Sets to 0 if invalid

SET currently=Checking if SKIP_INITIAL_NTWK_TEST has a valid value (0 or 1)...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%SKIP_INITIAL_NTWK_TEST%"=="0" GOTO :EOF
IF "%SKIP_INITIAL_NTWK_TEST%"=="1" GOTO :EOF
SET currently=SKIP_INITIAL_NTWK_TEST does not equal "1" or "0"
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET currently=Setting SKIP_INITIAL_NTWK_TEST to "0"...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET SKIP_INITIAL_NTWK_TEST=0
GOTO :EOF
:: ----------END TEST SKIP_INITIAL_NTWK_TEST VALUE---------------



:TEST_AUTORETRY_VAL
:: --------------------TEST AUTO_RETRY VALUE---------------------
:: Makes certain AUTO_RETRY has valid value
:: Sets to 0 if invalid

SET currently=Checking if AUTO_RETRY has a valid value (0 or 1)...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%AUTO_RETRY%"=="0" GOTO :EOF
IF "%AUTO_RETRY%"=="1" GOTO :EOF
SET currently=AUTO_RETRY does not equal "1" or "0"
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET currently=Setting AUTO_RETRY to "0"...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET AUTO_RETRY=0
GOTO :EOF
:: ------------------END TEST AUTO_RETRY VALUE-------------------



:TEST_SHOWADVANCEDTESTING
:: ------------TEST SHOW_ADVANCED_TESTING VALUE------------------
:: Makes certain SHOW_ADVANCED_TESTING has valid value
:: Sets to 0 if invalid

SET currently=Checking if SHOW_ADVANCED_TESTING has 
SET currently2=a valid value (0 or 1)...
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%SHOW_ADVANCED_TESTING%"=="0" GOTO :EOF
IF "%SHOW_ADVANCED_TESTING%"=="1" GOTO :EOF
SET currently=SHOW_ADVANCED_TESTING does not equal "1" or "0"
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET currently=Setting SHOW_ADVANCED_TESTING to "0"...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET SHOW_ADVANCED_TESTING=0
GOTO :EOF
:: -----------END TEST SHOW_ADVANCED_TESTING VALUE---------------



:TEST_ONLYONENETWORKNAMETEST
:: ----------TEST ONLY_ONE_NETWORK_NAME_TEST VALUE---------------
:: Makes certain ONLY_ONE_NETWORK_NAME_TEST has valid value
:: Sets to 0 if invalid

SET currently=Checking if ONLY_ONE_NETWORK_NAME_TEST has 
SET currently2=a valid value (0 or 1)...
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%ONLY_ONE_NETWORK_NAME_TEST%"=="0" GOTO :EOF
IF "%ONLY_ONE_NETWORK_NAME_TEST%"=="1" GOTO :EOF
SET currently=ONLY_ONE_NETWORK_NAME_TEST does not equal "1" or "0"
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET currently=Setting ONLY_ONE_NETWORK_NAME_TEST to "0"...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET ONLY_ONE_NETWORK_NAME_TEST=0
GOTO :EOF
:: ---------END TEST ONLY_ONE_NETWORK_NAME_TEST VALUE------------




:TEST_FIXES_VALS
:: --------------------TEST FIXES VALUES-------------------------
:: If fixes are disabled, gives option of enable both
:: or Continue

SET currently=Checking if values for Fixes are valid...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS

IF %USE_IP_RESET%==1 GOTO :TEST_FIXES_VALS_OK
IF %USE_NETWORK_RESET%==1 GOTO :TEST_FIXES_VALS_OK

:TEST_FIXES_VALS_INQUERY
SET currently=Both fixes are disabled.
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
IF %OMIT_USER_INPUT%==1 GOTO :TEST_FIXES_VALS_AUTO
ECHO.
ECHO.
ECHO Would you like to temporarily enable both of the fixes?
ECHO.
ECHO [ "n" : Run program but check internet connection only ]
ECHO [ "y" : Enable both fixes ]
ECHO.

SET /P usrInpt=[y/n] 
IF "%usrInpt%"=="n" GOTO :TEST_FIXES_VALS_LEAVE
IF "%usrInpt%"=="y" GOTO :TEST_FIXES_VALS_SET_ENABLE
GOTO :TEST_FIXES_VALS_INQUERY


:TEST_FIXES_VALS_LEAVE
SET currently=Both fixes are disabled. This program will not
SET currently2=fix the connection if it is unconnected.
SET SpecificStatus=
SET Using_Fixes=0
SET isWaiting=0
CALL :STATS
GOTO :EOF


:TEST_FIXES_VALS_SET_ENABLE
SET currently=Setting USE_IP_RESET and USE_NETWORK_RESET to 1
SET currently2=(enabling both fixes)
SET SpecificStatus=
SET isWaiting=1
CALL :STATS
SET isWaiting=0
SET USE_IP_RESET=1
SET USE_NETWORK_RESET=1
SET Using_Fixes=1
SET currently=Checking validity of Settings...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL STATS
GOTO :EOF


:TEST_FIXES_VALS_OK
SET Using_Fixes=1

GOTO :EOF


:TEST_FIXES_VALS_AUTO
SET Using_Fixes=0

GOTO :EOF
:: ------------------END TEST FIXES VALUES-----------------------



:TEST_OSDETECTOVERRIDE_VAL
:: --------------TEST OS_DETECT_OVERRIDE VALUE-------------------
:: Makes certain OS_DETECT_OVERRIDE has valid value
:: Sets to 0 if invalid

SET currently=Checking if OS_DETECT_OVERRIDE has a valid value (0 or 1)...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%OS_DETECT_OVERRIDE%"=="0" GOTO :EOF
IF "%OS_DETECT_OVERRIDE%"=="1" GOTO :EOF
SET currently=OS_DETECT_OVERRIDE does not equal "1" or "0"
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET currently=Setting OS_DETECT_OVERRIDE to "0"...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET OS_DETECT_OVERRIDE=0
GOTO :EOF
:: ------------END TEST OS_DETECT_OVERRIDE VALUE-----------------


:NEED_NETWORK
:: ---------------PROGRAM NEEDS NETWORK NAME---------------------
:: GOTO (NEED_NETWORK_AUTO || EXIT (COMPLETE || RESTART))
SET currently=Could not find "%NETWORK%"
SET currently2=NOTE: This program requires admin privaleges to run!
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
IF %OMIT_USER_INPUT%==1 GOTO :NEED_NETWORK_AUTO
ECHO.
ECHO.
ECHO Would you like to view current network connections?
SET /P usrInpt=[y/n] 
IF "%usrInpt%"=="n" GOTO :DONT_DISPLAY_NETWORK_CONNECTIONS
IF "%usrInpt%"=="y" GOTO :DISPLAY_NETWORK_CONNECTIONS
GOTO :NEED_NETWORK
:DISPLAY_NETWORK_CONNECTIONS
SET currently2=Showing Network Connections...
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
IF %DEBUGN%==0 %SystemRoot%\explorer.exe /N,::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{21EC2020-3AEA-1069-A2DD-08002B30309D}\::{7007ACC7-3202-11D1-AAD2-00805FC1270E}


:DONT_DISPLAY_NETWORK_CONNECTIONS
SET currently=Could not find "%NETWORK%"
SET currently2=
SET SpecificStatus=
SET isWaiting=0
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
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
ECHO.
ECHO.
ECHO (Please close file to continue)
IF %DEBUGN%==0 notepad "%THISFILEPATH%"

:PAST_SET_NETWORK_NAME
:: Self restart
SET currently=Restarting Program...
SET currently2=
SET SpecificStatus=
SET isWaiting=1
CALL :STATS
SET restartingProgram=1
START CMD /C "%THISFILEPATH%"
EXIT

:DONT_SET_NETWORK_NAME
SET currently=The network was not found. This program requires 
SET currently2=a valid connection name to run. EXITING...
SET SpecificStatus=
SET isWaiting=1
CALL :STATS
CALL :STATS
SET isWaiting=0
EXIT

:NEED_NETWORK_AUTO
SET currently=The network was not found. NETWORK_RESET fixes
SET currently2=will be temporarily disabled
SET SpecificStatus=
SET isWaiting=1
CALL :STATS
SET isWaiting=0
SET USE_NETWORK_RESET=0
SET USE_NETWORK_RESET_FAST=0
GOTO :EOF
:: -------------END PROGRAM NEEDS NETWORK NAME-------------------




:SYSTEM_UNSUPPORTED
:: --------------UNSUPPORTED OPERATING SYSTEM--------------------
:: EXIT
SET currently=This Operating System is not currently supported.
SET currently2=EXITING...
SET SpecificStatus=
SET isWaiting=1
CALL :STATS
CALL :STATS
SET isWaiting=0
EXIT
:: ------------END UNSUPPORTED OPERATING SYSTEM------------------



:CHECK_CONNECTION_ONLY
:: ---------CHECK INTERNET CONNECION ONLY (NO FIXES)-------------
:: SAFE BRANCH (GOTO ( CHECK_CONNECTION_ONLY || EXIT ) )
SET currently=Set to check connection only
SET currently2= (will not fix connection if not connected)
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
CALL :TEST isConnected
IF %isConnected%==1 GOTO :CHECK_CONNECTION_ONLY_SUCCESS
GOTO :CHECK_CONNECTION_ONLY_FAIL

:CHECK_CONNECTION_ONLY_SUCCESS
SET currently=Currently Connected to the Internet. EXITING...
IF %CONTINUOUS%==1 SET currently=Currently Connected to the Internet.
SET currently2=
SET SpecificStatus=
SET isWaiting=1
CALL :STATS
SET isWaiting=0
IF %CONTINUOUS%==1 GOTO :CHECK_CONNECTION_ONLY
EXIT

:CHECK_CONNECTION_ONLY_FAIL
IF %CONTINUOUS%==1 GOTO :CHECK_CONNECTION_ONLY_FAIL_CONTINUOUS
SET currently=NOT Connected to the Internet.
SET currently2=No fixes are set to be used. EXITING...
SET SpecificStatus=
SET isWaiting=1
CALL :STATS
SET isWaiting=0
EXIT

:CHECK_CONNECTION_ONLY_FAIL_CONTINUOUS
SET currently=NOT Connected to the Internet.
SET currently2=Waiting to re-check connection.
SET SpecificStatus=
SET isWaiting=1
CALL :STATS
SET isWaiting=0
SET /A delaymins=CHECK_DELAY
CALL :WAIT
GOTO :CHECK_CONNECTION_ONLY

:: -------END CHECK INTERNET CONNECION ONLY (NO FIXES)-----------


:FAILED
:: -------------------FIX ATTEMPT FAILED-------------------------
:: BRANCH (FAILED_CONTINUOUS || FIX || EXIT)
IF %CONTINUOUS%==1 GOTO :FAILED_CONTINUOUS
SET currently=Unable to Connect to Internet.
SET currently2=
SET SpecificStatus=
SET isWaiting=1
CALL :STATS
SET isWaiting=0
IF %AUTO_RETRY%==1 GOTO :FIX
IF %OMIT_USER_INPUT%==1 EXIT
ECHO Retry?
SET /P usrInpt=[y/n] 
IF "%usrInpt%"=="n" EXIT
IF "%usrInpt%"=="y" GOTO :FIX
GOTO :FAILED

:: -----------------END FIX ATTEMPT FAILED-----------------------


:FAILED_CONTINUOUS
:: ----------------FIX ATTEMPT FAILED (RETRY)--------------------
:: GOTO FIX
SET currently=Unable to Connect to Internet (Retrying...)
SET currently2=
SET SpecificStatus= 
SET isWaiting=1
CALL :STATS
SET isWaiting=0
GOTO :FIX
:: --------------END FIX ATTEMPT FAILED (RETRY)------------------


:SUCCESS
:: ------------------FIX ATTEMPT SUCCEEDED-----------------------
:: BRANCH (SUCCESS_CONTINUOUS || EXIT)

IF %CONTINUOUS%==1 GOTO :SUCCESS_CONTINUOUS
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
:: ----------------END FIX ATTEMPT SUCCEEDED---------------------


:SUCCESS_CONTINUOUS
:: -------------FIX ATTEMPT SUCCEEDED (RECHECK)------------------
:: BRANCH (SUCCESS || FIX)
SET currently=Successfully Connected to Internet.
SET currently2=
SET SpecificStatus= 
SET isWaiting=0
CALL :STATS
SET currently=Waiting to re-check Internet Connection...
SET currently2=
SET SpecificStatus=
SET /A delaymins=CHECK_DELAY
CALL :WAIT
CALL :TEST isConnected
IF %isConnected%==1 GOTO :SUCCESS
GOTO :FIX
:: -----------END FIX ATTEMPT SUCCEEDED (RECHECK)----------------
