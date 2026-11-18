--[[
    TemucraftProfGear: profession equipment panel. Each profession has a tool slot and two accessory slots kept by
    the server. Open with /profgear or the button on the character window.
      - alt-right-click profession equipment in your bags to wear it
      - right-click a slot to take it off; hover for the tooltip
    Everything is checked by the server; this panel only shows it (addon messages, prefix TPG).
--]]

local PREFIX = "TPG"
local NAMES = { [182] = "Herbalism", [186] = "Mining", [393] = "Skinning", [356] = "Fishing", [164] = "Blacksmithing",
    [165] = "Leatherworking", [171] = "Alchemy", [197] = "Tailoring", [202] = "Engineering", [333] = "Enchanting",
    [755] = "Jewelcrafting", [773] = "Inscription", [185] = "Cooking", [129] = "First Aid" }
local ROWS, SLOTS = 6, 3
local SLOT_LABEL = { "Tool", "Accessory", "Accessory" }

local professions = {}   -- { skill, value, max }
local gear = {}          -- gear[skill][slot] = { entry, prop }

local function Send(text)
    SendAddonMessage(PREFIX, text, "WHISPER", UnitName("player"))
end

local frame = CreateFrame("Frame", "TemucraftProfGearFrame", UIParent)
frame:SetWidth(330)
frame:SetHeight(70 + ROWS * 46)
frame:SetPoint("CENTER", 200, 0)
frame:SetFrameStrata("HIGH")
frame:SetToplevel(true)
frame:SetClampedToScreen(true)
frame:EnableMouse(true)
frame:SetMovable(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 },
})
frame:Hide()
tinsert(UISpecialFrames, "TemucraftProfGearFrame")

local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -18)
title:SetText("Profession Equipment")
local hint = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
hint:SetPoint("BOTTOM", 0, 16)
hint:SetText("Alt-right-click equipment in your bags to wear it. Right-click a slot to take it off.")
hint:SetWidth(290)
local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", -6, -6)
local empty = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
empty:SetPoint("CENTER")
empty:SetText("You have no professions yet.")

local rows = {}
for r = 1, ROWS do
    local row = CreateFrame("Frame", nil, frame)
    row:SetWidth(300)
    row:SetHeight(42)
    row:SetPoint("TOPLEFT", 18, -44 - (r - 1) * 46)
    row.name = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    row.name:SetPoint("TOPLEFT", 0, -4)
    row.name:SetWidth(150)
    row.name:SetJustifyH("LEFT")
    row.skill = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.skill:SetPoint("TOPLEFT", 0, -22)
    row.slots = {}
    for s = 1, SLOTS do
        local b = CreateFrame("Button", nil, row)
        b:SetWidth(36)
        b:SetHeight(36)
        b:SetPoint("TOPLEFT", 160 + (s - 1) * 44, -2)
        b:RegisterForClicks("RightButtonUp", "LeftButtonUp")
        b.icon = b:CreateTexture(nil, "ARTWORK")
        b.icon:SetAllPoints()
        b.border = b:CreateTexture(nil, "OVERLAY")
        b.border:SetTexture("Interface\\Buttons\\UI-Quickslot2")
        b.border:SetWidth(62)
        b.border:SetHeight(62)
        b.border:SetPoint("CENTER")
        b:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
        b.slot = s - 1
        b:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            if self.entry then
                GameTooltip:SetHyperlink("item:" .. self.entry .. ":0:0:0:0:0:" .. (self.prop or 0))
                GameTooltip:AddLine("Right-click to take it off.", 0.6, 0.6, 0.6)
            else
                GameTooltip:SetText(SLOT_LABEL[self.slot + 1] .. " (empty)")
                GameTooltip:AddLine("Alt-right-click profession equipment in your bags to wear it.", 1, 1, 1, true)
            end
            GameTooltip:Show()
        end)
        b:SetScript("OnLeave", function() GameTooltip:Hide() end)
        b:SetScript("OnClick", function(self, button)
            if button == "RightButton" and self.entry and self.skillId then
                Send("UN " .. self.skillId .. " " .. self.slot)
            elseif IsModifiedClick("CHATLINK") and self.entry then
                local _, link = GetItemInfo(self.entry)
                if link then ChatEdit_InsertLink(link) end
            end
        end)
        row.slots[s] = b
    end
    rows[r] = row
end

local function Refresh()
    for r = 1, ROWS do
        local p, row = professions[r], rows[r]
        if p then
            row.name:SetText(NAMES[p.skill] or ("Skill " .. p.skill))
            row.skill:SetText(p.value .. " / " .. p.max)
            for s = 1, SLOTS do
                local b, worn = row.slots[s], gear[p.skill] and gear[p.skill][s - 1]
                b.skillId = p.skill
                if worn then
                    b.entry, b.prop = worn.entry, worn.prop
                    b.icon:SetTexture(GetItemIcon(worn.entry) or "Interface\\Icons\\INV_Misc_QuestionMark")
                    b.icon:SetVertexColor(1, 1, 1)
                else
                    b.entry, b.prop = nil, nil
                    b.icon:SetTexture(s == 1 and "Interface\\Icons\\INV_Pick_02" or "Interface\\Icons\\INV_Misc_Gear_01")
                    b.icon:SetVertexColor(0.25, 0.25, 0.25)
                end
            end
            row:Show()
        else
            row:Hide()
        end
    end
    if #professions == 0 then empty:Show() else empty:Hide() end
end

local events = CreateFrame("Frame")
events:RegisterEvent("CHAT_MSG_ADDON")
events:SetScript("OnEvent", function(_, _, prefix, message, channel, sender)
    if prefix ~= PREFIX or sender ~= UnitName("player") then return end
    local kind, data = message:match("^(%u%u) ?(.*)$")
    if kind == "PR" then
        wipe(professions)
        for skill, value, max in data:gmatch("(%d+):(%d+):(%d+);") do
            tinsert(professions, { skill = tonumber(skill), value = tonumber(value), max = tonumber(max) })
        end
    elseif kind == "ST" then
        wipe(gear)
        for skill, slot, entry, prop in data:gmatch("(%d+):(%d+):(%d+):(%-?%d+);") do
            skill = tonumber(skill)
            gear[skill] = gear[skill] or {}
            gear[skill][tonumber(slot)] = { entry = tonumber(entry), prop = tonumber(prop) }
        end
        Refresh()
    elseif kind == "ER" then
        UIErrorsFrame:AddMessage(data, 1, 0.2, 0.2)
    end
end)

frame:SetScript("OnShow", function() Send("GET"); Refresh() end)

-- Alt-right-click in the bags: client bag 0 is the backpack (server bag 255, slots 23+), bags 1-4 are 19-22
hooksecurefunc("ContainerFrameItemButton_OnModifiedClick", function(self, button)
    if button ~= "RightButton" or not IsAltKeyDown() then return end
    local bag, slot = self:GetParent():GetID(), self:GetID()
    if not GetContainerItemID(bag, slot) then return end
    local sbag, sslot
    if bag == 0 then sbag, sslot = 255, 22 + slot else sbag, sslot = 18 + bag, slot - 1 end
    Send("EQ " .. sbag .. " " .. sslot .. " 255")
    if not frame:IsShown() then frame:Show() end
end)

local function Toggle() if frame:IsShown() then frame:Hide() else frame:Show() end end
SLASH_TEMUCRAFTPROFGEAR1 = "/profgear"
SlashCmdList["TEMUCRAFTPROFGEAR"] = Toggle

-- A button on the character window
local open = CreateFrame("Button", "TemucraftProfGearCharacterButton", PaperDollFrame, "UIPanelButtonTemplate")
open:SetWidth(90)
open:SetHeight(20)
open:SetPoint("TOPRIGHT", PaperDollFrame, "TOPRIGHT", -44, -40)
open:SetText("Professions")
open:SetScript("OnClick", Toggle)
