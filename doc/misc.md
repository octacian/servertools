# Misc Chatcommands
General chatcommands and the privileges needed to use them. The source for all commands but the first can be found in `misc.lua`, and require the config option `misc = true`.

## /genesis
Go to the Genesis point (spawn point) provided that it has been set.

| Privileges | Config Option | Source        |
| ---------- | ------------- | ------------- |
| none       | `genesis`     | `genesis.lua` |

### parameter: `set`
Set the genesis point (spawn point) for your world. When set, new players will be placed here.

| Extra Privileges |
| ---------------- |
| `servertools`    |

## /clear
Clear you inventory of all items.

| Privileges |
| ---------- |
| none       |

### parameter: `<player>`
Clear the inventory of another player (requires extra privileges).

| Extra Privileges |
| ---------------- |
| `servertools`    |

## /heal
Heal yourself regaining full health.

| Privileges |
| ---------- |
| `heal`     |

### parameter: `<player>`
Heal another player giving them full health (requires no extra privileges).

## [collection] settime
A collection of commands allowing you to quickly change the time. All require the same privilege (`settime`) and use the same config and source.

| Command | Function|
| ------- | --------|
| `/morning` | Set time to morning |
| `noon` | Set time to noon |
| `/night` | Set time to night |
| `/evening` | Set time to evening |

| Privileges|
| ----------|
| `settime` |

## update `<modname:nodename> <x> <y> <z>`
Place or replace a node at the coordinate specified. The update command can only set one node at a time, to set more than one, use worldedit.

| Privileges |
| ---------- |
| `update`   |

## ip `<player>`
Get the IP address of a player. The player must be in the game for the operation to be successful.

| Privileges |
| ---------- |
| `server`   |

## bring `<player>`
Bring a player to the location of the player executing the command. **Note:** the `player` field must be a player username, and cannot be a variable pointing to the player model (if used as a function).

| Privileges |
| ---------- |
| `bring`    |