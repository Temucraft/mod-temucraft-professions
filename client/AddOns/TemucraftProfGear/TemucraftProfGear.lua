--[[
    TemucraftProfGear: profession equipment panel. Each profession has a tool slot and two accessory slots kept by
    the server. Open with /profgear or the button on the character window.
      - alt-right-click profession equipment in your bags to wear it
      - right-click a slot to take it off; hover for the tooltip
    Reagent bag (right side): an extra bag for trade goods and reagents, kept by the server.
      - "Send reagents here": what you loot or craft goes straight in
      - click a stack to take it out, shift-click to take all of that item; ctrl-right-click a reagent in your bags
        to put it in; "Deposit reagents" moves every reagent from your bags
      - the trade skill window gets a "Reagent bag" button: takes what the recipe needs (times the number in the box)
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

-- ---------------------------------------------------------------- reagent bag
local COLS, BTN = 7, 37
local reagent = { auto = true, slots = 28, used = 0, items = {}, incoming = nil }

local rb = CreateFrame("Frame", "TemucraftReagentBagFrame", frame)
rb:SetWidth(COLS * (BTN + 3) + 30)
rb:SetHeight(frame:GetHeight())
rb:SetPoint("TOPLEFT", frame, "TOPRIGHT", -6, 0)
rb:SetBackdrop(frame:GetBackdrop())
rb:EnableMouse(true)
local rbTitle = rb:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
rbTitle:SetPoint("TOP", 0, -18)
rbTitle:SetText("Reagent Bag")
local rbUsed = rb:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
rbUsed:SetPoint("TOP", 0, -38)
local rbAuto = CreateFrame("CheckButton", "TemucraftReagentBagAuto", rb, "UICheckButtonTemplate")
rbAuto:SetWidth(24)
rbAuto:SetHeight(24)
rbAuto:SetPoint("BOTTOMLEFT", 16, 40)
_G[rbAuto:GetName() .. "Text"]:SetText("Send reagents here")
rbAuto:SetScript("OnClick", function(self) Send("RT " .. (self:GetChecked() and 1 or 0)) end)
local rbNotice = CreateFrame("CheckButton", "TemucraftReagentBagNotice", rb, "UICheckButtonTemplate")
rbNotice:SetWidth(24)
rbNotice:SetHeight(24)
rbNotice:SetPoint("BOTTOMLEFT", 16, 62)
_G[rbNotice:GetName() .. "Text"]:SetText("Tell me when reagents go here")
rbNotice:SetScript("OnClick", function(self) Send("RN " .. (self:GetChecked() and 1 or 0)) end)
local rbDeposit = CreateFrame("Button", nil, rb, "UIPanelButtonTemplate")
rbDeposit:SetWidth(130)
rbDeposit:SetHeight(22)
rbDeposit:SetPoint("BOTTOM", 0, 16)
rbDeposit:SetText("Deposit reagents")
rbDeposit:SetScript("OnClick", function() Send("RA") end)

local cells = {}
local function Cell(i)
    if cells[i] then return cells[i] end
    local b = CreateFrame("Button", nil, rb)
    b:SetWidth(BTN)
    b:SetHeight(BTN)
    local col, row = (i - 1) % COLS, math.floor((i - 1) / COLS)
    b:SetPoint("TOPLEFT", 16 + col * (BTN + 3), -54 - row * (BTN + 3))
    b.icon = b:CreateTexture(nil, "ARTWORK")
    b.icon:SetAllPoints()
    b.bg = b:CreateTexture(nil, "BACKGROUND")
    b.bg:SetTexture("Interface\\Buttons\\UI-EmptySlot-Disabled")
    b.bg:SetWidth(BTN * 1.65)
    b.bg:SetHeight(BTN * 1.65)
    b.bg:SetPoint("CENTER")
    b.count = b:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
    b.count:SetPoint("BOTTOMRIGHT", -2, 2)
    b:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
    b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    b:SetScript("OnEnter", function(self)
        if not self.entry then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetHyperlink("item:" .. self.entry)
        GameTooltip:AddLine(self.total .. " in the reagent bag", 1, 1, 1)
        GameTooltip:AddLine("Click: take this stack. Shift-click: take all.", 0.6, 0.6, 0.6)
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    b:SetScript("OnClick", function(self)
        if not self.entry then return end
        if IsModifiedClick("CHATLINK") then
            local _, link = GetItemInfo(self.entry)
            if link then ChatEdit_InsertLink(link) end
        elseif IsShiftKeyDown() then
            Send("RW " .. self.entry .. " " .. self.total)
        else
            Send("RW " .. self.entry .. " " .. self.stack)
        end
    end)
    cells[i] = b
    return b
end

local function RefreshBag()
    local rows = math.ceil(reagent.slots / COLS)
    rb:SetHeight(math.max(frame:GetHeight(), 120 + rows * (BTN + 3)))
    rbUsed:SetText(reagent.used .. " / " .. reagent.slots .. " slots")
    rbAuto:SetChecked(reagent.auto)
    rbNotice:SetChecked(reagent.notify ~= false)
    -- one cell per stack, like a real bag
    local list = {}
    for _, it in ipairs(reagent.items) do
        local stackSize = select(8, GetItemInfo(it.entry)) or 20
        if stackSize < 1 then stackSize = 1 end
        local left = it.count
        while left > 0 do
            local n = math.min(left, stackSize)
            tinsert(list, { entry = it.entry, n = n, total = it.count })
            left = left - n
        end
    end
    local shown = math.max(reagent.slots, #list)
    for i = 1, shown do
        local b, it = Cell(i), list[i]
        if it then
            b.entry, b.stack, b.total = it.entry, it.n, it.total
            b.icon:SetTexture(GetItemIcon(it.entry) or "Interface\\Icons\\INV_Misc_QuestionMark")
            b.count:SetText(it.n > 1 and it.n or "")
        else
            b.entry = nil
            b.icon:SetTexture(nil)
            b.count:SetText("")
        end
        b:Show()
    end
    for i = shown + 1, #cells do cells[i]:Hide() end
end

-- ctrl-right-click a reagent in your bags: into the reagent bag
hooksecurefunc("ContainerFrameItemButton_OnModifiedClick", function(self, button)
    if button ~= "RightButton" or not IsControlKeyDown() then return end
    local bag, slot = self:GetParent():GetID(), self:GetID()
    if not GetContainerItemID(bag, slot) then return end
    local sbag, sslot
    if bag == 0 then sbag, sslot = 255, 22 + slot else sbag, sslot = 18 + bag, slot - 1 end
    Send("RD " .. sbag .. " " .. sslot)
end)

-- the trade skill window: take what the selected recipe needs out of the reagent bag
local function AddTradeSkillButton()
    if TemucraftReagentBagTradeButton or not TradeSkillCreateButton then return end
    local b = CreateFrame("Button", "TemucraftReagentBagTradeButton", TradeSkillFrame, "UIPanelButtonTemplate")
    b:SetWidth(90)
    b:SetHeight(22)
    b:SetPoint("RIGHT", TradeSkillCreateAllButton, "LEFT", -4, 0)
    b:SetText("Reagent bag")
    b:SetScript("OnClick", function()
        local index = GetTradeSkillSelectionIndex()
        local link = index and GetTradeSkillRecipeLink(index)
        local spell = link and link:match("enchant:(%d+)")
        if spell then Send("RP " .. spell .. " " .. math.max(1, TradeSkillInputBox:GetNumber() or 1)) end
    end)
    b:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText("Take what this recipe needs (times the number in the box) out of your reagent bag.", 1, 1, 1, 1, true)
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("CHAT_MSG_ADDON")
events:SetScript("OnEvent", function(_, event, prefix, message, channel, sender)
    if event == "ADDON_LOADED" then
        if prefix == "Blizzard_TradeSkillUI" then AddTradeSkillButton() end
        return
    end
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
    elseif kind == "RS" then
        local auto, slots, used, notify = data:match("(%d+) (%d+) (%d+) ?(%d*)")
        reagent.auto, reagent.slots, reagent.used = auto == "1", tonumber(slots) or 28, tonumber(used) or 0
        reagent.notify = notify ~= "0"
        reagent.incoming = {}
    elseif kind == "RI" and reagent.incoming then
        for entry, count in data:gmatch("(%d+):(%d+);") do
            tinsert(reagent.incoming, { entry = tonumber(entry), count = tonumber(count) })
        end
    elseif kind == "RE" and reagent.incoming then
        reagent.items, reagent.incoming = reagent.incoming, nil
        RefreshBag()
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

-- A "Professions" tab on the character window, after Character / Pets / Reputation / Skills / Currency. The panel
-- shows inside the character window there; alt-right-click in the bags still opens it on its own.
local tab = CreateFrame("Button", "TemucraftProfGearTab", CharacterFrame, "CharacterFrameTabButtonTemplate")
tab:SetText("Professions")
PanelTemplates_TabResize(tab, 0)
local embedded = false

local function PlaceTab()
    local last
    for i = 1, 10 do
        local t = _G["CharacterFrameTab" .. i]
        if t and t:IsShown() then last = t end
    end
    tab:ClearAllPoints()
    if last then tab:SetPoint("LEFT", last, "RIGHT", -16, 0) end
end

local function Embed(on)
    embedded = on
    frame:ClearAllPoints()
    if on then
        frame:SetParent(CharacterFrame)
        frame:SetPoint("TOPLEFT", CharacterFrame, "TOPLEFT", 14, -40)
    else
        frame:SetParent(UIParent)
        frame:SetPoint("CENTER", 200, 0)
    end
    frame:SetMovable(not on)
    if on then close:Hide() else close:Show() end
end

local function ShowTab()
    for _, name in ipairs(CHARACTERFRAME_SUBFRAMES or {}) do
        local f = _G[name]
        if f then f:Hide() end
    end
    for i = 1, 10 do
        local t = _G["CharacterFrameTab" .. i]
        if t then PanelTemplates_DeselectTab(t) end
    end
    PanelTemplates_SelectTab(tab)
    Embed(true)
    frame:Show()
end

local function HideTab()
    PanelTemplates_DeselectTab(tab)
    if embedded then
        frame:Hide()
        Embed(false)
    end
end

tab:SetScript("OnClick", function() PlaySound("igCharacterInfoTab"); ShowTab() end)
CharacterFrame:HookScript("OnShow", function() PlaceTab(); HideTab() end)
CharacterFrame:HookScript("OnHide", HideTab)
hooksecurefunc("CharacterFrame_ShowSubFrame", HideTab)   -- one of Blizzard's tabs was picked
PanelTemplates_DeselectTab(tab)
PlaceTab()

-- /profgear: the character window on this tab (or closes it)
local function Toggle()
    if CharacterFrame:IsShown() and embedded then HideUIPanel(CharacterFrame) return end
    if not CharacterFrame:IsShown() then ShowUIPanel(CharacterFrame) end
    ShowTab()
end
SLASH_TEMUCRAFTPROFGEAR1 = "/profgear"
SlashCmdList["TEMUCRAFTPROFGEAR"] = Toggle
if IsAddOnLoaded and IsAddOnLoaded("Blizzard_TradeSkillUI") then AddTradeSkillButton() end
