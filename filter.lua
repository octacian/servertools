-- mods/servertools/filter.lua
--[[ language filter to automatically kick and or ban players. ]]--

--[[
___ ___ _  _ ___
| __|_ _| \| |   \
| _| | || .` | |) |
|_| |___|_|\_|___/

]]

-- [function] find in string
local function find_word(str, word)
  if not str and not word then return end -- something's wrong

  -- [loop] each word in str
  for iword in str:gmatch("%w+") do
    if iword == word then return true end
  end
end

--[[
__  __   _   ___ _  _
|  \/  | /_\ |_ _| \| |
| |\/| |/ _ \ | || .` |
|_|  |_/_/ \_\___|_|\_|

]]

-- load phrase table
local word = datalib.table.read(st.modpath.."/phrase.db")

-- if warnable word is used
for i, phrase in ipairs(word) do
  if phrase.type == "warn" then
    minetest.register_on_chat_message(function(name, message)
      local msg = message:lower()
      -- ignore commands
      if message:sub(1, 1) ~= "/" then
        -- filter for word(s)
        if find_word(msg, phrase.word) ~= nil then
          -- warn player
          minetest.chat_send_player(name, 'Please do not use emotional words, including "'..phrase.word..'," in the chat.')
          return true -- prevent message from showing in chat
        end
      end
    end)
  end
end

-- if kickable word is used
for i, phrase in ipairs(word) do
  if phrase.type == "kick" then
    minetest.register_on_chat_message(function(name, message)
      local msg = message:lower()
      -- ignore commands
      if message:sub(1, 1) ~= "/" then
        -- filter for word(s)
        if find_word(msg, phrase.word) ~= nil then
          -- kick player
          minetest.kick_player(name, 'Please do not use emotional or innappropriate words, including "'..phrase.word..'," in the chat.')
          minetest.chat_send_all("*** Kicked "..name.." for using innappropriate language.") -- print to chat
          servertools.log("Kicked "..name.." for using innappropriate language.") -- print to log
          return true -- prevent message from showing in chat
        end
      end
    end)
  end
end

-- if banable word is used
for i, phrase in ipairs(word) do
  if phrase.type == "ban" then
    minetest.register_on_chat_message(function(name, message)
      local msg = message:lower()
      -- ignore commands
      if message:sub(1, 1) ~= "/" then
        -- filter for word(s)
        if find_word(msg, phrase.word) ~= nil then
          -- ban player
          xban.ban_player(name, "servertools:filter", "5h", 'Used emotional or innappropriate words, including "'..phrase.word..'," in the chat.')
          minetest.chat_send_all("*** Banned"..name.." for using innappropriate language (5 hours).") -- print to chat
          servertools.log("Banned "..name.." for using innappropriate language (5 hours).") -- print to log
          return true -- prevent message from showing in chat
        end
      end
    end)
  end
end

servertools.log("Filter Module Loaded")
