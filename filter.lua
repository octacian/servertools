-- mods/servertools/filter.lua
--[[ language filter to automatically kick and or ban players.]]--

-- load phrase table
local word = servertools.load_table(st.modpath.."/phrase.db")

-- if warnable word is used
for i, phrase in ipairs(word) do
  if phrase.type == "warn" then
    minetest.register_on_chat_message(function(name, message)
      local msg = message:lower()
      -- ignore commands
      if message:sub(1, 1) ~= "/" then
        -- filter for word(s)
        if msg:find(phrase.word) ~= nil then
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
        if msg:find(phrase.word) ~= nil then
          -- kick player
          minetest.kick_player(name, "Please use only appropriate and clean language in the public chat. Players, especially those that are younger, do not need to be hearing or using such language.")
          minetest.chat_send_all("*** Kicked "..name.." for using innappropriate language.") -- print to chat
          minetest.log("action", "[ServerTools] Kicked "..name.." for using innappropriate language.") -- print to log
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
        if msg:find(phrase.word) ~= nil then
          -- ban player
          xban.ban_player(name, "servertools:filter", "5h", "Please use only appropriate and clean language in the public chat. Players, especially those that are younger, do not need to be hearing or using such language.")
          minetest.chat_send_all("*** Banned"..name.." for using innappropriate language (5 hour ban).") -- print to chat
          minetest.log("action", "[ServerTools] Banned "..name.." for using innappropriate language (5 hour ban).") -- print to log
          return true -- prevent message from showing in chat
        end
      end
    end)
  end
end
