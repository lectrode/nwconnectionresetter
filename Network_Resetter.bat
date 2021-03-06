REM *****************************************************************
REM ************        USE CAUTION WHEN EDITING!       *************
REM *****************************************************************
CALL :INITPROG

REM -----Program Info-----
REM Name: 		Network Resetter
REM Revision:
	SET rvsn=r186
REM Branch:
	SET Branch=

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
REM 				and using the font "Curier New"
REM 
REM 				If it seems stuck on "Resetting IP Address"
REM 				don't worry about it. It should get past it within a 
REM 				few minutes. If it persists longer than 10 minutes,
REM 				email me and I'll help you. If this happens often, you
REM 				can disable it under "Advanced Settings"
REM 
REM 				If after running the program it still won't connect, try
REM 				increasing the number of MINUTES to wait.
REM 
REM 				If you close the program while it is attempting to fix
REM 				your network connection, the network connection may still
REM 				be disabled. To fix this, re-run this program.
REM 				You can set MINUTES to 0 for a quick run. 
REM 
REM 				Possible error messages you may recieve:
REM
REM 				"This Operating System is not currently supported."
REM 				-The only thing you can do in this case is email me
REM 				the name of the Operating System and I'll try to add
REM 				support for it.
REM 				You can bypass the OS detection below in "Advanced
REM 				Settings", but the program may exhibit unusual behavior.
REM 
REM 				"Could not find <network> | This program requires a valid
REM 				network connection | please open with notepad for more information"
REM 				-To fix this please correct the NETWORK setting.
REM 				
REM 				This program is protected under the GPLv3 License. 
REM 				http://www.gnu.org/licenses/gpl.html



REM ************Alternate Settings****************
REM These settings are overriden by default. To enable these
REM settings, please set USE_ALTERNATE_SETTINGS to 1

REM NOTE: Changing the settings via the GUI will not change
REM       the values shown below. These "Alternate" settings
REM       are provided for those who do not wish to use the
REM       GUI to set them and/or save them to an external
REM       file.

SET USE_ALTERNATE_SETTINGS=0

SET MINUTES=10
SET NETWORK=Wireless Network Connection
SET CONTINUOUS=1
SET AUTO_RETRY=1
SET AUTOUPDATE=0
SET CHECK_DELAY=1
SET SHOW_ALL_ALERTS=1
SET SHOW_ADVANCED_TESTING=1
SET SLWMSG=0
SET TIMER_REFRESH_RATE=1
SET START_AT_LOGON=0
SET START_MINIMIZED=0
SET UPDATECHANNEL=2
SET CHECKUPDATEFREQ=5
SET USELOGGING=1
SET OMIT_USER_INPUT=0
SET SKIP_INITIAL_NTWK_TEST=0
SET USE_IP_RESET=1
SET USE_NETWORK_RESET_FAST=1
SET USE_NETWORK_RESET=1
SET USE_RESET_ROUTE_TABLE=0
SET TREAT_TIMEOUTS_AS_DISCONNECT=0
SET ONLY_ONE_NETWORK_NAME_TEST=1
SET OS_DETECT_OVERRIDE=0


:TOP
REM *************Main Code**************

::PROGRAMMER TOOLS
::set NoECHO to :: to show raw commands
SET NoECHO=

SET SIMULATE=0
SET SIMULATE_CONNTESTFAIL=0

::1=TEST_FAILED,2=TEST_UNREACHED,3=TEST_EXCEEDED_TEST_LIMIT,4=TEST_NEED_BROWSER,5=TEST_SUCCEEDED
SET SIMULATE_NETTEST=0

REM -------------------Initialize Program--------------------

SET THISFILEDIR=%~dp0
SET THISFILENAME=%~n0.bat
SET THISFILENAMEPATH=%~dpnx0
SET INITPARAMS=%1

GOTO :INITIALIZE





REM **************************************************************************
REM *****************************GUI*&*MISC*TOOLS*****************************
REM **************************************************************************


:STATS
%NoECHO%REM ---------------------PROGRAM STATUS-----------------------
%NoECHO%SET statsSleep=%1
%NoECHO%SET STATSSpacer=                                                                                   !
%NoECHO%REM CALL :GETRUNTIME_LENGTH
%NoECHO%SET currently=%currently1%%currently2%%currently3%%currently4%%currently5%
%NoECHO%SET SHOWNETWORK="%NETWORK%"%STATSSpacer%
%NoECHO%SET SHOWcurrently1=%currently1%%STATSSpacer%
%NoECHO%SET SHOWcurrently2=%currently2%%STATSSpacer%
%NoECHO%SET SHOWcurrently3=%currently3%%STATSSpacer%
%NoECHO%SET SHOWcurrently4=%currently4%%STATSSpacer%
%NoECHO%SET SHOWcurrently5=%currently5%%STATSSpacer%
%NoECHO%SET SHOWTimerStatus=%TimerStatus%%STATSSpacer%
%NoECHO%SET SHOWFixMode=                 
%NoECHO%IF x%Using_Fixes%==x0 SET SHOWFixMode=-Not using fixes-
%NoECHO%IF "%confixed%"=="" SET confixed=0
%NoECHO%REM SET SHOWconfixed=                %confixed% in %RUNTIMEL%
%NoECHO%IF NOT "%LastTitle%"=="%THISTITLE%" CALL :CENTERTEXT 74 SHOWTitle ****** %THISTITLE% ******
%NoECHO%IF NOT "%Lastconfixed%"=="%confixed%" CALL :CENTERTEXT 27 SHOWconfixed %confixed%
%NoECHO%SET LastTitle=%THISTITLE%
%NoECHO%SET Lastconfixed=%confixed%
%NoECHO%CLS
%NoECHO%								ECHO. ******************************************************************************
%NoECHO%								ECHO  *                                                                            *
%NoECHO%								ECHO  * %SHOWTitle% *
%NoECHO%								ECHO  *                                                                            *
%NoECHO%								ECHO  *                 http://code.google.com/p/nwconnectionresetter              *
%NoECHO%								ECHO  *                                                                            *
%NoECHO%								ECHO  *----------------------------------------------------------------------------*
%NoECHO%IF "%SIMULATE%"=="1"			ECHO  *       *SIMULATION ONLY! Set SIMULATE to 0 to enable functionality*         *
%NoECHO%IF "%SIMULATE%"=="1"			ECHO  *----------------------------------------------------------------------------*
%NoECHO%IF "%CONTINUOUS%"=="1"			ECHO  *  Program started:          ^|  Continuous Mode  ^|     Connection Fixes:     *
%NoECHO%IF "%CONTINUOUS%"=="1"			ECHO  * %StartDate% ^| %SHOWFixMode% ^|%SHOWconfixed%*
%NoECHO%IF "%CONTINUOUS%"=="1"			ECHO  *----------------------------------------------------------------------------*
										ECHO  *                                                                            *
%NoECHO%IF NOT "%NETWORK%"==""			ECHO  * Connection: %SHOWNETWORK:~0,63%*
%NoECHO%IF NOT "%NETWORK%"==""			ECHO  *                                                                            *
%NoECHO%IF NOT "%currently1%"==""		ECHO  * Current State: %SHOWcurrently1:~0,60%*
%NoECHO%IF NOT "%currently2%"==""		ECHO  *                %SHOWcurrently2:~0,60%*
%NoECHO%IF NOT "%currently3%"==""		ECHO  *                %SHOWcurrently3:~0,60%*
%NoECHO%IF NOT "%currently4%"==""		ECHO  *                %SHOWcurrently4:~0,60%*
%NoECHO%IF NOT "%currently5%"==""		ECHO  *                %SHOWcurrently5:~0,60%*
%NoECHO%IF NOT "%currently%"==""		ECHO  *                                                                            *
%NoECHO%IF NOT "%TimerStatus%"==""		ECHO  * %SHOWTimerStatus:~0,75%*
%NoECHO%IF NOT "%TimerStatus%"==""		ECHO  *                                                                            *
										ECHO  ******************************************************************************

%NoECHO%IF "%SLWMSG%"=="1" CALL :SLEEP %statsSleep%
%NoECHO%IF NOT "%SLWMSG%"=="1" IF NOT "%statsSleep%"=="" CALL :SLEEP %statsSleep%
GOTO :EOF
REM ---------------------END PROGRAM STATUS----------------------


:SLEEP
REM ------------------------PROGRAM SLEEP-------------------------
REM Program sleeps for %1 seconds
IF "%1"=="" SET pN=3
IF NOT "%1"=="" SET pN=%1
PING -n 2 -w 1000 127.0.0.1>NUL 2>&1
PING -n %pN% -w 1000 127.0.0.1>NUL 2>&1
GOTO :EOF
REM ------------------------END PROGRAM SLEEP---------------------


:RESETCURRENTLY
SET currently=
SET currently1=
SET currently2=
SET currently3=
SET currently4=
SET currently5=
SET TimerStatus=
GOTO :EOF


:HEADER
REM Settings header. Used when configuring settings.
%NoECHO%@ECHO OFF
%NoECHO%IF NOT "%LastTitle%"=="%THISTITLE%" CALL :CENTERTEXT 74 SHOWTitle ****** %THISTITLE% ******
%NoECHO%SET LastTitle=%THISTITLE%
SET DONEINIT=::
%NoECHO%CLS
%NoECHO%ECHO  ******************************************************************************
%NoECHO%ECHO  *                                                                            *
%NoECHO%ECHO  * %SHOWTitle% *
%NoECHO%ECHO  *                                                                            *
%NoECHO%ECHO  ******************************************************************************
%NoECHO%ECHO.
GOTO :EOF



:CENTERTEXT
%DONEINIT%%NoECHO%ECHO..........
SET TTLSPACE=%1
SET VAR2SET=%2
SET TEXT=
SET INCNUM=0
SET NUMCHECK=
SET HALFSPACE=
SET PARAMSPACE=
:CENTERTEXT_GETALLTEXT
IF NOT "%3"=="" SET TEXT=%TEXT%%PARAMSPACE%%3
IF NOT "%3"=="" SET PARAMSPACE= &SHIFT&GOTO :CENTERTEXT_GETALLTEXT
%DONEINIT%%NoECHO%ECHO...........
CALL :StrLength STRLEN %TEXT%

SET /A HALFSPACE=(TTLSPACE-STRLEN)/2
:ADDSPACEFRONT
SET /A INCNUM+=1
SET TEXT= %TEXT%
IF NOT %INCNUM% GEQ %HALFSPACE% GOTO :ADDSPACEFRONT
%DONEINIT%%NoECHO%ECHO..............
SET INCNUM=0
:ADDSPACEBACK
SET /A INCNUM+=1
SET TEXT=%TEXT% 
IF NOT %INCNUM% GEQ %HALFSPACE% GOTO :ADDSPACEBACK

SET /A NUMCHECK=(TTLSPACE-STRLEN)%%2
IF %NUMCHECK% GEQ 1 SET TEXT= %TEXT%
SET %VAR2SET%=%TEXT%
GOTO :EOF


:StrLength
::StrLength(retVal,string)
SET PARAMSPACE=
SET StrLenVar=%1
:StrLength_GETALLTEXT
IF NOT "%2"=="" SET #=%#%%PARAMSPACE%%2
IF NOT "%2"=="" SET PARAMSPACE= &SHIFT&GOTO :StrLength_GETALLTEXT
%DONEINIT%%NoECHO%ECHO............
set length=0
:stringLengthLoop
SET #def=0
IF DEFINED # SET #def=1
IF %#def%==1 SET #=%#:~1%
IF %#def%==1 SET /A length += 1
IF %#def%==1 GOTO :stringLengthLoop
%DONEINIT%%NoECHO%ECHO.............
SET "%StrLenVar%=%length%"
GOTO :EOF


:ToLower
FOR %%i IN ("A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i" "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r" "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z") DO CALL SET "%1=%%%1:%%~i%%"
GOTO:EOF

:GET_Randomfilename
SET filevar=%1
SET ext=%2
SET %filevar%=temp%RANDOM:~0,7%%ext%
IF EXIST "%THISFILEDIR%!%filevar%!" GOTO :GET_Randomfilename
GOTO :EOF

:GET_Randomfoldername
SET foldervar=%1
SET %foldervar%=temp%RANDOM:~0,7%
IF EXIST "%THISFILEDIR%!%foldervar%!"NUL GOTO :GET_Randomfoldername
GOTO :EOF


:GETRUNTIME_LENGTH
SET cYEAR=%DATE:~-4%
SET cMONTH=%DATE:~4,2%
SET cDAY=%DATE:~7,2%
SET cHOUR=%TIME:~0,2%
SET cMINUTE=%TIME:~3,2%
SET cSECOND=%TIME:~6,2%

IF NOT %cYEAR% GEQ 10 SET cYEAR=%cYEAR:~1,1% 
IF NOT %cMONTH% GEQ 10 SET cMONTH=%cMONTH:~1,1%
IF NOT %cDAY% GEQ 10 SET cDAY=%cDAY:~1,1%
IF NOT %cHOUR% GEQ 10 SET cHOUR=%cHOUR:~1,1%
IF NOT %cMINUTE% GEQ 10 SET cMINUTE=%cMINUTE:~1,1%
IF NOT %cSECOND% GEQ 10 SET cSECOND=%cSECOND:~1,1%

SET /A LeapYear=cYEAR%%4

IF %cSECOND% LSS %iSECOND% (
SET /A cMINUTE-=1
SET /A cSECOND+=60
)
IF %cMINUTE% LSS %iMINUTE% (
SET /A cHOUR-=1
SET /A cMINUTE+=60
)
IF %cHOUR% LSS %iHOUR% (
SET /A cDAY-=1
SET /A cHOUR+=24
)

IF NOT %cDAY% LSS %iDAY% GOTO :AFTcDAYCHECK
SET /A TMPMO=iMONTH
SET /A TMPNUM=iMONTH%%2
IF %cMONTH% LEQ 7 IF %TMPNUM%==1 SET MODAYS=31
IF %cMONTH% LEQ 7 IF %TMPNUM%==0 SET MODAYS=30
IF %cMONTH% GEQ 8 IF %TMPNUM%==0 SET MODAYS=31
IF %cMONTH% GEQ 8 IF %TMPNUM%==1 SET MODAYS=30
IF %cMONTH%==2 SET MODAYS=28
IF %cMONTH%==2 IF %LeapYear%==1 SET MODAYS=29

SET /A cMONTH-=1
SET /A cDAY+=MODAYS

:AFTcDAYCHECK
IF %cMONTH% LSS %iMONTH% (
SET /A cYEAR-=1
SET /A cMONTH+=12
)

SET /A cYEAR=cYEAR-iYEAR
SET /A cMONTH=cMONTH-iMONTH
SET /A cDAY=cDAY-iDAY
SET /A cHOUR=cHOUR-iHOUR
SET /A cMINUTE=cMINUTE-iMINUTE
SET /A cSECOND=cSECOND-iSECOND

IF %cSECOND% LSS 10 SET cSECOND=0%cSECOND%
IF %cMINUTE% LSS 10 SET cMINUTE=0%cMINUTE%

SET RUNTIMEL=
IF NOT %cYEAR%==0 SET RUNTIMEL=%cYEAR% yr 
IF NOT %cMONTH%==0 SET RUNTIMEL=%RUNTIMEL%%cMONTH% mo 
IF NOT %cDAY%==0 SET RUNTIMEL=%RUNTIMEL%%cDAY% day
SET RUNTIMEL=%RUNTIMEL%%cHOUR%:%cMINUTE%:%cSECOND%
GOTO :EOF


REM -----------------END INITIALIZE PROGRAM------------------

:MAIN_START
SET NETWORK_FOUNDINVALID=1
REM ------------------TO FIX OR NOT TO FIX-------------------
IF %Using_Fixes%==0 GOTO :CHECK_CONNECTION_ONLY
REM ----------------END TO FIX OR NOT TO FIX-----------------


REM -------------INITIAL NETWORK CONNECTION TEST-------------
REM BRANCH (SUCCESS || FIX)
REM Determine if connection needs to be fixed

IF %SKIP_INITIAL_NTWK_TEST%==1 GOTO :MAINNETTEST_FAIL

REM TEST CONNECTION AND INTERNET ACCESS
CALL :TEST_CONNECTION
IF %isConnected%==0 GOTO :MAINCONNTEST_FAIL
IF %isConnected%==1 GOTO :MAINCONNTEST_SUCCESS

:MAINCONNTEST_SUCCESS
CALL :TEST_INTERNET isConnected
IF %isConnected%==0 GOTO :MAINNETTEST_FAIL
IF %isConnected%==1 GOTO :SUCCESS
IF %isConnected%==2 GOTO :MAINNETTEST_UNREACH


:MAINCONNTEST_FAIL
CALL :DISCONNECTION_DETECTED
SET /A CONNFIX+=1
IF %CONNFIX% GTR %NUMCONNFIXES% GOTO :FAILED
CALL :CONNFIX%CONNFIX%
GOTO :MAIN_START

:MAINNETTEST_FAIL
CALL :DISCONNECTION_DETECTED
SET /A NETFIX+=1
IF %NETFIX% GTR %NUMNETFIXES% GOTO :FAILED
CALL :NETFIX%NETFIX%
GOTO :MAIN_START

:MAINNETTEST_UNREACH
IF NOT "%USE_RESET_ROUTE_TABLE%"=="1" GOTO :MAINNETTEST_FAIL
CALL :DISCONNECTION_DETECTED
SET ROUTEFIX+=1
IF %ROUTEFIX% GTR 1 GOTO :FAILED
CALL :FIXUNREACHABLE
GOTO :MAIN_START

REM -----------END INITIAL NETWORK CONNECTION TEST----------





:TEST_CONNECTION
REM ------------------TEST INTERNET CONNECTION-------------------
REM RETURN (isConnected= (1 || 0) )
CALL :RESETCURRENTLY
SET conchks=0
SET maxconchks=51
SET isConnected=0
SET currently2=
IF %SIMULATE%==1 IF %SIMULATE_CONNTESTFAIL%==1 GOTO :TEST_CONNECTION_FAILED
IF %SIMULATE%==1 IF %SIMULATE_CONNTESTFAIL%==0 SET isConnected=1&GOTO :EOF


:TEST_CONNECTION_CHECK
SET currently1=Checking for connectivity...
IF %conchks% GTR 0 SET currently2=[Currently Disconnected]
SET TimerStatus=
CALL :STATS
%NoECHO%IF %SHOW_ADVANCED_TESTING%==1 ECHO  Checks: %conchks%
IF "%NETWORK_IsMBN%"=="0" FOR /F "delims=" %%a IN ('NETSH INTERFACE SHOW INTERFACE "%NETWORK%"') DO @SET connect_test=%%a
IF "%NETWORK_IsMBN%"=="0" ECHO %connect_test% |FIND "Disconnected" >NUL
IF "%NETWORK_IsMBN%"=="0" IF ERRORLEVEL 1 SET isConnected=1&GOTO :EOF
IF "%NETWORK_IsMBN%"=="1" SET TC_MBN_ThisLine=0
IF "%NETWORK_IsMBN%"=="1" SET isConnected=0
IF "%NETWORK_IsMBN%"=="1" FOR /F "tokens=* delims=" %%a IN ('NETSH MBN SHOW INTERFACES') DO CALL :TEST_CONNECTION_CHECK_MBNPARSE %%a
REM IF "%NETWORK_IsMBN%"=="1" FOR /F "tokens=* delims=" %%a IN (C:\output.txt) DO CALL :TEST_CONNECTION_CHECK_MBNPARSE %%a
IF "%NETWORK_IsMBN%"=="1" IF "%isConnected%"=="1" GOTO :EOF
SET /A conchks+=1
IF %conchks% GEQ %maxconchks% GOTO :TEST_CONNECTION_FAILED
GOTO :TEST_CONNECTION_CHECK

:TEST_CONNECTION_CHECK_MBNPARSE
SET TC_MBN_Line=%*
FOR /F "tokens=1,2 delims=:" %%b IN ("%TC_MBN_Line%") DO SET TC_MBN_LineA=%%b&SET TC_MBN_LineB=%%c
IF "%TC_MBN_LineA%"=="" GOTO :EOF
ECHO %TC_MBN_LineA%|FIND "Name">NUL
SET TC_MBN_ERR=%ERRORLEVEL%
IF %TC_MBN_ERR%==0 ECHO "%TC_MBN_LineB%"|FIND "%NETWORK%">NUL
IF %TC_MBN_ERR%==0 IF NOT ERRORLEVEL 1 SET TC_MBN_ThisLine=1&GOTO :EOF
IF %TC_MBN_ERR%==0 SET TC_MBN_ThisLine=0&GOTO :EOF
IF %TC_MBN_ThisLine%==0 GOTO :EOF
ECHO %TC_MBN_LineA%|FIND "State">NUL
IF ERRORLEVEL 1 GOTO :EOF
ECHO %TC_MBN_LineB%|FIND "Not">NUL
IF ERRORLEVEL 1 SET isConnected=1
GOTO :EOF



:TEST_CONNECTION_FAILED
SET currently1=Connectivity test failed
SET currently2=[Currently Disconnected]
SET TimerStatus=
CALL :STATS
SET isConnected=0
GOTO :EOF

:TEST_INTERNET
SET main_tests=0
SET MaxStalls=10
SET NumStalls=0


:TEST_INIT
SET currently1=Testing Internet Connection...
SET currently2=
SET TimerStatus=
CALL :STATS
IF %SIMULATE%==1 IF %SIMULATE_NETTEST%==1 CALL :TEST_SET_TIME1&GOTO :TEST_FAILED
IF %SIMULATE%==1 IF %SIMULATE_NETTEST%==2 CALL :TEST_SET_TIME1&GOTO :TEST_UNREACHED
IF %SIMULATE%==1 IF %SIMULATE_NETTEST%==3 CALL :TEST_SET_TIME1&GOTO :TEST_EXCEEDED_TEST_LIMIT
IF %SIMULATE%==1 IF %SIMULATE_NETTEST%==4 CALL :TEST_SET_TIME1&GOTO :TEST_NEED_BROWSER
IF %SIMULATE%==1 IF %SIMULATE_NETTEST%==5 CALL :TEST_SET_TIME1&GOTO :TEST_SUCCEEDED


::Initialize Net Test
SET testwebsitenum=-1
CALL :TEST_CHANGETESTSITE
SET founds=0
SET times=0
SET nots=0
SET unreaches=0
SET totalTests=0
SET fluke_test_eliminator=5
SET maxTestLimit=15
SET /A NumStalls+=1
SET T_MILI_SMALLEST=300


::PING TEST
:TEST_TESTING
FOR /F "delims=" %%a IN ('PING -n 1 "%testwebsite%"') DO @SET ping_test=%%a

ECHO %ping_test% |FIND "request could not find" >NUL
IF NOT ERRORLEVEL 1 GOTO :TEST_NOT_CONNECTED

ECHO %ping_test% |FIND "Unreachable" >NUL
IF NOT ERRORLEVEL 1 GOTO :TEST_UNREACHABLE

ECHO %ping_test% |FIND "Minimum " >NUL
IF NOT ERRORLEVEL 1 GOTO :TEST_CONNECTED

GOTO :TEST_TIMED_OUT




REM ---------TEST-TOOLS------------

:TEST_INC_TOTALTESTS
SET /A totalTests+=1
SET SHOWttlTests=%totalTests%  .
GOTO :EOF

:TEST_SET_TIME1
SET T1_DATE=%DATE%
FOR /F "tokens=1-4* DELIMS=:." %%t IN ("%TIME%") DO SET T1_HR=%%t&SET T1_MIN=%%u&SET T1_SEC=%%v&SET T1_MIL=%%w
SET /A T1_TTLTIME=T1_MIL+(T1_SEC*100)+(T1_MIN*6000)+(T1_HR*360000)
GOTO :EOF

:TEST_CHANGETESTSITE
REM Microsoft Sites do NOT work!
SET TTLSITES=9

IF "%testwebsitenum%"=="-1" (
	SET /A testwebsitenum=TTLSITES*%RANDOM%/32768+1
) ELSE (
	IF %testwebsitenum% GEQ %TTLSITES% (
		SET testwebsitenum=1
	) ELSE (
		SET /A testwebsitenum+=1
	)
)

IF "%testwebsitenum%"=="1" SET testwebsite=www.facebook.com
IF "%testwebsitenum%"=="2" SET testwebsite=www.google.com
IF "%testwebsitenum%"=="3" SET testwebsite=www.linkedin.com
IF "%testwebsitenum%"=="4" SET testwebsite=www.yahoo.com
IF "%testwebsitenum%"=="5" SET testwebsite=www.apple.com
IF "%testwebsitenum%"=="6" SET testwebsite=www.youtube.com
IF "%testwebsitenum%"=="7" SET testwebsite=www.ask.com
IF "%testwebsitenum%"=="8" SET testwebsite=www.baidu.com
IF "%testwebsitenum%"=="9" SET testwebsite=www.wikipedia.org
IF "%testwebsite%"=="" GOTO :TEST_CHANGETESTSITE
GOTO :EOF


REM --------END-TEST-TOOLS---------


REM ---------PING-RESULTS----------


:TEST_CONNECTED
CALL :TEST_INC_TOTALTESTS
IF %SHOW_ADVANCED_TESTING%==1 ECHO %SHOWttlTests:~0,2%: Connect Success      (%testwebsite%)
SET /A founds+=1
SET unreaches=0
SET times=0
SET nots=0
IF %founds% GEQ %fluke_test_eliminator% GOTO :TEST_SUCCEEDED
GOTO :TEST_TESTING


:TEST_NOT_CONNECTED
CALL :TEST_INC_TOTALTESTS
IF %nots%==0 CALL :TEST_SET_TIME1
IF %SHOW_ADVANCED_TESTING%==1 ECHO %SHOWttlTests:~0,2%: Could not connect    (%testwebsite%)
CALL :TEST_CHANGETESTSITE
SET /A nots+=1
SET unreaches=0
SET founds=0
SET times=0
IF %nots% GEQ %fluke_test_eliminator% GOTO :TEST_FAILED
GOTO :TEST_TESTING


:TEST_UNREACHABLE
CALL :TEST_INC_TOTALTESTS
IF %unreaches%==0 CALL :TEST_SET_TIME1
IF %SHOW_ADVANCED_TESTING%==1 ECHO %SHOWttlTests:~0,2%: Location Unreachable (%testwebsite%)
CALL :TEST_CHANGETESTSITE
SET /A unreaches+=1
SET founds=0
SET nots=0
SET times=0
IF %nots% GEQ %fluke_test_eliminator% GOTO :TEST_UNREACHED
GOTO :TEST_TESTING


:TEST_TIMED_OUT
CALL :TEST_INC_TOTALTESTS
IF %times%==0 CALL :TEST_SET_TIME1
IF %SHOW_ADVANCED_TESTING%==1 ECHO %SHOWttlTests:~0,2%: Request Timed Out    (%testwebsite%)
CALL :TEST_CHANGETESTSITE
SET /A times+=1
SET unreaches=0
SET founds=0
SET nots=0
IF %TREAT_TIMEOUTS_AS_DISCONNECT%==1 IF %times% GEQ %fluke_test_eliminator% GOTO :TEST_FAILED
IF %TREAT_TIMEOUTS_AS_DISCONNECT%==0 IF %times% GEQ %fluke_test_eliminator% GOTO :TEST_NEED_BROWSER
IF %totalTests% GEQ %maxTestLimit% GOTO :TEST_EXCEEDED_TEST_LIMIT
GOTO :TEST_TESTING

REM ---------END-PING-RESULTS----------





REM ---------TEST-RESULTS-------------

:TEST_FAILED
REM DEBUGGING || FAILED A TEST
SET T2_DATE=%DATE%
IF NOT "%T1_DATE%"=="%T2_DATE%" GOTO :TEST_INTERNET
FOR /F "tokens=1-4* DELIMS=:." %%t IN ("%TIME%") DO SET T2_HR=%%t&SET T2_MIN=%%u&SET T2_SEC=%%v&SET T2_MIL=%%w
SET /A T2_TTLTIME=T2_MIL+(T2_SEC*100)+(T2_MIN*6000)+(T2_HR*360000)
SET /A T_TIMEPAST=T2_TTLTIME-T1_TTLTIME
IF %NumStalls%==1 SET TH=st
IF %NumStalls%==2 SET TH=nd
IF %NumStalls%==3 SET TH=rd
IF %NumStalls% GEQ 4 SET TH=th
IF %SHOW_ADVANCED_TESTING%==1 IF %T_TIMEPAST% LSS %T_MILI_SMALLEST% ECHO Test Too Fast Detected! Stalling...(%NumStalls%%TH% of Max:%MaxStalls%)
IF %T_TIMEPAST% LSS %T_MILI_SMALLEST% IF NOT %NumStalls% GEQ %MaxStalls% CALL :SLEEP&GOTO :TEST_INIT

SET /A main_tests=main_tests+1
IF %SLWMSG%==1 CALL :SLEEP
SET currently1=Internet Connection not detected
SET currently2=
SET TimerStatus=
CALL :STATS
SET isConnected=0
GOTO :EOF


:TEST_UNREACHED
IF %SLWMSG%==1 CALL :SLEEP
IF NOT %SLWMSG%==1 IF %SHOW_ADVANCED_TESTING%==1 CALL :SLEEP 1

SET currently1=Target sites are unreachable.
SET currently2=
SET TimerStatus=
CALL :STATS 3

SET isConnected=2
GOTO :EOF

:TEST_EXCEEDED_TEST_LIMIT
IF %SLWMSG%==1 CALL :SLEEP
IF NOT %SLWMSG%==1 IF %SHOW_ADVANCED_TESTING%==1 CALL :SLEEP 1

SET currently1=Unable to varify internet connectivity. This is a
SET currently2=poor quality connection. Internet browsing may be slow.
SET TimerStatus=
CALL :STATS 3

SET isConnected=1
GOTO :EOF

:TEST_NEED_BROWSER
IF %SLWMSG%==1 CALL :SLEEP
IF NOT %SLWMSG%==1 IF %SHOW_ADVANCED_TESTING%==1 CALL :SLEEP 1

SET currently1=Unable to varify internet connectivity. You may need
SET currently2=to long in via a browser for full network access.
SET TimerStatus=
CALL :STATS 3

SET isConnected=1
GOTO :EOF

:TEST_SUCCEEDED
IF %SLWMSG%==1 CALL :SLEEP
IF NOT %SLWMSG%==1 IF %SHOW_ADVANCED_TESTING%==1 CALL :SLEEP 1

SET isConnected=1
GOTO :EOF

REM ---------TEST-RESULTS-------------

REM ----------------END TEST INTERNET CONNECTION-----------------







:DISCONNECTION_DETECTED
IF %SETNFileDir%==TEMP GOTO :DISCONNECTION_DETECTED_NOLOG
SET MyDate=%date:~10,4%-%date:~4,2%-%date:~7,2%
SET MyDate=%MyDate: =0%
SET MyTime=%TIME: =0%
TYPE NUL>>"%SETNFileDir%log.csv"
IF "%USELOGGING%"=="1" IF NOT %ProgramMustFix%0==10 (ECHO %NETWORK% , Disconnected , %MyDate% , %MyTime%)>>"%SETNFileDir%log.csv"
:DISCONNECTION_DETECTED_NOLOG
SET ProgramMustFix=1
GOTO :EOF


:RECONNECTION_DETECTED
IF %SETNFileDir%==TEMP GOTO :RECONNECTION_DETECTED_NOLOG
SET MyDate=%date:~10,4%-%date:~4,2%-%date:~7,2%
SET MyDate=%MyDate: =0%
TYPE NUL>>"%SETNFileDir%log.csv"
IF "%USELOGGING%"=="1" (ECHO %NETWORK% , Reconnected , %MyDate% , %MyTime%)>>"%SETNFileDir%log.csv"
:RECONNECTION_DETECTED_NOLOG
SET ProgramMustFix=0
IF "%confixed%"=="" SET confixed=0
SET /A confixed+=1
GOTO :EOF



REM ------------------FIX INTERNET CONNECTION--------------------
REM BRANCH (SUCCESS || FAILED)
REM Call the different methods of fixing
REM This allows for different fixes to be added later

REM In order to add more fixes, NUMCONNFIXES and NUMNETFIXES must
REM be raised (if the fix pertains to them).


REM *****RESET NETWORK ADAPTER FAST*****
:CONNFIX1
:NETFIX1
IF "%USE_NETWORK_RESET_FAST%"=="1" CALL :FIX_RESET_NETWORK_FAST
GOTO :EOF


REM *****RESET IP ADDRESS*****
:CONNFIX2
:NETFIX2
IF "%USE_IP_RESET%"=="1" CALL :FIX_RESET_IP
GOTO :EOF


REM *****RESET NETWORK ADAPTER SLOW*****
:NETFIX3
IF "%USE_NETWORK_RESET%"=="1" CALL :FIX_RESET_NETWORK
GOTO :EOF


REM *****RESET ROUTE TABLE*****
:FIXUNREACHABLE
IF "%USE_RESET_ROUTE_TABLE%"=="1" ROUTE -F
GOTO :EOF


REM -----------------END FIX INTERNET CONNECTION------------------




:FIX_RESET_IP
REM -------------------FIX: RESET IP ADDRESS----------------------
REM Fix internet connection by reseting the IP address

SET currently1=Releasing IP Address
SET currently2=*May take a couple minutes*
SET TimerStatus=
CALL :STATS

REM Release IP Address
IPCONFIG /RELEASE >NUL 2>&1


REM Flush DNS Cache
SET currently1=Flushing DNS Cache
SET currently2=
SET TimerStatus=
CALL :STATS

IPCONFIG /FLUSHDNS >NUL 2>&1


REM Renew IP Address
SET currently1=Renewing IP Address
SET currently2=*May take a couple minutes*
SET TimerStatus=
CALL :STATS

IPCONFIG /RENEW >NUL 2>&1

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

SET currently1=Waiting to re-enable [%NETWORK%]
SET currently2=
SET TimerStatus=

REM Wait specified time
SET delaymins=%MINUTES%
CALL :WAIT

REM Enable network connection
CALL :ENABLE_NW


REM CANNOT TEST HERE
REM Checking network connection here causes unwanted recursion 

GOTO :EOF
REM -------------END FIX: RESET NETWORK CONNECTION----------------


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
SET TimerStatus=Time Left:  %hrs%%mins%%scnds% of %HOURS%%MINUTES2%%SECONDS%

REM Display updated TimeStamp
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

SET currently1=Disabling [%NETWORK%]...
SET currently2=
SET TimerStatus=
CALL :STATS

IF %ONLY_ONE_NETWORK_NAME_TEST%==0 CALL :TEST_NETWORK_NAME
IF %winVistaOrNewer%==1 NETSH INTERFACE SET INTERFACE "%NETWORK%" DISABLE
IF %winVistaOrNewer%==0 CALL :TOGGLECONNECTION_OLD_OS DIS

SET currently1=[%NETWORK%] Disabled
SET currently2=
SET TimerStatus=
CALL :STATS
GOTO :EOF
REM ---------------END DISABLE NETWORK CONNECTION-----------------


:ENABLE_NW
REM ------------------ENABLE NETWORK CONNECTION-------------------
REM Determine OS and enable via a compatible method

SET currently1=Enabling [%NETWORK%]
SET currently2=
SET TimerStatus=
CALL :STATS

REM TEST_NETWORK_NAME (EXIT || RETURN)
IF %ONLY_ONE_NETWORK_NAME_TEST%==0 CALL :TEST_NETWORK_NAME
IF %winVistaOrNewer%==1 NETSH INTERFACE SET INTERFACE "%NETWORK%" ENABLE
IF %winVistaOrNewer%==0 CALL :TOGGLECONNECTION_OLD_OS EN

SET currently1=[%NETWORK%] Enabled
SET currently2=
SET TimerStatus=
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
CALL :GET_Randomfilename %disOrEn%Network .vbs
@ECHO On
@ECHO Const ssfCONTROLS = 3 '>!%disOrEn%Network!
@ECHO sConnectionName = "%NETWORK%" '>>!%disOrEn%Network!
@ECHO sEnableVerb = "En&able" '>>!%disOrEn%Network!
@ECHO sDisableVerb = "Disa&ble" '>>!%disOrEn%Network!
@ECHO set shellApp = createobject("shell.application") '>>!%disOrEn%Network!
@ECHO set oControlPanel = shellApp.Namespace(ssfCONTROLS) '>>!%disOrEn%Network!
@ECHO set oNetConnections = nothing '>>!%disOrEn%Network!
@ECHO for each folderitem in oControlPanel.items '>>!%disOrEn%Network!
@ECHO   if folderitem.name = "Network Connections" then '>>!%disOrEn%Network!
@ECHO         set oNetConnections = folderitem.getfolder: exit for '>>!%disOrEn%Network!
@ECHO end if '>>!%disOrEn%Network!
@ECHO next '>>!%disOrEn%Network!
@ECHO if oNetConnections is nothing then '>>!%disOrEn%Network!
@ECHO msgbox "Couldn't find 'Network Connections' folder" '>>!%disOrEn%Network!
@ECHO wscript.quit '>>!%disOrEn%Network!
@ECHO end if '>>!%disOrEn%Network!
@ECHO set oLanConnection = nothing '>>!%disOrEn%Network!
@ECHO for each folderitem in oNetConnections.items '>>!%disOrEn%Network!
@ECHO if lcase(folderitem.name) = lcase(sConnectionName) then '>>!%disOrEn%Network!
@ECHO set oLanConnection = folderitem: exit for '>>!%disOrEn%Network!
@ECHO end if '>>!%disOrEn%Network!
@ECHO next '>>!%disOrEn%Network!
@ECHO Dim objFSO '>>!%disOrEn%Network!
@ECHO if oLanConnection is nothing then '>>!%disOrEn%Network!
@ECHO msgbox "Couldn't find %NETWORK%" '>>!%disOrEn%Network!
@ECHO msgbox "This program requires a valid Network Connection name to work properly" '>>!%disOrEn%Network!
@ECHO msgbox "Please close the script and open it with notepad for more information" '>>!%disOrEn%Network!
@ECHO Set objFSO = CreateObject("Scripting.FileSystemObject") '>>!%disOrEn%Network!
@ECHO objFSO.DeleteFile WScript.ScriptFullName '>>!%disOrEn%Network!
@ECHO Set objFSO = Nothing '>>!%disOrEn%Network!
@ECHO wscript.quit '>>!%disOrEn%Network!
@ECHO end if '>>!%disOrEn%Network!
@ECHO bEnabled = true '>>!%disOrEn%Network!
@ECHO set oEnableVerb = nothing '>>!%disOrEn%Network!
@ECHO set oDisableVerb = nothing '>>!%disOrEn%Network!
@ECHO s = "Verbs: " ^& vbcrlf '>>!%disOrEn%Network!
@ECHO for each verb in oLanConnection.verbs '>>!%disOrEn%Network!
@ECHO s = s ^& vbcrlf ^& verb.name '>>!%disOrEn%Network!
@ECHO if verb.name = sEnableVerb then '>>!%disOrEn%Network!
@ECHO set oEnableVerb = verb '>>!%disOrEn%Network!
@ECHO bEnabled = false '>>!%disOrEn%Network!
@ECHO end if '>>!%disOrEn%Network!
@ECHO if verb.name = sDisableVerb then '>>!%disOrEn%Network!
@ECHO set oDisableVerb = verb '>>!%disOrEn%Network!
@ECHO end if '>>!%disOrEn%Network!
@ECHO next '>>!%disOrEn%Network!
@ECHO if bEnabled = %trufalse% then '>>!%disOrEn%Network!
@ECHO o%disOrEn%Verb.DoIt '>>!%disOrEn%Network!
@ECHO end if '>>!%disOrEn%Network!
@ECHO wscript.sleep 2000 '>>!%disOrEn%Network!
@ECHO Set objFSO = CreateObject("Scripting.FileSystemObject") '>>!%disOrEn%Network!
@ECHO objFSO.DeleteFile WScript.ScriptFullName '>>!%disOrEn%Network!
@ECHO Set objFSO = Nothing '>>!%disOrEn%Network!
%NOECHO%@ECHO Off
CALL :STATS
START /B /WAIT CMD /C cscript //B //NoLogo !%disOrEn%Network!
CALL :SLEEP 2
IF EXIST "!%disOrEn%Network!" DEL /F /S /Q "!%disOrEn%Network!"
GOTO :EOF
REM --------------END DISABLE/ENABLE CONNECTION FOR WINXP----------------






REM ---------------------RESTART PROGRAM--------------------------
:RESTART_PROGRAM
REM Self restart
SET currently1=Restarting Script...
SET currently2=
SET TimerStatus=
CALL :STATS 3
SET restartingProgram=1
START CMD /C "%THISFILENAMEPATH%"%STARTPARAMS%
EXIT
REM -----------------END RESTART PROGRAM--------------------------






REM --------------------------------------------------------------
REM --------------------------------------------------------------
REM --------------------------RESULTS-----------------------------
REM --------------------------------------------------------------
REM --------------------------------------------------------------



:SYSTEM_UNSUPPORTED
REM --------------UNSUPPORTED OPERATING SYSTEM--------------------
REM EXIT
SET currently1=This Operating System is not currently supported.
SET currently2=
SET TimerStatus=
CALL :STATS
ECHO Press any key to EXIT...
PAUSE>NUL
EXIT
REM ------------END UNSUPPORTED OPERATING SYSTEM------------------


:CHECK_CONNECTION_ONLY
REM ---------CHECK INTERNET CONNECION ONLY (NO FIXES)-------------
REM SAFE BRANCH (GOTO ( CHECK_CONNECTION_ONLY || EXIT ) )
SET currently1=Set to check connection only
SET currently2= (will not fix connection if not connected)
SET TimerStatus=
CALL :STATS
CALL :TEST_INTERNET isConnected
IF %isConnected%==1 GOTO :CHECK_CONNECTION_ONLY_SUCCESS
GOTO :CHECK_CONNECTION_ONLY_FAIL

:CHECK_CONNECTION_ONLY_SUCCESS
SET currently1=Currently Connected to the Internet.
IF %CONTINUOUS%==1 GOTO :CHECK_CONNECTION_ONLY_SUCCESS_CONTINUOUS
IF %AUTOUPDATE%==1 CALL :SelfUpdate
SET currently2=
SET TimerStatus=
CALL :STATS
ECHO.
ECHO Press any key to return to main menu...
PAUSE>NUL
GOTO :TOP


:CHECK_CONNECTION_ONLY_SUCCESS_CONTINUOUS
SET STARTUPPARAMS= STARTUP
SET /A TestsSinceUpdate+=1
IF %TestsSinceUpdate% GTR %CHECKUPDATEFREQ% SET TestsSinceUpdate=0
IF %AUTOUPDATE%==1 IF %CONTINUOUS%==1 IF %TestsSinceUpdate%==0 CALL :SelfUpdate
SET currently1=Waiting to re-check Internet Connection...
SET currently2=Last check: Connected
CALL :STATS
SET /A delaymins=CHECK_DELAY
CALL :WAIT
GOTO :CHECK_CONNECTION_ONLY



:CHECK_CONNECTION_ONLY_FAIL
SET /A TestsSinceUpdate+=1
IF %CONTINUOUS%==1 GOTO :CHECK_CONNECTION_ONLY_FAIL_CONTINUOUS
SET currently1=NOT Connected to the Internet.
SET currently2=No fixes are set to be used.
SET TimerStatus=
CALL :STATS
ECHO.
ECHO Press any key to return to main menu...
PAUSE>NUL
GOTO :TOP

:CHECK_CONNECTION_ONLY_FAIL_CONTINUOUS
SET currently1=Waiting to re-check Internet Connection...
SET currently2=Last check: Not Connected
SET TimerStatus=
CALL :STATS
SET /A delaymins=CHECK_DELAY
CALL :WAIT
GOTO :CHECK_CONNECTION_ONLY

REM -------END CHECK INTERNET CONNECION ONLY (NO FIXES)-----------


:FAILED
REM -------------------FIX ATTEMPT FAILED-------------------------
REM BRANCH (FAILED_CONTINUOUS || FIX || EXIT)
SET CONNFIX=0
SET NETFIX=0
SET ROUTEFIX=0
SET /A TestsSinceUpdate+=1
IF %CONTINUOUS%==1 GOTO :FAILED_CONTINUOUS
SET currently1=Unable to Connect to Internet.
SET currently2=
SET TimerStatus=
CALL :STATS 3
IF %AUTO_RETRY%==1 GOTO :MAIN_START
ECHO What would you like to do?
ECHO.
ECHO Retry                 [1]      
ECHO Return to Main Menu   [2]
ECHO Exit                  [3]
ECHO.
SET /P usrInpt=[1/2/3] 
IF "%usrInpt%"=="" GOTO :MAIN_START
IF "%usrInpt%"=="1" GOTO :MAIN_START
IF "%usrInpt%"=="2" GOTO :TOP
IF "%usrInpt%"=="3" EXIT
GOTO :FAILED

REM -----------------END FIX ATTEMPT FAILED-----------------------


:FAILED_CONTINUOUS
REM ----------------FIX ATTEMPT FAILED (RETRY)--------------------
REM GOTO FIX
SET currently1=Unable to Connect to Internet (Retrying...)
SET currently2=
SET TimerStatus= 
CALL :STATS 3
GOTO :MAIN_START
REM --------------END FIX ATTEMPT FAILED (RETRY)------------------


:SUCCESS
REM ------------------FIX ATTEMPT SUCCEEDED-----------------------
REM BRANCH (SUCCESS_CONTINUOUS || EXIT)

REM Declare that connection has been fixed
ECHO ProgramMustFix: %ProgramMustFix%
IF %ProgramMustFix%==1 CALL :RECONNECTION_DETECTED
SET CONNFIX=0
SET NETFIX=0
SET ROUTEFIX=0

SET currently1=Successfully Connected to Internet.

IF %CONTINUOUS%==1 GOTO :SUCCESS_CONTINUOUS
IF %AUTOUPDATE%==1 CALL :SelfUpdate
SET currently2=
SET TimerStatus=
CALL :STATS
ECHO.
ECHO If you still cannot access the internet, you may need
ECHO to log into the network via Cisco or a similar program.
ECHO.
ECHO Press any key to return to main menu...
PAUSE>NUL
GOTO :TOP
REM ----------------END FIX ATTEMPT SUCCEEDED---------------------


:SUCCESS_CONTINUOUS
REM -------------FIX ATTEMPT SUCCEEDED (RECHECK)------------------
REM BRANCH (SUCCESS || FIX)
SET STARTUPPARAMS= STARTUP
SET /A TestsSinceUpdate+=1
IF %TestsSinceUpdate% GTR %CHECKUPDATEFREQ% SET TestsSinceUpdate=0
IF %AUTOUPDATE%==1 IF %CONTINUOUS%==1 IF %TestsSinceUpdate%==0 CALL :SelfUpdate
IF %AUTOUPDATE%==1 IF %CONTINUOUS%==0 CALL :SelfUpdate
SET currently1=Waiting to re-check Internet Connection...
SET currently2=
SET TimerStatus=
SET /A delaymins=CHECK_DELAY
CALL :WAIT
GOTO :MAIN_START
REM -----------END FIX ATTEMPT SUCCEEDED (RECHECK)----------------





REM --------------------------------------------------------------
REM --------------------------------------------------------------
REM ------------------------AUTO-UPDATE---------------------------
REM --------------------------------------------------------------
REM --------------------------------------------------------------



:SelfUpdate

REM UPDATECHANNEL: 1=stable 2=beta 3=dev
%NoECHO%IF "%UPDATECHANNEL%"=="1" SET SU_GUI_UPDATECHANNEL=Stable
%NoECHO%IF "%UPDATECHANNEL%"=="2" SET SU_GUI_UPDATECHANNEL=Beta
%NoECHO%IF "%UPDATECHANNEL%"=="3" SET SU_GUI_UPDATECHANNEL=Dev
%NoECHO%IF NOT "%currently1%"=="" SET currently2=-
%NoECHO%SET currently3=Self Update [%SU_GUI_UPDATECHANNEL%]
%NoECHO%SET currently4=Initializing...
%NoECHO%CALL :STATS
CALL :SelfUpdate_GETRemoteServer
SET rvsnchk=%rvsn:.=%
SET rvsnchk=%rvsnchk:_=%
SET rvsnchk=%rvsnchk:r=%
SET rvsnchk=%rvsnchk:v=%
SET rvsnchk=%rvsnchk:b=%
SET lastUPDATECHANNEL=%rvsn:~0,1%
IF %lastUPDATECHANNEL%==v SET lastUPDATECHANNEL=1
IF %lastUPDATECHANNEL%==b SET lastUPDATECHANNEL=2
IF %lastUPDATECHANNEL%==r SET lastUPDATECHANNEL=3
IF "%UPDATECHANNEL%"=="3" GOTO :SelfUpdate_dev


REM Get versions

%NoECHO%SET currently4=Retrieving local and remote versions...
%NoECHO%CALL :STATS

SET webdowntimeout=30
IF NOT %lastUPDATECHANNEL%==%UPDATECHANNEL% GOTO :SU_ForceUpdate

SET NeedUpdate=0
SET remotevsn=
SET DLFilePath=%remoteserver%cur
CALL :GET_Randomfilename remotecur .bat
SET DLFileName=%remotecur%
CALL :SelfUpdate_DLFile
SET SU_ERR=101
CALL :SU_VerifyCur %THISFILEDIR%%DLFileName%
IF %SU_Cur_Valid%==0 GOTO :SelfUpdate_Error
CALL "%THISFILEDIR%%DLFileName%"
IF NOT "!BR_%branchurl%!"=="integrated" IF NOT "%Branch%"=="" GOTO :SelfUpdate_dev
IF "%UPDATECHANNEL%"=="1" SET remotevsn=%stablevsn%
IF "%UPDATECHANNEL%"=="2" SET remotevsn=%betavsn%
SET SU_ERR=102
IF "%remotevsn%"=="" GOTO :SelfUpdate_Error

REM Compare versions


%NoECHO%SET currently4=Comparing versions...
%NoECHO%CALL :STATS

SET remotevsn=%remotevsn:.=%
SET remotevsn=%remotevsn:_=%
IF NOT %rvsnchk% LSS %remotevsn% GOTO :SelfUpdate_AlreadyUp2date


REM Download new version
:SU_ForceUpdate


%NoECHO%SET currently4=Downloading latest %SU_GUI_UPDATECHANNEL% version
%NoECHO%CALL :STATS

IF "%UPDATECHANNEL%"=="1" SET DLFilePath=%remoteserver%Network_Resetter_Stable
IF "%UPDATECHANNEL%"=="2" SET DLFilePath=%remoteserver%Network_Resetter_Beta
REM IF "%UPDATECHANNEL%"=="1" SET DLFilePath=%stablefile%
REM IF "%UPDATECHANNEL%"=="2" SET DLFilePath=%betafile%
CALL :GET_Randomfilename updaterDLfile .txt
SET DLFileName=%updaterDLfile%
CALL :SelfUpdate_DLFile

REM Verify file contents


%NoECHO%SET currently4=Verifying downloaded file...
%NoECHO%CALL :STATS

SET SU_ERR=103
CALL :SelfUpdate_VerifyFileContents "%THISFILEDIR%%DLFileName%"
IF NOT EXIST "%THISFILEDIR%%DLFileName%" GOTO :SelfUpdate_Error



%NoECHO%SET currently4=Updating script...
%NoECHO%CALL :STATS

CALL :GET_Randomfilename updaterfile .bat

@ECHO ON
@ECHO DEL "%THISFILENAMEPATH%" >%updaterfile%
@ECHO REN "%THISFILEDIR%%DLFileName%" "%THISFILENAME%" >>%updaterfile%
@ECHO START CMD /C "%THISFILEDIR%%THISFILENAME%%STARTUPPARAMS%" >>%updaterfile%
@ECHO DEL /F/S/Q "%%~dpnx0" >>%updaterfile%
%NoECHO%@ECHO OFF
CALL "%THISFILEDIR%%updaterfile%"&EXIT



:SelfUpdate_DLFile
IF "%DLFilePath%"=="" GOTO :EOF
CALL :GET_Randomfilename webdown .vbs
@ECHO On
@ECHO 'Download Update  '>%webdown%
@ECHO Dim xPost '>>%webdown%
@ECHO Set xPost = CreateObject("WinHttp.WinHttpRequest.5.1") '>>%webdown%
@ECHO xpost.open "HEAD", "%DLFilePath%", False '>>%webdown%
@ECHO xpost.send '>>%webdown%
@ECHO Select Case Cint(xpost.status) '>>%webdown%
@ECHO    Case 200, 202, 302 '>>%webdown%
@ECHO      Set xpost = Nothing '>>%webdown%
@ECHO      CheckPath = True '>>%webdown%
@ECHO    Case Else '>>%webdown%
@ECHO    Set xpost = Nothing '>>%webdown%
@ECHO      CheckPath = False '>>%webdown%
@ECHO End Select '>>%webdown%
@ECHO If (CheckPath) Then '>>%webdown%
@ECHO Dim xPost2 '>>%webdown%
@ECHO Set xPost2 = CreateObject("WinHttp.WinHttpRequest.5.1") '>>%webdown%
@ECHO xPost2.Open "GET","%DLFilePath%",0 '>>%webdown%
@ECHO xPost2.Send() '>>%webdown%
@ECHO Set sGet = CreateObject("ADODB.Stream") '>>%webdown%
@ECHO sGet.Mode = 3 '>>%webdown%
@ECHO sGet.Type = 1 '>>%webdown%
@ECHO sGet.Open() '>>%webdown%
@ECHO sGet.Write(xPost2.responseBody) '>>%webdown%
@ECHO sGet.SaveToFile "%DLFileName%",2 '>>%webdown%
@ECHO Set xPost2 = Nothing '>>%webdown%
@ECHO END IF '>>%webdown%
@ECHO Set xPost = Nothing '>>%webdown%
@ECHO Dim objFSO '>>%webdown%
@ECHO Set objFSO = CreateObject("Scripting.FileSystemObject") '>>%webdown%
@ECHO objFSO.DeleteFile WScript.ScriptFullName '>>%webdown%
@ECHO Set objFSO = Nothing '>>%webdown%
%NoECHO%@ECHO off
START /B /WAIT CMD /C cscript //B //T:%webdowntimeout% //NoLogo %webdown%
CALL :SLEEP 1
IF EXIST "%webdown%" DEL /F /S /Q "%webdown%"
GOTO :EOF



:SelfUpdate_dev


%NoECHO%SET currently4=Initializing...
%NoECHO%CALL :STATS

SET SU_Cur_Valid=1

REM Check SVN installed:
SET SU_ERR=201
svn -?>NUL 2>&1
IF ERRORLEVEL 1 GOTO :SelfUpdate_Error
REM Valid working copy
svn info>NUL 2>&1
IF ERRORLEVEL 1 GOTO :SU_UpdateByCheckout



%NoECHO%SET currently4=Retrieving local and remote versions...
%NoECHO%CALL :STATS

IF NOT %lastUPDATECHANNEL%==%UPDATECHANNEL% GOTO :SU_ForceUpdate_dev

SET SU_HasSVNUpdate=0
FOR /F "tokens=* DELIMS=" %%u IN ('svn status --trust-server-cert --non-interactive --verbose --show-updates') DO ^
ECHO %%u |FIND "*">NUL&IF NOT ERRORLEVEL 1 SET SU_HasSVNUpdate=1

IF %SU_HasSVNUpdate% EQU 0 GOTO :SelfUpdate_AlreadyUp2Date


:SU_ForceUpdate_dev

%NoECHO%SET currently4=Updating script...
%NoECHO%CALL :STATS

CALL :GET_Randomfilename updaterfile .bat
@ECHO ON
@ECHO svn update --trust-server-cert --non-interactive >%updaterfile%
@ECHO START CMD /C "%THISFILEDIR%%THISFILENAME%%STARTUPPARAMS%" >>%updaterfile%
@ECHO DEL /F/S/Q "%%~dpnx0" >>%updaterfile%
%NoECHO%@ECHO OFF
START CMD /C "%THISFILEDIR%%updaterfile%"&EXIT

:SU_UpdateByCheckout


%NoECHO%SET currently4=Retrieving local and remote versions...
%NoECHO%CALL :STATS

IF NOT %lastUPDATECHANNEL%==%UPDATECHANNEL% GOTO :SU_ForceUpdate_UBC

IF NOT "%branch%"=="" SET webdowntimeout=15
IF NOT "%branch%"=="" SET DLFilePath=%remoteserver%cur
IF NOT "%branch%"=="" CALL :GET_Randomfilename remotecur .bat
IF NOT "%branch%"=="" SET DLFileName=%remotecur%
IF NOT "%branch%"=="" CALL :SelfUpdate_DLFile
SET SU_ERR=301
IF NOT "%branch%"=="" CALL :SU_VerifyCur %THISFILEDIR%%DLFileName%
IF NOT "%branch%"=="" IF %SU_Cur_Valid%==0 GOTO :SelfUpdate_Error
IF NOT "%branch%"=="" CALL "%THISFILEDIR%%DLFileName%"
IF "!BR_%branchurl%!"=="integrated" SET branchurl=


SET SU_ERR=302
SET remoteRepo=http://nwconnectionresetter.googlecode.com/svn/trunk/
IF NOT "%branchurl%"=="" SET remoteRepo=http://nwconnectionresetter.googlecode.com/svn/branches/%branchurl%/
FOR /F "tokens=* DELIMS=" %%u IN ('svn info --trust-server-cert --non-interactive %remoteRepo%Network_Resetter.bat') DO ^
ECHO %%u |FIND "Last Changed Rev">NUL&IF NOT ERRORLEVEL 1 SET SU_InLine=%%u
FOR /F "tokens=4 DELIMS= " %%u IN ("%SU_InLine%") DO SET remotevsn=%%u
IF "%remotevsn%"=="" GOTO :SelfUpdate_Error


%NoECHO%SET currently4=Comparing versions...
%NoECHO%CALL :STATS

SET remotevsn=%remotevsn:.=%
SET remotevsn=%remotevsn:_=%
IF %rvsnchk% GEQ %remotevsn% GOTO :SelfUpdate_AlreadyUp2Date

:SU_ForceUpdate_UBC


%NoECHO%SET currently4=Checking out latest version...
%NoECHO%CALL :STATS

CALL :GET_Randomfoldername checkoutfolder
CALL :GET_Randomfilename NR_Update .bat

SET SU_ERR=303
IF "%Branch%"=="" svn checkout --trust-server-cert --non-interactive http://nwconnectionresetter.googlecode.com/svn/trunk "%THISFILEDIR%%checkoutfolder%">NUL 2>&1
IF NOT "%Branch%"=="" svn checkout --trust-server-cert --non-interactive http://nwconnectionresetter.googlecode.com/svn/branches/%branchurl% "%THISFILEDIR%%checkoutfolder%">NUL 2>&1
IF NOT EXIST "%THISFILEDIR%%checkoutfolder%\Network_Resetter.bat" GOTO :SelfUpdate_Error
SET SU_ERR=304
MOVE /Y "%THISFILEDIR%%checkoutfolder%\Network_Resetter.bat" "%THISFILEDIR%%NR_Update%">NUL 2>&1
IF ERRORLEVEL 1 GOTO :SelfUpdate_Error
SET SU_UBC_DelfolAttempts=0
:SU_UBC_RetryDelFol
SET /A SU_UBC_DelfolAttempts+=1
RD /S/Q "%THISFILEDIR%%checkoutfolder%"
IF EXIST "%THISFILEDIR%%checkoutfolder%/"NUL IF NOT %SU_UBC_DelfolAttempts% GTR 5 GOTO :SU_UBC_RetryDelFol

CALL :GET_Randomfilename updaterfile .bat
@ECHO ON
@ECHO MOVE /Y "%THISFILEDIR%%NR_Update%" "%THISFILENAMEPATH%" >"%THISFILEDIR%%updaterfile%"
@ECHO START CMD /C "%THISFILENAMEPATH%" >>"%THISFILEDIR%%updaterfile%"
@ECHO DEL /F/S/Q "%%~dpnx0" >>"%THISFILEDIR%%updaterfile%"
%NoECHO%@ECHO OFF
SET SU_ERR=305
START CMD /C "%THISFILEDIR%%updaterfile%"&EXIT


:SelfUpdate_GETRemoteServer
REM Main or backup or disconnect
SET remoteserver=http://electrodexs.net/ncr/
GOTO :EOF


:SelfUpdate_VerifyFileContents
SET vdl_fileloc=%*
SET vdl_filevalid=0
SET vdl_attempts=0
:SelfUpdate_VerifyFileContents_retry
SET vdl_attempts+=1
CALL :SelfUpdate_VerifyFileContents_check %vdl_fileloc%
IF %vdl_filevalid%==0 IF %vdl_attempts% GTR 5 DEL /F/S/Q %vdl_fileloc%
GOTO :EOF

:SelfUpdate_VerifyFileContents_check
SET vdl_filesize=%~z1
IF 0%verificationsize% LSS 0%vdl_filesize% SET vdl_filevalid=1
IF %vdl_filevalid%==0 CALL :SLEEP 1
GOTO :EOF


:SU_VerifyCur
SET SU_Cur_Valid=1
IF NOT EXIST "%*" SET SU_Cur_Valid=0&GOTO :EOF
SET SU_Cur_numlines=0
FOR /F "usebackq tokens=* DELIMS=" %%c IN ("%*") DO SET /A SU_Cur_numlines+=1
IF %SU_Cur_numlines% LEQ 3 SET SU_Cur_Valid=0&DEL /F /S /Q "%*"
GOTO :EOF


:SelfUpdate_AlreadyUp2date
REM Already up to date


%NoECHO%SET currently4=Script is already up to date
%NoECHO%CALL :STATS 3
CALL :RESETCURRENTLY
GOTO :EOF


:SelfUpdate_Error
::%NoECHO%MODE CON LINES=120
REM Could not self-update [ERR:%SU_ERR%]
%NoECHO%ECHO Self-Update has encountered a critical error and cannot continue
%NoECHO%ECHO.
%NoECHO%IF %SU_ERR%==101 ECHO ERR:%SU_ERR% Could not retrieve remote versions file^
%NoECHO%				 &CALL :SU_ERRSOL_READWRITE^
%NoECHO%				 &CALL :SU_ERRSOL_NET

%NoECHO%IF %SU_ERR%==102 ECHO ERR:%SU_ERR% Remote versions file is invalid^
%NoECHO%				&CALL :SU_ERRSOL_TIMEOUT^
%NoECHO%				&CALL :SU_ERRSOL_CHANGEDFORMAT

%NoECHO%IF %SU_ERR%==103 ECHO ERR:%SU_ERR% Could not download updated script^
%NoECHO%				&CALL :SU_ERRSOL_TIMEOUT^
%NoECHO%				&CALL :SU_ERRSOL_NET

%NoECHO%IF %SU_ERR%==201 ECHO ERR:%SU_ERR% SVN command line not installed properly^
%NoECHO%				&CALL :SU_ERRSOL_SVN

%NoECHO%IF %SU_ERR%==301 ECHO ERR:%SU_ERR% Could not retrieve remote versions file^
%NoECHO%				 &CALL :SU_ERRSOL_READWRITE^
%NoECHO%				 &CALL :SU_ERRSOL_NET

%NoECHO%IF %SU_ERR%==302 ECHO ERR:%SU_ERR% Could not retrieve svn remote versions^
%NoECHO%				&CALL :SU_ERRSOL_CHANGEDFORMAT^
%NoECHO%				 &CALL :SU_ERRSOL_NET

%NoECHO%IF %SU_ERR%==303 ECHO ERR:%SU_ERR% Could not checkout updated script to new folder^
%NoECHO%				 &CALL :SU_ERRSOL_READWRITE^
%NoECHO%				 &CALL :SU_ERRSOL_NET

%NoECHO%IF %SU_ERR%==304 ECHO ERR:%SU_ERR% Could not move/rename temporary update file^
%NoECHO%				 &CALL :SU_ERRSOL_READWRITE

%NoECHO%IF %SU_ERR%==305 ECHO ERR:%SU_ERR% Could not start temporary script file
%NoECHO%ECHO.
IF %CONTINUOUS%==0 PAUSE
IF %CONTINUOUS%==1 ECHO Script will continue in some seconds
IF %CONTINUOUS%==1 CALL :SLEEP 5
CALL :RESETCURRENTLY
GOTO :EOF

:SU_ERRSOL_READWRITE
ECHO ^>Please make sure you have read/write access to the
ECHO  location this script is in.
ECHO.
GOTO :EOF

:SU_ERRSOL_NET
ECHO ^>Please make sure you are connected to the internet.
ECHO ^>You may need to manually update this script if your 
ECHO  connection quality is poor
ECHO.
GOTO :EOF

:SU_ERRSOL_TIMEOUT
ECHO ^>With slower connections please configure the Self-Update
ECHO  to use a longer timeout.
ECHO.
GOTO :EOF

:SU_ERRSOL_CHANGEDFORMAT
ECHO ^>You may need to manually update this script if the
ECHO  update method has changed.
ECHO.
GOTO :EOF

:SU_ERRSOL_SVN
CALL :RESETCURRENTLY
CALL :HEADER
ECHO ^>This channel requires that you have SVN tools installed
ECHO  You may need to install/reinstall SVN and make sure the
ECHO command line tools are also installed.
ECHO.
IF "%CONTINUOUS%"=="1" GOTO :EOF
ECHO Would you like to change the update channel you are on?
ECHO Change to Stable        [1]
ECHO Change to BETA          [2] [Recommended]
ECHO Stay  on  DEV           [3]
SET /P usrInput=[1/2/3] 
IF "%usrInput%"=="" SET usrInput=2
IF "%usrInput%"=="1" SET UPDATECHANNEL=1&CALL :SETTINGS_EXPORTONLY&CALL :RESETCURRETLY&GOTO :SelfUpdate
IF "%usrInput%"=="2" SET UPDATECHANNEL=2&CALL :SETTINGS_EXPORTONLY&CALL :RESETCURRETLY&GOTO :SelfUpdate
IF "%usrInput%"=="3" GOTO :EOF
GOTO :SU_ERRSOL_SVN



REM --------------------------------------------------------------
REM --------------------------------------------------------------
REM ----------------------SETTING-CHECKS--------------------------
REM --------------------------------------------------------------
REM --------------------------------------------------------------


:DETECT_ADMIN_RIGHTS
SET ADMIN_NOECHO=
IF "%1"=="silent" SET ADMIN_NOECHO=::
REM ----------------------DETECT ADMIN RIGHTS---------------------
%ADMIN_NOECHO%SET currently1=Checking if script has administrative privileges...
%ADMIN_NOECHO%SET currently2=
%ADMIN_NOECHO%SET TimerStatus=
%ADMIN_NOECHO%IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
SET ISADMIN=0
AT > NUL
IF NOT ERRORLEVEL 1 SET ISADMIN=1
GOTO :EOF
REM --------------------END DETECT ADMIN RIGHTS-------------------


:CHECK_NEED_ADMIN
IF %ISADMIN%==1 GOTO :EOF
IF %USE_NETWORK_RESET%==0 IF %USE_NETWORK_RESET_FAST%==0 GOTO :EOF
CALL :HEADER
ECHO Warning! This script was not run with administrative privileges!
IF %ISADMIN%==0 IF "%OMIT_USER_INPUT%"=="1" ECHO Functions that require admin rights will be disabled&CALL :SLEEP 5&GOTO :EOF
REM Functions that require admin rights:
REM -WinXP: Temporary VBS file cannot enable or disable the adapter on limited account
REM -WinXP: NETSH INTERFACE SHOW INTERFACE
REM -Win7:  NETSH INTERFACE SET INTERFACE "[Network Connection Name]" [ENABLE/DISABLE]

REM Settings that enable/disable these functions:
REM -USE_NETWORK_RESET
REM -USE_NETWORK_RESET_FAST

ECHO.
ECHO You currently have function(s) enabled that require Administrative privileges:
IF %USE_NETWORK_RESET%==1 ECHO -USE_NETWORK_RESET
IF %USE_NETWORK_RESET_FAST%==1 ECHO -USE_NETWORK_RESET_FAST
ECHO.
ECHO What would you like to do?
ECHO.
								ECHO Temporarily disable these functions and continue    [T]
IF NOT "%SETNFileDir%"=="TEMP"	ECHO Change these settings and continue                  [C]
								ECHO Don't do anything and close this script             [X]
SET usrInput=
IF NOT "%SETNFileDir%"=="TEMP" SET /P usrInput=[T/C/X] 
IF "%SETNFileDir%"=="TEMP" SET /P usrInput=[T/X] 
IF /I "%usrInput%"=="t" GOTO :CHANGEADMINSETS
IF /I "%usrInput%"=="c" GOTO :CHANGEADMINSETS
IF /I "%usrInput%"=="x" EXIT
GOTO :CHECK_NEED_ADMIN

:CHANGEADMINSETS
SET USE_NETWORK_RESET=0
SET USE_NETWORK_RESET_FAST=0
IF /I %usrInput%==t SET SETNFileDir=TEMP
IF /I %usrInput%==c CALL :SETTINGS_EXPORT
GOTO :EOF




:DETECT_OS
REM -------------------DETECT OPERATING SYSTEM--------------------
REM SAFE BRANCH (EXIT || RETURN)
REM RETURN (winVistaOrNewer (1 || 0) )
REM Detect OS and return compatibility

SET currently1=Checking if Operating System is supported...
SET currently2=
SET TimerStatus=
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS

REM Get OS name
FOR /F "tokens=3*" %%i IN ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName ^| Find "ProductName"') DO set vers=%%i %%j
IF "%vers%"=="" GOTO :UNSUPPORTED
ECHO %vers% | FIND "Windows XP" > NUL
IF %ERRORLEVEL% == 0 GOTO :OLDVER
ECHO %vers% | FIND "Windows Server 2003" > NUL
IF %ERRORLEVEL% == 0 GOTO :OLDVER
ECHO %vers% | find "Windows 7" > NUL
IF %ERRORLEVEL% == 0 GOTO :NewVer
ECHO %vers% | find "Windows Server 2008" > NUL
IF %ERRORLEVEL% == 0 GOTO :NewVer
ECHO %vers% | find "Windows Vista" > NUL
IF %ERRORLEVEL% == 0 GOTO :NewVer


:UNSUPPORTED
REM INTERNAL BRANCH (RUN_ON_SUPPORTED || SYSTEM_UNSUPPORTED)
SET currently1=Operating System is unsupported
SET currently2=
SET TimerStatus=
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
SET currently1=Operating System is supported
SET currently2=(WindowsXP)
SET TimerStatus=
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
SET winVistaOrNewer=0
GOTO :EOF

:NewVer
REM RETURN winVistaOrNewer (1)
SET currently1=Operating System is supported
SET currently2= (%vers%)
SET TimerStatus=
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
SET winVistaOrNewer=1
GOTO :EOF


:RUN_ON_UNSUPPORTED
REM INTERNAL BRANCH (CONTINUE_RUN_ANYWAY || SYSTEM_UNSUPPORTED)
SET currently1=Attempting to run on UNSUPPORTED Operating System...
SET currently2=
SET TimerStatus=
CALL :STATS
IF %OMIT_USER_INPUT%==1 GOTO :CONTINUE_RUN_ANYWAY
ECHO.
ECHO.
ECHO This may cuase unexpected behavior in this script.
ECHO Are you sure you want to do this?
SET /P usrInpt=[y/n] 
IF "%usrInpt%"=="y" GOTO :CONTINUE_RUN_ANYWAY
IF "%usrInpt%"=="n" GOTO :SYSTEM_UNSUPPORTED
GOTO :RUN_ON_UNSUPPORTED

:CONTINUE_RUN_ANYWAY
REM RETURN winVistaOrNewer (0)
SET currently1=Continuing to run script. OS is treated
SET currently2=as though it were WindowsXP
SET TimerStatus=
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
SET winVistaOrNewer=0
GOTO :EOF
REM -----------------END DETECT OPERATING SYSTEM------------------



:CHECK_START_AT_LOGON
REM --------------------CHECK START AT LOG ON---------------------
REM Copies self to Startup Folder if START_AT_LOGON==1
REM Else Deletes "NetworkResetterByLectrode.bat" in 
REM Startup Folder

SET currently1=Checking if set to start at user log on...
SET currently2=
SET TimerStatus=
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF %START_AT_LOGON%==0 GOTO :DONT_STARTUP
IF "%SETNFileDir%"=="TEMP" GOTO :EOF
IF "%SETNFileDir%"=="%THISFILEDIR%" GOTO :EOF

SET currently1=Script is set to start at user log on.
SET currently2=Creating Launcher in Startup Folder...
SET TimerStatus=
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
IF "%START_MINIMIZED%"=="1" SET CSAL_MIN= /MIN
SET StartupFile=%USERPROFILE%\Start Menu\Programs\Startup\NetworkResetterByLectrode.bat
ECHO @IF NOT EXIST "%THISFILENAMEPATH%" @DEL /F /S /Q "%%~dpnx0"^&EXIT >"%StartupFile%"
ECHO @START%CSAL_MIN% "" /D "%THISFILEDIR%" "%THISFILENAMEPATH%" STARTUP  >>"%StartupFile%"

GOTO :EOF

:DONT_STARTUP
SET currently1=Script is not set to start at user log on.
SET currently2=Removing Launcher in Startup folder, if any...
SET TimerStatus=
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
TYPE NUL > "%USERPROFILE%\Start Menu\Programs\Startup\NetworkResetterByLectrode.bat"
DEL /F /Q "%USERPROFILE%\Start Menu\Programs\Startup\NetworkResetterByLectrode.bat" >NUL 2>&1

GOTO :EOF
REM ------------------END CHECK START AT LOG ON-------------------


:TEST_NETWORK_NAME
REM ----------------------TEST NETWORK NAME-----------------------
REM SAFE BRANCH (EXIT || RETURN)
IF NOT "%~1"=="1" IF %has_tested_ntwk_name_recent% GEQ 1 GOTO :EOF
SET /A has_tested_ntwk_name_recent+=1

SET currently1=Checking if [%NETWORK%]
SET currently2=is a valid network connection name...
SET TimerStatus=
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS
CALL :TESTNetworkName %NETWORK%
IF "%NETWORK_IsValid%"=="0" GOTO :SETTINGS_SETNETWORK
GOTO :EOF

:TESTNetworkName
SET TESTNETWORK=%*
SET NETWORK_IsValid=1
SET NETWORK_IsMBN=0
NETSH INTERFACE SHOW INTERFACE|FIND "%TESTNETWORK%">NUL 2>&1
IF NOT ERRORLEVEL 1 GOTO :EOF
NETSH MBN SHOW INTERFACES|FIND "%TESTNETWORK%">NUL 2>&1
IF NOT ERRORLEVEL 1 SET NETWORK_IsMBN=1&GOTO :EOF
SET NETWORK_IsValid=0
GOTO :EOF
REM --------------------END TEST NETWORK NAME---------------------



:TESTIntVAR
REM ----------------------TEST INTEGAR VALUE----------------------
REM %1=varname
REM %2=min value
REM %3=max value
SET varname=%1
IF %2==%3 SET IntNoLimit=1
IF NOT %2==%3 SET IntNoLimit=0
SET currently1=Checking if %varname% has a valid 
SET currently2=value (Integar between %2 and %3)...
IF IntNoLimit==1 SET currently2=value (an Integar)...
SET TimerStatus=
IF NOT "%SHOW_ALL_ALERTS%"=="0" CALL :STATS

IF "0"=="!%varname%!" GOTO :TESTIntVAR_ISNUM

SET /a num=!%varname%!
IF NOT "%num%"=="0" GOTO :TESTIntVAR_ISNUM

GOTO :TESTIntVAR_NOTVALID

:TESTIntVAR_ISNUM
IF %IntNoLimit%==1 SET %varname%=%num%
IF %IntNoLimit%==1 GOTO :EOF
IF %num% GEQ %2 IF %num% LEQ %3 SET %varname%=%num%
IF %num% GEQ %2 IF %num% LEQ %3 GOTO :EOF


:TESTIntVAR_NOTVALID
SET currently1=%varname% does not have a valid value.
SET currently2=Setting %varname% to !%varname%_D!...
SET TimerStatus=
CALL :STATS
SET %varname%=!%varname%_D!
GOTO :EOF
REM --------------------END TEST INTEGAR VALUE--------------------



:TEST01VAR
REM ----------------------TEST 0 or 1 VALUE-----------------------
SET varname=%1
SET currently1=Checking if %varname% has 
SET currently2=a valid value (0 or 1)...
SET TimerStatus=
IF NOT "%SHOW_ALL_ALERTS%"=="0" CALL :STATS
IF "!%varname%!"=="0" GOTO :EOF
IF "!%varname%!"=="1" GOTO :EOF
SET currently1=%varname% does not equal 1 or 0
SET currently2=
SET TimerStatus=
CALL :STATS
SET currently1=Setting %varname% to !%varname%_D!...
SET currently2=
SET TimerStatus=
CALL :STATS
SET %varname%=!%varname%_D!
GOTO :EOF
REM --------------------END TEST 0 or 1 VALUE---------------------




:TEST_FIXES_VALS
REM --------------------TEST FIXES VALUES-------------------------
REM If fixes are disabled, gives option of enable both
REM or Continue

SET currently1=Checking if values for Fixes are valid...
SET currently2=
SET TimerStatus=
IF "%SHOW_ALL_ALERTS%"=="1" CALL :STATS

IF %USE_IP_RESET%==1 GOTO :TEST_FIXES_VALS_OK
IF %USE_NETWORK_RESET%==1 GOTO :TEST_FIXES_VALS_OK
IF %USE_NETWORK_RESET_FAST%==1 GOTO :TEST_FIXES_VALS_OK
IF %USE_RESET_ROUTE_TABLE%==1 GOTO :TEST_FIXES_VALS_OK
IF %ISADMIN%==0 GOTO :TEST_FIXES_VALS_AUTO


:TEST_FIXES_VALS_INQUERY
SET currently1=All fixes are disabled.
SET currently2=
SET TimerStatus=
CALL :STATS
IF %OMIT_USER_INPUT%==1 GOTO :TEST_FIXES_VALS_AUTO
ECHO.
ECHO.
ECHO Would you like to temporarily enable 3 of the fixes?
ECHO.
ECHO [ "n" : Run this script but check internet connection only ]
ECHO [ "y" : Enable Reset IP, NetworkSlow, NetworkFast fixes ]
ECHO.

SET /P usrInpt=[y/n] 
IF "%usrInpt%"=="n" GOTO :TEST_FIXES_VALS_LEAVE
IF "%usrInpt%"=="y" GOTO :TEST_FIXES_VALS_SET_ENABLE
GOTO :TEST_FIXES_VALS_INQUERY


:TEST_FIXES_VALS_LEAVE
SET currently1=All fixes are disabled. This script will not
SET currently2=fix the connection if it is unconnected.
SET TimerStatus=
SET Using_Fixes=0
CALL :STATS
GOTO :EOF


:TEST_FIXES_VALS_SET_ENABLE
SET currently1=Setting USE_IP_RESET and USE_NETWORK_RESET to 1
SET currently2=(enabling both fixes)
SET TimerStatus=
CALL :STATS 3
SET USE_IP_RESET=1
SET USE_NETWORK_RESET=1
SET USE_NETWORK_RESET_FAST=1
SET Using_Fixes=1
SET currently1=Checking validity of Settings...
SET currently2=
SET TimerStatus=
CALL STATS
GOTO :EOF


:TEST_FIXES_VALS_OK
SET Using_Fixes=1

GOTO :EOF


:TEST_FIXES_VALS_AUTO
SET Using_Fixes=0
GOTO :EOF
REM ------------------END TEST FIXES VALUES-----------------------




:GET_NETWORK_CONNECTIONS
SET CON_NUM=0
FOR /F "tokens=* DELIMS=" %%n IN ('NETSH INTERFACE SHOW INTERFACE') DO CALL :GET_NETWORK_CONNECTIONS_PARSE %%n
GOTO :EOF

:GET_NETWORK_CONNECTIONS_PARSE
SET LINE=%*
ECHO %LINE% |FIND "--------">NUL
IF NOT ERRORLEVEL 1 GOTO :EOF
ECHO %LINE% |FIND "Interface Name">NUL
IF NOT ERRORLEVEL 1 GOTO :EOF
SET /A CON_NUM+=1
FOR /F "tokens=1,3*" %%c IN ("%LINE%") DO SET CONNECTION%CON_NUM%_Admin=%%c&SET CONNECTION%CON_NUM%_Type=%%d&SET CONNECTION%CON_NUM%_Name=%%e
GOTO :EOF



:SETTINGS_CHECKALL
REM Initial CHECKS
SET currently1=Checking validity of Settings...
SET currently2=
SET TimerStatus=
CALL :STATS
CALL :DETECT_ADMIN_RIGHTS
CALL :TEST01VAR SLWMSG
CALL :TEST01VAR SHOW_ALL_ALERTS
CALL :TEST01VAR CONTINUOUS
CALL :TEST01VAR AUTOUPDATE
CALL :TEST01VAR OS_DETECT_OVERRIDE
CALL :TEST01VAR USE_NETWORK_RESET
CALL :TEST01VAR USE_NETWORK_RESET_FAST
CALL :TEST01VAR USE_RESET_ROUTE_TABLE
CALL :TEST01VAR USE_IP_RESET
CALL :TEST01VAR OMIT_USER_INPUT
CALL :TEST_FIXES_VALS
CALL :CHECK_NEED_ADMIN

IF %USE_NETWORK_RESET%==1 (
	CALL :DETECT_OS
	CALL :TEST_NETWORK_NAME 1
	CALL :TESTIntVAR MINUTES x x
) ELSE (
	IF %USE_NETWORK_RESET_FAST%==1 (
		CALL :DETECT_OS
		CALL :TEST_NETWORK_NAME 1
		CALL :TESTIntVAR MINUTES x x
	)
)
CALL :TESTIntVAR TIMER_REFRESH_RATE 0 99999999
CALL :TESTIntVAR CHECK_DELAY 0 99999999
CALL :TESTIntVAR UPDATECHANNEL 1 3
CALL :TESTIntVAR CHECKUPDATEFREQ 0 99999999
CALL :TEST01VAR USELOGGING
CALL :TEST01VAR START_MINIMIZED
CALL :TEST01VAR START_AT_LOGON
CALL :TEST01VAR AUTO_RETRY
CALL :TEST01VAR SHOW_ADVANCED_TESTING
CALL :TEST01VAR SKIP_INITIAL_NTWK_TEST
CALL :TEST01VAR TREAT_TIMEOUTS_AS_DISCONNECT
CALL :TEST01VAR ONLY_ONE_NETWORK_NAME_TEST
CALL :CHECK_START_AT_LOGON
GOTO :EOF



REM --------------------------------------------------------------
REM --------------------------------------------------------------
REM -----------------------INITIALIZING---------------------------
REM --------------------------------------------------------------
REM --------------------------------------------------------------

:INITIALIZE
@ECHO ON
%NoECHO%@ECHO OFF
CLS
REM Set CMD window size
%NoECHO%MODE CON COLS=81 LINES=25
%NoECHO%ECHO.
%NoECHO%ECHO                             Initializing program...

IF NOT "%Branch%"=="" SET branchurl=%Branch%&SET Branch=[%Branch%] &CALL :ToLower branchurl
SET THISTITLE=Lectrode's Network Connection Resetter %Branch%%rvsn%
TITLE %THISTITLE%


IF "%USE_ALTERNATE_SETTINGS%"=="1" IF NOT "%START_MINIMIZED%"=="1" CALL :USINGALTSETNNOTICE

REM Set Global Variables
SETLOCAL ENABLEDELAYEDEXPANSION
SET SettingsFileName=NWRSettings
SET NUMCONNFIXES=2
SET NUMNETFIXES=3
SET NETFIX=0
SET CONNFIX=0
SET ROUTEFIX=0
SET restartingProgram=
SET has_tested_ntwk_name_recent=0
SET delaymins=
SET LastTitle=
IF "%TestsSinceUpdate%"=="" SET TestsSinceUpdate=-1
IF "%ProgramMustFix%"=="" SET ProgramMustFix=0
SET NCNUM=0
SET NETWORK_FOUNDINVALID=0
SET STARTUPPARAMS=
SET DONEINIT=

CALL :RESETCURRENTLY


IF "%StartDate%"=="" SET StartDate=%DATE% %TIME%
REM GOTO :AFTSETTIME
REM SET iYEAR=%DATE:~-4%
REM SET iMONTH=%DATE:~4,2%
REM SET iDAY=%DATE:~7,2%
REM SET iHOUR=%TIME:~0,2%
REM SET iMINUTE=%TIME:~3,2%
REM SET iSECOND=%TIME:~6,2%

REM IF NOT %iYEAR% GEQ 10 SET iYEAR=%iYEAR:~1,1% 
REM IF NOT %iMONTH% GEQ 10 SET iMONTH=%iMONTH:~1,1%
REM IF NOT %iDAY% GEQ 10 SET iDAY=%iDAY:~1,1%
REM IF NOT %iHOUR% GEQ 10 SET iHOUR=%iHOUR:~1,1%
REM IF NOT %iMINUTE% GEQ 10 SET iMINUTE=%iMINUTE:~1,1%
REM IF NOT %iSECOND% GEQ 10 SET iSECOND=%iSECOND:~1,1%
REM :AFTSETTIME

CALL :SETTINGS_SETDEFAULT
IF NOT "%USE_ALTERNATE_SETTINGS%"=="1" IF "%INITIAL_RESET2DEFAULT_DONE%"=="" CALL :SETTINGS_RESET2DEFAULT
SET INITIAL_RESET2DEFAULT_DONE=1
IF "%INITPARAMS%"=="RESET" CALL :SETTINGS_RESET
IF "%USE_ALTERNATE_SETTINGS%"=="1" GOTO :AFTCALLCHECKSETNFILE
CALL :PROGRAM_INTRO
%NoECHO%ECHO....
%NoECHO%ECHO.....
CALL :SETTINGS_CHECKFILE
%NoECHO%ECHO......
%NoECHO%ECHO.......
CALL :DETECT_ADMIN_RIGHTS silent
%NoECHO%ECHO........
%NoECHO%ECHO.........
IF "%INITPARAMS%"=="STARTUP" GOTO :AFTCALLCHECKSETNFILE

REM Temporary check so older scripts will not have their continous checks interrupted
IF NOT "%maxconchks%"=="" IF "%CONTINUOUS%"=="1" GOTO :AFTCALLCHECKSETNFILE
CALL :SETTINGS_OPTION
SET DONEINIT=::

:AFTCALLCHECKSETNFILE

REM The function SETTINGS_EXPORT checks all setting
REM values before exporting them.
REM It checks the values wether or not it actually
REM exports the settings.
CALL :SETTINGS_EXPORT

CALL :CHECK_NEED_ADMIN

GOTO :MAIN_START




REM --------------------------------------------------------------
REM --------------------------------------------------------------
REM ------------------------MISC-Alerts---------------------------
REM --------------------------------------------------------------
REM --------------------------------------------------------------


:INITPROG
@ECHO OFF
@PROMPT :
@CLS
@ECHO.
@ECHO                             Initializing program...
GOTO :EOF





:PROGRAM_INTRO
REM ----------------------PROGRAM INTRO----------------------
REM Displays notice for 2 seconds
%NoECHO%CLS
%NoECHO%ECHO  ******************************************************************************
%NoECHO%ECHO  *                                                                            *
%NoECHO%ECHO  *                     *Documentation on how to use this                      *
%NoECHO%ECHO  *                     script can be accessed via Notepad                     *
%NoECHO%ECHO  *                                                                            *
%NoECHO%ECHO  *                                                                            *
%NoECHO%ECHO  ******************************************************************************
%NoECHO%ECHO.
%NoECHO%ECHO.
%NoECHO%ECHO..
%NoECHO%ECHO...
%NoECHO%CALL :SLEEP 2
GOTO :EOF
REM ---------------------END PROGRAM INTRO--------------------


:USINGALTSETNNOTICE
%NoECHO%CLS
%NoECHO%ECHO.
%NoECHO%ECHO  ******************************************************************************
%NoECHO%ECHO  *                                                                            *
%NoECHO%ECHO  *           This script is currently set to use internal settings.           *
%NoECHO%ECHO  *                                                                            *
%NoECHO%ECHO  *         To configure settings via the GUI, please open this script         *
%NoECHO%ECHO  *             with notepad and set USE_ALTERNATE_SETTINGS to 0               *
%NoECHO%ECHO  *                                                                            *
%NoECHO%ECHO  ******************************************************************************
%NoECHO%ECHO.
%NoECHO%ECHO.
%NoECHO%CALL :SLEEP 5
GOTO :EOF





REM --------------------------------------------------------------
REM --------------------------------------------------------------
REM ----------------------SETTING-CONFIG--------------------------
REM --------------------------------------------------------------
REM --------------------------------------------------------------



:SETTINGS_OPTION
CALL :HEADER
ECHO.
IF "%SETNFileDir%"=="TEMP" ECHO *Currently Using Temporary Settings*
IF "%SETNFileDir%"=="TEMP" ECHO.
ECHO What would you like to do?
ECHO -Detect/Fix Connection   [1]
ECHO -Edit Configuration      [2]
ECHO -Check for Update        [3]
ECHO -EXIT                    [x]
ECHO.
SET usrInput=
SET /P usrInput=[1/2/3/x] 
IF "%usrInput%"=="" GOTO :EOF
IF "%usrInput%"=="1" SET usrInput=&GOTO :EOF
IF "%usrInput%"=="2" SET usrInput=&CALL :SETTINGS_SET
IF "%usrInput%"=="3" SET currently1=Manual check for updates...
IF "%usrInput%"=="3" SET usrInput=&CALL :SelfUpdate
IF /I "%usrInput%"=="x" EXIT
GOTO :SETTINGS_OPTION

:SETTINGS_SET
SET SetnBeenSet=1
IF "%SETNFileDir%"=="TEMP" CALL :SETTINGS_CHKCHOOSELOC
CALL :HEADER
IF "%SETNFileDir%"=="TEMP" ECHO You have selected Temporary Settings
IF "%SETNFileDir%"=="TEMP" ECHO.
IF "%SETNFileDir%"=="TEMP" ECHO Changes made to settings will be lost when this
IF "%SETNFileDir%"=="TEMP" ECHO script is closed.
IF "%SETNFileDir%"=="TEMP" ECHO.
ECHO What would you like to do?
ECHO -Review all settings                        (1)
ECHO -Choose setting to change from list         (2)
ECHO -Select a Settings Preset                   (3)
ECHO -Reset all settings to their default values (4)
ECHO -Change where settings are stored           (5)
ECHO -Main Menu                                  (x)
ECHO.
SET usrInput=
SET /P usrInput=[1/2/3/4/5/X] 
IF /I "%usrInput%"=="X" SET usrInput=&GOTO :EOF
IF "%usrInput%"=="1" SET usrInput=&CALL :SETTINGS_SET_ALL
IF "%usrInput%"=="2" SET usrInput=&CALL :SETTINGS_SET_LIST_MAIN
IF "%usrInput%"=="3" SET usrInput=&CALL :SETTINGS_SELECT_PRESET
IF "%usrInput%"=="4" SET usrInput=&CALL :SETTINGS_RESET
IF "%usrInput%"=="5" SET usrInput=&CALL :SETTINGS_CHANGESETTINGLOCATION
GOTO :SETTINGS_SET


:SETTINGS_CHECKFILE
SET SETNFILECHK=0

IF EXIST "%SystemDrive%\NWResetter\%SettingsFileName%.BAT" (
SET FOUNDLOCAL=1
CALL "%SystemDrive%\NWResetter\%SettingsFileName%.BAT" LOAD
SET SETNFileDir=%SystemDrive%\NWResetter\
SET /A SETNFILECHK+=1
)

IF EXIST "%AppData%\NWResetter\%SettingsFileName%.BAT" (
SET FOUNDUSER=1
CALL "%AppData%\NWResetter\%SettingsFileName%.BAT" LOAD
SET SETNFileDir=%AppData%\NWResetter\
SET /A SETNFILECHK+=1
)

IF EXIST "%THISFILEDIR%%SettingsFileName%.BAT" (
SET FOUNDPORT=1
CALL "%THISFILEDIR%%SettingsFileName%.BAT" LOAD
SET /A SETNFILECHK+=1
SET SETNFileDir=%THISFILEDIR%
)

IF %SETNFILECHK%==0 (
SET /A SETNFILECHK+=1
SET SETNFileDir=TEMP
)

IF %SETNFILECHK%==1 GOTO :EOF
IF NOT %SETNFILECHK% GEQ 2 GOTO :SETTINGS_CHECKFILE_END
:SETTINGS_CHECKFILE_MULTIPLE
REM Multiple settings files
CALL :HEADER
ECHO Multiple setting files were found. Which one
ECHO would you like to use?
IF NOT "%FOUNDLOCAL%"=="" ECHO -Local [%SystemDrive%\NWResetter]               [L]
IF NOT "%FOUNDUSER%"==""  ECHO -User  [Appdata\NWResetter]          [U]
IF NOT "%FOUNDPORT%"==""  ECHO -Portable [Same folder as main file] [P]
SET usrInput=
SET /P usrInput=[] 
IF NOT "%FOUNDPORT%"=="" IF /I "%usrInput%"=="P" SET SETNFileDir=%THISFILEDIR%
IF NOT "%FOUNDPORT%"=="" IF /I "%usrInput%"=="P" SET usrInput=&GOTO :EOF
IF NOT "%FOUNDUSER%"=="" IF /I "%usrInput%"=="U" SET SETNFileDir=%Appdata%\NWResetter\
IF NOT "%FOUNDUSER%"=="" IF /I "%usrInput%"=="U" SET usrInput=&GOTO :EOF
IF NOT "%FOUNDLOCAL%"=="" IF /I "%usrInput%"=="L" SET SETNFileDir=%SystemDrive%\NWResetter\
IF NOT "%FOUNDLOCAL%"=="" IF /I "%usrInput%"=="L" SET usrInput=&GOTO :EOF
GOTO :SETTINGS_CHECKFILE_MULTIPLE

:SETTINGS_CHECKFILE_END
IF "%INITPARAMS%"=="SETTINGS" SET INITPARAMS=
GOTO :EOF



:SETTINGS_CHANGESETTINGLOCATION
CALL :HEADER
SET SetnBeenSet=1
ECHO Where would you like to save the settings?
ECHO.
ECHO -Temporary Settings [Don't Save]          [1]
ECHO -Current user's Application Data folder   [2] [Recommended]
ECHO -%SystemDrive%\NWResetter\                           [3]
ECHO -Same folder as this script [Portable]    [4]
ECHO.
SET usrInput=
SET /P usrInput=[1/2/3/4] 
IF "%usrInput%"=="" GOTO :SETTINGS_CHANGESETTINGLOCATION_TEMP
IF "%usrInput%"=="1" SET usrInput=&GOTO :SETTINGS_CHANGESETTINGLOCATION_TEMP
IF "%usrInput%"=="2" SET usrInput=&GOTO :SETTINGS_CHANGESETTINGLOCATION_USR
IF "%usrInput%"=="3" SET usrInput=&GOTO :SETTINGS_CHANGESETTINGLOCATION_LOC
IF "%usrInput%"=="4" SET usrInput=&GOTO :SETTINGS_CHANGESETTINGLOCATION_PORT
GOTO :SETTINGS_CHANGESETTINGLOCATION


:SETTINGS_CHANGESETTINGLOCATION_TEMP
REM CALL :SETTINGS_RESET2DEFAULT
SET SETNFileDir=TEMP
CALL :SETTINGS_SET
GOTO :EOF

:SETTINGS_CHANGESETTINGLOCATION_USR
REM CALL :SETTINGS_RESET2DEFAULT
MD "%AppData%\NWResetter"
SET SETNFileDir=%AppData%\NWResetter\
CALL :SETTINGS_EXPORT
CALL :SETTINGS_SET
GOTO :EOF

:SETTINGS_CHANGESETTINGLOCATION_LOC
REM CALL :SETTINGS_RESET2DEFAULT
MD "%SystemDrive%\NWResetter"
SET SETNFileDir=%SystemDrive%\NWResetter\
CALL :SETTINGS_EXPORT
CALL :SETTINGS_SET
GOTO :EOF

:SETTINGS_CHANGESETTINGLOCATION_PORT
REM CALL :SETTINGS_RESET2DEFAULT
SET SETNFileDir=%THISFILEDIR%
CALL :SETTINGS_EXPORT
CALL :SETTINGS_SET
GOTO :EOF



:SETTINGS_RESET
CLS
CALL :HEADER
ECHO Reset Function Initiated...
CALL :SETTINGS_SETDEFAULT
CALL :SETTINGS_RESET2DEFAULT
CALL :SETTINGS_EXPORT
GOTO :EOF



:SETTINGS_CHKCHOOSELOC
IF "%ASKED4SAVLOC%"=="1" GOTO :EOF
CALL :HEADER
SET ASKED4SAVLOC=1
ECHO Settings file location has not been set. 
ECHO Any changes you make to settings will not be saved.
ECHO.
ECHO Would you like to choose a place to save your settings?
SET usrInput=
SET /P usrInput=[y/n] 
IF /I "%usrInput%"=="" SET usrInput=y
IF /I "%usrInput%"=="Y" SET usrInput=&GOTO :SETTINGS_CHANGESETTINGLOCATION
IF /I "%usrInput%"=="N" SET usrInput=&GOTO :EOF
GOTO :SETTINGS_CHKCHOOSELOC



:SETTINGS_SELECT_PRESET
CALL :HEADER
ECHO Select a Preset to view details:
ECHO -Normal Run to Fix                          (1)
ECHO -Advanced Run to Fix                        (2)
ECHO -Connection Monitoring                      (3)
ECHO -Advanced Connection Monitoring             (4)
ECHO -Cancel                                     (X)
ECHO.
SET usrInput=
SET /P usrInput=[1/2/3/4/X] 
IF /I "%usrInput%"=="X" SET usrInput=&GOTO :EOF
IF "%usrInput%"=="1" SET usrInput=&GOTO :SETTINGS_VIEW_PRESET01
IF "%usrInput%"=="2" SET usrInput=&GOTO :SETTINGS_VIEW_PRESET02
IF "%usrInput%"=="3" SET usrInput=&GOTO :SETTINGS_VIEW_PRESET03
IF "%usrInput%"=="4" SET usrInput=&GOTO :SETTINGS_VIEW_PRESET04
GOTO :SETTINGS_SELECT_PRESET


:SETTINGS_SET_ALL
CALL :HEADER
CALL :SETTINGS_SETNETWORK
CALL :SETTINGS_SETONE B2
CALL :SETTINGS_SETONE B3
CALL :SETTINGS_SETONE B4
CALL :SETTINGS_SETONE B5
CALL :SETTINGS_SETONE B6

CALL :SETTINGS_SETONE D1
CALL :SETTINGS_SETONE D2
CALL :SETTINGS_SETONE D3
CALL :SETTINGS_SETONE D4

CALL :SETTINGS_SETONE U1
CALL :SETTINGS_SETONE U2
CALL :SETTINGS_SETONE U3

CALL :SETTINGS_SETONE F1
CALL :SETTINGS_SETONE F2
CALL :SETTINGS_SETONE F3
CALL :SETTINGS_SETONE F4
CALL :SETTINGS_SETONE F5
CALL :SETTINGS_SETONE F6

CALL :SETTINGS_SETONE A1
CALL :SETTINGS_SETONE A2
CALL :SETTINGS_SETONE A3
CALL :SETTINGS_SETONE A4
CALL :SETTINGS_SETONE A5
GOTO :EOF


:SETTINGS_SET_LIST_MAIN
CALL :HEADER
IF "%CONTINUOUS%"=="1" SET MODE=Continuous
IF "%CONTINUOUS%"=="0" SET MODE=Run Once
ECHO Navigation:
ECHO View Main Settings[ ]     View Display Settings[D]   Configure Fixes[F]
ECHO View Update Settings[U]   View Advanced Settings[A]  Return[X]            
ECHO.
ECHO -Main Settings-
ECHO.
ECHO  [Setting]             [#]  [Current Value]
ECHO -Connection Name       (1)  "%NETWORK%"
ECHO -Mode                  (2)   %MODE%
IF "%CONTINUOUS%"=="1" ECHO -Check every X minutes (3)   %CHECK_DELAY%
IF "%CONTINUOUS%"=="0" ECHO -Check every X minutes [Continuous mode only]
ECHO -Start at Logon        (4)   %START_AT_LOGON%
ECHO -Start Minimized       (5)   %START_MINIMIZED%
ECHO -Use Logging           (6)   %USELOGGING%
ECHO.
SET usrInput=
SET /P usrInput=[D/F/U/A/X/1/2/3/4/5] 
IF "%usrInput%"=="1" CALL :SETTINGS_SETNETWORK
IF "%usrInput%"=="2" CALL :SETTINGS_SETONE B2
IF "%usrInput%"=="3" CALL :SETTINGS_SETONE B3
IF "%usrInput%"=="3" CALL :SETTINGS_SETONE B4
IF "%usrInput%"=="3" CALL :SETTINGS_SETONE B5
IF /I "%usrInput%"=="M" SET usrInput= &GOTO :SETTINGS_SET_LIST_MAIN
IF /I "%usrInput%"=="D" SET usrInput= &GOTO :SETTINGS_SET_LIST_GUI
IF /I "%usrInput%"=="F" SET usrInput= &GOTO :SETTINGS_SET_LIST_FIXES
IF /I "%usrInput%"=="U" SET usrInput= &GOTO :SETTINGS_SET_LIST_UPDATE
IF /I "%usrInput%"=="A" SET usrInput= &GOTO :SETTINGS_SET_LIST_ADV
IF /I "%usrInput%"=="X" SET usrInput= &GOTO :EOF
GOTO :SETTINGS_SET_LIST_MAIN

:SETTINGS_SET_LIST_UPDATE
CALL :HEADER
IF "%UPDATECHANNEL%"=="1" SET CURCHANNEL=Stable
IF "%UPDATECHANNEL%"=="2" SET CURCHANNEL=Beta
IF "%UPDATECHANNEL%"=="3" SET CURCHANNEL=Dev
ECHO Navigation:
ECHO View Main Settings[M]     View Display Settings[D]   Configure Fixes[F]
ECHO View Update Settings[ ]   View Advanced Settings[A]  Return[X]            
ECHO.
ECHO -Update Settings-
ECHO.
ECHO  [Setting]             [#]  [Current Value]
ECHO -Auto Update           (1)   %AUTOUPDATE%
ECHO -Update Channel        (2)   %CURCHANNEL%
ECHO -Update Frequency      (3)   %CHECKUPDATEFREQ%
ECHO.
SET usrInput=
SET /P usrInput=[M/D/F/A/X/1/2/3]  
IF "%usrInput%"=="1" CALL :SETTINGS_SETONE U1
IF "%usrInput%"=="2" CALL :SETTINGS_SETONE U2
IF "%usrInput%"=="3" CALL :SETTINGS_SETONE U3
IF /I "%usrInput%"=="M" SET usrInput= &GOTO :SETTINGS_SET_LIST_MAIN
IF /I "%usrInput%"=="D" SET usrInput= &GOTO :SETTINGS_SET_LIST_GUI
IF /I "%usrInput%"=="F" SET usrInput= &GOTO :SETTINGS_SET_LIST_FIXES
IF /I "%usrInput%"=="U" SET usrInput= &GOTO :SETTINGS_SET_LIST_UPDATE
IF /I "%usrInput%"=="A" SET usrInput= &GOTO :SETTINGS_SET_LIST_ADV
IF /I "%usrInput%"=="X" SET usrInput= &GOTO :EOF
GOTO :SETTINGS_SET_LIST_UPDATE


:SETTINGS_SET_LIST_GUI
CALL :HEADER
ECHO Navigation:
ECHO View Main Settings[M]     View Display Settings[ ]   Configure Fixes[F]
ECHO View Update Settings[U]   View Advanced Settings[A]  Return[X]            
ECHO.
ECHO -Display Settings-
ECHO.
ECHO  [Setting]             [#]  [Current Value]
ECHO -Show All Alerts       (1)   %SHOW_ALL_ALERTS%
ECHO -Show Advanced Testing (2)   %SHOW_ADVANCED_TESTING%
ECHO -Slow Messages         (3)   %SLWMSG%
ECHO -Timer Refresh Rate    (4)   %TIMER_REFRESH_RATE% Second[s]
ECHO.
SET usrInput=
SET /P usrInput=[M/F/U/A/X/1/2/3/4]  
IF "%usrInput%"=="1" CALL :SETTINGS_SETONE D1
IF "%usrInput%"=="2" CALL :SETTINGS_SETONE D2
IF "%usrInput%"=="3" CALL :SETTINGS_SETONE D3
IF "%usrInput%"=="4" CALL :SETTINGS_SETONE D4
IF /I "%usrInput%"=="M" SET usrInput= &GOTO :SETTINGS_SET_LIST_MAIN
IF /I "%usrInput%"=="D" SET usrInput= &GOTO :SETTINGS_SET_LIST_GUI
IF /I "%usrInput%"=="F" SET usrInput= &GOTO :SETTINGS_SET_LIST_FIXES
IF /I "%usrInput%"=="U" SET usrInput= &GOTO :SETTINGS_SET_LIST_UPDATE
IF /I "%usrInput%"=="A" SET usrInput= &GOTO :SETTINGS_SET_LIST_ADV
IF /I "%usrInput%"=="X" SET usrInput= &GOTO :EOF
GOTO :SETTINGS_SET_LIST_MISC


:SETTINGS_SET_LIST_ADV
CALL :HEADER
ECHO Navigation:
ECHO View Main Settings[M]     View Display Settings[D]   Configure Fixes[F]
ECHO View Update Settings[U]   View Advanced Settings[ ]  Return[X]            
ECHO.
ECHO -Advanced Settings-
ECHO.
ECHO  [Setting]                   [#]  [Current Value]
ECHO -Omit User Input             (1)   %OMIT_USER_INPUT%
ECHO -Skip Initial Ntwk Test      (2)   %SKIP_INITIAL_NTWK_TEST%
ECHO -Treat Timeout as disconnect (3)   %TREAT_TIMEOUTS_AS_DISCONNECT%
ECHO -One Connection name test    (4)   %ONLY_ONE_NETWORK_NAME_TEST%
ECHO -OS Detection Override       (5)   %OS_DETECT_OVERRIDE%
ECHO.
SET usrInput=
SET /P usrInput=[M/D/F/U/X/1/2/3/4/5] 
IF "%usrInput%"=="1" CALL :SETTINGS_SETONE A1
IF "%usrInput%"=="2" CALL :SETTINGS_SETONE A2
IF "%usrInput%"=="3" CALL :SETTINGS_SETONE A3
IF "%usrInput%"=="4" CALL :SETTINGS_SETONE A4
IF "%usrInput%"=="5" CALL :SETTINGS_SETONE A5
IF /I "%usrInput%"=="M" SET usrInput= &GOTO :SETTINGS_SET_LIST_MAIN
IF /I "%usrInput%"=="D" SET usrInput= &GOTO :SETTINGS_SET_LIST_GUI
IF /I "%usrInput%"=="F" SET usrInput= &GOTO :SETTINGS_SET_LIST_FIXES
IF /I "%usrInput%"=="U" SET usrInput= &GOTO :SETTINGS_SET_LIST_UPDATE
IF /I "%usrInput%"=="A" SET usrInput= &GOTO :SETTINGS_SET_LIST_ADV
IF /I "%usrInput%"=="X" SET usrInput= &GOTO :EOF
GOTO :SETTINGS_SET_LIST_ADV


:SETTINGS_SET_LIST_FIXES
CALL :HEADER
ECHO Navigation:
ECHO View Main Settings[M]     View Display Settings[D]   Configure Fixes[ ]
ECHO View Update Settings[U]   View Advanced Settings[A]  Return[X]            
ECHO.
ECHO -Fixes Configuration-
ECHO.
ECHO  [Setting]                   [##]  [Current Value]
ECHO -AutoRetry                   (1)   %AUTO_RETRY%
ECHO -Network Reset Stall         (2)   %MINUTES% Minute[s]
ECHO -Enable FIX: FastNWReset     (3)   %USE_NETWORK_RESET_FAST%
ECHO -Enable FIX: Reset IP        (4)   %USE_IP_RESET%
ECHO -Enable FIX: SlowNWReset     (5)   %USE_NETWORK_RESET%
ECHO -Enable FIX: ResetRoutes     (6)   %USE_RESET_ROUTE_TABLE%
ECHO.
SET usrInput=
SET /P usrInput=[M/D/U/A/X/1/2/3/4/5/6/7]  
IF "%usrInput%"=="1" CALL :SETTINGS_SETONE F1
IF "%usrInput%"=="2" CALL :SETTINGS_SETONE F2
IF "%usrInput%"=="3" CALL :SETTINGS_SETONE F3
IF "%usrInput%"=="4" CALL :SETTINGS_SETONE F4
IF "%usrInput%"=="5" CALL :SETTINGS_SETONE F5
IF "%usrInput%"=="6" CALL :SETTINGS_SETONE F6
IF /I "%usrInput%"=="M" SET usrInput= &GOTO :SETTINGS_SET_LIST_MAIN
IF /I "%usrInput%"=="D" SET usrInput= &GOTO :SETTINGS_SET_LIST_GUI
IF /I "%usrInput%"=="F" SET usrInput= &GOTO :SETTINGS_SET_LIST_FIXES
IF /I "%usrInput%"=="U" SET usrInput= &GOTO :SETTINGS_SET_LIST_UPDATE
IF /I "%usrInput%"=="A" SET usrInput= &GOTO :SETTINGS_SET_LIST_ADV
IF /I "%usrInput%"=="X" SET usrInput= &GOTO :EOF
GOTO :SETTINGS_SET_LIST_ADV

:SETTINGS_SETONE
CALL :SETTINGS_GETINFO %1
CALL :HEADER
IF "%SETNVAR%"=="" SET SETTINGVAR=%SETTINGTITLE%
IF NOT "%SETNVAR%"=="" SET SETTINGVAR=%SETNVAR%
ECHO. *%SETTINGTITLE%*
ECHO. %SETTINGOPT%
ECHO.
ECHO. %SETTINGINFO1%
ECHO. %SETTINGINFO2%
ECHO. %SETTINGINFO3%
ECHO.
ECHO Default Value: !%SETTINGVAR%_D!
IF "!%SETTINGVAR%!"=="" ECHO Current Value: [none set yet]
IF NOT "!%SETTINGVAR%!"=="" ECHO Current Value: !%SETTINGVAR%!
ECHO.
ECHO Please enter the new setting value:
ECHO (Enter "D" for default)
ECHO (Enter nothing to keep current setting)
ECHO.
SET usrInput=
SET /P usrInput=[] 
IF "%usrInput%"=="" GOTO :EOF
IF /I "%usrInput%"=="D" SET %SETTINGVAR%=!%SETTINGVAR%_D!
IF /I NOT "%usrInput%"=="D" SET %SETTINGVAR%=%usrInput%
SET usrInput=
CALL :SETTINGS_EXPORT
GOTO :EOF

:SETTINGS_SETNETWORK
CALL :HEADER
CALL :GET_NETWORK_CONNECTIONS
IF "%NETWORK_FOUNDINVALID%"=="1" IF "%OMITUSERINPUT%"=="1" GOTO :SETTINGS_SETNETWORK_BESTGUESS
SET NETWORK_OLD=%NETWORK%
SET NETWORK=
SET STATSpacer=                                                      !
ECHO. *Connection Name*
ECHO. 
ECHO. Current value: "%NETWORK_OLD%"
ECHO.
ECHO. Please select the connection through which you connect to
ECHO. the internet, or enter a connection name manually:
ECHO. (Enter nothing to keep the current setting)
ECHO. NOTE: Capital letters matter!
ECHO. 
FOR /L %%n IN (1,1,%CON_NUM%) DO SET SHOWCONN%%n=!CONNECTION%%n_NAME!%STATSpacer%
FOR /L %%n IN (1,1,%CON_NUM%) DO ECHO -!SHOWCONN%%n:~0,40! [%%n]
ECHO.
SET usrInput=
SET /P usrInput=[] 
IF "%usrInput%"=="" SET NETWORK=%NETWORK_OLD%&GOTO :EOF
IF "%SHOW_ALL_ALERTS%"=="1" ECHO Verifying...
FOR /L %%n IN (1,1,%CON_NUM%) DO IF "%usrInput%"=="%%n" SET NETWORK=!CONNECTION%%n_NAME!
IF "%NETWORK%"=="" SET NETWORK=%usrInput%
SET usrInput=
CALL :TESTNetworkName %NETWORK%
IF "%NETWORK_IsValid%"=="0" SET NETWORK=%NETWORK_OLD%&ECHO Not a valid name...&CALL :SLEEP 2&GOTO :SETTINGS_SETNETWORK
CALL :SETTINGS_EXPORT
GOTO :EOF

:SETTINGS_SETNETWORK_BESTGUESS
ECHO. User Input is Omitted. Choosing Network Connection
ECHO. based on best guess...
SET NETWORK=
FOR /L %%n IN (10,-1,1) DO CALL :SETTINGS_SETNETWORK_BESTGUESS_GUESSING Wireless Network Connection %%n
CALL :SETTINGS_SETNETWORK_BESTGUESS_GUESSING Wireless Network Connection
FOR /L %%n IN (10,-1,1) DO CALL :SETTINGS_SETNETWORK_BESTGUESS_GUESSING Local Area Connection %%n
 CALL :SETTINGS_SETNETWORK_BESTGUESS_GUESSING Local Area Connection
IF "%NETWORK%"=="" SET NETWORK=%CONNECTION1_NAME%
GOTO :EOF

:SETTINGS_SETNETWORK_BESTGUESS_GUESSING
IF NOT "%NETWORK%"=="" GOTO :EOF
CALL :TESTNetworkName %*
IF %NETWORK_IsValid%==0 GOTO :EOF
SET NETWORK=%*
GOTO :EOF



:SETTINGS_GETINFO
SET usrInput=
SET SETTINGTITLE=
SET SETTINGOPT=
SET SETTINGINFO1=
SET SETTINGINFO2=
SET SETTINGINFO3=
SET SETNVAR=

IF %1==B2 (
SET SETTINGTITLE=MODE
SET SETTINGOPT=
SET SETTINGINFO1=Enter 0 for Run Once
SET SETTINGINFO2=Enter 1 for Continuous [checks every %CHECK_DELAY% minute[s]]
SET SETTINGINFO3=[Must run settings file to configure settings if this is set to 1]
SET SETNVAR=CONTINUOUS
)
IF %1==B3 (
SET SETTINGTITLE=CHECK_DELAY
SET SETTINGOPT=Integers Only! [aka 0,1,2,etc]
SET SETTINGINFO1=
SET SETTINGINFO2=In MODE:Continuous, this is how many minutes between
SET SETTINGINFO3=connection tests.
)
IF %1==B4 (
SET SETTINGTITLE=START_AT_LOGON
SET SETTINGOPT=Enter 1 for True, Enter 0 for False
SET SETTINGINFO1=Start this script at user log on
SET SETTINGINFO2=When true, this script will start when you log on.
SET SETTINGINFO3=NOTE: Not available when running with portable or temp settings
)
IF %1==B5 (
SET SETTINGTITLE=START_MINIMIZED
SET SETTINGOPT=Enter 1 for True, Enter 0 for False
SET SETTINGINFO1=Start Minimized
SET SETTINGINFO2=When true, this sript will minimize itself when it is run
SET SETTINGINFO3=
)
IF %1==B6 (
SET SETTINGTITLE=USE LOGGING
SET SETTINGOPT=Enter 1 for On, Enter 0 for Off
SET SETTINGINFO1=
SET SETTINGINFO2=
SET SETTINGINFO3=
SET SETNVAR=USELOGGING
)
IF %1==U1 (
SET SETTINGTITLE=Automaticly Update
SET SETTINGOPT=Enter 1 for On, Enter 0 for Off
SET SETTINGINFO1=When on, the script will occasionally 
SET SETTINGINFO2=check for updates after a successful
SET SETTINGINFO3=internet connection test.
SET SETNVAR=AUTOUPDATE
)
IF %1==U2 (
SET SETTINGTITLE=Update Channel
SET SETTINGOPT=1 for Stable, 2 for Beta, 3 for Dev
SET SETTINGINFO1=Determines which release version this
SET SETTINGINFO2=script will update to
SET SETTINGINFO3=
SET SETNVAR=UPDATECHANNEL
)
IF %1==U3 (
SET SETTINGTITLE=Update Check Frequency
SET SETTINGOPT=Integers Only! [aka 0,1,2,etc]
SET SETTINGINFO1=Only applies to continuous mode!
SET SETTINGINFO2=This script will check for updates only
SET SETTINGINFO3=after this many successful connection tests
SET SETNVAR=CHECKUPDATEFREQ
)
IF %1==D1 (
SET SETTINGTITLE=SHOW_ALL_ALERTS
SET SETTINGOPT=Enter 1 for On, Enter 0 for Off
SET SETTINGINFO1=When set to On, shows more detailed messages.
SET SETTINGINFO2=NOTE: Regardless of what you set this too, this
SET SETTINGINFO3=script will always display important messages.
)
IF %1==D2 (
SET SETTINGTITLE=SHOW_ADVANCED_TESTING
SET SETTINGOPT=Enter 1 for On, Enter 0 for Off
SET SETTINGINFO1=Show Advanced Testing Output
SET SETTINGINFO2=When true, more details will be shown reguarding
SET SETTINGINFO3=testing the internet
)
IF %1==D3 (
SET SETTINGTITLE=SLOW MESSAGES
SET SETTINGOPT=Enter 1 for On, Enter 0 for Off
SET SETTINGINFO1=
SET SETTINGINFO2=When true, this script will pause for every message it displays 
SET SETTINGINFO3=to allow the user to read them [run time will be longer]
SET SETNVAR=SLWMSG
)
IF %1==D4 (
SET SETTINGTITLE=TIMER_REFRESH_RATE
SET SETTINGOPT=Integers greater than 0 Only! [aka 1,2,3,etc]
SET SETTINGINFO1=Timer Refresh Rate [Update every # seconds]
SET SETTINGINFO2=[1-10 recommended]
SET SETTINGINFO3=
)
IF %1==F1 (
SET SETTINGTITLE=AUTO_RETRY
SET SETTINGOPT=Enter 1 for On, Enter 0 for Off
SET SETTINGINFO1=
SET SETTINGINFO2=If fix fails the first time, automatically keep
SET SETTINGINFO3=retrying. [Applies to Mode:Run Once only!]
)
IF %1==F2 (
SET SETTINGTITLE=MINUTES
SET SETTINGOPT=Integers Only! [aka 0,1,2,etc]
SET SETTINGINFO1=Number of minutes to wait before re-enabling
SET SETTINGINFO2=the network adapter [5-15 reccomended]
SET SETTINGINFO3=
)
IF %1==F3 (
SET SETTINGTITLE=USE_NETWORK_RESET_FAST
SET SETTINGOPT=Enter 1 for On, Enter 0 for Off
SET SETTINGINFO1=Enable FIX: Quick Connection Reset
SET SETTINGINFO2=This fix quickly enables and disables the connection
SET SETTINGINFO3=*Requires Administrative rights
)
IF %1==F4 (
SET SETTINGTITLE=USE_IP_RESET
SET SETTINGOPT=Enter 1 for On, Enter 0 for Off
SET SETTINGINFO1=Enable FIX: Reset the IP Address
SET SETTINGINFO2=This fix releases, flushes, and renews the IP Address
SET SETTINGINFO3=*This affects all Network Connections
)
IF %1==F5 (
SET SETTINGTITLE=USE_NETWORK_RESET [Slow]
SET SETTINGOPT=Enter 1 for On, Enter 0 for Off
SET SETTINGINFO1=Enable FIX: Slow Connection Reset
SET SETTINGINFO2=This fix disables, stalls, and enables the connection
SET SETTINGINFO3=*Requires Administrative rights
SET SETNVAR=USE_NETWORK_RESET
)
IF %1==F6 (
SET SETTINGTITLE=USE_RESET_ROUTE_TABLE
SET SETTINGOPT=Enter 1 for On, Enter 0 for Off
SET SETTINGINFO1=Enable FIX: Reset Route Table
SET SETTINGINFO2=This fixes 'Host Unreachable' errors.
SET SETTINGINFO3=*This affects all Network Connections
)
IF %1==A1 (
SET SETTINGTITLE=OMIT_USER_INPUT
SET SETTINGOPT=Enter 1 for True, Enter 0 for False
SET SETTINGINFO1=Omit ALL user input
SET SETTINGINFO2=Assumes all settings are intentional and will not
SET SETTINGINFO3=prompt the user to enter additional/correct information
)
IF %1==A2 (
SET SETTINGTITLE=SKIP_INITIAL_NTWK_TEST
SET SETTINGOPT=Enter 1 for True, Enter 0 for False
SET SETTINGINFO1=Skip Initial Network Connection Test
SET SETTINGINFO2=Select this if you want this script to immediately attempt 
SET SETTINGINFO3=to fix your connection without testing the connection first
)
IF %1==A3 (
SET SETTINGTITLE=TREAT_TIMEOUTS_AS_DISCONNECT
SET SETTINGOPT=Enter 1 for True, Enter 0 for False
SET SETTINGINFO1=If you use browser-based network authentication, you may
SET SETTINGINFO2=need to set this to False. Other times, routers may need
SET SETTINGINFO3=to re-register your device to fix timeout problems.
)
IF %1==A4 (
SET SETTINGTITLE=ONLY_ONE_NETWORK_NAME_TEST
SET SETTINGOPT=Enter 1 for True, Enter 0 for False
SET SETTINGINFO1=Don't test Network Name more than once
SET SETTINGINFO2=Setting to True is ideal on most computers as long as the 
SET SETTINGINFO3=Network Connection name does not change
)
IF %1==A5 (
SET SETTINGTITLE=OS_DETECT_OVERRIDE
SET SETTINGOPT=Enter 1 for On, Enter 0 for Off
SET SETTINGINFO1=Override Operating System Detection
SET SETTINGINFO2=This will force this script to continue running on an unsupported OS.
SET SETTINGINFO3=Doing so may cause this script to exibit unusual behavior.
)

GOTO :EOF


:SETTINGS_SETDEFAULT
REM Defines default setting values
IF %rvsn:~0,1%==v SET UPDATECHANNEL_D=1
IF %rvsn:~0,1%==b SET UPDATECHANNEL_D=2
IF %rvsn:~0,1%==r SET UPDATECHANNEL_D=3
SET MINUTES_D=10
SET NETWORK_D=Wireless Network Connection
SET CONTINUOUS_D=0
SET AUTO_RETRY_D=0
SET AUTOUPDATE_D=1
SET CHECKUPDATEFREQ_D=5
SET CHECK_DELAY_D=1
SET SHOW_ALL_ALERTS_D=1
SET SHOW_ADVANCED_TESTING_D=0
SET SLWMSG_D=0
SET TIMER_REFRESH_RATE_D=1
SET START_AT_LOGON_D=0
SET START_MINIMIZED_D=0
SET USELOGGING_D=0
SET OMIT_USER_INPUT_D=0
SET SKIP_INITIAL_NTWK_TEST_D=0
SET USE_IP_RESET_D=1
SET USE_NETWORK_RESET_FAST_D=1
SET USE_NETWORK_RESET_D=1
SET USE_RESET_ROUTE_TABLE_D=0
SET TREAT_TIMEOUTS_AS_DISCONNECT_D=1
SET ONLY_ONE_NETWORK_NAME_TEST_D=1
SET OS_DETECT_OVERRIDE_D=0
GOTO :EOF

:SETTINGS_RESET2DEFAULT
REM Set all settings to their default values.
SET MINUTES=%MINUTES_D%
SET NETWORK=%NETWORK_D%
SET CONTINUOUS=%CONTINUOUS_D%
SET AUTO_RETRY=%AUTO_RETRY_D%
SET AUTOUPDATE=%AUTOUPDATE_D%
SET UPDATECHANNEL=%UPDATECHANNEL_D%
SET CHECKUPDATEFREQ=%CHECKUPDATEFREQ_D%
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
SET USE_RESET_ROUTE_TABLE=%USE_RESET_ROUTE_TABLE_D%
SET TREAT_TIMEOUTS_AS_DISCONNECT=%TREAT_TIMEOUTS_AS_DISCONNECT_D%
SET ONLY_ONE_NETWORK_NAME_TEST=%ONLY_ONE_NETWORK_NAME_TEST_D%
SET OS_DETECT_OVERRIDE=%OS_DETECT_OVERRIDE_D%
GOTO :EOF


:SETTINGS_CLEARALL
SET MINUTES=
SET NETWORK=
SET CONTINUOUS=
SET AUTO_RETRY=
SET AUTOUPDATE=
SET UPDATECHANNEL=
SET CHECKUPDATEFREQ=
SET CHECK_DELAY=
SET SHOW_ALL_ALERTS=
SET SHOW_ADVANCED_TESTING=
SET SLWMSG=
SET TIMER_REFRESH_RATE=
SET START_AT_LOGON=
SET START_MINIMIZED=
SET OMIT_USER_INPUT=
SET SKIP_INITIAL_NTWK_TEST=
SET USE_IP_RESET=
SET USE_NETWORK_RESET_FAST=
SET USE_NETWORK_RESET=
SET USE_RESET_ROUTE_TABLE=
SET TREAT_TIMEOUTS_AS_DISCONNECT=
SET ONLY_ONE_NETWORK_NAME_TEST=
SET OS_DETECT_OVERRIDE=
GOTO :EOF


:SETTINGS_ALLHAVEVALUES
REM Make sure all settings have values
CALL :SETTINGS_SETDEFAULT
IF "%MINUTES%"=="" SET MINUTES=%MINUTES_D%
IF "%NETWORK%"=="" SET NETWORK=%NETWORK_D%
IF "%CONTINUOUS%"=="" SET CONTINUOUS=%CONTINUOUS_D%
IF "%AUTO_RETRY%"=="" SET AUTO_RETRY=%AUTO_RETRY_D%
IF "%AUTOUPDATE%"=="" SET AUTOUPDATE=%AUTOUPDATE_D%
IF "%UPDATECHANNEL%"=="" SET UPDATECHANNEL=%UPDATECHANNEL_D%
IF "%CHECKUPDATEFREQ%"=="" SET CHECKUPDATEFREQ=%CHECKUPDATEFREQ_D%
IF "%CHECK_DELAY%"=="" SET CHECK_DELAY=%CHECK_DELAY_D%
IF "%SHOW_ALL_ALERTS%"=="" SET SHOW_ALL_ALERTS=%SHOW_ALL_ALERTS_D%
IF "%SHOW_ADVANCED_TESTING%"=="" SET SHOW_ADVANCED_TESTING=%SHOW_ADVANCED_TESTING_D%
IF "%SLWMSG%"=="" SET SLWMSG=%SLWMSG_D%
IF "%TIMER_REFRESH_RATE%"=="" SET TIMER_REFRESH_RATE=%TIMER_REFRESH_RATE_D%
IF "%START_AT_LOGON%"=="" SET START_AT_LOGON=%START_AT_LOGON_D%
IF "%START_MINIMIZED%"=="" SET START_MINIMIZED=%START_MINIMIZED_D%
IF "%OMIT_USER_INPUT%"=="" SET OMIT_USER_INPUT=%OMIT_USER_INPUT_D%
IF "%SKIP_INITIAL_NTWK_TEST%"=="" SET SKIP_INITIAL_NTWK_TEST=%SKIP_INITIAL_NTWK_TEST_D%
IF "%USE_IP_RESET%"=="" SET USE_IP_RESET=%USE_IP_RESET_D%
IF "%USE_NETWORK_RESET_FAST%"=="" SET USE_NETWORK_RESET_FAST=%USE_NETWORK_RESET_FAST_D%
IF "%USE_NETWORK_RESET%"=="" SET USE_NETWORK_RESET=%USE_NETWORK_RESET_D%
IF "%USE_RESET_ROUTE_TABLE%"=="" SET USE_RESET_ROUTE_TABLE=%USE_RESET_ROUTE_TABLE_D%
IF "%TREAT_TIMEOUTS_AS_DISCONNECT%"=="" SET TREAT_TIMEOUTS_AS_DISCONNECT=%TREAT_TIMEOUTS_AS_DISCONNECT_D%
IF "%ONLY_ONE_NETWORK_NAME_TEST%"=="" SET ONLY_ONE_NETWORK_NAME_TEST=%ONLY_ONE_NETWORK_NAME_TEST_D%
IF "%OS_DETECT_OVERRIDE%"=="" SET OS_DETECT_OVERRIDE=%OS_DETECT_OVERRIDE_D%
GOTO :EOF

:SETTINGS_VIEW_PRESET01
CALL :HEADER
ECHO  *Normal Run to Fix*
ECHO.
ECHO Assumes the user only wishes to run this script when
ECHO the network connection needs to be fixed 
ECHO -no connection monitoring
ECHO -tests connection to make sure it needs to be fixed
ECHO.
ECHO.
ECHO What would you like to do?
ECHO -Use this preset       [1]
ECHO -View next preset      [N]
ECHO -Cancel                [X]
SET usrInput=
SET /P usrInput=[1/N/X] 
IF /I "%usrInput%"=="X" SET usrInput=&GOTO :SETTINGS_SELECT_PRESET
IF /I "%usrInput%"=="N" SET usrInput=&GOTO :SETTINGS_VIEW_PRESET02
IF /I "%usrInput%"=="" GOTO :SETTINGS_PRESET01
IF /I "%usrInput%"=="1" SET usrInput=&GOTO :SETTINGS_PRESET01
GOTO :SETTINGS_VIEW_PRESET01

:SETTINGS_VIEW_PRESET02
CALL :HEADER
ECHO  *Advanced Run to Fix*
ECHO.
ECHO Assumes the user only wishes to run this script when
ECHO the network connection needs to be fixed 
ECHO -no connection monitoring
ECHO -Does NOT check connection before fixing
ECHO -Shows advanced output
ECHO.
ECHO.
ECHO What would you like to do?
ECHO -Use this preset       [1]
ECHO -View next preset      [N]
ECHO -Cancel                [X]
SET usrInput=
SET /P usrInput=[1/N/X] 
IF /I "%usrInput%"=="X" SET usrInput=&GOTO :SETTINGS_SELECT_PRESET
IF /I "%usrInput%"=="N" SET usrInput=&GOTO :SETTINGS_VIEW_PRESET03
IF /I "%usrInput%"=="" GOTO :SETTINGS_PRESET02
IF /I "%usrInput%"=="1" SET usrInput=&GOTO :SETTINGS_PRESET02
GOTO :SETTINGS_VIEW_PRESET02

:SETTINGS_VIEW_PRESET03
CALL :HEADER
ECHO  *Normal Connection Monitoring*
ECHO.
ECHO Assumes user wants connection fixed if connection is
ECHO disrupted anytime while this is running
ECHO -Connection monitoring
ECHO -Attempts to fix connection automatically
ECHO.
ECHO.
ECHO What would you like to do?
ECHO -Use this preset       [1]
ECHO -View next preset      [N]
ECHO -Cancel                [X]
SET usrInput=
SET /P usrInput=[1/N/X] 
IF /I "%usrInput%"=="X" SET usrInput=&GOTO :SETTINGS_SELECT_PRESET
IF /I "%usrInput%"=="N" SET usrInput=&GOTO :SETTINGS_VIEW_PRESET04
IF /I "%usrInput%"=="" GOTO :SETTINGS_PRESET03
IF /I "%usrInput%"=="1" SET usrInput=&GOTO :SETTINGS_PRESET03
GOTO :SETTINGS_VIEW_PRESET03

:SETTINGS_VIEW_PRESET04
CALL :HEADER
ECHO  *Advanced Connection Monitoring*
ECHO.
ECHO Assumes user wants connection fixed if connection is
ECHO disrupted anytime while this is running
ECHO -Connection monitoring
ECHO -Attempts to fix connection automatically
ECHO -Shows advanced output
ECHO.
ECHO.
ECHO What would you like to do?
ECHO -Use this preset       [1]
ECHO -View next preset      [N]
ECHO -Cancel                [X]
SET usrInput=
SET /P usrInput=[1/N/X] 
IF /I "%usrInput%"=="X" SET usrInput=&GOTO :SETTINGS_SELECT_PRESET
IF /I "%usrInput%"=="N" SET usrInput=&GOTO :SETTINGS_VIEW_PRESET01
IF /I "%usrInput%"=="" GOTO :SETTINGS_PRESET04
IF /I "%usrInput%"=="1" SET usrInput=&GOTO :SETTINGS_PRESET04
GOTO :SETTINGS_VIEW_PRESET04

:SETTINGS_PRESET01
REM Normal Run to Fix
SET MINUTES=10
::SET NETWORK=Wireless Network Connection
SET CONTINUOUS=0
SET AUTO_RETRY=1
SET AUTOUPDATE=1
SET UPDATECHANNEL=%UPDATECHANNEL_D%
SET CHECKUPDATEFREQ=5
SET CHECK_DELAY=1
SET SHOW_ALL_ALERTS=1
SET SHOW_ADVANCED_TESTING=0
SET SLWMSG=0
SET TIMER_REFRESH_RATE=1
SET START_AT_LOGON=1
SET START_MINIMIZED=1
SET USELOGGING=0
SET OMIT_USER_INPUT=0
SET SKIP_INITIAL_NTWK_TEST=0
SET USE_IP_RESET=1
SET USE_NETWORK_RESET_FAST=1
SET USE_NETWORK_RESET=1
SET USE_RESET_ROUTE_TABLE=0
SET TREAT_TIMEOUTS_AS_DISCONNECT=1
SET ONLY_ONE_NETWORK_NAME_TEST=1
SET OS_DETECT_OVERRIDE=0
GOTO :EOF

:SETTINGS_PRESET02
REM Advanced Run to Fix
SET MINUTES=10
::SET NETWORK=Wireless Network Connection
SET CONTINUOUS=0
SET AUTO_RETRY=1
SET AUTOUPDATE=1
SET UPDATECHANNEL=%UPDATECHANNEL_D%
SET CHECKUPDATEFREQ=5
SET CHECK_DELAY=1
SET SHOW_ALL_ALERTS=1
SET SHOW_ADVANCED_TESTING=1
SET SLWMSG=0
SET TIMER_REFRESH_RATE=1
SET START_AT_LOGON=1
SET START_MINIMIZED=1
SET USELOGGING=1
SET OMIT_USER_INPUT=0
SET SKIP_INITIAL_NTWK_TEST=1
SET USE_IP_RESET=1
SET USE_NETWORK_RESET_FAST=1
SET USE_NETWORK_RESET=1
SET USE_RESET_ROUTE_TABLE=0
SET TREAT_TIMEOUTS_AS_DISCONNECT=1
SET ONLY_ONE_NETWORK_NAME_TEST=1
SET OS_DETECT_OVERRIDE=0
GOTO :EOF

:SETTINGS_PRESET03
REM Normal Connection Monitoring
SET MINUTES=10
::SET NETWORK=Wireless Network Connection
SET CONTINUOUS=1
SET AUTO_RETRY=1
SET AUTOUPDATE=1
SET UPDATECHANNEL=%UPDATECHANNEL_D%
SET CHECKUPDATEFREQ=5
SET CHECK_DELAY=1
SET SHOW_ALL_ALERTS=1
SET SHOW_ADVANCED_TESTING=0
SET SLWMSG=0
SET TIMER_REFRESH_RATE=1
SET START_AT_LOGON=1
SET START_MINIMIZED=1
SET USELOGGING=0
SET OMIT_USER_INPUT=0
SET SKIP_INITIAL_NTWK_TEST=0
SET USE_IP_RESET=1
SET USE_NETWORK_RESET_FAST=1
SET USE_NETWORK_RESET=1
SET USE_RESET_ROUTE_TABLE=0
SET TREAT_TIMEOUTS_AS_DISCONNECT=1
SET ONLY_ONE_NETWORK_NAME_TEST=1
SET OS_DETECT_OVERRIDE=0
GOTO :EOF

:SETTINGS_PRESET04
REM Advanced Connection Monitoring
SET MINUTES=10
::SET NETWORK=Wireless Network Connection
SET CONTINUOUS=1
SET AUTO_RETRY=1
SET AUTOUPDATE=1
SET UPDATECHANNEL=%UPDATECHANNEL_D%
SET CHECKUPDATEFREQ=5
SET CHECK_DELAY=1
SET SHOW_ALL_ALERTS=1
SET SHOW_ADVANCED_TESTING=1
SET SLWMSG=0
SET TIMER_REFRESH_RATE=1
SET START_AT_LOGON=1
SET START_MINIMIZED=1
SET USELOGGING=1
SET OMIT_USER_INPUT=0
SET SKIP_INITIAL_NTWK_TEST=0
SET USE_IP_RESET=1
SET USE_NETWORK_RESET_FAST=1
SET USE_NETWORK_RESET=1
SET USE_RESET_ROUTE_TABLE=0
SET TREAT_TIMEOUTS_AS_DISCONNECT=1
SET ONLY_ONE_NETWORK_NAME_TEST=1
SET OS_DETECT_OVERRIDE=0
GOTO :EOF

:SETTINGS_EXPORT
CALL :SETTINGS_CHECKALL
:SETTINGS_EXPORTONLY
IF "%SETNFileDir%"=="TEMP" GOTO :EOF
IF "%USE_ALTERNATE_SETTINGS%"=="1" GOTO :EOF
CALL :HEADER
IF "%SETNFileDir%"=="" ECHO ERROR: No Setting file location selected.
IF "%SETNFileDir%"=="" ECHO Cannot export settings
IF "%SETNFileDir%"=="" ECHO Press any key to restart the program...
IF "%SETNFileDir%"=="" PAUSE>NUL
IF "%SETNFileDir%"=="" GOTO :RESTART_PROGRAM
SET currently1=Exporting Settings...
SET currently2=
SET TimerStatus=
CALL :STATS
IF "%SIMULATE%"=="1" GOTO :SETTINGS_EXPORT_SKIP
TYPE NUL>"%SETNFileDir%%SettingsFileName%.BAT"
DEL /F "%SETNFileDir%%SettingsFileName%.BAT"
(ECHO IF "%%1"=="" START /B CMD /C "%THISFILENAMEPATH%" SETTINGS)>>"%SETNFileDir%%SettingsFileName%.BAT"
(ECHO SET MINUTES=^%MINUTES%)>>"%SETNFileDir%%SettingsFileName%.BAT"
(ECHO SET NETWORK=^%NETWORK%)>>"%SETNFileDir%%SettingsFileName%.BAT"
(ECHO SET CONTINUOUS=^%CONTINUOUS%)>>"%SETNFileDir%%SettingsFileName%.BAT"
(ECHO SET AUTO_RETRY=^%AUTO_RETRY%)>>"%SETNFileDir%%SettingsFileName%.BAT"
(ECHO SET AUTOUPDATE=^%AUTOUPDATE%)>>"%SETNFileDir%%SettingsFileName%.BAT"
(ECHO SET UPDATECHANNEL=^%UPDATECHANNEL%)>>"%SETNFileDir%%SettingsFileName%.BAT"
(ECHO SET CHECKUPDATEFREQ=^%CHECKUPDATEFREQ%)>>"%SETNFileDir%%SettingsFileName%.BAT"
(ECHO SET CHECK_DELAY=^%CHECK_DELAY%)>>"%SETNFileDir%%SettingsFileName%.BAT"
(ECHO SET SHOW_ALL_ALERTS=^%SHOW_ALL_ALERTS%)>>"%SETNFileDir%%SettingsFileName%.BAT"
(ECHO SET SHOW_ADVANCED_TESTING=^%SHOW_ADVANCED_TESTING%)>>"%SETNFileDir%%SettingsFileName%.BAT"
(ECHO SET SLWMSG=^%SLWMSG%)>>"%SETNFileDir%%SettingsFileName%.BAT"
(ECHO SET TIMER_REFRESH_RATE=^%TIMER_REFRESH_RATE%)>>"%SETNFileDir%%SettingsFileName%.BAT"
(ECHO SET START_AT_LOGON=^%START_AT_LOGON%)>>"%SETNFileDir%%SettingsFileName%.BAT"
(ECHO SET START_MINIMIZED=^%START_MINIMIZED%)>>"%SETNFileDir%%SettingsFileName%.BAT"
(ECHO SET OMIT_USER_INPUT=^%OMIT_USER_INPUT%)>>"%SETNFileDir%%SettingsFileName%.BAT"
(ECHO SET SKIP_INITIAL_NTWK_TEST=^%SKIP_INITIAL_NTWK_TEST%)>>"%SETNFileDir%%SettingsFileName%.BAT"
(ECHO SET USE_IP_RESET=^%USE_IP_RESET%)>>"%SETNFileDir%%SettingsFileName%.BAT"
(ECHO SET USE_NETWORK_RESET_FAST=^%USE_NETWORK_RESET_FAST%)>>"%SETNFileDir%%SettingsFileName%.BAT"
(ECHO SET USE_NETWORK_RESET=^%USE_NETWORK_RESET%)>>"%SETNFileDir%%SettingsFileName%.BAT"
(ECHO SET USE_RESET_ROUTE_TABLE=^%USE_RESET_ROUTE_TABLE%)>>"%SETNFileDir%%SettingsFileName%.BAT"
(ECHO SET TREAT_TIMEOUTS_AS_DISCONNECT=^%TREAT_TIMEOUTS_AS_DISCONNECT%)>>"%SETNFileDir%%SettingsFileName%.BAT"
(ECHO SET ONLY_ONE_NETWORK_NAME_TEST=^%ONLY_ONE_NETWORK_NAME_TEST%)>>"%SETNFileDir%%SettingsFileName%.BAT"
(ECHO SET OS_DETECT_OVERRIDE=^%OS_DETECT_OVERRIDE%)>>"%SETNFileDir%%SettingsFileName%.BAT"
:SETTINGS_EXPORT_SKIP
GOTO :EOF


:SETTINGS_LOAD
CALL %THISFILEDIR%%SettingsFileName%.BAT LOAD
GOTO :EOF

REM EOF