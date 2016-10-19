# Rank Module
Module allowing custom and pre-defined ranks to be given or removed from a player. Chat messages are prefixed with the player's rank. Privileges are automatically granted and revoked upon rank set.

## Defining and Customizing Ranks
The definitions for ranks are all found in a single file called `rank.conf` found in the mod folder. Here you can customize predefined ranks, or even add your own. Everything is in a simple Lua table, making it easy to work with.

All the ranks are stored in a table called `st.ranks`. Here we will use the "moderator" rank for example:

```
-- moderator
  { name = "moderator", level = 2, prefix = "[moderator]", colour = "#f1c40f", cmd = "mod", privs = {
    interact = true,
    shout = true,
    fast = true,
    kick = true,
    ban = true,
    servertools = true,
    heal = true,
    teleport = true,
    bring = true,
  }, can = {
    "getrank",
  }, },
```

The first line, `-- moderator`, is an unrequired comment telling what class is being registered. In between the opening and closing `{`, is the actual information. Name defines the name of the class, within either single or double quotes. The level is very important, as it helps ServerTools understand if a player is of the highest level, or not. The level is used to decide whether a player with the `setrank` capability can change their rank to the desired entry. Whenever a player whose rank has a prefix sends a chat message, the prefix will appear to others (but not themself) at the beginning of their message, styled with the hex code specified in `colour`.

`cmd` allows you to specify a special command for quickly setting the rank of any player to, in this case, moderator. For example, if an admin with the `setrank` capability ran `/mod <playername>`, the player specified would receive the rank. Running the command again will not remove the rank, and the server admin must run `/rank <playername> <rankname>` to give them a lower ranking.

In the `privs` sub-table, all of the privileges for players of that rank can be found. Each privilege is on a new line, with a comma at the end of each line (even the last). There should be no capitals, and each line should end with ` = true` (e.g. `fly = true,`). Setting it to be false, will not give the rank that privilege.

Capabilities are integral to the higher-level ranks, as they allow players of that rank to execute important functions such as getting or setting the rank of a player. The `can` sub-table somewhat resembles that of `privs`, but is quite different. Each capability should be listed (with no capitals) on a new line, each line ending in a comma. However, the capability name should be surrounded with single or double quotes and lines do not need to end with true or false.

## Commands
### rank
Return rank of player executing command to the player.

| Capability | Config Option | Source        |
| ---------- | ------------- | ------------- |
| none       | `rank`        | `rank.lua`    |

### parameter: <player>
Get the rank of a player and return to the player executing the command.

| Extra Capabilities |
| ------------------ |
| `getrank`          |

### parameter: <player> <newrank>
Set the rank of a player.

| Extra Capabilities |
| ------------------ |
| `setrank`          |

## API
The API section documents functions that can be accessed from other mods. All functions below depend on the `ranking` module.

### get_player_rank
**Usage:**  `servertools.get_player_rank(name)`

Returns the rank of player specified by `name`.

### get_rank_privs
**Usage:** `servertools.get_rank_privs(rank)`

Returns the privileges of the rank (`rank`) as a table.

### get_rank_level
**Module:** `ranking`
**Usage:** `servertools.get_rank_level(rank)`

Returns integer value indicating the rank (`rank`).

### get_rank_high
**Usage:** `servertools.get_rank_high(list)`

Returns the highest levelled rank in a list, the default list being found in the table variable `st.ranks`.

### get_rank_value
**Module:** `ranking`
**Usage:** `servertools.get_rank_value(rank, value)`

Get any value (`value`) for a rank (`rank`).

### player_can
**Module:** `ranking`
**Usage:** `servertools.player_can(player, capability)`

Check if a player (`player`) has a specific capability (`capability`).

### set_player_rank
**Module:** `ranking`
**Usage:** `servertools.set_player_rank(from, name, newrank)`

Set the rank (`newrank`) of a player (`name`). **Note:** `from` must contain the name of a valid player to check that they have permission to run the function.
