local _, core = ...;

core.commands = {
  ["show"] = core.Config.Toggle,

  ["help"] = function()
    print(" ");
    core:Print("List of slash commands");
    core:Print("|cff00cc66/trs show|r - show the addon window");
    core:Print("|cff00cc66/trs help|r - show help infos");
    print(" ");
  end
}

function HandleSlashCommands(str)
  if (#str == 0) then
    core.commands.help();
    return;
  end

  if (str == "show") then
    core.commands.show()
  end

  if (str == "help") then
    core.commands.help()
  end
end

function core:Print(...)
  local hex = select(4, self.Config:GetThemeColor());
  local prefix = string.format("|cff%s%s|r", hex:upper(), "Tchin Raid Scheduler:");
  DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", prefix, tostringall(...)));
end

function core:init(event, name)
  if (name ~= "TchinRaidScheduler") then return end

  for  i = 1 , NUM_CHAT_WINDOWS do
    _G["ChatFrame"..i.."EditBox"]:SetAltArrowKeyMode(false)
  end

  SLASH_RELOADUI1 = "/rl"
  SlashCmdList.RELOADUI = ReloadUI

  SLASH_FRAMESTK1 = "/fs"
  SlashCmdList.FRAMESTK = function()
    LoadAddOn("Blizzard_DebugTools")
    FrameStackTooltip_Toggle()
  end

  SLASH_TchinRaidScheduler1 = "/trs";
  SlashCmdList.TchinRaidScheduler = HandleSlashCommands;

  core:Print("Welcome", UnitName("player").."!")
end

local events = CreateFrame("Frame");
events:RegisterEvent("ADDON_LOADED");
events:SetScript("OnEvent", core.init);
