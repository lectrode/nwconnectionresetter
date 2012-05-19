REM *****************************************************************
REM ************ DON'T EDIT ANYTHING BEYOND THIS POINT! *************
REM *****************************************************************

REM -----Program Info-----
REM Name: 		Network Resetter
REM Revision:
	SET rvsn=60

REM 
REM Description:	Fixes network connection by trying each of the following:
REM 				1) Reset Network Connection (Quick Reset)
REM 				2) Reset IP Address
REM 				3) Reset Network Connection (Slow Reset)
REM 
REM Author:			Lectrode 
REM 				Website:	http://electrodexs.net
REM 				Email: 		stevenspchelp@gmail.com
REM 
REM Notes:			This is easiest read in a program such as Notepad++
REM 				and using the font "Curier New" size 10.
REM 				
REM 				Make sure the settings below are correct BEFORE
REM 				you run the program. (default settings should be
REM 				good for computers running Vista and Windows 7 and
REM 				using the *DEFAULT* wireless connection)
REM 
REM 				If it seems stuck on "Resetting IP Address"
REM 				don't worry about it. It should get past it within a 
REM 				few minutes. If it persists longer than 10 minutes,
REM 				email me and I'll help you. If this happens often, you
REM 				can disable it below under "Advanced Settings"
REM 
REM 				If after running the program it still won't connect, try
REM 				increasing the number of MINUTES to wait.
REM 
REM 				If you close the program while it is attempting to fix
REM 				your network connection, the network connection may still
REM 				be disabled. To fix this, re-run this program.
REM 				You can set MINUTES to 0 for a quick run. 
REM 
REM 				"This Operating System is not currently supported."
REM 				-The only thing you can do in this case is email me
REM 				the name of the Operating System and I'll try to add
REM 				support for it.
REM 				You can bypass the OS detection below in Advanced
REM 				Settings, but the program may exhibit unusual behavior.
REM 
REM 				"Could not find <network> | This program requires a valid
REM 				network connection | please open with notepad for more information"
REM 				-To fix this please correct the NETWORK setting below.
REM 				
REM 				This program is protected under the GPLv3 License. 
REM 				http://www.gnu.org/licenses/gpl.html









REM *************Main Code**************


REM -------------------Initialize Program--------------------


@ECHO OFF

REM Restart itself minimized if set to do so
IF "%restartingProgram%"=="" (
	IF "%START_MINIMIZED%"=="1" (
		IF "%MINIMIZED%"=="" (
			SET MINIMIZED=1
			START /MIN CMD /C "%~dpnx0"
			EXIT
		)
	)
)

REM Set CMD window size & title
MODE CON COLS=81 LINES=30
TITLE Lectrode's Network Connection Resetter r%rvsn%

REM Set Global Variables
SET SettingsFileName=NWRSettings
SET THISFILEDIR=%~dp0
SET THISFILENAME=%~n0.bat
SET THISFILENAMEPATH=%~dpnx0
SET restartingProgram=
SET has_tested_ntwk_name_recent=0
SET currently=
SET currently2=
SET SpecificStatus=
SET isWaiting=0
SET delaymins=
IF "%ProgramMustFix%"=="" SET /A ProgramMustFix=0
SET NCNUM=0

CALL :SETTINGS_SETDEFAULT
IF "%1"=="RESET" CALL :SETTINGS_RESET
CALL :SETTINGS_CHECKFILE
IF "%1"=="SETTINGS" CALL :SETTINGS_SET


GOTO :TOP


:SETTINGS_CHECKFILE
SET SETNFILECHK=0

IF EXIST "C:\NWResetter\%SettingsFileName%.BAT" (
SET FOUNDLOCAL=1
CALL "C:\NWResetter\%SettingsFileName%.BAT" LOAD
SET SETNFileDir=C:\NWResetter\
SET /A SETNFILECHK+=1
)

IF EXIST "%AppData%\NWResetter\%SettingsFileName%.BAT" (
SET FOUNDUSER=1
CALL "C:\NWResetter\%SettingsFileName%.BAT" LOAD
SET SETNFileDir=C:\NWResetter\
SET /A SETNFILECHK+=1
)

IF EXIST "%THISFILEDIR%%SettingsFileName%.BAT" (
SET FOUNDPORT=1
CALL "%THISFILEDIR%%SettingsFileName%.BAT" LOAD
SET /A SETNFILECHK+=1
SET SETNFileDir=%THISFILEDIR%
)

IF %SETNFILECHK%==0 (
CALL :SETTINGS_FIRSTRUN
)

IF %SETNFILECHK%==1 GOTO :EOF
IF NOT %SETNFILECHK% GEQ 2 GOTO :SETTINGS_CHECKFILE_END
:SETTINGS_CHECKFILE_MULTIPLE
REM Multiple settings files
CALL :HEADER
ECHO Multiple setting files were found. Which one
ECHO would you like to use?
IF NOT "%FOUNDLOCAL%"=="" ECHO -Local [C:\NWResetter]               [L]
IF NOT "%FOUNDUSER%"==""  ECHO -User  [Appdata\NWResetter]          [U]
IF NOT "%FOUNDPORT%"==""  ECHO -Portable [Same folder as main file] [P]
SET usrInput=
SET /P usrInput=[] 
IF NOT "%FOUNDPORT%"=="" IF /I "%usrInput%"=="P" SET SETNFileDir=%THISFILEDIR%
IF NOT "%FOUNDPORT%"=="" IF /I "%usrInput%"=="P" GOTO :EOF
IF NOT "%FOUNDUSER%"=="" IF /I "%usrInput%"=="U" SET SETNFileDir=%Appdata%\NWResetter\
IF NOT "%FOUNDUSER%"=="" IF /I "%usrInput%"=="U" GOTO :EOF
IF NOT "%FOUNDLOCAL%"=="" IF /I "%usrInput%"=="L" SET SETNFileDir=C:\NWResetter\
IF NOT "%FOUNDLOCAL%"=="" IF /I "%usrInput%"=="L" GOTO :EOF
GOTO :SETTINGS_CHECKFILE_MULTIPLE

:SETTINGS_CHECKFILE_END
GOTO :EOF



:SETTINGS_FIRSTRUN
CALL :HEADER
ECHO No setting files were found. 
ECHO.
ECHO What would you like to do?
ECHO -Run program with temporary settings    [1]
ECHO -Make settings for this user only       [2] [Recommended]
ECHO -Make settings for this computer only   [3]
ECHO -Make settings portable                 [4]
ECHO.
SET usrInput=
SET /P usrInput=[1/2/3/4] 
IF "%usrInput%"=="" GOTO :SETTINGS_FIRSTRUN_TEMP
IF "%usrInput%"=="1" GOTO :SETTINGS_FIRSTRUN_TEMP
IF "%usrInput%"=="2" GOTO :SETTINGS_FIRSTRUN_USR
IF "%usrInput%"=="3" GOTO :SETTINGS_FIRSTRUN_LOC
IF "%usrInput%"=="4" GOTO :SETTINGS_FIRSTRUN_PORT
GOTO :SETTINGS_FIRSTRUN


:SETTINGS_FIRSTRUN_TEMP
CALL :SETTINGS_RESET2DEFAULT
SET SETNFileDir=TEMP
CALL :SETTINGS_SET
GOTO :EOF

:SETTINGS_FIRSTRUN_USR
CALL :SETTINGS_RESET2DEFAULT
MD "%AppData%\NWResetter"
SET SETNFileDir=%AppData%\NWResetter\
CALL :SETTINGS_EXPORT
CALL :SETTINGS_SET
GOTO :EOF

:SETTINGS_FIRSTRUN_LOC
CALL :SETTINGS_RESET2DEFAULT
MD "C:\NWResetter"
SET SETNFileDir=C:\NWResetter\
CALL :SETTINGS_EXPORT
CALL :SETTINGS_SET
GOTO :EOF

:SETTINGS_FIRSTRUN_PORT
CALL :SETTINGS_RESET2DEFAULT
SET SETNFileDir=%THISFILEDIR%
CALL :SETTINGS_EXPORT
CALL :SETTINGS_SET
GOTO :EOF



:SETTINGS_RESET
CLS
CALL :HEADER
ECHO Reset Function Initiated...
CALL :SETTINGS_RESET2DEFAULT
CALL :SETTINGS_EXPORT
GOTO :EOF

:SETTINGS_SET
CLS
CALL :HEADER
IF "%SETNFileDir%"=="TEMP" ECHO You have selected Temporary Settings
IF "%SETNFileDir%"=="TEMP" ECHO.
IF "%SETNFileDir%"=="TEMP" ECHO Changes made to settings will be lost when program
IF "%SETNFileDir%"=="TEMP" ECHO is closed.
IF "%SETNFileDir%"=="TEMP" ECHO.
ECHO What would you like to do?
ECHO -Review all settings                        (1)
ECHO -Choose setting to change from list         (2)
ECHO -Reset all settings to their default values (3)
ECHO -Run program                                (R)
ECHO -Exit                                       (X)
ECHO.
SET usrInput=
SET /P usrInput=[1/2/3/R/X] 
IF /I "%usrInput%"=="R" GOTO :EOF
IF /I "%usrInput%"=="X" EXIT
IF "%usrInput%"=="1" CALL :SETTINGS_SET_ALL
IF "%usrInput%"=="2" CALL :SETTINGS_SET_LIST_MAIN
IF "%usrInput%"=="3" CALL :SETTINGS_RESET
GOTO :SETTINGS_SET


:SETTINGS_SET_ALL
CALL :HEADER
CALL :SETTINGS_SETONE B1
CALL :SETTINGS_SETONE B2
CALL :SETTINGS_SETONE B3
CALL :SETTINGS_SETONE M1
CALL :SETTINGS_SETONE M2
CALL :SETTINGS_SETONE M3
CALL :SETTINGS_SETONE M4
CALL :SETTINGS_SETONE M5
CALL :SETTINGS_SETONE M6
CALL :SETTINGS_SETONE M7
CALL :SETTINGS_SETONE M8
CALL :SETTINGS_SETONE A1
CALL :SETTINGS_SETONE A2
CALL :SETTINGS_SETONE A3
CALL :SETTINGS_SETONE A4
CALL :SETTINGS_SETONE A5
CALL :SETTINGS_SETONE A6
CALL :SETTINGS_SETONE A7
CALL :SETTINGS_SETONE A8
GOTO :EOF


:SETTINGS_SET_LIST_MAIN
CALL :HEADER
IF "%CONTINUOUS%"=="1" SET MODE=Continuous
IF "%CONTINUOUS%"=="0" SET MODE=Run Once
ECHO Navigation:
ECHO -View Misc. Settings    (M)
ECHO -View Advanced Settings (A)
ECHO -Cancel                 (X)
ECHO.
ECHO What settings would you like to set?
ECHO Setting                 #   Current Value
ECHO.
ECHO -Connection Name       (1)  "%NETWORK%"
ECHO -Network Reset Stall   (2)   %MINUTES% Minutes
ECHO -Mode                  (3)   %MODE%
ECHO.
SET usrInput=
SET /P usrInput=[M/A/X/1/2/3] 
IF "%usrInput%"=="1" CALL :SETTINGS_SETONE B1
IF "%usrInput%"=="2" CALL :SETTINGS_SETONE B2
IF "%usrInput%"=="3" CALL :SETTINGS_SETONE B3
IF /I "%usrInput%"=="M" GOTO :SETTINGS_SET_LIST_MISC
IF /I "%usrInput%"=="A" GOTO :SETTINGS_SET_LIST_ADV
IF /I "%usrInput%"=="X" GOTO :EOF
GOTO :SETTINGS_SET_LIST_MAIN

:SETTINGS_SET_LIST_MISC
CLS
CALL :HEADER
ECHO Navigation:
ECHO -View Basic Settings    (B)
ECHO -View Advanced Settings (A)
ECHO -Cancel                 (X)
ECHO.
ECHO What settings would you like to set?
ECHO Setting                 #   Current Value
ECHO.
ECHO -AutoRetry             (1)   %AUTO_RETRY%
ECHO -Check Delay           (2)   %CHECK_DELAY% Minute[s]
ECHO -Show All Alerts       (3)   %SHOW_ALL_ALERTS%
ECHO -Show Advanced Testing (4)   %SHOW_ADVANCED_TESTING%
ECHO -Slow Messages         (5)   %SLWMSG%
ECHO -Timer Refresh Rate    (6)   %TIMER_REFRESH_RATE% Second[s]
ECHO -Start at Logon        (7)   %START_AT_LOGON%
ECHO -Start Minimized       (8)   %START_MINIMIZED%
ECHO.
SET usrInput=
SET /P usrInput=[B/A/X/1/2/3/4/5/6/7/8] 
IF "%usrInput%"=="1" CALL :SETTINGS_SETONE M1
IF "%usrInput%"=="2" CALL :SETTINGS_SETONE M2
IF "%usrInput%"=="3" CALL :SETTINGS_SETONE M3
IF "%usrInput%"=="4" CALL :SETTINGS_SETONE M4
IF "%usrInput%"=="5" CALL :SETTINGS_SETONE M5
IF "%usrInput%"=="6" CALL :SETTINGS_SETONE M6
IF "%usrInput%"=="7" CALL :SETTINGS_SETONE M7
IF "%usrInput%"=="8" CALL :SETTINGS_SETONE M8
IF /I "%usrInput%"=="B" GOTO :SETTINGS_SET_LIST_MAIN
IF /I "%usrInput%"=="A" GOTO :SETTINGS_SET_LIST_ADV
IF /I "%usrInput%"=="X" GOTO :EOF
GOTO :SETTINGS_SET_LIST_MISC


:SETTINGS_SET_LIST_ADV
CLS
CALL :HEADER
ECHO Navigation:
ECHO -View Basic Settings    (B)
ECHO -View Misc. Settings    (M)
ECHO -Cancel                 (X)
ECHO.
ECHO What settings would you like to set?
ECHO Setting                    #   Current Value
ECHO.
ECHO -Omit User Input          (1)   %OMIT_USER_INPUT%
ECHO -Skip Initial Ntwk Test   (2)   %SKIP_INITIAL_NTWK_TEST%
ECHO -Enable FIX: Reset IP     (3)   %USE_IP_RESET%
ECHO -Enable FIX: FastNWReset  (4)   %USE_NETWORK_RESET_FAST%
ECHO -Enable FIX: SlowNWReset  (5)   %USE_NETWORK_RESET%
ECHO -One Connection name test (6)   %ONLY_ONE_NETWORK_NAME_TEST%
ECHO -OS Detection Override    (7)   %OS_DETECT_OVERRIDE%
ECHO -DEBUGN                   (8)   %DEBUGN%
ECHO.
SET usrInput=
SET /P usrInput=[B/M/X/1/2/3/4/5/6/7/8] 
IF "%usrInput%"=="1" CALL :SETTINGS_SETONE A1
IF "%usrInput%"=="2" CALL :SETTINGS_SETONE A2
IF "%usrInput%"=="3" CALL :SETTINGS_SETONE A3
IF "%usrInput%"=="4" CALL :SETTINGS_SETONE A4
IF "%usrInput%"=="5" CALL :SETTINGS_SETONE A5
IF "%usrInput%"=="6" CALL :SETTINGS_SETONE A6
IF "%usrInput%"=="7" CALL :SETTINGS_SETONE A7
IF "%usrInput%"=="8" CALL :SETTINGS_SETONE A8
IF /I "%usrInput%"=="B" GOTO :SETTINGS_SET_LIST_MAIN
IF /I "%usrInput%"=="M" GOTO :SETTINGS_SET_LIST_MISC
IF /I "%usrInput%"=="X" GOTO :EOF
GOTO :SETTINGS_SET_LIST_ADV

:SETTINGS_SETONE
CLS
CALL :SETTINGS_GETINFO %1
CALL :HEADER
ECHO. *%SETTINGTITLE%*
ECHO. %SETTINGOPT%
ECHO.
ECHO. %SETTINGINFO1%
ECHO. %SETTINGINFO2%
ECHO. %SETTINGINFO3%
ECHO.
IF "%SETTINGCUR%"=="" ECHO Current Value: [none set yet]
IF NOT "%SETTINGCUR%"=="" ECHO Current Value: %SETTINGCUR%
ECHO.
ECHO Please enter the new setting value:
ECHO (Enter "D" for default)
ECHO (Enter nothing to keep current setting)
ECHO.
SET usrInput=
SET /P usrInput=[] 
IF "%usrInput%"=="" GOTO :EOF
IF /I "%usrInput%"=="D" (
IF "%SETNVAR%"=="" SET %SETTINGTITLE%=%SETTINGDEFAULT%
IF NOT "%SETNVAR%"=="" SET %SETNVAR%=%SETTINGDEFAULT%
SET usrInput=
CALL :SETTINGS_EXPORT
GOTO :EOF
)
IF "%SETNVAR%"=="" SET %SETTINGTITLE%=%usrInput%
IF NOT "%SETNVAR%"=="" SET %SETNVAR%=%usrInput%
SET usrInput=
CALL :SETTINGS_EXPORT
GOTO :EOF


:SETTINGS_GETINFO
SET usrInput=
SET SETTINGTITLE=
SET SETTINGOPT=
SET SETTINGINFO1=
SET SETTINGINFO2=
SET SETTINGINFO3=
SET SETNVAR=
SET SETTINGDEFAULT=
SET SETTINGCUR=

IF %1==B1 (
SET SETTINGTITLE=NETWORK
SET SETTINGOPT=
SET SETTINGINFO1=Name of the Network to be reset
REM SET SETTINGINFO2=*enter "n!" to view network connections*
SET SETTINGINFO3=
SET SETTINGDEFAULT=%NETWORK_D%
SET SETTINGCUR=%NETWORK%
)
IF %1==B2 (
SET SETTINGTITLE=MINUTES
SET SETTINGOPT=Integers Only! [aka 0,1,2,etc]
SET SETTINGINFO1=Number of minutes to wait before re-enabling
SET SETTINGINFO2=the network adapter [5-15 reccomended]
SET SETTINGINFO3=
SET SETTINGDEFAULT=%MINUTES_D%
SET SETTINGCUR=%MINUTES%
)
IF %1==B3 (
SET SETTINGTITLE=MODE
SET SETTINGOPT=
SET SETTINGINFO1=Enter 0 for Run Once
SET SETTINGINFO2=Enter 1 for Continuous [checks every %CHECK_DELAY% minute[s]]
SET SETTINGINFO3=
SET SETNVAR=CONTINUOUS
SET SETTINGDEFAULT=%CONTINUOUS_D%
SET SETTINGCUR=%CONTINUOUS%
)
IF %1==M1 (
SET SETTINGTITLE=AUTO_RETRY
SET SETTINGOPT=Enter 1 for On, Enter 0 for Off
SET SETTINGINFO1=
SET SETTINGINFO2=If fix fails the first time, automatically keep
SET SETTINGINFO3=retrying. [Applies to Mode:Run Once only!]
SET SETTINGDEFAULT=%AUTO_RETRY_D%
SET SETTINGCUR=%AUTO_RETRY%
)
IF %1==M2 (
SET SETTINGTITLE=CHECK_DELAY
SET SETTINGOPT=Integers Only! [aka 0,1,2,etc]
SET SETTINGINFO1=
SET SETTINGINFO2=In MODE:Continuous, this is how many minutes between
SET SETTINGINFO3=connection tests.
SET SETTINGDEFAULT=%CHECK_DELAY_D%
SET SETTINGCUR=%CHECK_DELAY%
)
IF %1==M3 (
SET SETTINGTITLE=SHOW_ALL_ALERTS
SET SETTINGOPT=Enter 1 for On, Enter 0 for Off
SET SETTINGINFO1=When set to On, shows more detailed messages.
SET SETTINGINFO2=NOTE: Regardless of what you set this too, this
SET SETTINGINFO3=program will always display important messages.
SET SETTINGDEFAULT=%SHOW_ALL_ALERTS_D%
SET SETTINGCUR=%SHOW_ALL_ALERTS%
)
IF %1==M4 (
SET SETTINGTITLE=SHOW_ADVANCED_TESTING
SET SETTINGOPT=Enter 1 for On, Enter 0 for Off
SET SETTINGINFO1=Show Advanced Testing Output
SET SETTINGINFO2=When true, more details will be shown reguarding
SET SETTINGINFO3=testing the internet
SET SETTINGDEFAULT=%SHOW_ADVANCED_TESTING_D%
SET SETTINGCUR=%SHOW_ADVANCED_TESTING%
)
IF %1==M5 (
SET SETTINGTITLE=SLOW MESSAGES
SET SETTINGOPT=Enter 1 for On, Enter 0 for Off
SET SETTINGINFO1=
SET SETTINGINFO2=When true, program will pause for every message it displays 
SET SETTINGINFO3=to allow the user to read them [run time will be longer]
SET SETNVAR=SLWMSG
SET SETTINGDEFAULT=%SLWMSG_D%
SET SETTINGCUR=%SLWMSG%
)
IF %1==M6 (
SET SETTINGTITLE=TIMER_REFRESH_RATE
SET SETTINGOPT=Integers greater than 0 Only! [aka 1,2,3,etc]
SET SETTINGINFO1=Timer Refresh Rate [Update every # seconds]
SET SETTINGINFO2=[1-10 recommended]
SET SETTINGINFO3=
SET SETTINGDEFAULT=%TIMER_REFRESH_RATE_D%
SET SETTINGCUR=%TIMER_REFRESH_RATE%
)
IF %1==M7 (
SET SETTINGTITLE=START_AT_LOGON
SET SETTINGOPT=Enter 1 for True, Enter 0 for False
SET SETTINGINFO1=Start Program at user log on
SET SETTINGINFO2=When true, the program will start when you log on.
SET SETTINGINFO3=NOTE: Not available when running with portable or temp settings
SET SETTINGDEFAULT=%START_AT_LOGON_D%
SET SETTINGCUR=%START_AT_LOGON%
)
IF %1==M8 (
SET SETTINGTITLE=START_MINIMIZED
SET SETTINGOPT=Enter 1 for True, Enter 0 for False
SET SETTINGINFO1=Start Minimized
SET SETTINGINFO2=When true, program will minimize itself when it is run
SET SETTINGINFO3=
SET SETTINGDEFAULT=%START_MINIMIZED_D%
SET SETTINGCUR=%START_MINIMIZED%
)
IF %1==A1 (
SET SETTINGTITLE=OMIT_USER_INPUT
SET SETTINGOPT=Enter 1 for True, Enter 0 for False
SET SETTINGINFO1=Omit ALL user input
SET SETTINGINFO2=Assumes all settings are intentional and will not
SET SETTINGINFO3=prompt the user to enter additional/correct information
SET SETTINGDEFAULT=%OMIT_USER_INPUT_D%
SET SETTINGCUR=%OMIT_USER_INPUT%
)
IF %1==A2 (
SET SETTINGTITLE=SKIP_INITIAL_NTWK_TEST
SET SETTINGOPT=Enter 1 for True, Enter 0 for False
SET SETTINGINFO1=Skip Initial Network Connection Test
SET SETTINGINFO2=Select this if you want the program to immediately attempt 
SET SETTINGINFO3=to fix your connection without testing the connection first
SET SETTINGDEFAULT=%SKIP_INITIAL_NTWK_TEST_D%
SET SETTINGCUR=%SKIP_INITIAL_NTWK_TEST%
)
IF %1==A3 (
SET SETTINGTITLE=USE_IP_RESET
SET SETTINGOPT=Enter 1 for On, Enter 0 for Off
SET SETTINGINFO1=Enable FIX: Reset the IP Address
SET SETTINGINFO2=Unless you frequently get stuck on "Reseting IP address"
SET SETTINGINFO3=you should leave this enabled.
SET SETTINGDEFAULT=%USE_IP_RESET_D%
SET SETTINGCUR=%USE_IP_RESET%
)
IF %1==A4 (
SET SETTINGTITLE=USE_NETWORK_RESET_FAST
SET SETTINGOPT=Enter 1 for On, Enter 0 for Off
SET SETTINGINFO1=Enable FIX: Quick Connection Reset
SET SETTINGINFO2=If enabled, this is tried first to fix your connection
SET SETTINGINFO3=In most cases this should be left enabled.
SET SETTINGDEFAULT=%USE_NETWORK_RESET_FAST_D%
SET SETTINGCUR=%USE_NETWORK_RESET_FAST%
)
IF %1==A5 (
SET SETTINGTITLE=USE_NETWORK_RESET [Slow]
SET SETTINGOPT=Enter 1 for On, Enter 0 for Off
SET SETTINGINFO1=Enable FIX: Slow Connection Reset
SET SETTINGINFO2=Slow Reset works more often than Quick Reset.
SET SETTINGINFO3=In most cases this should be left enabled.
SET SETNVAR=USE_NETWORK_RESET
SET SETTINGDEFAULT=%USE_NETWORK_RESET_D%
SET SETTINGCUR=%USE_NETWORK_RESET%
)
IF %1==A6 (
SET SETTINGTITLE=ONLY_ONE_NETWORK_NAME_TEST
SET SETTINGOPT=Enter 1 for True, Enter 0 for False
SET SETTINGINFO1=Don't test Network Name more than once
SET SETTINGINFO2=Setting to True is ideal on most computers as long as the 
SET SETTINGINFO3=Network Connection name does not change
SET SETTINGDEFAULT=%ONLY_ONE_NETWORK_NAME_TEST_D%
SET SETTINGCUR=%ONLY_ONE_NETWORK_NAME_TEST%
)
IF %1==A7 (
SET SETTINGTITLE=OS_DETECT_OVERRIDE
SET SETTINGOPT=Enter 1 for On, Enter 0 for Off
SET SETTINGINFO1=Override OS Detection
SET SETTINGINFO2=This will force the program to continue running on an unsupported OS.
SET SETTINGINFO3=Doing so may cause the program to exibit unusual behavior.
SET SETTINGDEFAULT=%OS_DETECT_OVERRIDE_D%
SET SETTINGCUR=%OS_DETECT_OVERRIDE%
)
IF %1==A8 (
SET SETTINGTITLE=DEBUGGING
SET SETTINGOPT=Enter 1 for On, Enter 0 for Off
SET SETTINGINFO1=Programmer Tool - Debugging
SET SETTINGINFO2=Debugging mode disables actual functionality of this program
SET SETTINGINFO3=
SET SETNVAR=DEBUGN
SET SETTINGDEFAULT=%DEBUGN_D%
SET SETTINGCUR=%DEBUGN%
)

GOTO :EOF


:SETTINGS_SETDEFAULT
REM Sets variables holding default settings values
ECHO Getting default values...
SET MINUTES_D=10
SET NETWORK_D=Wireless Network Connection
SET CONTINUOUS_D=0
SET AUTO_RETRY_D=0
SET CHECK_DELAY_D=1
SET SHOW_ALL_ALERTS_D=1
SET SHOW_ADVANCED_TESTING_D=0
SET SLWMSG_D=0
SET TIMER_REFRESH_RATE_D=1
SET START_AT_LOGON_D=0
SET START_MINIMIZED_D=0
SET OMIT_USER_INPUT_D=0
SET SKIP_INITIAL_NTWK_TEST_D=0
SET USE_IP_RESET_D=1
SET USE_NETWORK_RESET_FAST_D=1
SET USE_NETWORK_RESET_D=1
SET ONLY_ONE_NETWORK_NAME_TEST_D=1
SET OS_DETECT_OVERRIDE_D=0
SET DEBUGN_D=0
GOTO :EOF

:SETTINGS_RESET2DEFAULT
ECHO Resetting settings to their default values...
SET MINUTES=%MINUTES_D%
SET NETWORK=%NETWORK_D%
SET CONTINUOUS=%CONTINUOUS_D%
SET AUTO_RETRY=%AUTO_RETRY_D%
SET CHECK_DELAY=%CHECK_DELAY_D%
SET SHOW_ALL_ALERTS=%SHOW_ALL_ALERTS_D%
SET SHOW_ADVANCED_TESTING=%SHOW_ADVANCED_TESTING_D%
SET SLWMSG=%SLWMSG_D%
SET TIMER_REFRESH_RATE=%TIMER_REFRESH_RATE_D%
SET START_AT_LOGON=%START_AT_LOGON_D%
SET START_MINIMIZED=%START_MINIMIZED_D%
SET OMIT_USER_INPUT=%OMIT_USER_INPUT_D%
SET SKIP_INITIAL_NTWK_TEST=%SKIP_INITIAL_NTWK_TEST_D%
SET USE_IP_RESET=%USE_IP_RESET_D%
SET USE_NETWORK_RESET_FAST=%USE_NETWORK_RESET_FAST_D%
SET USE_NETWORK_RESET=%USE_NETWORK_RESET_D%
SET ONLY_ONE_NETWORK_NAME_TEST=%ONLY_ONE_NETWORK_NAME_TEST_D%
SET OS_DETECT_OVERRIDE=%OS_DETECT_OVERRIDE_D%
SET DEBUGN=%DEBUGN_D%
GOTO :EOF

:SETTINGS_EXPORT
IF "%SETNFileDir%"=="TEMP" GOTO :EOF
CALL :HEADER
IF "%SETNFileDir%"=="" ECHO ERROR: No Setting file location selected.
IF "%SETNFileDir%"=="" ECHO Cannot export settings
IF "%SETNFileDir%"=="" ECHO Press any key to restart the program...
IF "%SETNFileDir%"=="" PAUSE>NUL
IF "%SETNFileDir%"=="" GOTO :RESTART_PROGRAM
ECHO Exporting Settings...
@ECHO ON
IF "%DEBUGN%"=="1" GOTO :SETTINGS_EXPORT_SKIP
TYPE NUL>"%SETNFileDir%%SettingsFileName%.BAT"
DEL /F %SettingsFileName%.BAT
ECHO IF "%%1"=="" START CMD /C "%THISFILENAMEPATH%" SETTINGS>>"%SETNFileDir%%SettingsFileName%.BAT"
ECHO SET MINUTES=^%MINUTES%>>"%SETNFileDir%%SettingsFileName%.BAT"
ECHO SET NETWORK=^%NETWORK%>>"%SETNFileDir%%SettingsFileName%.BAT"
ECHO SET CONTINUOUS=^%CONTINUOUS%>>"%SETNFileDir%%SettingsFileName%.BAT"
ECHO SET AUTO_RETRY=^%AUTO_RETRY%>>"%SETNFileDir%%SettingsFileName%.BAT"
ECHO SET CHECK_DELAY=^%CHECK_DELAY%>>"%SETNFileDir%%SettingsFileName%.BAT"
ECHO SET SHOW_ALL_ALERTS=^%SHOW_ALL_ALERTS%>>"%SETNFileDir%%SettingsFileName%.BAT"
ECHO SET SHOW_ADVANCED_TESTING=^%SHOW_ADVANCED_TESTING%>>"%SETNFileDir%%SettingsFileName%.BAT"
ECHO SET SLWMSG=^%SLWMSG%>>"%SETNFileDir%%SettingsFileName%.BAT"
ECHO SET TIMER_REFRESH_RATE=^%TIMER_REFRESH_RATE%>>"%SETNFileDir%%SettingsFileName%.BAT"
ECHO SET START_AT_LOGON=^%START_AT_LOGON%>>"%SETNFileDir%%SettingsFileName%.BAT"
ECHO SET START_MINIMIZED=^%START_MINIMIZED%>>"%SETNFileDir%%SettingsFileName%.BAT"
ECHO SET OMIT_USER_INPUT=^%OMIT_USER_INPUT%>>"%SETNFileDir%%SettingsFileName%.BAT"
ECHO SET SKIP_INITIAL_NTWK_TEST=^%SKIP_INITIAL_NTWK_TEST%>>"%SETNFileDir%%SettingsFileName%.BAT"
ECHO SET USE_IP_RESET=^%USE_IP_RESET%>>"%SETNFileDir%%SettingsFileName%.BAT"
ECHO SET USE_NETWORK_RESET_FAST=^%USE_NETWORK_RESET_FAST%>>"%SETNFileDir%%SettingsFileName%.BAT"
ECHO SET USE_NETWORK_RESET=^%USE_NETWORK_RESET%>>"%SETNFileDir%%SettingsFileName%.BAT"
ECHO SET ONLY_ONE_NETWORK_NAME_TEST=^%ONLY_ONE_NETWORK_NAME_TEST%>>"%SETNFileDir%%SettingsFileName%.BAT"
ECHO SET OS_DETECT_OVERRIDE=^%OS_DETECT_OVERRIDE%>>"%SETNFileDir%%SettingsFileName%.BAT"
ECHO SET DEBUGN=^%DEBUGN%>>"%SETNFileDir%%SettingsFileName%.BAT"
ECHO GOTO :EOF
@ECHO OFF
:SETTINGS_EXPORT_SKIP
ECHO Done Exporting Settings.
GOTO :EOF


:SETTINGS_LOAD
CALL %THISFILEDIR%%SettingsFileName%.BAT LOAD
GOTO :EOF


:HEADER
@ECHO OFF
CLS
ECHO  ******************************************************************************
ECHO  *         ******   Lectrode's Network Connection Resetter r%rvsn%  ******        *
ECHO  ******************************************************************************
ECHO.
GOTO :EOF


:TOP
REM Display program introduction
CALL :PROGRAM_INTRO

REM Initial CHECKS
SET currently=Checking validity of Settings...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
CALL :TEST01VAR SLWMSG 0 %SLWMSG%
CALL :TEST01VAR SHOW_ALL_ALERTS 1 %SHOW_ALL_ALERTS%
CALL :TEST01VAR DEBUGN 0 %DEBUGN%
CALL :TEST01VAR CONTINUOUS 0 %CONTINUOUS%
CALL :TEST01VAR OS_DETECT_OVERRIDE 0 %OS_DETECT_OVERRIDE%
CALL :TEST01VAR USE_NETWORK_RESET 1 %USE_NETWORK_RESET%
CALL :TEST01VAR USE_NETWORK_RESET_FAST 1 %USE_NETWORK_RESET_FAST%
CALL :TEST01VAR USE_IP_RESET 1 %USE_IP_RESET%
CALL :TEST01VAR OMIT_USER_INPUT 0 %OMIT_USER_INPUT%
CALL :TEST_FIXES_VALS

IF %USE_NETWORK_RESET%==1 (
	CALL :DETECT_OS
	CALL :TEST_NETWORK_NAME 1
	CALL :TESTIntVAR MINUTES 10 x x %MINUTES%
) ELSE (
	IF %USE_NETWORK_RESET_FAST%==1 (
		CALL :DETECT_OS
		CALL :TEST_NETWORK_NAME 1
		CALL :TESTIntVAR MINUTES 10 x x %MINUTES%
	)
)
CALL :TESTIntVAR TIMER_REFRESH_RATE 1 0 99999999 %TIMER_REFRESH_RATE%
CALL :TESTIntVAR CHECK_DELAY 1 0 99999999 %CHECK_DELAY%
CALL :TEST01VAR START_AT_LOGON 0 %START_AT_LOGON%
CALL :TEST01VAR START_MINIMIZED 0 %START_MINIMIZED%
CALL :TEST01VAR AUTO_RETRY 0 %AUTO_RETRY%
CALL :TEST01VAR SHOW_ADVANCED_TESTING 0 %SHOW_ADVANCED_TESTING%
CALL :TEST01VAR SKIP_INITIAL_NTWK_TEST 0 %SKIP_INITIAL_NTWK_TEST%
CALL :TEST01VAR ONLY_ONE_NETWORK_NAME_TEST 1 %ONLY_ONE_NETWORK_NAME_TEST%


REM Copy to startup folder if set to start when 
REM user logs on
CALL :CHECK_START_AT_LOGON

REM -----------------END INITIALIZE PROGRAM------------------



REM ------------------TO FIX OR NOT TO FIX-------------------
IF %Using_Fixes%==0 GOTO :CHECK_CONNECTION_ONLY
REM ----------------END TO FIX OR NOT TO FIX-----------------


REM -------------INITIAL NETWORK CONNECTION TEST-------------
REM BRANCH (SUCCESS || FIX)
REM Determine if connection needs to be fixed

IF %SKIP_INITIAL_NTWK_TEST%==1 GOTO :FIX
REM Enable adapter if not already enabled
CALL :ENABLE_NW
CALL :TEST isConnected
IF %isConnected%==1 GOTO :SUCCESS
GOTO :FIX
REM -----------END INITIAL NETWORK CONNECTION TEST-----------



:PROGRAM_INTRO
REM ----------------------PROGRAM INTRO----------------------
REM Displays notice for 3 seconds
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
CALL :SLEEP
GOTO :EOF
REM ---------------------END PROGRAM INTRO--------------------


:STATS
REM ---------------------PROGRAM STATUS-----------------------
SET STATSSpacer=                                                                                   !
SET SHOWNETWORK="%NETWORK%"%STATSSpacer%
SET SHOWcurrently=%currently%%STATSSpacer%
SET SHOWcurrently2=%currently2%%STATSSpacer%
SET SHOWSpecificStatus=%SpecificStatus%%STATSSpacer%
IF %confixed%0 GTR 10 SET SHOWconfixed=%confixed% times.%STATSSpacer%
IF NOT %confixed%0 GTR 10 SET SHOWconfixed=%confixed% time.%STATSSpacer%
CLS
						ECHO  ******************************************************************************
						ECHO  *         ******   Lectrode's Network Connection Resetter r%rvsn%  ******        *
						ECHO  *                                                                            *
						ECHO  *                 http://code.google.com/p/nwconnectionresetter              *
						ECHO  ******************************************************************************
IF "%DEBUGN%"=="1"		ECHO  *          *DEBUGGING ONLY! Set DEBUGN to 0 to reset connection*             *
IF "%CONTINUOUS%"=="1"	ECHO  *                                                                            *
IF "%CONTINUOUS%"=="1"	ECHO  *                              *Continuous Mode*                             *
						ECHO  *                                                                            *
						ECHO  * Connection: %SHOWNETWORK:~0,63%*
						ECHO  *                                                                            *
IF NOT "%confixed%"==""	ECHO  * Connection fixed %SHOWconfixed:~0,58%*
IF NOT "%confixed%"==""	ECHO  *                                                                            *
						ECHO  * Current State: %SHOWcurrently:~0,60%*
						ECHO  *                %SHOWcurrently2:~0,60%*
						ECHO  *                                                                            *
						ECHO  * %SHOWSpecificStatus:~0,75%*
						ECHO  *                                                                            *
						ECHO  ******************************************************************************

IF "%SLWMSG%"=="1" (
	CALL :SLEEP
) ELSE (
	IF "%isWaiting%"=="1" CALL :SLEEP
)
GOTO :EOF
REM ---------------------END PROGRAM STATUS----------------------



:TEST
REM ------------------TEST INTERNET CONNECTION-------------------
REM RETURN (isConnected= (1 || 0) )
SET conchks=0
SET maxconchks=101
CALL :CHECK_CONNECTED
CALL :CHECK_INTERNET intresult
SET %1=%intresult%
GOTO :EOF

:CHECK_CONNECTED
IF NOT "%conchks%"=="0" SET ProgramMustFix=1
SET currently=Checking for connectivity...
SET currently2=(Currently Disconnected)
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET connectcheckgood=0
FOR /F "delims=" %%a IN ('NETSH INTERFACE SHOW INTERFACE "%NETWORK%"') DO @SET connect_test=%%a
ECHO %connect_test% |FIND "Disconnected" >NUL
IF ERRORLEVEL 1 SET /A connectcheckgood+=1
ECHO %connect_test% |FIND "Disabled" >NUL
IF ERRORLEVEL 1 SET /A connectcheckgood+=1
SET /A conchks+=1
IF %conchks% GEQ %maxconchks% GOTO :CHECK_CONNECTED_FAILED
IF %SHOW_ADVANCED_TESTING%==1 ECHO  Checks: %conchks%
IF NOT %connectcheckgood% GEQ 2 GOTO :CHECK_CONNECTED
GOTO :EOF

:CHECK_CONNECTED_FAILED
SET currently=Connectivity test failed
SET currently2=(Currently Disconnected)
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET /A chknwcn+=1
IF NOT %chknwcn% GEQ 3 CALL :ENABLE_NW
IF NOT %chknwcn% GEQ 3 GOTO :CHECK_CONNECTED
ECHO Unable to connect to any networks with this connection.
ECHO.
ECHO It may be physically disabled or disconnected, or there 
ECHO are no wireless networks in range.
ECHO.
CALL :SLEEP 2
IF %CONTINUOUS%==1 GOTO :RESTART_PROGRAM
ECHO Press any key to re-test connectivity
PAUSE>NUL
GOTO :CHECK_CONNECTED

:CHECK_INTERNET
SET currently=Testing Internet Connection...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS

SET main_tests=0


:TEST_INIT
IF %DEBUGN%==1 GOTO :TEST_FAILED

IF %SHOW_ADVANCED_TESTING%==1 ECHO Setting Initial Variables...
SET testwebsite=www.google.com
SET founds=0
SET times=0
SET nots=0
SET unreaches=0
SET totalTests=0
SET fluke_test_eliminator=5
SET maxTestLimit=15

IF %SHOW_ADVANCED_TESTING%==1 ECHO Attempting to locate %testwebsite%...
:TEST_TESTING
FOR /F "delims=" %%a IN ('PING -n 1 %testwebsite%') DO @SET ping_test=%%a

ECHO %ping_test% |FIND "request could not find" >NUL
IF NOT ERRORLEVEL 1 GOTO :TEST_NOT_CONNECTED

ECHO %ping_test% |FIND "Unreachable" >NUL
IF NOT ERRORLEVEL 1 GOTO :TEST_UNREACHABLE

ECHO %ping_test% |FIND "Minimum " >NUL
IF NOT ERRORLEVEL 1 GOTO :TEST_CONNECTED

GOTO :TEST_TIMED_OUT





:TEST_CONNECTED
SET /A totalTests+=1
IF %SHOW_ADVANCED_TESTING%==1 ECHO %totalTests%: Connected
SET /A founds+=1
SET unreaches=0
SET times=0
SET nots=0
IF %founds% GEQ %fluke_test_eliminator% GOTO :TEST_SUCCEEDED
GOTO :TEST_TESTING


:TEST_NOT_CONNECTED
SET /A totalTests+=1
IF %SHOW_ADVANCED_TESTING%==1 ECHO %totalTests%: Could not connect
SET /A nots+=1
SET unreaches=0
SET founds=0
SET times=0
IF %nots% GEQ %fluke_test_eliminator% GOTO :TEST_FAILED
GOTO :TEST_TESTING


:TEST_UNREACHABLE
SET /A totalTests+=1
IF "%testwebsite%"=="www.google.com" (
SET testwebsite=www.yahoo.com
) ELSE (
SET testwebsite=www.google.com
)
IF %SHOW_ADVANCED_TESTING%==1 ECHO %totalTests%: Location Unreachable (changed testwebsite to %testwebsite%)
SET /A unreaches+=1
SET founds=0
SET nots=0
SET times=0
IF %nots% GEQ %fluke_test_eliminator% GOTO :TEST_UNREACHED
GOTO :TEST_TESTING


:TEST_TIMED_OUT
SET /A totalTests+=1
IF %SHOW_ADVANCED_TESTING%==1 ECHO %totalTests%: Request Timed Out
SET /A times+=1
SET unreaches=0
SET founds=0
SET nots=0
IF %times% GEQ %fluke_test_eliminator% GOTO :TEST_FAILED
IF %totalTests% GEQ %maxTestLimit% GOTO :TEST_EXCEEDED_TEST_LIMIT
GOTO :TEST_TESTING


:TEST_FAILED
REM DEBUGGING || FAILED A TEST
SET /A main_tests=main_tests+1

IF %SLWMSG%==1 CALL :SLEEP

SET currently=Internet Connection not detected
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS

SET %~1=0
GOTO :EOF

:TEST_UNREACHED
IF %SLWMSG%==1 CALL :SLEEP
IF NOT %SLWMSG%==1 IF %SHOW_ADVANCED_TESTING%==1 CALL :SLEEP 1

SET currently=Unable to varify internet connectivity.
SET currently2=Internet browsing may be slow or unavailable.
SET SpecificStatus=
SET isWaiting=1
CALL :STATS
SET isWaiting=0

SET %~1=1
GOTO :EOF

:TEST_EXCEEDED_TEST_LIMIT
IF %SLWMSG%==1 CALL :SLEEP
IF NOT %SLWMSG%==1 IF %SHOW_ADVANCED_TESTING%==1 CALL :SLEEP 1

SET currently=Unable to varify internet connectivity. This is a
SET currently2=poor quality connection. Internet browsing may be slow.
SET SpecificStatus=
SET isWaiting=1
CALL :STATS
SET isWaiting=0

SET %~1=1
GOTO :EOF

:TEST_SUCCEEDED
IF %SLWMSG%==1 CALL :SLEEP
IF NOT %SLWMSG%==1 IF %SHOW_ADVANCED_TESTING%==1 CALL :SLEEP 1

SET %~1=1
GOTO :EOF
REM ----------------END TEST INTERNET CONNECTION-----------------




:FIX
REM ------------------FIX INTERNET CONNECTION--------------------
REM BRANCH (SUCCESS || FAILED)
REM Call the different methods of fixing
REM This allows for different fixes to be added later

REM Declare that connection needs to be fixed and that this program
REM is attempting that fix
SET ProgramMustFix=1

REM *****RESET NETWORK CONNECTION FAST*****

IF %USE_NETWORK_RESET_FAST%==0 GOTO :END_RESET_NETORK_FAST_MAIN
	CALL :FIX_RESET_NETWORK_FAST
	CALL :TEST isConnected
	IF %isConnected%==1 GOTO :SUCCESS

	REM FIX FAILED
	SET currently=Quickly reseting the Network Connection
	SET currently2=did not fix the problem
	SET SpecificStatus=
	SET isWaiting=0
	CALL :STATS
:END_RESET_NETORK_FAST_MAIN
REM ***END RESET NETWORK CONNECTION FAST***


REM *****RESET IP ADDRESS*****
IF %USE_IP_RESET%==0 GOTO :END_RESET_IP_MAIN
	CALL :FIX_RESET_IP
	CALL :TEST isConnected
	IF %isConnected%==1 GOTO :SUCCESS
	
	REM FIX FAILED
	SET currently=Resetting IP did not fix the problem
	SET currently2=
	SET SpecificStatus=
	SET isWaiting=0
	CALL :STATS
	
:END_RESET_IP_MAIN
REM ***END RESET IP ADDRESS***


REM *****RESET NETWORK CONNECTION*****

IF %USE_NETWORK_RESET%==0 GOTO :END_RESET_NETORK_MAIN
	CALL :FIX_RESET_NETWORK
	CALL :TEST isConnected
	IF %isConnected%==1 GOTO :SUCCESS

	REM FIX FAILED
	SET /A mins="TTLSCNDS/60"
	SET currently=Disabling Network for %mins% minutes
	SET currently2=did not fix the problem
	SET SpecificStatus=
	SET isWaiting=0
	CALL :STATS
:END_RESET_NETORK_MAIN
REM ***END RESET NETWORK CONNECTION***



REM FIXES FAILED
GOTO :FAILED
REM -----------------END FIX INTERNET CONNECTION------------------




:FIX_RESET_IP
REM -------------------FIX: RESET IP ADDRESS----------------------
REM Fix internet connection by reseting the IP address

SET currently=Releasing IP Address
SET currently2=*May take a couple minutes*
SET SpecificStatus=
SET isWaiting=0
CALL :STATS

REM Release IP Address
IF %DEBUGN%==0 IPCONFIG /RELEASE >NUL


REM Flush DNS Cache
SET currently=Flushing DNS Cache
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS

IF %DEBUGN%==0 IPCONFIG /FLUSHDNS >NUL


REM Renew IP Address
SET currently=Renewing IP Address
SET currently2=*May take a couple minutes*
SET SpecificStatus=
SET isWaiting=0
CALL :STATS

IF %DEBUGN%==0 IPCONFIG /RENEW >NUL

REM CANNOT TEST HERE
REM Checking network connection here causes unwanted recursion
GOTO :EOF
REM -----------------END FIX: RESET IP ADDRESS--------------------



:FIX_RESET_NETWORK_FAST
REM -------------FIX: RESET NETWORK CONNECTION FAST---------------
REM Disable Network, Enable Network
CALL :DISABLE_NW
CALL :ENABLE_NW

REM CANNOT TEST HERE
REM Checking network connection here causes unwanted recursion 

GOTO :EOF
REM -----------END FIX: RESET NETWORK CONNECTION FAST-------------



:FIX_RESET_NETWORK
REM ---------------FIX: RESET NETWORK CONNECTION------------------
REM Disable Network, Wait, Enable Network

REM Disable network connection
CALL :DISABLE_NW

SET currently=Waiting to re-enable "%NETWORK%"
SET currently2=
SET SpecificStatus=

REM Wait specified time
SET delaymins=%MINUTES%
CALL :WAIT

REM Enable network connection
CALL :ENABLE_NW


REM CANNOT TEST HERE
REM Checking network connection here causes unwanted recursion 

GOTO :EOF
REM -------------END FIX: RESET NETWORK CONNECTION----------------


:SLEEP
REM ------------------------PROGRAM SLEEP-------------------------
REM Program sleeps for %1 seconds
IF "%1"=="" SET pN=3
IF NOT "%1"=="" SET pN=%1
PING -n 2 -w 1000 127.0.0.1>NUL
PING -n %pN% -w 1000 127.0.0.1>NUL
GOTO :EOF
REM ------------------------END PROGRAM SLEEP---------------------


:WAIT
SETLOCAL
REM -----------------------PROGRAM TIMER--------------------------

REM ******INITIALIZE TIMER*****

REM Calculate total time
SET /A PINGS="(delaymins*60)/TIMER_REFRESH_RATE"
SET /A TTLSCNDS="PINGS*TIMER_REFRESH_RATE"
SET /A HOURS="(TTLSCNDS/3600)"
SET /A MINUTES2="(TTLSCNDS-(HOURS*3600))/60"
SET /A SECONDS="TTLSCNDS-((HOURS*3600)+(MINUTES2*60))"

REM Set HOURS to "" or "##:"
REM (always 2 digits or nothing)
IF %HOURS%==0 (
	SET HOURS=
) ELSE (
	SET HOURS=%HOURS%:
)

REM Set MINUTES2 to "","##:", "00:", or "0#:"
REM (always 2 digits or nothing)
REM (always 2 digits if HOURS>0)
IF %MINUTES2%==0 (
	IF "%HOURS%"=="" (
		SET MINUTES2=
	) ELSE (
		SET MINUTES2=00:
	)
) ELSE (
	SET MINUTES2=%MINUTES2%:
)

REM Set SECONDS to "##" or "0#"
REM (always 2 digits)
IF %SECONDS% LEQ 9 SET SECONDS=0%SECONDS%

REM Set Ticker to 0
SET ticker=0

REM ****END INITIALIZE TIMER***


:WAITING
REM *****TICKING TIMER*****


REM Calculate REM aining time
SET /A left="PINGS-ticker"
SET /A ttlscndslft="left*TIMER_REFRESH_RATE"
SET /A hrs="ttlscndslft/3600"
SET /A mins="(ttlscndslft-(hrs*3600))/60"
SET /A scnds="(ttlscndslft-((hrs*3600)+(mins*60)))"

REM Bump ticker
SET /A ticker+=1


REM Set hrs to "","##:", or "0#:"
REM (always 2 digits or nothing)
IF %hrs%==0 (
	SET hrs=
) ELSE (
	SET hrs=%hrs%:
)

REM Set mins to "","##:", "00:", or "0#:"
REM (always 2 digits or nothing)
REM (always 2 digits if HOURS>0)
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

REM Set SECONDS to "##" or "0#"
REM (always 2 digits)
IF %scnds% LEQ 9 SET scnds=0%scnds%

REM Update TimeStamp
SET SpecificStatus=Time Left:  %hrs%%mins%%scnds% of %HOURS%%MINUTES2%%SECONDS%

REM Display updated TimeStamp
SET isWaiting=0
CALL :STATS
CALL :SLEEP %TIMER_REFRESH_RATE%

REM Cycle through "WAITING" again if waiting time 
REM has not been reached
IF %ticker% LEQ %PINGS% GOTO :WAITING
ENDLOCAL

SET has_tested_ntwk_name_recent=0
GOTO :EOF
REM ---------------------END PROGRAM TIMER------------------------



:DISABLE_NW
REM -----------------DISABLE NETWORK CONNECTION-------------------
REM Determine OS and disable via a compatible method

SET currently=Disabling "%NETWORK%"...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS

IF %ONLY_ONE_NETWORK_NAME_TEST%==0 CALL :TEST_NETWORK_NAME
IF %DEBUGN%==0 IF %winVistaOrNewer%==1 NETSH INTERFACE SET INTERFACE "%NETWORK%" DISABLE
IF %DEBUGN%==0 IF %winVistaOrNewer%==0 CALL :TOGGLECONNECTION_OLD_OS DIS

SET currently="%NETWORK%" Disabled
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
GOTO :EOF
REM ---------------END DISABLE NETWORK CONNECTION-----------------


:ENABLE_NW
REM ------------------ENABLE NETWORK CONNECTION-------------------
REM Determine OS and enable via a compatible method

SET currently=Enabling "%NETWORK%"
SET currently2=
SET SpecificStatus=
SET isWaiting=0 
CALL :STATS

REM TEST_NETWORK_NAME (EXIT || RETURN)
IF %ONLY_ONE_NETWORK_NAME_TEST%==0 CALL :TEST_NETWORK_NAME
IF %DEBUGN%==0 IF %winVistaOrNewer%==1 NETSH INTERFACE SET INTERFACE "%NETWORK%" ENABLE
IF %DEBUGN%==0 IF %winVistaOrNewer%==0 CALL :TOGGLECONNECTION_OLD_OS EN

SET currently="%NETWORK%" Enabled
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
GOTO :EOF
REM ----------------END ENABLE NETWORK CONNECTION-----------------




:TOGGLECONNECTION_OLD_OS
REM ----------------DISABLE/ENABLE CONNECTION FOR WINXP------------------
REM No known way to disable/enable from cmd line. Instead, we must
REM create a temp vbs file that disables it and deletes itself when 
REM its run
IF %1==EN SET disOrEn=Enable
IF %1==EN SET trufalse=false
IF %1==DIS SET disOrEn=Disable
IF %1==DIS SET trufalse=true
ECHO disoren: %disOrEn%
ECHO trufalse: %trufalse%
PAUSE
@ECHO on
ECHO Const ssfCONTROLS = 3 >>%disOrEn%Network.vbs
ECHO sConnectionName = "%NETWORK%" >>%disOrEn%Network.vbs
ECHO sEnableVerb = "En&able" >>%disOrEn%Network.vbs
ECHO sDisableVerb = "Disa&ble" >>%disOrEn%Network.vbs
ECHO set shellApp = createobject("shell.application") >>%disOrEn%Network.vbs
ECHO set oControlPanel = shellApp.Namespace(ssfCONTROLS) >>%disOrEn%Network.vbs
ECHO set oNetConnections = nothing >>%disOrEn%Network.vbs
ECHO for each folderitem in oControlPanel.items >>%disOrEn%Network.vbs
ECHO   if folderitem.name = "Network Connections" then >>%disOrEn%Network.vbs
ECHO         set oNetConnections = folderitem.getfolder: exit for >>%disOrEn%Network.vbs
ECHO end if >>%disOrEn%Network.vbs
ECHO next >>%disOrEn%Network.vbs
ECHO if oNetConnections is nothing then >>%disOrEn%Network.vbs
ECHO msgbox "Couldn't find 'Network Connections' folder" >>%disOrEn%Network.vbs
ECHO wscript.quit >>%disOrEn%Network.vbs
ECHO end if >>%disOrEn%Network.vbs
ECHO set oLanConnection = nothing >>%disOrEn%Network.vbs
ECHO for each folderitem in oNetConnections.items >>%disOrEn%Network.vbs
ECHO if lcase(folderitem.name) = lcase(sConnectionName) then >>%disOrEn%Network.vbs
ECHO set oLanConnection = folderitem: exit for >>%disOrEn%Network.vbs
ECHO end if >>%disOrEn%Network.vbs
ECHO next >>%disOrEn%Network.vbs
ECHO Dim objFSO >>%disOrEn%Network.vbs
ECHO if oLanConnection is nothing then >>%disOrEn%Network.vbs
ECHO msgbox "Couldn't find %NETWORK%" >>%disOrEn%Network.vbs
ECHO msgbox "This program requires a valid Network Connection name to work properly" >>%disOrEn%Network.vbs
ECHO msgbox "Please close the program and open it with notepad for more information" >>%disOrEn%Network.vbs
ECHO Set objFSO = CreateObject("Scripting.FileSystemObject") >>%disOrEn%Network.vbs
ECHO objFSO.DeleteFile WScript.ScriptFullName >>%disOrEn%Network.vbs
ECHO Set objFSO = Nothing >>%disOrEn%Network.vbs
ECHO wscript.quit >>%disOrEn%Network.vbs
ECHO end if >>%disOrEn%Network.vbs
ECHO bEnabled = true >>%disOrEn%Network.vbs
ECHO set oEnableVerb = nothing >>%disOrEn%Network.vbs
ECHO set oDisableVerb = nothing >>%disOrEn%Network.vbs
ECHO s = "Verbs: " & vbcrlf >>%disOrEn%Network.vbs
ECHO for each verb in oLanConnection.verbs >>%disOrEn%Network.vbs
ECHO s = s & vbcrlf & verb.name >>%disOrEn%Network.vbs
ECHO if verb.name = sEnableVerb then >>%disOrEn%Network.vbs
ECHO set oEnableVerb = verb >>%disOrEn%Network.vbs
ECHO bEnabled = false >>%disOrEn%Network.vbs
ECHO end if >>%disOrEn%Network.vbs
ECHO if verb.name = sDisableVerb then >>%disOrEn%Network.vbs
ECHO set oDisableVerb = verb >>%disOrEn%Network.vbs
ECHO end if >>%disOrEn%Network.vbs
ECHO next >>%disOrEn%Network.vbs
ECHO if bEnabled = %trufalse% then >>%disOrEn%Network.vbs
ECHO o%disOrEn%Verb.DoIt >>%disOrEn%Network.vbs
ECHO end if >>%disOrEn%Network.vbs
ECHO wscript.sleep 2000 >>%disOrEn%Network.vbs
ECHO Set objFSO = CreateObject("Scripting.FileSystemObject") >>%disOrEn%Network.vbs
ECHO objFSO.DeleteFile WScript.ScriptFullName >>%disOrEn%Network.vbs
ECHO Set objFSO = Nothing >>%disOrEn%Network.vbs
@ECHO off
SET isWaiting=0
CALL :STATS
cscript %disOrEn%Network.vbs
GOTO :EOF
REM --------------END DISABLE/ENABLE CONNECTION FOR WINXP----------------



:DETECT_OS
REM -------------------DETECT OPERATING SYSTEM--------------------
REM SAFE BRANCH (EXIT || RETURN)
REM RETURN (winVistaOrNewer (1 || 0) )
REM Detect OS and return compatibility

SET currently=Checking if Operating System is supported...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS

REM Get OS name
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
REM INTERNAL BRANCH (RUN_ON_SUPPORTED || SYSTEM_UNSUPPORTED)
SET currently=Operating System is unsupported
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
ECHO.
ECHO.
ECHO This OS is unsupported:
VER
CALL :SLEEP
IF %OS_DETECT_OVERRIDE%==1 GOTO :RUN_ON_UNSUPPORTED
CALL :SLEEP
GOTO :SYSTEM_UNSUPPORTED

:OldVer
REM RETURN winVistaOrNewer (0)
SET currently=Operating System is supported
SET currently2=(WindowsXP)
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
SET winVistaOrNewer=0
GOTO :EOF

:NewVer
REM RETURN winVistaOrNewer (1)
SET currently=Operating System is supported
SET currently2= (%vers%)
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
SET winVistaOrNewer=1
GOTO :EOF


:RUN_ON_UNSUPPORTED
REM INTERNAL BRANCH (CONTINUE_RUN_ANYWAY || SYSTEM_UNSUPPORTED)
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
REM RETURN winVistaOrNewer (0)
SET currently=Continuing to run program. OS is treated
SET currently2=as though it were WindowsXP
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
SET winVistaOrNewer=0
GOTO :EOF
REM -----------------END DETECT OPERATING SYSTEM------------------



:CHECK_START_AT_LOGON
REM --------------------CHECK START AT LOG ON---------------------
REM Copies self to Startup Folder if START_AT_LOGON==1
REM Else Deletes "NetworkResetterByLectrode.bat" in 
REM Startup Folder

SET currently=Checking if set to start at user log on...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF %START_AT_LOGON%==0 GOTO :DONT_STARTUP
IF "%SETNFileDir%"=="TEMP" GOTO :EOF
IF "%SETNFileDir%"=="%THISFILEDIR%" GOTO :EOF

SET currently=Program is set to start at user log on.
SET currently2=Copying self to Startup Folder...
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
COPY %THISFILENAME% "%systemdrive%\Documents and Settings\%USERNAME%\Start Menu\Programs\Startup\NetworkResetterByLectrode.bat" >NUL
GOTO :EOF

:DONT_STARTUP
SET currently=Program is not set to start at user log on.
SET currently2=Removing copies of self in Startup folder, if any...
SET SpecificStatus=
SET isWaiting=0
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
TYPE NUL > "%systemdrive%\Documents and Settings\%USERNAME%\Start Menu\Programs\Startup\NetworkResetterByLectrode.bat"
DEL /F /Q "%systemdrive%\Documents and Settings\%USERNAME%\Start Menu\Programs\Startup\NetworkResetterByLectrode.bat" >NUL

GOTO :EOF
REM ------------------END CHECK START AT LOG ON-------------------



:TEST_NETWORK_NAME
REM ----------------------TEST NETWORK NAME-----------------------
REM SAFE BRANCH (EXIT || RETURN)

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
REM --------------------END TEST NETWORK NAME---------------------



:TESTIntVAR
REM ----------------------TEST INTEGAR VALUE----------------------
REM %1=varname
REM %2=default value
REM %3=min value
REM %4=max value
REM %5=current value
IF %3==%4 SET IntNoLimit=1
IF NOT %3==%4 SET IntNoLimit=0
SET currently=Checking if %1 has a valid 
SET currently2=value (Integar between %3 and %4)...
IF IntNoLimit==1 SET currently2=value (an Integar)...
SET SpecificStatus=
SET isWaiting=0
IF NOT "%SHOW_ALL_ALERTS%"=="0" CALL :STATS

IF "0"=="%5" GOTO :TESTIntVAR_ISNUM

SET /a num=%5
IF NOT "%num%"=="0" GOTO :TESTIntVAR_ISNUM

GOTO :TESTIntVAR_NOTVALID

:TESTIntVAR_ISNUM
IF %IntNoLimit%==1 SET %1=%num%
IF %IntNoLimit%==1 GOTO :EOF
IF %num% GEQ %3 IF %num% LEQ %4 SET %1=%num%
IF %num% GEQ %3 IF %num% LEQ %4 GOTO :EOF


:TESTIntVAR_NOTVALID
SET currently=%1 does not have a valid value.
SET currently2=Setting %1 to %2...
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET %1=%2
GOTO :EOF
REM --------------------END TEST INTEGAR VALUE--------------------



:TEST01VAR
REM ----------------------TEST 0 or 1 VALUE-----------------------
REM %1=varname
REM %2=default value
REM %3=current value
SET currently=Checking if %1 has 
SET currently2=a valid value (0 or 1)...
SET SpecificStatus=
SET isWaiting=0
IF NOT "%SHOW_ALL_ALERTS%"=="0" CALL :STATS
IF "%3"=="0" GOTO :EOF
IF "%3"=="1" GOTO :EOF
SET currently=%1 does not equal "1" or "0"
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET currently=Setting %1 to "%2"...
SET currently2=
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
SET %1=%2
GOTO :EOF
REM --------------------END TEST 0 or 1 VALUE---------------------




:TEST_FIXES_VALS
REM --------------------TEST FIXES VALUES-------------------------
REM If fixes are disabled, gives option of enable both
REM or Continue

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
REM ------------------END TEST FIXES VALUES-----------------------




:NEED_NETWORK
REM ---------------PROGRAM NEEDS NETWORK NAME---------------------
REM GOTO (NEED_NETWORK_AUTO || EXIT (COMPLETE || RESTART))
SET NETWORK_NAMES_NUM=9


IF %NCNUM%==0 SET NETWORKCOMMON=Wireless Network Connection
IF %NCNUM%==1 SET NETWORKCOMMON=Local Area Connection
IF %NCNUM%==2 SET NETWORKCOMMON=LAN
IF %NCNUM%==3 SET NETWORKCOMMON=Wireless Network Connection 1
IF %NCNUM%==4 SET NETWORKCOMMON=Wireless Network Connection 2
IF %NCNUM%==5 SET NETWORKCOMMON=Wireless Network Connection 3
IF %NCNUM%==6 SET NETWORKCOMMON=Wireless Network Connection 4
IF %NCNUM%==7 SET NETWORKCOMMON=Wireless Network Connection 5
IF %NCNUM%==8 SET NETWORKCOMMON=Wireless Network Connection 6
IF %NCNUM%==9 SET NETWORKCOMMON=Local Area Network

SET currently=Could not find '%NETWORK%'
SET currently2=Testing Common Network Names...
SET SpecificStatus=Checking '%NETWORKCOMMON%'
SET isWaiting=0
CALL :STATS

IF %DEBUGN%==0 NETSH INTERFACE SET INTERFACE NAME="%NETWORKCOMMON%" NEWNAME="%NETWORKCOMMON%"|FIND "name is not registered " >NUL
SET /A NCNUM+=1
IF %DEBUGN%==0 IF ERRORLEVEL 1 GOTO :FOUND_CUSTOM_NAME
IF %DEBUGN%==0 IF NOT ERRORLEVEL 1 IF %NCNUM% GTR %NETWORK_NAMES_NUM% GOTO :COMMON_NAMES_NOT_FOUND
IF %DEBUGN%==0 IF NOT ERRORLEVEL 1 GOTO :NEED_NETWORK


:FOUND_CUSTOM_NAME
SET currently=Found a Network connection match:
SET currently2='%NETWORKCOMMON%'
SET SpecificStatus=
SET isWaiting=0
CALL :STATS
ECHO.
ECHO.
IF %OMIT_USER_INPUT%==1 SET NETWORK==%NETWORKCOMMON%
IF %OMIT_USER_INPUT%==1 GOTO :EOF
ECHO Would you like to reset and/or monitor this network connection?
SET /P usrInpt=[y/n]
IF "%usrInpt%"=="n" IF %NCNUM% LSS %NETWORK_NAMES_NUM% GOTO :NEED_NETWORK
IF "%usrInpt%"=="y" SET NETWORK=%NETWORKCOMMON%
IF "%usrInpt%"=="y" CALL :SETTINGS_EXPORT
IF "%usrInpt%"=="y" GOTO :EOF
GOTO :FOUND_CUSTOM_NAME


:COMMON_NAMES_NOT_FOUND
SET currently=Could not find "%NETWORK%"
SET currently2=
SET SpecificStatus=NOTE: This program must be run as an administrator!
SET isWaiting=0
CALL :STATS
ECHO.
ECHO.
ECHO If the network name is correct, you may need to run this program
ECHO by right-clicking and selecting "Run as Administrator" (Windows
ECHO Vista and 7) or RunAs administrator (Windows XP)
IF %OMIT_USER_INPUT%==1 GOTO :NEED_NETWORK_AUTO
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
CALL :SETTINGS_SETONE B1
GOTO :TEST_NETWORK_NAME


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
REM -------------END PROGRAM NEEDS NETWORK NAME-------------------






REM ---------------------RESTART PROGRAM--------------------------
:RESTART_PROGRAM
REM Self restart
SET currently=Restarting Program...
SET currently2=
SET SpecificStatus=
SET isWaiting=1
CALL :STATS
SET restartingProgram=1
START CMD /C "%THISFILENAMEPATH%"
EXIT
REM -----------------END RESTART PROGRAM--------------------------




REM ------------------------AUTO UPDATE---------------------------
:SelfUpdate
IF NOT %DEBUGN%==0 GOTO :EOF
@ECHO on
SET file=http://electrodexs.net/data/Network_Resetter.txt
DEL webdown.vbs
ECHO 'Download Update  >webdown.vbs
ECHO Set xPost = CreateObject("Microsoft.XMLHTTP") '>>webdown.vbs
ECHO xpost.open "HEAD", "%file%", False '>>webdown.vbs
ECHO xpost.send '>>webdown.vbs
ECHO Select Case Cint(xpost.status) '>>webdown.vbs
ECHO    Case 200, 202, 302 '>>webdown.vbs
ECHO      Set xpost = Nothing '>>webdown.vbs
ECHO      CheckPath = True '>>webdown.vbs
ECHO    Case Else '>>webdown.vbs
ECHO    Set xpost = Nothing '>>webdown.vbs
ECHO      CheckPath = False '>>webdown.vbs
ECHO End Select '>>webdown.vbs
ECHO If (CheckPath) Then '>>webdown.vbs
ECHO Set xPost = CreateObject("Microsoft.XMLHTTP") '>>webdown.vbs
ECHO xPost.Open "GET","%file%",0 '>>webdown.vbs
ECHO xPost.Send() '>>webdown.vbs
ECHO Set sGet = CreateObject("ADODB.Stream") '>>webdown.vbs
ECHO sGet.Mode = 3 '>>webdown.vbs
ECHO sGet.Type = 1 '>>webdown.vbs
ECHO sGet.Open() '>>webdown.vbs
ECHO sGet.Write(xPost.responseBody) '>>webdown.vbs
ECHO sGet.SaveToFile "Network_Resetter.bat",2 '>>webdown.vbs
ECHO END IF '>>webdown.vbs
ECHO Dim objFSO '>>webdown.vbs
ECHO Set objFSO = CreateObject("Scripting.FileSystemObject") '>>webdown.vbs
ECHO objFSO.DeleteFile WScript.ScriptFullName '>>webdown.vbs
ECHO Set objFSO = Nothing '>>webdown.vbs
cscript webdown.vbs
@ECHO off
GOTO :EOF
REM ----------------------END AUTO UPDATE-------------------------








REM --------------------------------------------------------------
REM --------------------------------------------------------------
REM --------------------------RESULTS-----------------------------
REM --------------------------------------------------------------
REM --------------------------------------------------------------



:SYSTEM_UNSUPPORTED
REM --------------UNSUPPORTED OPERATING SYSTEM--------------------
REM EXIT
SET currently=This Operating System is not currently supported.
SET currently2=EXITING...
SET SpecificStatus=
SET isWaiting=1
CALL :STATS
CALL :STATS
SET isWaiting=0
EXIT
REM ------------END UNSUPPORTED OPERATING SYSTEM------------------


:CHECK_CONNECTION_ONLY
REM ---------CHECK INTERNET CONNECION ONLY (NO FIXES)-------------
REM SAFE BRANCH (GOTO ( CHECK_CONNECTION_ONLY || EXIT ) )
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

REM -------END CHECK INTERNET CONNECION ONLY (NO FIXES)-----------


:FAILED
REM -------------------FIX ATTEMPT FAILED-------------------------
REM BRANCH (FAILED_CONTINUOUS || FIX || EXIT)
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

REM -----------------END FIX ATTEMPT FAILED-----------------------


:FAILED_CONTINUOUS
REM ----------------FIX ATTEMPT FAILED (RETRY)--------------------
REM GOTO FIX
SET currently=Unable to Connect to Internet (Retrying...)
SET currently2=
SET SpecificStatus= 
SET isWaiting=1
CALL :STATS
SET isWaiting=0
GOTO :FIX
REM --------------END FIX ATTEMPT FAILED (RETRY)------------------


:SUCCESS
REM ------------------FIX ATTEMPT SUCCEEDED-----------------------
REM BRANCH (SUCCESS_CONTINUOUS || EXIT)

REM Declare that connection has been fixed
ECHO ProgramMustFix: %ProgramMustFix%
IF %ProgramMustFix%==1 (
SET ProgramMustFix=0
IF "%confixed%"=="" SET confixed=0
SET /A confixed+=1
)

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
CALL :SLEEP
CALL :SLEEP
IF %DEBUGN%==1 PAUSE
EXIT
REM ----------------END FIX ATTEMPT SUCCEEDED---------------------


:SUCCESS_CONTINUOUS
REM -------------FIX ATTEMPT SUCCEEDED (RECHECK)------------------
REM BRANCH (SUCCESS || FIX)
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
REM -----------END FIX ATTEMPT SUCCEEDED (RECHECK)----------------