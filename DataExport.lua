-- GuildMan Namespace
DE_NS = {
  ADDON_NAME = "DataExport",
  SHORT_ADDON_NAME = "DE",
};

-- Global Libraries
DE_NS.LOGGER = LibDebugLogger(DE_NS.ADDON_NAME);                       -- Debug logging
DE_NS.CHAT = LibChatMessage(DE_NS.ADDON_NAME,DE_NS.SHORT_ADDON_NAME); -- Output to chat
DE_NS.LIB_SLASH_CMDR = LibSlashCommander;                              -- CLI Library

-- Functions

--- Prints the help info
function DE_NS.printHelp()
  local strHelp = string.format("Help:\nType: %s or %s <command>\n<command> can be:\n", DE_NS.SLASH_CMD[1][1],DE_NS.SLASH_CMD[1][2])
  for _, sub_cmd in ipairs(GM_NS.SLASH_SUBCMDS) do
    local strSubCmd = string.format("%s (%s) - %s \n", sub_cmd[1][1], sub_cmd[1][2], sub_cmd[3])
    strHelp = strHelp .. strSubCmd
  end
  GM_NS.CHAT:Print(strHelp)
end

-- Global Slash Commands and SubCommands
DE_NS.SLASH_CMD = { { "/dataExport", "/de" }, DE_NS.printHelp, "print help info" }
DE_NS.SLASH_SUBCMDS = { 
  { { "help", "h" },DE_NS.printHelp, "print help info" }
}

--- register commands with slash commander addon
function DE_NS.RegisterSlashCommands()
  -- Register Slash Command
  local command =DE_NS.LIB_SLASH_CMDR:Register()
  command:AddAlias(DE_NS.SLASH_CMD[1][1])
  command:AddAlias(DE_NS.SLASH_CMD[1][2])
  command:SetCallback(DE_NS.SLASH_CMD[2])
  command:SetDescription(DE_NS.SLASH_CMD[3])

  -- Register Slash Subcommands
  for _, sub_cmd in ipairs(DE_NS.SLASH_SUBCMDS) do
    local subcommand = command:RegisterSubCommand()
    subcommand:AddAlias(sub_cmd[1][1])
    subcommand:AddAlias(sub_cmd[1][2])
    subcommand:SetCallback(sub_cmd[2])
    subcommand:SetDescription(sub_cmd[3])
  end
end

--- Initialize addon
function DE_NS.Initialize()
 local initialMsg = string.format("Loaded Addon: %s", DE_NS.ADDON_NAME)
 DE_NS.LOGGER:Info(initialMsg)
 DE_NS.CHAT:Print(initialMsg)
 DE_NS.RegisterSlashCommands()
end

--- Startup
function DE_NS.OnAddOnLoaded(event, addonName)
  if addonName == DE_NS.ADDON_NAME then
   DE_NS.Initialize()
    EVENT_MANAGER:UnregisterForEvent(DE_NS.ADDON_NAME, EVENT_ADD_ON_LOADED)
  end
end

EVENT_MANAGER:RegisterForEvent(DE_NS.ADDON_NAME, EVENT_ADD_ON_LOADED,DE_NS.OnAddOnLoaded)
