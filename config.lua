local _, core = ...;
core.Config = {};

local Config = core.Config;
local UIConfig;

local defaults = {
  theme = {
    r = 0,
    g = 0.8,
    b = 1,
    hex = "00ccff"
  }
}

function Config:Toggle()
  local menu = UIConfig or Config:CreateMenu();
  menu:SetShown(not menu:IsShown());
end

function Config:GetThemeColor()
  local c = defaults.theme;
  return c.r, c.g, c.b, c.hex;
end

local function ScrollFrame_OnMouseWheel(self, delta)
  local newValue = self:GetVerticalScroll() - (delta * 20);

  if (newValue < 0) then
    newValue = 0;
  elseif (newValue > self:GetVerticalScrollRange()) then
    newValue = self:GetVerticalScrollRange();
  end

  self:SetVerticalScroll(newValue);
end

function Config:CreateMenu()
  UIConfig = CreateFrame("Frame", "TchinFrame", UIParent, "BasicFrameTemplateWithInset");
  UIConfig:SetSize(500, 560);
  UIConfig:SetPoint("CENTER");
  UIConfig:SetMovable(true);
  UIConfig:EnableMouse(true);
  UIConfig:SetFrameStrata("HIGH")
  UIConfig:RegisterForDrag("LeftButton");
  UIConfig:SetScript("OnDragStart", UIConfig.StartMoving);
  UIConfig:SetScript("OnDragStop", UIConfig.StopMovingOrSizing);

  UIConfig.title = UIConfig:CreateFontString(nil, "OVERLAY");
  UIConfig.title:SetFontObject("GameFontHighlight");
  UIConfig.title:SetPoint("LEFT", UIConfig.TitleBg, 5, 0);
  UIConfig.title:SetText("Tchïn Raid Scheduler");

  UIConfig.ScrollFrame = CreateFrame("ScrollFrame", nil, UIConfig, "UIPanelScrollFrameTemplate");
  UIConfig.ScrollFrame:SetPoint("TOPLEFT", TchinFrame.InsetBg, "TOPLEFT", 8, -8);
  UIConfig.ScrollFrame:SetPoint("BOTTOMRIGHT", TchinFrame.InsetBg, "BOTTOMRIGHT", -3, 60);
  UIConfig.ScrollFrame:SetClipsChildren(true);
  UIConfig.ScrollFrame:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel);

  UIConfig.child = CreateFrame("Frame", nil, UIConfig.ScrollFrame);
  UIConfig.child:SetSize(475, 450);
  UIConfig.ScrollFrame:SetScrollChild(UIConfig.child);



  UIConfig.ScrollFrame.ScrollBar:ClearAllPoints();
  UIConfig.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", UIConfig.ScrollFrame, "TOPRIGHT", -20, -22);
  UIConfig.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", UIConfig.ScrollFrame, "BOTTOMRIGHT", -15, 22);

  UIConfig.editBox = CreateFrame("EditBox", "TchinEditBox", UIConfig, "TchinInputBoxTemplate");
  UIConfig.editBox:SetPoint("TOPLEFT", UIConfig.child, 5, -5);
  UIConfig.editBox:SetWidth(430);
  UIConfig.editBox:SetText("Paste the list here.");
  UIConfig.editBox:SetAutoFocus(false);
  UIConfig.editBox:SetMultiLine(true);
  UIConfig.editBox:SetMaxLetters(2000);

  UIConfig.inviteBtn = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate");
  UIConfig.inviteBtn:SetPoint("CENTER", UIConfig, "BOTTOM", 0, 40);
  UIConfig.inviteBtn:SetSize(120, 30);
  UIConfig.inviteBtn:SetText("Invite Members");
  UIConfig.inviteBtn:SetNormalFontObject("GameFontNormal");
  UIConfig.inviteBtn:SetHighlightFontObject("GameFontHighlight");
  UIConfig.inviteBtn:SetScript("OnClick", function()
    local text = UIConfig.editBox:GetText();
    local t = {};

    for name in string.gmatch(text, "([^|]+)") do
      table.insert(t, name)
    end

    for i = 1 , table.getn(t) do
      if (UnitInParty("player")) then
        if (not UnitInRaid("player")) then
          core:Print("Switching to raid mode.")
          ConvertToRaid()
        end
      end
      InviteUnit(t[i]);
    end
    core:Print("Done sending invites.")
  end);

  UIConfig:Hide();
  return UIConfig;
end
