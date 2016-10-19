# ServerTools API
This documentation is also available at the official [ServerTools Wiki](https://endev.xyz/octacian/servertools/wiki). Divided into several parts, one for each main topic, this documentation includes all functions available for use from other mods.

**Note:** instead of using the prefix `servertools` when calling any of the functions or variables documented below, you may use `st.`

## Global Variables
Variables available for use within functions documented in the below sections. Note that the prefix `servertools` can be replaced with `st` as with available functions.

* `servertools` : defines modname for global functions
* `st` : points to `servertools`
* `servertools.modpath` : ServerTools Modpath for use with the dmAPI of datalib.
* `servertools.worldpath` : path of current world for use with the dmAPI of datalib.
* `servertools.datapath` : `servertools` folder within the world path for use with the dmAPI or datalib. It is recommended that you store general data within this folder rather than cluttering the root world directory.

## API Functions
Functions available from another mod. When the `name` field is required, provide some identification of where the function was run. Normally this would be a player username, however, when not triggered by a player the value should be as follows: `modname:callback_location`.

### clearinv
**Usage:** `servertools.clearinv(name, player)`

Clear the inventory of any `player`. Called in chatcommand `/clear` (`misc.lua`). Function requires no privileges, and triggers a detailed log.

### get_ip
**Usage:** `servertools.get_ip(name, player)`

Get the public IP address of any `player`. This function could be exploited by malicious users if improperly implemented.

### update_node
**Usage:** `servertools.update_node(name, <new_nodestring> <x> <y> <z>)`

Sets the node at coordinates to the specified item string. Do not put commas between parameters, and the new itemstring may only point to a node (not a tool or item). Entering incorrect data triggers a detailed error log. Be careful with this function, as it can destroy and place nodes without warning.
