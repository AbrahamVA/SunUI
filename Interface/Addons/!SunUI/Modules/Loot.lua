﻿local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("loot", "AceTimer-3.0")
function Module:OnInitialize()
local  iconsize = 28
local L = {
	fish = "Fishy loot",
	empty = "Empty slot",
}
local addon = CreateFrame("Button", "m_Loot")
local title = addon:CreateFontString(nil, "OVERLAY")
local lb = CreateFrame("Button", "m_LootAdv", addon, "UIPanelScrollDownButtonTemplate")		-- Link button
local LDD = CreateFrame("Frame", "m_LootLDD", addon, "UIDropDownMenuTemplate")				-- Link dropdown menu frame

local sq, ss, sn
local OnEnter = function(self)
	local slot = self:GetID()
	if(LootSlotIsItem(slot)) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetLootItem(slot)
		CursorUpdate(self)
	end

	self.drop:Show()
	self.drop:SetVertexColor(1, 1, 0)
end


local function OnLinkClick(self)
    ToggleDropDownMenu(1, nil, LDD, lb, 0, 0)
end

local function LDD_OnClick(self)
    local val = self.value
	Announce(val)
end

function Announce(chn)
    local nums = GetNumLootItems()
    if(nums == 0) then return end
    if UnitIsPlayer("target") or not UnitExists("target") then -- Chests are hard to identify!
		SendChatMessage("*** Loot from chest ***", chn)
	else
		SendChatMessage("*** Loot from "..UnitName("target").." ***", chn)
	end
    for i = 1, GetNumLootItems() do
        if(LootSlotIsItem(i)) then
            local link = GetLootSlotLink(i)
            local messlink = "- %s"
            SendChatMessage(format(messlink, link), chn)
        end
    end
end

local function LDD_Initialize()  
    local info = {}
    
    info.text = "Announce to"
    info.notCheckable = true
    info.isTitle = true
    UIDropDownMenu_AddButton(info)
    
    --announce chanels
    info = {}
    info.text = "  raid"
    info.value = "raid"
    info.notCheckable = 1
    info.func = LDD_OnClick
    UIDropDownMenu_AddButton(info)
    
    info = {}
    info.text = "  guild"
    info.value = "guild"
    info.notCheckable = 1
    info.func = LDD_OnClick
    UIDropDownMenu_AddButton(info)
	
	info = {}
    info.text = "  party"
    info.value = "party"
    info.notCheckable = 1
    info.func = LDD_OnClick
    UIDropDownMenu_AddButton(info)

    info = {}
    info.text = "  say"
    info.value = "say"
    info.notCheckable = 1
    info.func = LDD_OnClick
    UIDropDownMenu_AddButton(info)
    
    info = nil
end

local OnLeave = function(self)
	--if(self.quality > 1) then
		local color = ITEM_QUALITY_COLORS[self.quality]
		self.drop:SetVertexColor(color.r, color.g, color.b)
	--else
	--	self.drop:Hide()
	--end

	GameTooltip:Hide()
	ResetCursor()
end

local OnClick = function(self)
	if(IsModifiedClick()) then
		HandleModifiedItemClick(GetLootSlotLink(self:GetID()))
	else
		StaticPopup_Hide"CONFIRM_LOOT_DISTRIBUTION"
		ss = self:GetID()
		sq = self.quality
		sn = self.name:GetText()
		LootSlot(ss)
	end
end

local OnUpdate = function(self)
	if(GameTooltip:IsOwned(self)) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetLootItem(self:GetID())
		CursorOnUpdate(self)
	end
end

local createSlot = function(id)
	local frame = CreateFrame("Button", 'm_LootSlot'..id, addon)
	frame:Point("LEFT", 8, 0)
	frame:Point("RIGHT", -8, 0)
	frame:Height(iconsize-2)
	frame:SetID(id)
	
	frame:SetScript("OnEnter", OnEnter)
	frame:SetScript("OnLeave", OnLeave)
	frame:SetScript("OnClick", OnClick)
	frame:SetScript("OnUpdate", OnUpdate)

	local iconFrame = CreateFrame("Frame", nil, frame)
	iconFrame:Height(iconsize+2)
	iconFrame:Width(iconsize+2)
	iconFrame:ClearAllPoints()
	iconFrame:Point("LEFT", frame, 3,0)
	
	local icon = iconFrame:CreateTexture(nil, "BACKGROUND")
	icon:SetAlpha(.8)
	icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	icon:SetAllPoints(iconFrame)
	frame.icon = icon
    
	local overlay = iconFrame:CreateTexture(nil, "OVERLAY")
    overlay:SetTexture(DB.bordertex)
	overlay:Point("TOPLEFT",iconFrame,"TOPLEFT",-3,3)
	overlay:Point("BOTTOMRIGHT",iconFrame,"BOTTOMRIGHT",3,-3)
	overlay:SetVertexColor(0.35, 0.35, 0.35, 1);
	frame.overlay = overlay
	
	local count = iconFrame:CreateFontString(nil, "OVERLAY")
	count:ClearAllPoints()
	count:SetJustifyH"RIGHT"
	count:Point("BOTTOMRIGHT", iconFrame, 2, 2)
	count:SetFontObject(NumberFontNormal)
	count:SetShadowOffset(.8, -.8)
	count:SetShadowColor(0, 0, 0, 1)
	count:SetText(1)
	frame.count = count

	local name = frame:CreateFontString(nil, "OVERLAY")
	name:SetJustifyH"LEFT"
	name:ClearAllPoints()
	name:Point("RIGHT", frame)
	name:Point("LEFT", icon, "RIGHT",8,0)
	name:SetNonSpaceWrap(true)
	name:SetFont(DB.Font, 17, "OUTLINE")
	--name:SetFontObject(GameFontWhite)GameTooltipHeaderText

	name:Width(120)
	frame.name = name
	
	local drop = frame:CreateTexture(nil, "ARTWORK")
	drop:SetTexture(DB.loottex)
	drop:Point("LEFT", icon, "RIGHT", 0, 0)
	drop:Point("RIGHT", frame, "RIGHT", -3, 0)
	drop:Point("TOP", frame,"TOP",0,-3)
	drop:Point("BOTTOM", frame,"BOTTOM",0,3)
	--drop:SetAllPoints(frame)
	drop:SetAlpha(.5)
	frame.drop = drop
	frame:Point("TOP", addon, 8, (-5+iconsize)-(id*(iconsize+10))-10)
	frame:SetBackdrop{
	edgeFile = DB.edgetex, edgeSize = 10,
	--insets = {left = 0, right = 0, top = 0, bottom = 0},
	}
	addon.slots[id] = frame
	
	return frame

end

title:SetFont(DB.Font, 16, "OUTLINE")
title:SetJustifyH"LEFT"
title:Point("TOPLEFT", addon, "TOPLEFT", 6, -4)

addon:SetScript("OnMouseDown", function(self) if(IsAltKeyDown()) then self:StartMoving() end end)
addon:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
addon:SetScript("OnHide", function(self)
	StaticPopup_Hide"CONFIRM_LOOT_DISTRIBUTION"
	CloseLoot()
end)
addon:SetMovable(true)
addon:RegisterForClicks"anyup"

addon:SetParent(UIParent)
addon:SetUserPlaced(true)
addon:Point("TOPLEFT", 0, -104)
addon:Width(256)
addon:Height(64)
addon:CreateShadow("Background")



addon:SetClampedToScreen(true)
addon:SetClampRectInsets(0, 0, 14, 0)
addon:SetHitRectInsets(0, 0, -14, 0)
addon:SetFrameStrata"HIGH"
addon:SetToplevel(true)

lb:ClearAllPoints()
lb:Width(20)
lb:Height(14)
lb:SetScale(0.85)
lb:Point("TOPRIGHT", addon, "TOPRIGHT", -35, -9)
lb:SetFrameStrata("TOOLTIP")
lb:RegisterForClicks("RightButtonUp", "LeftButtonUp")
lb:SetScript("OnClick", OnLinkClick)
lb:Hide()
UIDropDownMenu_Initialize(LDD, LDD_Initialize, "MENU")

addon.slots = {}
addon.LOOT_CLOSED = function(self)
	StaticPopup_Hide"LOOT_BIND"
	self:Hide()

	for _, v in pairs(self.slots) do
		v:Hide()
	end
	lb:Hide()
end
addon.LOOT_OPENED = function(self, event, autoloot)
	self:Show()
	lb:Show()
	if(not self:IsShown()) then
		CloseLoot(not autoLoot)
	end

	local items = GetNumLootItems()

	if(IsFishingLoot()) then
		title:SetText(L.fish)
	elseif(not UnitIsFriend("player", "target") and UnitIsDead"target") then
		title:SetText(UnitName"target")
	else
		title:SetText(LOOT)
	end

	-- Blizzard uses strings here
	if(GetCVar("lootUnderMouse") == "1") then
		local x, y = GetCursorPosition()
		x = x / self:GetEffectiveScale()
		y = y / self:GetEffectiveScale()

		self:ClearAllPoints()
		self:Point("TOPLEFT", nil, "BOTTOMLEFT", x-40, y+20)
		self:GetCenter()
		self:Raise()
	end

	local m = 0
	if(items > 0) then
		for i=1, items do
			local slot = addon.slots[i] or createSlot(i)
			local texture, item, quantity, quality, locked = GetLootSlotInfo(i)
			local color = ITEM_QUALITY_COLORS[quality]

			if(LootSlotIsCoin(i)) then
				item = item:gsub("\n", ", ")
			end

			if(quantity and quantity > 1) then
				slot.count:SetText(quantity)
				slot.count:Show()
			else
				slot.count:Hide()
			end

			slot.overlay:SetVertexColor(color.r, color.g, color.b)
			slot:SetBackdropBorderColor(color.r, color.g, color.b)
			slot.drop:SetVertexColor(color.r, color.g, color.b)
			slot.drop:Show()

			slot.quality = quality
			slot.name:SetText(item)
			slot.name:SetTextColor(color.r, color.g, color.b)
			slot.icon:SetTexture(texture)

			m = math.max(m, quality)

			slot:Enable()
			slot:Show()
		end
	else
		local slot = addon.slots[1] or createSlot(1)
		local color = ITEM_QUALITY_COLORS[0]

		slot.name:SetText(L.empty)
		slot.name:SetTextColor(color.r, color.g, color.b)
		slot.icon:SetTexture[[Interface\Icons\INV_Misc_Herb_AncientLichen]]

		items = 1

		slot.count:Hide()
		slot.drop:Hide()
		slot:Disable()
		slot:Show()
	end

	local color = ITEM_QUALITY_COLORS[m]
	self:SetBackdropBorderColor(color.r, color.g, color.b, .8)
	self:Height(math.max((items*(iconsize+10))+27), 20)
	self:Width(250)
	title:Width(220)
	title:Height(16)
	
--[[	local close = CreateFrame("Button", nil, addon, "UIPanelCloseButton" )
	close:Point("TOPRIGHT", 0, 2)
	close:SetScale(0.87)
	close:SetScript("OnClick", function(self) self:GetParent():Hide() end)]]

	local close = self:CreateTexture(nil, "ARTWORK")
	close:SetTexture(DB.closebtex)
	close:SetTexCoord(0, .7, 0, 1)
	close:Width(20)
	close:Height(14)
	close:SetVertexColor(0.5, 0.5, 0.4)
	close:Point("TOPRIGHT", self, "TOPRIGHT", -6, -7)
	
	local closebutton = CreateFrame("Button", nil)
	closebutton:SetParent( self )
	closebutton:Width(20)
	closebutton:Height(14)
	closebutton:SetScale(0.9)
	closebutton:Point("CENTER", close, "CENTER")
	closebutton:SetScript("OnClick", function(self) self:GetParent():Hide() end)
	closebutton:SetScript( "OnLeave", function() close:SetVertexColor(0.5, 0.5, 0.4) end )
	closebutton:SetScript( "OnEnter", function() close:SetVertexColor(0.7, 0.2, 0.2) end )

end

addon.LOOT_SLOT_CLEARED = function(self, event, slot)
	if(not self:IsShown()) then return end

	addon.slots[slot]:Hide()
	
end



addon.OPEN_MASTER_LOOT_LIST = function(self)
	ToggleDropDownMenu(1, nil, GroupLootDropDown, addon.slots[ss], 0, 0)
end

addon.UPDATE_MASTER_LOOT_LIST = function(self)
	UIDropDownMenu_Refresh(GroupLootDropDown)
end

addon:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)

addon:RegisterEvent"LOOT_OPENED"
addon:RegisterEvent"LOOT_SLOT_CLEARED"
addon:RegisterEvent"LOOT_CLOSED"
addon:RegisterEvent"OPEN_MASTER_LOOT_LIST"
addon:RegisterEvent"UPDATE_MASTER_LOOT_LIST"
addon:Hide()

-- Fuzz
LootFrame:UnregisterAllEvents()
table.insert(UISpecialFrames, "m_Loot")

function _G.GroupLootDropDown_GiveLoot(self)
	if ( sq >= MASTER_LOOT_THREHOLD ) then
		local dialog = StaticPopup_Show("CONFIRM_LOOT_DISTRIBUTION", ITEM_QUALITY_COLORS[sq].hex..sn..FONT_COLOR_CODE_CLOSE, self:GetText())
		if (dialog) then
			dialog.data = self.value
		end
	else
		GiveMasterLoot(ss, self.value)
	end
	CloseDropDownMenus()
end

StaticPopupDialogs["CONFIRM_LOOT_DISTRIBUTION"].OnAccept = function(self, data)
	GiveMasterLoot(ss, data)
end

-- MasterLoot module
local hexColors = {}
for k, v in pairs(RAID_CLASS_COLORS) do
	hexColors[k] = string.format("|cff%02x%02x%02x", v.r * 255, v.g * 255, v.b * 255)
end
hexColors["UNKNOWN"] = string.format("|cff%02x%02x%02x", 0.6*255, 0.6*255, 0.6*255)

if CUSTOM_CLASS_COLORS then
	local function update()
		for k, v in pairs(CUSTOM_CLASS_COLORS) do
			hexColors[k] = ("|cff%02x%02x%02x"):format(v.r * 255, v.g * 255, v.b * 255)
		end
	end
	CUSTOM_CLASS_COLORS:RegisterCallback(update)
	update()
end

local playerName = UnitName("player")
local unknownColor = { r = .6, g = .6, b = .6 }
local classesInRaid = {}
local randoms = {}
local function CandidateUnitClass(candidate)
	local class, fileName = UnitClass(candidate)
	if class then
		return class, fileName
	end
	return L_ML_UNKNOWN, "UNKNOWN"
end

local function init()
	local candidate, color
	local info = UIDropDownMenu_CreateInfo()
	
	if UIDROPDOWNMENU_MENU_LEVEL == 2 then
		-- raid class menu
		for i = 1, 40 do
			candidate = GetMasterLootCandidate(i)
			if candidate then
				local class = select(2, CandidateUnitClass(candidate))
				if class == UIDROPDOWNMENU_MENU_VALUE then -- we check for not class adding everyone that left the raid to every menu to prevent not being able to loot to them
					-- Add candidate button
					info.text = candidate -- coloredNames[candidate]
					info.colorCode = hexColors[class] or hexColors["UNKOWN"]
					info.textHeight = 12
					info.value = i
					info.notCheckable = 1
					info.disabled = nil
					info.func = GroupLootDropDown_GiveLoot
					UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL)
				end
			end
		end
		return
	end

	info.isTitle = 1
	info.text = GIVE_LOOT
	info.textHeight = 12
	info.notCheckable = 1
	info.disabled = nil
	info.notClickable = nil
	UIDropDownMenu_AddButton(info)
	
	if ( GetNumRaidMembers() > 0 ) then
		-- In a raid

		for k, v in pairs(classesInRaid) do
			classesInRaid[k] = nil
		end
		for i = 1, 40 do
			candidate = GetMasterLootCandidate(i)
			if candidate then
				local cname, class = CandidateUnitClass(candidate)
				classesInRaid[class] = cname
			end		
		end

		for k, v in pairs(classesInRaid) do
			info.isTitle = nil
			info.text = v -- classColors[k]..v.."|r"
			info.colorCode = hexColors[k] or hexColors["UNKOWN"]
			info.textHeight = 12
			info.hasArrow = 1
			info.notCheckable = 1
			info.value = k
			info.func = nil
			info.disabled = nil
			UIDropDownMenu_AddButton(info)
		end
	else
		-- In a party
		for i=1, MAX_PARTY_MEMBERS+1, 1 do
			candidate = GetMasterLootCandidate(i)
			if candidate then
				-- Add candidate button
				info.text = candidate -- coloredNames[candidate]
				info.colorCode = hexColors[select(2,CandidateUnitClass(candidate))] or hexColors["UNKOWN"]
				info.textHeight = 12
				info.value = i
				info.notCheckable = 1
				info.hasArrow = nil
				info.isTitle = nil
				info.disabled = nil
				info.func = GroupLootDropDown_GiveLoot
				UIDropDownMenu_AddButton(info)
			end
		end
	end
	
	for k, v in pairs(randoms) do randoms[k] = nil end
	for i = 1, 40 do
		candidate = GetMasterLootCandidate(i)
		if candidate then
			table.insert(randoms, i)
		end
	end
	if #randoms > 0 then
		info.colorCode = "|cffffffff"
		info.isTitle = nil
		info.textHeight = 12
		info.value = randoms[math.random(1, #randoms)]
		info.notCheckable = 1
		info.text = "Random"
		info.func = GroupLootDropDown_GiveLoot
		info.icon = nil--"Interface\\Buttons\\UI-GroupLoot-Dice-Up"
		UIDropDownMenu_AddButton(info)
	end
	for i = 1, 40 do
		candidate = GetMasterLootCandidate(i)
		if candidate and candidate == playerName then
			info.colorCode = hexColors[select(2,CandidateUnitClass(candidate))] or hexColors["UNKOWN"]
			info.isTitle = nil
			info.textHeight = 12
			info.value = i
			info.notCheckable = 1
			info.text = "Self"
			info.func = GroupLootDropDown_GiveLoot
			info.icon = nil--"Interface\\Buttons\\UI-GroupLoot-Coin-Up"
			UIDropDownMenu_AddButton(info)
		end
	end
end

UIDropDownMenu_Initialize(GroupLootDropDown, init, "MENU")
end