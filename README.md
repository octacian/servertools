ServerTools [servertools]
=========================
Version 0.2

Licence: MIT (see license.txt)

Useful for servers, and even singleplayer worlds, ServerTools adds several commands allowing you to clear your inventory, heal yourself or another player, and more. This mod is still work in progress, and new features will be added all the time, so read the updating instructions below to make sure you always have the latest version.

As this mod grows and more features are added, the commands section below will be replaced with the [wiki](http://208.69.243.45:3000/octacian/servertools/wiki) through Gogs (http://208.69.243.45:3000/octacian/servertools/wiki).

### Commands
* `/setgenesis`: set the genesis point in your world. Whenever a new player logs in, they will be automatically transprted here. Privileges: `servertools`.
* `/genesis`: go to the genesis point (provided that it has been set). Privileges: none.
* `/clear`: clear your inventory or another player's. Privileges: own inventory = none, another player's = `servertools`.
* `/heal`: heal yourself or another player. Privileges: `heal`.
* `/morning`: set time to morning. Priveleges: `settime`.
* `/noon`: set time to noon. Privileges: `settime`.
* `/evening`: set time to evening. Privileges: `settime`.
* `/night`: set time to night. Privileges: `settime`.
* `/update`: place/update a node at a coordinate. Privileges: `update`.
* `/bring` : bring player to your location. Privileges: `bring`.

### Installation and Updates
Unzip the archive, rename the folder to servertools and place it in `minetest/mods` or in the mods folder of the subgame in which you wish to use ServerTools.

You can also install this mod in the `worldmods` folder inside any world directory to use it only within one world.

For further information or help see:
http://wiki.minetest.com/wiki/Installing_Mods

To update, periodically check the Gogs repository and download either the latest release or the master branch (most up to date, but often unstable).

The mod will soon include an auto update function, which will work on its own so long as you have internet.

**Dependencies:** default (no dependencies)
