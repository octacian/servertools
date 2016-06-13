-- mods/servertools/filter.lua
--[[ language filter to automatically kick and or ban players.]]--
-- WARNING: BELOW TABLE CONTAINS EXLICIT LANGUAGE FOR FILTERING PURPOSES

-- warnable
local WARNABLE = {
  { warn = "fudge" },
  { warn = "crap" },
  { warn = "damn" },
  { warn = "danm" },
  { warn = "omg" },
  { warn = "my god" },
}

-- kickable
local KICKABLE = {
  { kick = "fuck" },
  { kick = "fukc" },
  { kick = "fuk" },
  { kick = "shit" },
  { kick = "ass" },
  { kick = "wtf" },
  { kick = "f*ck" },
  { kick = "sh*t" },
  { kick = "bull" },
  { kick = "dick" },
  { kick = "bitch" },
}

-- banable
local BANABLE = {
  { ban = "sex" },
  { ban = "boob" },
  { ban = "breast" },
  { ban = "penis" },
  { ban = "vag" },
  { ban = "pussy" },
}

-- if warnable word is used
for i, word in ipairs(WARNABLE) do
  minetest.register_on_chat_message(function(name, message)
    local msg = message:lower()
    -- ignore commands
    if message:sub(1, 1) ~= "/" then
      -- filter for word(s)
      if msg:find(word.warn) ~= nil then
        -- warn player
        minetest.chat_send_player(name, 'Please do not use emotional words, including "'..word.warn..'," in the chat.')
        return true -- prevent message from showing in chat
      end
    end
  end)
end

-- if kickable word is used
for i, word in ipairs(KICKABLE) do
  minetest.register_on_chat_message(function(name, message)
    local msg = message:lower()
    -- ignore commands
    if message:sub(1, 1) ~= "/" then
      -- filter for word(s)
      if msg:find(word.kick) ~= nil then
        -- kick player
        minetest.kick_player(name, "Please use only appropriate and clean language in the public chat. Players, especially those that are younger, do not need to be hearing or using such language.")
        minetest.chat_send_all("*** Kicked "..name.." for using innappropriate language.") -- print to chat
        minetest.log("action", "[ServerTools] Kicked "..name.." for using innappropriate language.") -- print to log
        return true -- prevent message from showing in chat
      end
    end
  end)
end

-- if banable word is used
for i, word in ipairs(BANABLE) do
  minetest.register_on_chat_message(function(name, message)
    local msg = message:lower()
    -- ignore commands
    if message:sub(1, 1) ~= "/" then
      -- filter for word(s)
      if msg:find(word.ban) ~= nil then
        -- ban player
        xban.ban_player(name, "servertools:filter", "5h", "Please use only appropriate and clean language in the public chat. Players, especially those that are younger, do not need to be hearing or using such language.")
        minetest.chat_send_all("*** Banned"..name.." for using innappropriate language (5 hour ban).") -- print to chat
        minetest.log("action", "[ServerTools] Banned "..name.." for using innappropriate language (5 hour ban).") -- print to log
        return true -- prevent message from showing in chat
      end
    end
  end)
end
