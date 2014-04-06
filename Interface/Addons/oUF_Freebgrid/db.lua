local ADDON_NAME, ns = ...
local binding_modifiers = { "Click", "shift-", "ctrl-", "alt-", "ctrl-shift-", "alt-shift-", "alt-ctrl-"}   --���ʩ����ش���
ns.mediapath = "Interface\\AddOns\\oUF_Freebgrid\\media\\"

ns.defaults = {
    scale = 1.0,
    scale25 = 1.0,
    scale40 = 1.0,
    scaleYes = false,
    width = 65,
    height = 32,
    texture = "gradient",
    texturePath = ns.mediapath.."gradient",
    font = "calibri",
    fontPath = "Fonts\\ARkai_T.TTF",
    fontsize = 14,
    fontsizeEdge = 12,
    outline = nil,
    solo = false,
    player = true,
    party = true,
    numCol = 5,
    numUnits = 5,
    petUnits = 5,
    MTUnits = 5,
    spacing = 5,
    orientation = "HORIZONTAL",  --Ѫ��ˮƽ�䶯
    porientation = "HORIZONTAL", --����/���� ˮƽ�䶯
    horizontal = true,           --С���ڳ�Աˮƽ����
    pethorizontal = false,
    MThorizontal = false,
    growth = "DOWN",
    multi = true,            --��С������
    petgrowth = "RIGHT",
    MTgrowth = "RIGHT",
    omfChar = false,
    reversecolors = true,   --Ѫ��ְҵ��ɫ��ʾ
    definecolors = false,   
    powerbar = true,
    powerbarsize = .20,
    outsideRange = .40,
    arrow = true,
    arrowmouseover = true,
    arrowmouseoveralways = false,
    arrowscale = 1.0,
    healtext = false,
    healbar = true,
    healoverflow = true,
    healothersonly = false,
    healalpha = .40,
    roleicon = true,  --��ɫͼ��  ����̹������dps��3��ͼ��
    pets = false,
    MT = false,
    indicatorsize = 6,
    symbolsize = 11,
    leadersize = 12,
    aurasize = 18,
    deficit = false,
    perc = false,
    actual = false,
    myhealcolor = { r = 0.0, g = 1.0, b = 0.5, a = 0.4 },
    otherhealcolor = { r = 0.0, g = 1.0, b = 0.0, a = 0.4 },
    hpcolor = { r = 0.1, g = 0.1, b = 0.1, a = 1 },
    hpbgcolor = { r = 0.33, g = 0.33, b = 0.33, a = 1 },
    powercolor = { r = 1, g = 1, b = 1, a = 1 },
    powerbgcolor = { r = 0.33, g = 0.33, b = 0.33, a = 1 },
    powerdefinecolors = false,   --�Զ��巨������ɫ
    colorSmooth = false,
    gradient = { r = 1, g = 0, b = 0, a = 1 },
    tborder = true,
    fborder = true,
    afk = true,
    highlight = true,
    dispel = true,
    powerclass = true,
    tooltip = true,
    smooth = false,
    altpower = false,
    sortName = false,
    sortClass = false,
    classOrder = "DEATHKNIGHT,DRUID,HUNTER,MAGE,PALADIN,PRIEST,ROGUE,SHAMAN,WARLOCK,WARRIOR",
    hidemenu = false,
    autorez = false,
    ClickCastenable = true,     --���ʩ�����
	  ClickCastsetchange = false, --���ʩ�����
    ClickCastset = {},          --���ʩ�����
    cluster = {
        enabled = false,
        range = 30,
        freq = 250,
        perc = 90,
        textcolor = { r = 0, g = .9, b = .6, a = 1 },
    },
    hpinverted = false,
    hpreversed = false,
    ppinverted = false,
    ppreversed = false,
}


local ClassClickSets = {
	PRIEST = { 
		["1"] = {
			["Click"]		= {
				["action"]	= "target",
							},
			["shift-"]		= {
				["action"]	= 139,--"�֏�",
							},
			["ctrl-"]		= {
				["action"]	= 527,--"�ɢħ��",
							},
			["alt-"]		= {
				["action"]	= 2061,--"�����ί�",
							},
			["alt-ctrl-"]	= {
				["action"]	= 2006,--"�ͻ��g",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]		= 17,--"�����g:��",
							},
			["shift-"]		= {
				["action"]	= 33076,--"�K�϶\��",
							},
			["ctrl-"]		= {
				["action"]	= 528,--"������", 
							},
			["alt-"]		= {
				["action"]	= 2060,--"��Ч�ί��g",
							},
			["alt-ctrl-"]	= {
				["action"]	= 32546,--"���`�ί�",
							},
		},
		["3"] = {
			["Click"]			= {
				["action"]	= 34861,--"�ί�֮�h",
							},
			["shift-"]		= {
				["action"]	= 2050, --������
							},
			["alt-"]		= {
				["action"]	= 1706, --Ư����
							},
			["ctrl-"]		= {
				["action"]	= 21562,--��
							},
		},
		["4"] = {
			["Click"]		= {
				["action"]		= 596, --���Ƶ���
							},
			["shift-"]		= {
				["action"]	= 47758, -- ����
							},
			["ctrl-"]		= {
				["action"]	= 73325, -- ������Ծ
							},
		},
		["5"] = {
			["Click"]			= {
				["action"]	= 48153, -- �ػ�֮��
							},
			["shift-"]		= {
				["action"]	= 88625, -- ʥ����
							},
			["ctrl-"]		= {
				["action"]	= 33206,--ʹ��ѹ��
							},
		},
	},
	
	DRUID = { 
		["1"] = {
			["Click"]		= {
				["action"]	= "target",
							},
			["shift-"]		= {
				["action"]	= 774,--"�ش��g",
							},
			["ctrl-"]		= {
				["action"]	= 2782,--"������ʴ",
							},
			["alt-"]		= {
				["action"]	= 8936,--"�K��",
							},
			["alt-ctrl-"]	= {
				["action"]	= 50769,--"�ͻ�",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 48438,--"Ұ�Գɳ�",
							},
			["shift-"]		= {
				["action"]	= 18562,--"Ѹ������",
							},
			["ctrl-"]		= {
				["action"]	= 88423, -- ��Ȼ����
							},
			["alt-"]		= {
				["action"]	= 50464,--"���a�g",
							},
			["alt-ctrl-"]	= {
				["action"]	= 1126, -- Ұ��ӡ��
							},
		},
		["3"] = {
			["Click"]			= {
				["action"]	= 33763,--"����֮��",
							},
			["shift-"]		= {
				["action"]	= 5185,--����֮��
							},
			["ctrl-"]		= {
				["action"]	= 20484,--����,
							},
		},
		["4"] = {
			["Click"]			= {
				["action"]	= 29166,----����
							},
			["alt-"]		= {
				["action"]		= 33763,----����֮��
							},
		},
	},
	SHAMAN = { 
		["1"] = {
			["Click"]		= {
				["action"]	= "target",
							},
			["ctrl-shift-"]	= {
				["action"]	= 974,		--"���֮��",
				},
			["ctrl-"]		= {
				["action"]	= 2008,		--"����֮��",
							},
			["alt-"]		= {
				["action"]	= 8004,		--"����֮ӿ",
							},
			["shift-"]		= {
				["action"]	= 1064,		--"������",
							},
			["alt-ctrl-"]	= {
				["action"]	= 331,		--"���Ʋ�",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 51886,	--"�������",
							},
			["ctrl-"]		= {
				["action"]	= 546,		--ˮ������
							},
			["alt-"]		= {
				["action"]	= 131,		--ˮ�º���
							},
		},
		["3"] = {
			["Click"]			= {
				["action"]	= 61295,	--"����",
							},
			["alt-ctrl-"]	= {
				["action"]	= 77472,	--"ǿЧ���Ʋ�",	
							},
		},
		["4"] = {
			["Click"]			= {
				["action"]	= 73680,	--"Ԫ���ͷ�",
							},
		},
		["5"] = {

		},
	},

	PALADIN = { 
		["1"] = {
			["Click"]		= {
				["action"]	= "target",
							},
			["shift-"]		= {
				["action"]	= 635,--"�}���g",
							},
			["alt-"]		= {
				["action"]	= 19750,--"�}���W�F",
							},
			["ctrl-"]		= {
				["action"]	= 53563,--"ʥ���ű�",
							},
			["alt-ctrl-"]	= {
				["action"]	= 7328,--"���H",
							},
		},
		["2"] = {
		    ["Click"]			= {
				["action"]	= 20473,--"���}���",
							},
			["shift-"]		= {
				["action"]	= 82326,--"��ʥ֮��",
							},
			["ctrl-"]		= {
				["action"]	= 4987,--"�Q���g",
							},
			["alt-"]		= {
				["action"]	= 85673,--"��ҫʥ��",
							},
			["alt-ctrl-"]	= {
				["action"]	= 633,--"�}���g",
							},
		},
		["3"] = {
		    ["Click"]			= {
				["action"]	= 31789,--���x���o
							},
			["alt-"]		= {
				["action"]	= 1044,--����֮��
							},
			["ctrl-"]	= {
				["action"]	= 31789, -- �������
							},
		},
		["4"] = {
			["Click"]			= {
				["action"]	= 1022,	--"����֮��",
							},
			["alt-"]		= {
				["action"]	= 6940,  --����֮��
							},
		},
		["5"] = {
			["Click"]			= {
				["action"]	= 1038,	--"����֮��",
							},
		},
	},

	WARRIOR = { 
		["1"] = {
			["Click"]			= {
				["action"]	= "target",
							},
			["ctrl-"]		= {
				["action"]	= 50720,--"������o",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 3411,--"��_",
							},
		},
	},

	MAGE = { 
		["1"] = {
			["Click"]			= {
				["action"]	= "target",
							},
			["alt-"]		= {
				["action"]	= 1459,--"�ط�����",
							},
			["ctrl-"]		= {
				["action"]	= 54646,--"רע",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 475,--"����{��",
							},
			["shift-"]		= {
				["action"]	= 130,--"����",
							},
		},
	},

	WARLOCK = { 
		["1"] = {
			["Click"]			= {
				["action"]	= "target",
							},
			["alt-"]		= {
				["action"]	= 80398,--"�ڰ���ͼ",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 5697,--"ħϢ",
							},
		},
	},

	HUNTER = { 
		["1"] = {
			["Click"]			= {
				["action"]	= "target",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 34477,--"�`��",
							},
			["shift-"]		= {
				["action"]	= 136, --���Ƴ���
							},
		},
	},
	
	ROGUE = { 
		["1"] = {
			["Click"]			= {
				["action"]	= "target",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 57933,--"͵��Q��",
							},
		},
	},
	
	DEATHKNIGHT = {
		["1"] = {
			["Click"]			= {
				["action"]	= "target",
							},
			["shift-"]		= {
				["action"]	= 61999, --��������
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 47541, --����
							},
			["alt-"]		= {
				["action"]	= 49016, -- а����ң�а���츳)
							},
		},
	},
}

local function GetTalentSpec()
	local currentSpec = GetSpecialization()
	local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec)) or "NONE"
	return currentSpecName
end

function ns.ClickSetDefault ()
	local db = {}
	local i
	for i=1, 5  do
		db[tostring(i )] = {}
		local modifier
		for _, modifier in ipairs(binding_modifiers) do
			db[tostring(i )][modifier] = {}
			db[tostring(i )][modifier]["action"] = "NONE"
		end
	end

	local class = select(2, UnitClass("player"))
		for k, _ in pairs(ClassClickSets[class]) do
				for j, _ in pairs(ClassClickSets[class][k]) do
					local var = ClassClickSets[class][k][j]["action"]
					local spellname = GetSpellInfo(var)
					if (var == "target" or var == "menu" or var == "follow") then
						db[k][j]["action"] = var
					elseif spellname then						
						db[k][j]["action"] = spellname
					end
				end
		end
	ns.db.ClickCastset = db
end

function ns.InitDB()
    _G[ADDON_NAME.."DB"] = _G[ADDON_NAME.."DB"] or {}
	
	for n, _ in pairs(_G[ADDON_NAME.."DB"]) do		
		if not string.match(n,"Talent") then
			_G[ADDON_NAME.."DB"][n] = nil
		end
	end
	
	ns.TalentTree = "Talent"..format('%q', GetTalentSpec())
	local tree = ns.TalentTree

	if type(_G[ADDON_NAME.."DB"][tree]) ~= "table" then
		_G[ADDON_NAME.."DB"][tree] = {}
	end	
	
	for k, v in pairs(ns.defaults) do
        if(type(_G[ADDON_NAME.."DB"][tree][k]) == 'nil') then
            _G[ADDON_NAME.."DB"][tree][k] = v
        end
    end
	
    ns.db = _G[ADDON_NAME.."DB"][tree]

	if not ns.db.ClickCastsetchange then
		ns.ClickSetDefault () 
		ns.db.ClickCastsetchange = true	
	end
	
	if ns.TalentChanged then
		ns.updateFrameSetting()
		ns.ApplyClickSetting()
		ns.TalentChanged = nil
	end
	
end

function ns.FlushDB()
    for k,v in pairs(ns.defaults) do 
        if ns.db[k] == v and type(ns.db[k]) ~= "table" then 
            ns.db[k] = nil 
        end 
    end
end