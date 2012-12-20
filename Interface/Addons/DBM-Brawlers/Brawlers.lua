local mod	= DBM:NewMod("Brawlers", "DBM-Brawlers")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 8353 $"):sub(12, -3))
--mod:SetCreatureID(60491)
--mod:SetModelID(41448)
mod:SetZone()

mod:RegisterEvents(
	"PLAYER_REGEN_ENABLED",
	"CHAT_MSG_MONSTER_YELL",
	"UNIT_DIED",
	"ZONE_CHANGED_NEW_AREA"
)

local specWarnYourTurn			= mod:NewSpecialWarning("specWarnYourTurn")

--need to add a custom beserk to the only boss that isn't 2 minutes. 68252 (Proboskus). Need a good berserk log that has combat regen or chat yell time.
local berserkTimer				= mod:NewBerserkTimer(120)--all fights have a 2 min enrage to 134545. some fights have an earlier berserk though.

mod:AddBoolOption("SpectatorMode", true)
mod:RemoveOption("HealthFrame")
mod:RemoveOption("SpeedKillTimer")

local matchActive = false
local playerIsFighting = false
local currentFighter = nil
local currentRank = 0--Used to stop bars for the right sub mod based on dynamic rank detection from pulls
local modsStopped = false

function mod:PlayerFighting() -- for external mods
	return playerIsFighting
end

function mod:CHAT_MSG_MONSTER_YELL(msg, npc, _, _, target)
	local isMatchBegin = true
	if msg:find(L.Rank1) then
		currentFighter = target
		currentRank = 1
	elseif msg:find(L.Rank2) then
		currentFighter = target
		currentRank = 2
	elseif msg:find(L.Rank3) then
		currentFighter = target
		currentRank = 3
	elseif msg:find(L.Rank4) then
		currentFighter = target
		currentRank = 4
	elseif msg:find(L.Rank5) then
		currentFighter = target
		currentRank = 5
	elseif msg:find(L.Rank6) then
		currentFighter = target
		currentRank = 6
	elseif msg:find(L.Rank7) then
		currentFighter = target
		currentRank = 7
	elseif msg:find(L.Rank8) then
		currentFighter = target
		currentRank = 8
	elseif currentFighter and target == currentFighter and (npc == L.Bizmo or npc == L.Bazzelflange) then--He's targeting current fighter but it's not a match begin yell, the only other time this happens is on match end.
		self:SendSync("MatchEnd")
		isMatchBegin = false
	else
		isMatchBegin = false
	end
	if isMatchBegin then
		if target == UnitName("player") then
			specWarnYourTurn:Show()
			playerIsFighting = true
		end
		self:SendSync("MatchBegin")
--[[	elseif matchActive and (msg:find(L.Victory1) or msg:find(L.Victory2) or msg:find(L.Victory3) or msg:find(L.Victory4) or msg:find(L.Victory5) or msg:find(L.Victory6) or msg:find(L.Lost1) or msg:find(L.Lost2) or msg:find(L.Lost3) or msg:find(L.Lost4) or msg:find(L.Lost5) or msg:find(L.Lost6) or msg:find(L.Lost7) or msg:find(L.Lost8) or msg:find(L.Lost9)) then
		self:SendSync("MatchEnd")--]]
	end
end

--TODO: Maybe add a PLAYE_REGEN_DISABLED event that checks current target for deciding what special bars to start on engage.
function mod:PLAYER_REGEN_ENABLED()
	--Backup for failed match end detection. this only works if you're grouped with the fighter. This is for when npc doesn't yell on victory or wipe.
	if playerIsFighting then--We check playerIsFighting to filter bar brawls, this should only be true if we were ported into ring.
		playerIsFighting = false
		self:SendSync("MatchEnd")
	end
end

function mod:UNIT_DIED(args)
	--Another backup for when npc doesn't yell. This is a way to detect a wipe at least.
	local thingThatDied = string.split("-", args.destName)--currentFighter never has realm name, so we need to strip it from combat log for CRZ support
	if currentFighter and currentFighter == thingThatDied then--They wiped.
		self:SendSync("MatchEnd")
	end
end

function mod:ZONE_CHANGED_NEW_AREA()
	local currentZoneID = GetCurrentMapAreaID()
	if currentZoneID == 922 or currentZoneID == 925 then modsStopped = false return end--We returned to pug, reset variable
	if modsStopped then return end--Don't need this to fire every time you change zones after the first.
	self:Stop()
	for i = 1, 8 do
		local mod2 = DBM:GetModByName("BrawlRank" .. i)
		if mod2 then
			mod2:Stop()--Stop all timers and warnings
		end
	end
	modsStopped = true
end

--Most group up for this so they can buff eachother for matches. Syncing should greatly improve reliability, especially for match end since the person fighting definitely should detect that (probably missing yells still)
function mod:OnSync(msg)
	if msg == "MatchBegin" then
		self:Stop()--Sometimes bizmo doesn't yell when a match ends too early, if a new match begins we stop on begin before starting new stuff
		matchActive = true
		berserkTimer:Start()
	elseif msg == "MatchEnd" then
		currentFighter = nil
		matchActive = false
		self:Stop()
		local mod2 = DBM:GetModByName("BrawlRank" .. currentRank)
		if mod2 then
			mod2:Stop()--Stop all timers and warnings
		end
	end
end