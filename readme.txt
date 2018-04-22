WRUGS 1.1.4 Beta

Website: www.wow-durance.com
Author: Spare
Author Realm: EU-Defias Brotherhood

Addon Description:
WRUGS is a whisper authentication addon for World of Warcraft. This addon is mainly
created as an addon against gold spammers, but aswell as a project to learn lua for me.
But as everyone can make a mistake, there might be any bug in the addon. If you find 
any bug, or error message, please make a screenshot and PM it to me. 

Trust me, you won't get any gold spam whisper until there's anything made against this 
addon.

WRUGS will basically block any whisper you will receive, but to make it a bit more doable
it will not block the following players:
  - Players from your guild
  - Players from your party
  - Players from your raid
  - Players from your friendslist
  - NPCs
  - Gamemasters

The blocked player will receive a message that will tell the command to authenticate with
WRUGS. The command the player has to send you, is WRUGS by default, but can be set to 
anything you like with the /wrugs setpass command.

Commandlist:
  /wrugs                        -- This command will show the status of WRUGS.
  /wrugs setpass [New Pass]	-- This command will set a new authentication password.
  /wrugs hidepass               -- This command will toggle the function to hide the password.
                                      at your automatic reply when a player is not authenticated yet.
                                      Using this command will toggle it on/off.
  /wrugs privacy                -- This is the same idea as the hidepass command, but won't allow
                                      authentication while enabled. Using this command will toggle it on/off.
  /wrugs add [Playername]       -- With this command you can manually authenticate players.
  /wrugs remove [Playername]    -- With this command you can manually remove players from your whitelist.
  /wrugs purgeplayers           -- WARNING! This command will purge the complete whitelist.
  /wrugs purgehistory           -- WARNING! This command will purge the complete block history.
  /wrugs [On/Off]               -- This command will turn on/off WRUGS.

************************* Changelog *************************

BETA 1.1.4
 - German localization added (thanks to Saphyron).
 - French localization added (thanks to Scrapy).
 - Missing guildcheck fixed.
 - Local authentication message fixed.
 - WRUGS now supports Chatr.

RELEASE 1.1.3
 - WRUGS now supports La Vendetta Bossmods.

RELEASE 1.1.2
 - The function to hide your authentication password will now aswell work while the privacy function is disabled.
 - The WRUGS+WIM combination is now working properly with players from your party/raid/friendslist/guild and GM's.
 - WRUGS will no longer block messages while it's disabled with the WRUGS+WIM combination.
 - The chatframes are now always being hooked, which will fix the issue with WRUGS suddenly showing all of the whispers.
 - The /wrugs (status) command will now show the authentication password properly after changing it.
 - Blocklog has been re-added. (No option to view the messages ingame yet)

BETA 1.1.1
 - Variables fixed for new WRUGS users.
 - Privacy function will no longer allow authentication when enabled.

BETA 1.1.0
 - WRUGS code has been redesigned
 - Function added to synchronize authenticated players through the guild (enabled by default, while in a guild)
 - Privacy function added, to block all unknown incoming whispers (disabled by default)
 - Function added to hide the password at the automatic reply (disabled by default)
 - Function added to remove players from the whitelist, and to purge the complete list
 - Function added to purge the list of blocked whispers
 - Localization added to make translations possible
 - Version number was incorrect [FIXED]
 - WIM is now supported

BETA 1.0.3
 - Whispers with itemlinks are no longer being blocked
 - Seeing unauthencated player tells [FIXED]
 - Invalid pattern capture error while using specific messages [FIXED]
 - Unfinished capture error while using specific messages [FIXED]
 - Blocked messages are now being logged at WRUGS.lua

BETA 1.0.2:
 - Added the '/wrugs status' command to check your current version, authentication command and to see if it's enabled/disabled.
 - People that you whisper will be automatically authenticated (excluding automatic whispers).
 - Changed the block message.

BETA 1.0.1:
 - WRUGS addons now succesfully work next to eachother
 - Automatic messages will now be hidden for yourself 
