-- GuildMan Namespace
DE_NS = {
  ADDON_NAME = "DataExport",
  SHORT_ADDON_NAME = "DE",
  SAVED_VAR_NAME = "DataExportSavedVariables",
  SLASH_CMD = { { "/dataExport", "/de" }, "print help info" },
  SLASH_SUBCMDS = {
    { { "help", "h" }, 'func', "print help info" },
    { { "print-db", "db" }, 'func', "print DB" },
    { { "add-record", "ar" }, 'func', "add record to DB" }
  },
  DEFAULT = {
    DISPLAY_NAME = { GetDisplayName() }
  },
  VARIABLE_VERSION = 1,
  DB = {}
};

DE_NS.LOGGER = LibDebugLogger(DE_NS.ADDON_NAME)
DE_NS.CHAT = LibChatMessage(DE_NS.ADDON_NAME, DE_NS.SHORT_ADDON_NAME)
DE_NS.LIB_SLASH_CMDR = LibSlashCommander
DE_NS.LTF = LibTableFunctions
-- Functions

--- Prints the help info
function DE_NS.printHelp()
  local strHelp = string.format("Help:\nType: %s or %s <command>\n<command> can be:\n", DE_NS.SLASH_CMD[1][1],
    DE_NS.SLASH_CMD[1][2])
  for _, sub_cmd in ipairs(DE_NS.SLASH_SUBCMDS) do
    local strSubCmd = string.format("%s (%s) - %s \n", sub_cmd[1][1], sub_cmd[1][2], sub_cmd[3])
    strHelp = strHelp .. strSubCmd
  end
  DE_NS.CHAT:Print(strHelp)
end

function DE_NS.printDB()
  local strDB = DE_NS.LTF:DeepPrint(DE_NS.DB)
  DE_NS.CHAT:Print(strDB) 
end

function DE_NS.addRecord(input)
  chunks = {}
  for substring in input:gmatch("%S+") do
   table.insert(chunks, substring)
  end
  
  DE_NS.DB[chunks[1]]={chunks[2]}
end

-- Global Slash Commands and SubCommands

--- register commands with slash commander addon
function DE_NS.RegisterSlashCommands()

  -- Assign functions
  DE_NS.SLASH_SUBCMDS[1][2] = DE_NS.printHelp
  DE_NS.SLASH_SUBCMDS[2][2] = DE_NS.printDB
  DE_NS.SLASH_SUBCMDS[3][2] = DE_NS.addRecord

  -- Register Slash Command
  local command = DE_NS.LIB_SLASH_CMDR:Register()
  command:AddAlias(DE_NS.SLASH_CMD[1][1])
  command:AddAlias(DE_NS.SLASH_CMD[1][2])
  command:SetCallback(DE_NS.printHelp)
  command:SetDescription(DE_NS.SLASH_CMD[2])

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
  DE_NS.DB = ZO_SavedVars:NewAccountWide(DE_NS.SAVED_VAR_NAME, DE_NS.VARIABLE_VERSION, nil, DE_NS.DEFAULT)
end

--- Startup
function DE_NS.OnAddOnLoaded(event, addonName)
  if addonName == DE_NS.ADDON_NAME then
    DE_NS.Initialize()
    EVENT_MANAGER:UnregisterForEvent(DE_NS.ADDON_NAME, EVENT_ADD_ON_LOADED)
  end
end

EVENT_MANAGER:RegisterForEvent(DE_NS.ADDON_NAME, EVENT_ADD_ON_LOADED, DE_NS.OnAddOnLoaded)
