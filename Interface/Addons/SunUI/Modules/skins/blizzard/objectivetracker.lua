local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

local ot = ObjectiveTrackerFrame
local BlocksFrame = ot.BlocksFrame

local function LoadSkin()
	--移动任务追踪
	local holder = CreateFrame("Frame", UIParent)
	holder:SetSize(ObjectiveTrackerFrame:GetWidth(), ObjectiveTrackerFrame:GetHeight())
	holder:SetPoint(ObjectiveTrackerFrame:GetPoint())
	S:CreateMover(holder, "ObjectiveTrackerFrameMover", TRACK_QUEST, true, nil, "ALL,GENERAL")
	ot._SetPoint = ot.SetPoint
	hooksecurefunc(ot, "SetPoint", function(a, p, a2, x, y)
		local aa, pa, a2a, xa, ya = ObjectiveTrackerFrameMover:GetPoint()
		if (a~=aa and a2a~=a2 and x~=xa and y~=ya) and not isMove then
			ot:ClearAllPoints()
			ot:_SetPoint("TOPLEFT", holder, "TOPLEFT", 90, 0)
            ot:SetHeight(638)
		end
	end)
	
	--移动载具
	local holder2 = CreateFrame("Frame", UIParent)
	holder2:SetSize(VehicleSeatIndicator:GetWidth(), VehicleSeatIndicator:GetHeight())
	holder2:SetPoint(VehicleSeatIndicator:GetPoint())
	S:CreateMover(holder2, "VehicleSeatIndicatorMover", BINDING_HEADER_VEHICLE, true, nil, "ALL,GENERAL")
	VehicleSeatIndicator._SetPoint = VehicleSeatIndicator.SetPoint
	hooksecurefunc(VehicleSeatIndicator, "SetPoint", function(a, p, a2, x, y)
		local aa, pa, a2a, xa, ya = VehicleSeatIndicatorMover:GetPoint()
		if (a~=aa and a2a~=a2 and x~=xa and y~=ya) and not isMove2 then
			VehicleSeatIndicator:ClearAllPoints()
			VehicleSeatIndicator:_SetPoint("TOPLEFT", holder2, "TOPLEFT", 0, 0)
		end
	end)

	-- [[ Header ]]

	-- Header

	ot.HeaderMenu.Title:FontTemplate(nil, nil, "OUTLINE")
	
	-- Minimize button
	local minimizeButton = ot.HeaderMenu.MinimizeButton
	A:ReskinExpandOrCollapse(minimizeButton)
	minimizeButton:SetSize(15, 15)
	minimizeButton.plus:Hide()

	hooksecurefunc("ObjectiveTracker_Collapse", function()
		minimizeButton.plus:Show()
	end)
	hooksecurefunc("ObjectiveTracker_Expand", function()
		minimizeButton.plus:Hide()
	end)
	-- [[ Blocks and lines ]]

	for _, headerName in pairs({"QuestHeader", "AchievementHeader", "ScenarioHeader"}) do
		local header = BlocksFrame[headerName]

		header.Background:Hide()
		header.Text:FontTemplate(nil, nil, "OUTLINE")
	end

	do
		local header = BONUS_OBJECTIVE_TRACKER_MODULE.Header

		header.Background:Hide()
		header.Text:FontTemplate(nil, nil, "OUTLINE")
	end

	hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "SetBlockHeader", function(_, block)
		if not block.headerStyled then
			block.HeaderText:FontTemplate(nil, nil, "OUTLINE")
			block.headerStyled = true
		end
	end)

	hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", function(_, block)
		if not block.headerStyled then
			block.HeaderText:FontTemplate(nil, nil, "OUTLINE")
			block.headerStyled = true
		end

		local itemButton = block.itemButton

		if itemButton and not itemButton.styled then
			itemButton:SetNormalTexture("")
			itemButton:SetPushedTexture("")

			itemButton.HotKey:ClearAllPoints()
			itemButton.HotKey:SetPoint("TOP", itemButton, -1, 0)
			itemButton.HotKey:SetJustifyH("CENTER")
			itemButton.HotKey:FontTemplate(nil, nil, "OUTLINE")

			itemButton.icon:SetTexCoord(.08, .92, .08, .92)
			A:CreateBG(itemButton)

			itemButton.styled = true
		end
	end)

	hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddObjective", function(self, block)
		if block.module == QUEST_TRACKER_MODULE or block.module == ACHIEVEMENT_TRACKER_MODULE then
			local line = block.currentLine

			local p1, a, p2, x, y = line:GetPoint()
			line:SetPoint(p1, a, p2, x, y - 4)
		end
	end)

	local function fixBlockHeight(block)
		if block.shouldFix then
			local height = block:GetHeight()

			if block.lines then
				for _, line in pairs(block.lines) do
					if line:IsShown() then
						height = height + 4
					end
				end
			end

			block.shouldFix = false
			block:SetHeight(height + 5)
			block.shouldFix = true
		end
	end

	hooksecurefunc("ObjectiveTracker_AddBlock", function(block)
		if block.lines then
			for _, line in pairs(block.lines) do
				if not line.styled then
					line.Text:FontTemplate(nil, nil, "OUTLINE")
					line.Text:SetSpacing(2)

					if line.Dash then
						line.Dash:FontTemplate(nil, nil, "OUTLINE")
					end

					line:SetHeight(line.Text:GetHeight())

					line.styled = true
				end
			end
		end

		if not block.styled then
			block.shouldFix = true
			hooksecurefunc(block, "SetHeight", fixBlockHeight)
			block.styled = true
		end
	end)

	-- [[ Bonus objective progress bar ]]

	hooksecurefunc(BONUS_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", function(self, block, line)
		local progressBar = line.ProgressBar

		if not progressBar.styled then
			local bar = progressBar.Bar
			local label = bar.Label

			bar.BorderLeft:Hide()
			bar.BorderRight:Hide()
			bar.BorderMid:Hide()
			select(5, bar:GetRegions()):Hide()

			bar:SetStatusBarTexture(A["media"].backdrop)

			label:ClearAllPoints()
			label:SetPoint("CENTER", 0, -1)
			label:FontTemplate(nil, nil, "OUTLINE")

			local bg = A:CreateBDFrame(bar)
			bg:SetPoint("TOPLEFT", -1, 0)
			bg:SetPoint("BOTTOMRIGHT", 0, -3)

			progressBar.styled = true
		end
	end)
	--[[
	hooksecurefunc(SCENARIO_TRACKER_MODULE, "AddTimerBar", function(block, line, duration, startTime)
		local timerBar = line.TimerBar
		S:Print(line.TimerBar)
		
		if timerBar then
			print(_G[timerBar:GetName().."Bar"])
		end
		
		if timerBar.Bar and not timerBar.Bar.skinned then
			timerBar.Bar:StripTextures()
			timerBar.Bar:SetStatusBarTexture(A["media"].backdrop)
			A:CreateMark(timerBar.Bar)
			
			timerBar.Bar.bg = CreateFrame("Frame", nil, timerBar.Bar)
			timerBar.Bar.bg:SetPoint("TOPLEFT", timerBar.Bar, "TOPLEFT", -1, 1)
			timerBar.Bar.bg:SetPoint("BOTTOMRIGHT", timerBar.Bar, "BOTTOMRIGHT", 1, -1)
			timerBar.Bar.bg:SetFrameStrata(timerBar.Bar:GetFrameStrata())
			timerBar.Bar.bg:SetFrameLevel(timerBar.Bar:GetFrameLevel() - 1)
			timerBar.Bar.bg:SetBackdrop(backdrop)
			timerBar.Bar.bg:SetBackdropColor(0, 0, 0, 0.5)
			timerBar.Bar.bg:SetBackdropBorderColor(0, 0, 0, 1)
			
			timerBar.Bar.skinned = true
		end
	end)
	]]
end

A:RegisterSkin("SunUI", LoadSkin)
