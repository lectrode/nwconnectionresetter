# Network Connection Resetter #

## Batch file to Monitor and Reset Network Connection ##
## OS: Windows XP,Vista,7 and Windows Server 2003,2008 ##
<br />
_Please check out my **[Quick Net Fix](https://code.google.com/p/quick-net-fix/)**, as that script has superseded this one in nearly all aspects, including compatibility with older and newer Windows systems_
<br />
This is a program I started making in February 2011. The reason I made this was because the school I was at had a flawed wireless network setup. I believe the fault lied with the routers they use.

The problem is thus:
If you use the wireless network, you will frequently get kicked off (and by frequently I mean multiple times a day)(and by "kicked off" I mean switched to "Limited network connectivity" (no internet access)). This problem occurs even when the laptop/computer is stationary. It will not allow you to reconnect.

Questions and comments are welcome =)




## Latest Release (v16.1): ##
### New Main Features! ###

  * **Automatic or Manual Self-Update**
    * Your choice of 3 update "Channels" - Stable, Beta, Dev


  * **Improved `StartUp` method**
    * New `StartUp` Launcher immediately starts program minimized if set to do so
    * If script not run with `StartUp` launcher, user is given option of configuring the settings, even in Continuous mode

For more changes please view the [v16.1 Changelog](http://code.google.com/p/nwconnectionresetter/downloads/detail?name=Network_Resetter_v16_1.bat)


### Attempted Fixes: ###
  * **Quick disable and re-enable of your network adapter**
    * This will occasionally fix the connection


  * **Reset IP Address**
    * This will also occasionally fix the problem. Disable this if you use multiple network connections at the same time!


  * **If the first 2 solutions don't work, it disables the network adapter, waits 10 minutes, and re-enables it**
    * This solution works 99% of the time, but since it takes so long it is tried last.

  * **4th fix (disabled by default): Reset Route Table**
    * This fix is only attempted if it gets "Destination Host Unreachable" errors AND this fix is enabled via the settings.


### Additional Features ###

  * settings are editable via the program GUI`*`
  * ability to choose from 4 different setting presets
  * option for storing settings in main batch file (not editable via the GUI`*`)
  * settings are stored in external file located in (place of your choice):
    1. `%SystemDrive%\NWResetter\`
    1. `%AppData%\NWResetter\`
      * Win7: `C:\Users\YourUser\AppData\Roaming`
      * WinXP: `C:\Documents and Settings\YourUser\Application Data`


  1. Same folder as `Network_Resetter.bat`





## Future Features: ##


  * support for monitoring and fixing multiple network connections ([issue 8](https://code.google.com/p/nwconnectionresetter/issues/detail?id=8))
  * Built-In FAQ ([issue 26](https://code.google.com/p/nwconnectionresetter/issues/detail?id=26))






NOTE: in this context, GUI means text shown on screen via command prompt