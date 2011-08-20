:: -----Program Info-----
:: Name: 		Network Resetter
::
:: Verson:		3.1.251
::
:: Description:	Fixes network connection by trying each of the following:
::				1) Reset IP Address
::				2) Disable connection, wait specified time, re-enable connection
::
:: Author:		Lectrode (http://electrodexs.net)
::
:: Notes:		Make sure the settings below are correct BEFORE
::				you run the program. (default settings should be
::				good for computers running Vista and Windows 7 and
::				using the default wireless connection)
::
::				If after running the program it still won't connect, try
::				increasing the number of minutes to wait.
::
::				If you close the program early, your network connection
::				will still be disabled. To fix this, re-run this program.
::				You can set MINUTES to 0 for a quick run.
::
::				The constant "Pinging 127.0.0.1 with 32 bits of data..."
::				is normal. It is the only way that this program language
::				can "sleep" or pause for a few seconds
::
:: Disclaimer:	This program is provided "AS-IS" and the author has no
::				responsibility for what may happen to your computer.
::				Use at your own risk.



:: -----Settings------

:: Number of minutes to wait before re-enabling
:: the network adapter (5-15 reccomended)
:: Integers Only! (aka "0" or "1"   NOT  "1.5")
SET MINUTES=15

:: Name of the Network to be reset
:: Network connections on your computer can be found at
:: Control Panel\Network and Internet\Network Connections
SET NETWORK=Wireless Network Connection


:: CONTINUOUS MODE - Constant check and run (BETA)
::  "1" for True, "0" for false
:: Program will constantly run and will check your connection
:: every few minutes to ensure you are connected. If it 
:: detects that you have been disconected, it will automatically
:: attempt to repair your connection. If attempt fails, it will
:: keep retrying until it succeeds.
SET CONTINUOUS=1

:: If CONTINUOUS is set to 1, this is how many minutes between
:: connection tests.
SET CHECKDELAY=3

:: Programmer Tool - Debugging
::  "1" for True, "0" for false
:: Debugging mode disables actual functionality of this 
:: program (aka it won't fix your connection when debugging)
SET DEBUGN=0







:: ************ DON'T EDIT ANYTHING BEYOND THIS POINT! *************

:: --------Main Code---------

::Output only what program tells it to with "ECHO"
@echo off

:: Set CMD window size
mode con cols=81 lines=30

::Display program introduction (this is non-interactive program yada yada)
::Called twice to last longer
CALL :ProgramIntro
CALL :ProgramIntro

::Test internet connection
::(called only if not Debugging)
IF %DEBUGN%==0 CALL :Test


::":FIX" is called if ":Test" fails
:FIX

::Call the fix methods
::Each mothod calls ":Test" after it runs
CALL :MainCodeResetIP
CALL :MainCodeNetworkReset

::If it gets here, none of the fixes above worked
GOTO :FAILED


::MainCodeResetIP method
:MainCodeResetIP

::Set & Display Status
SET currently=Releasing IP Address
CALL :Stats

::Release IP Address
IF %DEBUGN%==0 IPCONFIG /RELEASE

::Set & Display Status
SET currently=Flushing DNS Cache
CALL :Stats

::Flush DNS Cache
IF %DEBUGN%==0 IPCONFIG /FLUSHDNS

::Set & Display Status
SET currently=Renewing IP Address
CALL :Stats

::Renew IP Address
IF %DEBUGN%==0 IPCONFIG /RENEW

::Test internet connection
::(called only if not Debugging)
IF %DEBUGN%==0 CALL :Test

::If it gets here, Resetting IP didn't fix the problem
SET currently=Resetting IP did not fix the problem
CALL :Stats

::End of MainCodeResetIP method
GOTO :EOF



::Method for Network Connection Reset
:MainCodeNetworkReset

::Disable network connection
CALL :DisableNW

::Set and Display status
SET currently=Waiting to re-enable "%Network%"
CALL :Stats

::Cycle through updating time until limit is reached
::limit is stored in delaymins
SET delaymins=%MINUTES%
CALL :WAIT

::Once done waithing, Enable network connection
CALL :EnableNW

::Test internet connection
::(called only if not Debugging)
IF %DEBUGN%==0 CALL :Test

::Calculate Minutes to be displayed
SET /A MINUTES="TTLSCNDS/60"

::Set and Display Status
SET currently=Waiting %MINUTES% minutes did not fix the problem
CALL :Stats

::END of Network Reset Method
GOTO :EOF

:: ":Test" Method
:TEST
::First Test
PING -n 1 www.google.com|find "Reply from " >NUL
IF NOT ERRORLEVEL 1 goto :SUCCESS
::First test failed, wait 3 seconds
CALL :Pinger
::Second Test
PING -n 1 www.google.com|find "Reply from " >NUL
IF NOT ERRORLEVEL 1 goto :SUCCESS
::Second Test failed. Go back to 
::where ":Test" was called from
GOTO :EOF

::Display Program Introduction Method
:ProgramIntro
CLS
ECHO  ******************************************************************************
ECHO  *                                                                            *
ECHO  *                                                                            *
ECHO  *                  *Settings can be changed via Notepad                      *
ECHO  *                                                                            *
ECHO  *                                                                            *
ECHO  ******************************************************************************
ECHO `
ECHO `
PING 127.0.0.1
GOTO :EOF

:Stats
CLS
					ECHO  ******************************************************************************
					ECHO  *      ******   Lectrode's Network Connection Resetter v3.1.251   ******     *
					ECHO  ******************************************************************************
IF %DEBUGN%==1 		ECHO  *          *DEBUGGING ONLY! Set DEBUGN to 0 to reset connection*             *
IF %CONTINUOUS%==1 	ECHO  *                                                                            *
IF %CONTINUOUS%==1 	ECHO  *                              *Continuous Mode*                             *
					ECHO  *                                                                            *
					ECHO  * Connection:    "%NETWORK%"
					ECHO  *                                                                            *
					ECHO  * Current State: %currently%
					ECHO  *                                                                            *
					ECHO  * %SpecificStatus%
					ECHO  *                                                                            *
					ECHO  ******************************************************************************
IF %DEBUGN%==1 CALL :Pinger
GOTO :EOF



:DisableNW
SET currently=Disabling "%Network%"
CALL :Stats

IF %DEBUGN%==0 netsh interface set interface "%NETWORK%" DISABLE
SET currently="%Network%" Disabled
CALL :Stats
GOTO :EOF


:Pinger
PING 127.0.0.1
GOTO :EOF

:WAIT

::calculate number of PINGS
SET /A PINGS="(delaymins*60)/3"

::Calculate total time
SET /A TTLSCNDS="PINGS*3"
SET /A HOURS="(TTLSCNDS/3600)"
SET /A MINUTES="(TTLSCNDS-(HOURS*3600))/60"
SET /A SECONDS="TTLSCNDS-((HOURS*3600)+(MINUTES*60))"

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

::Set MINUTES to "","##:", "00:", or "0#:"
::(always 2 digits or nothing)
::(always 2 digits if HOURS>0)
IF %MINUTES%==0 (
	IF "%HOURS%"=="" (
		SET MINUTES= 
	) ELSE (
		SET MINUTES=00:
	)
) ELSE (
	IF %MINUTES% LEQ 9 (
	SET MINUTES=0%MINUTES%:
	) ELSE (
	SET MINUTES=%MINUTES%:
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
	IF %mins% LEQ 9 (
	SET mins=0%mins%:
	) ELSE (
	SET mins=%mins%:
	)
)

::Set SECONDS to "##" or "0#"
::(always 2 digits)
IF %scnds% LEQ 9 SET scnds=0%scnds%

::Update TimeStamp
SET SpecificStatus=Time Left:  %hrs%%mins%%scnds% of %HOURS%%MINUTES%%SECONDS%

::Displays status on screen
CALL :Stats

::Closest thing BATCH files have to "sleep"
CALL :Pinger

::Cycle through "WAITING" again if waiting time 
::has not been reached
IF %ticker% LEQ %PINGS% ( GOTO :WAITING )
GOTO :EOF


:EnableNW
SET currently=Enabling "%Network%"
SET SpecificStatus= 
CALL :Stats

IF %DEBUGN%==0 netsh interface set interface "%NETWORK%" ENABLE
SET currently="%Network%" Enabled
CALL :Stats
GOTO :EOF



:FAILED
SET currently=Unable to Connect to Internet.
SET SpecificStatus= 
IF %CONTINUOUS%==1 SET currently=Unable to Connect to Internet (Retrying...)
CALL :Stats
IF %CONTINUOUS%==1 CALL :Pinger
IF %CONTINUOUS%==1 GOTO :FIX
SET /P goAgain=Retry? (y or n)
IF NOT %goAgain%==y EXIT
GOTO :FIX

:SUCCESS
IF %CONTINUOUS%==0 SET currently=Successfully Connected to Internet. EXITING...
IF %CONTINUOUS%==1 SET currently=Successfully Connected to Internet.
SET SpecificStatus= 
CALL :Stats
CALL :Pinger
IF %CONTINUOUS%==1 SET currently=Connected to Internet. Waiting to re-check...
IF %CONTINUOUS%==1 CALL :Stats
IF %CONTINUOUS%==1 SET delaymins=%CHECKDELAY%
IF %CONTINUOUS%==1 CALL :WAIT
IF %CONTINUOUS%==1 GOTO :TEST
IF %DEBUGN%==1 PAUSE
EXIT

