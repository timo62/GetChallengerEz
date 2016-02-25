--[[function OnDraw()
    for i = 1, myHero.buffCount do
        local tBuff = myHero:getBuff(i)
        if BuffIsValid(tBuff) then
                DrawTextA(tBuff.name,12,20,20*i+20)
        end
    end
end]]

function OnLoad()
	QQQ = BarUnderObject()
	QQQ:AddBar(myHero, 2, nil, nil, 3)
	Menu()
end



--[[TableBuffs = {
	["MasterYi"] = {
					"wujustylesuperchargedvisual" = {ActiveTime = 5},
				   "doublestrike" = {ActiveTime = 4}
				}
	--["MasterYi"] = {BuffName = "doublestrike", ActiveTime = 4} --zhonyasringshield
}]]

function OnUpdateBuff(unit, buff)
  if unit and buff then
    if ItemTable[buff.name] then
    	--QQQ:AddBar(unit, ItemTable[buff.name].ActiveTime, nil, nil, 3) 
    	if Menu.itemsMenu.useReg and buff.name == "RegenerationPotion" then 
      		QQQ:AddBar(unit, ItemTable[buff.name].ActiveTime, nil, nil, 3)
      	elseif Menu.itemsMenu.useRefill and buff.name == "ItemCrystalFlask" then
      		QQQ:AddBar(unit, ItemTable[buff.name].ActiveTime, nil, nil, 3)
  		elseif Menu.itemsMenu.useHunter and buff.name == "ItemCrystalFlaskJungle" then
      		QQQ:AddBar(unit, ItemTable[buff.name].ActiveTime, nil, nil, 3)
  		elseif Menu.itemsMenu.useCorruption and buff.name == "ItemDarkCrystalFlask" then
      		QQQ:AddBar(unit, ItemTable[buff.name].ActiveTime, nil, nil, 3)
  		elseif Menu.itemsMenu.useElixirOfSorcery and buff.name == "ElixirOfSorcery" then
      		QQQ:AddBar(unit, ItemTable[buff.name].ActiveTime, nil, nil, 3)
      	elseif Menu.itemsMenu.useElixirOfIron and buff.name == "ElixirOfIron" then
      		QQQ:AddBar(unit, ItemTable[buff.name].ActiveTime, nil, nil, 3)
      	elseif Menu.itemsMenu.useElixirOfWrath and buff.name == "ElixirOfWrath" then
      		QQQ:AddBar(unit, ItemTable[buff.name].ActiveTime, nil, nil, 3)
      	elseif Menu.itemsMenu.useYoumu and buff.name == "spectralfury" then
      		QQQ:AddBar(unit, ItemTable[buff.name].ActiveTime, nil, nil, 3)
  		elseif Menu.itemsMenu.useZhonya and buff.name == "zhonyasringshield" then
      		QQQ:AddBar(unit, ItemTable[buff.name].ActiveTime, nil, nil, 3)
  		elseif Menu.itemsMenu.useHexdrinker and buff.name == "Hexdrinker" then
      		QQQ:AddBar(unit, ItemTable[buff.name].ActiveTime, nil, nil, 3)
  		end
  	end
  end
end

function OnRemoveBuff(unit, buff)
	if unit and buff.valid and unit.isMe then
		if ItemTable[buff.name] then
			QQQ:RemoveBar(myHero)
		elseif Menu.itemsMenu.useAngel and buff.name == "willrevive" then
			QQQ:AddBar(unit, 4, nil, nil, 3) 
		end
	end
end

class "BarUnderObject"
function BarUnderObject:__init()
	self.bars = {}
	self.draw = true
	AddDrawCallback(function ()
		self:OnDraw()
	end)
	AddTickCallback(function ()
		self:DeleteInvalid()
	end)
end

function BarUnderObject:OnDraw()
	DrawTextA(#self.bars)

	local w = WINDOW_W
	local h = WINDOW_H
	for i,v in pairs(self.bars) do
		local wts = WorldToScreen(D3DXVECTOR3(v.obj.x,v.obj.y,v.obj.z))
		local percentage = ((v.time-os.clock())/v.t)*100
		DrawLineBorder(wts.x-v.maxsize*(percentage/2),wts.y,wts.x+v.maxsize*(percentage/2),wts.y,12,v.color,1)
		DrawLine(wts.x-v.maxsize*(percentage/2)+1,wts.y,wts.x+v.maxsize*(percentage/2),wts.y, 11, v.fillcolor )
		DrawTextA(math.round(v.time-os.clock(),1),12,wts.x,wts.y-5)
	end
end

function BarUnderObject:AddBar(_obj,_time,_color, _fillcolor,_maxsize)
	if not _color then _color = ARGB(128,255,255,255) end
	if not _fillcolor then _fillcolor = ARGB(128,0,255,0) end
	if not _maxsize then _maxsize = 1.5 end

	if _obj.valid and _time and _time > 0 then
		self.bars[#self.bars+1] = {obj = _obj, t = _time, time = os.clock()+_time, color = _color, fillcolor = _fillcolor, maxsize = _maxsize}
	end
end

function BarUnderObject:RemoveBar(_obj)
	local n = {}
	for _, v in pairs(self.bars) do
		if v.obj ~= _obj then
			n[#n+1] = v
		end
	end
	self.bars = nil
	self.bars = n
end

function BarUnderObject:DeleteInvalid()
	local n = {}
	for _, v in pairs(self.bars) do
		if v.obj and v.obj.valid and v.time > os.clock() then
			n[#n+1] = v
		end
	end
	self.bars = nil
	self.bars = n
end

	function Menu ()
	Menu = scriptConfig("Ez Timer", "EZTimer")

    Menu:addSubMenu("Items", "itemsMenu")
      Menu.itemsMenu:addParam("useAngel", "Show Guardian Angel", SCRIPT_PARAM_ONOFF, true)
      Menu.itemsMenu:addParam("useYoumu", "Show Youmu", SCRIPT_PARAM_ONOFF, true)
      Menu.itemsMenu:addParam("useHexdrinker", "Show Hexdrinker", SCRIPT_PARAM_ONOFF, true)
      Menu.itemsMenu:addParam("useZhonya", "Show Zhonyas", SCRIPT_PARAM_ONOFF, true)
      Menu.itemsMenu:addParam("useReg", "Show Regeneration Potion", SCRIPT_PARAM_ONOFF, true)
      Menu.itemsMenu:addParam("useRefill", "Show Refilable Potion", SCRIPT_PARAM_ONOFF, true)
      Menu.itemsMenu:addParam("useHunter", "Show Hunter's Potion", SCRIPT_PARAM_ONOFF, true)
      Menu.itemsMenu:addParam("useCorruption", "Show Corruption Potion", SCRIPT_PARAM_ONOFF, true)
      Menu.itemsMenu:addParam("useElixirOfIron", "Show Elixir Of Iron", SCRIPT_PARAM_ONOFF, true)
      Menu.itemsMenu:addParam("useElixirOfSorcery", "Show Elixir Of Sorcery", SCRIPT_PARAM_ONOFF, true)
      Menu.itemsMenu:addParam("useElixirOfWrath", "Show Elixir Of Wrath", SCRIPT_PARAM_ONOFF, true)
      
	end


--local [_P] = "Passiv"

ItemTable = {
	---------------------- WARDS HERE -------------------------
	["PinkWard"] = {ItemName = "VisionWard", ActiveTime = 60, Effect = "Ward", CoolDown = 0},
	--["WardingTotemlv1"] = {ItemName = "TrinketTotemLvl1", ActiveTime = 60 + 3.5*enemyHero.lvl, Effect = "Ward", CoolDown = 180-5.3*enemyHero.lvl},
	["FarsightWard"] = {ItemName = "TrinketOrbLvl3", ActiveTime = 60, Effect = "Ward", CoolDown = 90},
	["Sightstone"] = {ItemName = "ItemGhostWard", ActiveTime = 150, Effect = "Ward", CoolDown = 0},
	["RubySightstone"] = {Itemname = "ItemGhostWard", ActiveTime = 150, Effect = "Ward", CoolDown = 0},

	---------------------- POTIONS/POTS HERE ------------------------- 

	--["HealthPotion"] = {ItemName = "RegenerationPotion", Buffname = "RegenerationPotion" ,ActiveTime = 15, Effect = "Healing", CoolDown = 0},
	["RegenerationPotion"] = {ItemName = "RegenerationPotion", Buffname = "RegenerationPotion" ,ActiveTime = 15, Effect = "Healing", CoolDown = 0},
	["ItemCrystalFlask"] = {ItemName = "RefilablePotion", Buffname = "ItemCrystalFlask" ,ActiveTime = 12, Effect = "Healing", CoolDown = 0},
	["ItemDarkCrystalFlask"] = {ItemName = "CorruptionPotion", Buffname = "ItemDarkCrystalFlask" ,ActiveTime = 12, Effect = "Healing", CoolDown = 0}, -- ID 2033
	["ItemCrystalFlaskJungle"] = {ItemName = "HuntersPotion", Buffname = "ItemCrystalFlaskJungle" ,ActiveTime = 8, Effect = "Healing", CoolDown = 0},
	["ElixirOfIron"] = {ItemName = "ElixirOfIron", Buffname = "" ,ActiveTime = 180, Effect = "Elixir", CoolDown = 0}, -- ID 2138
	["ElixirOfSorcery"] = {ItemName = "ElixirOfSorcery", Buffname = "" ,ActiveTime = 180, Effect = "Elixir", CoolDown = 0}, -- ID 2139
	["ElixirOfWrath"] = {ItemName = "ElixirOfWrath", Buffname = "" ,ActiveTime = 180, Effect = "Elixir", CoolDown = 0}, -- ID 2140
	["BiscuitPotion"] = {ItemName = "ItemMiniRegenPotion", Buffname = "" ,ActiveTime = 15, Effect = "Healing", CoolDown = 0},


	---------------------- ITEMS HERE ----------------------------
	--["mawenrage"] = {ItemName = "SteraksGage", Buffname = "", ActiveTime = 3, Effect = "Speed", CoolDown = 60},
	["TalismanOfAscension"] = {ItemName = "shurelyascrest", Buffname = "", ActiveTime = 3, Effect = "Speed", CoolDown = 60},
	["zhonyasringshield"] = {ItemName = "ZhonyasHourglass", Buffname = "zhonyasringshield", ActiveTime = 2.5, Effect = "Invulnerable", CoolDown = 90},
	["BilgewaterCutlass"] = {ItemName = "BilgewaterCutlass", Buffname = "", ActiveTime = 2, Effect = "DMG + Slow", CoolDown = 90},
	["HextechGunblade"] = {ItemName = "HextechGunblade", Buffname = "", ActiveTime = 2, Effect = "DMG + Slow", CoolDown = 30},
	["BOTRK"] = {ItemName = "ItemSwordOfFeastAndFamine", Buffname = "", ActiveTime = 3, Effect = "DMG + Slow", CoolDown = 90},
	["Catalyst"] = {ItemName = "catalystheal", Buffname = "", ActiveTime = 8, Effect = "Healing", CoolDown = 0}, 								-- ID 3027
	["RodOfAges"] = {ItemName = "catalystheal", Buffname = "", ActiveTime = 8, Effect = "Healing", CoolDown = 0}, 								-- ID 3027
	["RighteousGlory"] = {ItemName = "ItemRighteousGlory", Buffname = "", ActiveTime = 3, Effect = "Speed + Slow", CoolDown = 90},
	["ExecutionersCalling"] = {ItemName = " ", Buffname = "" ,ActiveTime = 3, Effect = "Wound", CoolDown = 0},									-- ID 3123
	["MortalReminder"] = {ItemName = "lastwhisper", Buffname = "" ,ActiveTime = 5, Effect = "Wound", CoolDown = 0},
	["Hexdrinker"] = {ItemName = "hexdrinker", Buffname = "Hexdrinker" ,ActiveTime = 5, Effect = "Shield", CoolDown = 90},								-- ID 3155
	["MawOfMalmortius"] = {ItemName = "mawenrage", Buffname = "" ,ActiveTime = 5, Effect = "Wound", CoolDown = 90},							-- ID 3156
	["KircheisShard"] = {ItemName = "itemstatikshank", Buffname = "" ,ActiveTime = 0, Effect = "Energize", CoolDown = 0},						-- ID 2015
	["RapidFireCannon"] = {ItemName = "itemrapidfirecannon", Buffname = "" ,ActiveTime = 0, Effect = "Energize", CoolDown = 0},					-- ID 3094
	["StatikkShiv"] = {ItemName = "itemstatikshankchain", Buffname = "" ,ActiveTime = 0, Effect = "Energize", CoolDown = 0},					-- ID 3087
	["Phage"] = {ItemName = "itemphageminispeed, itemphagespeed", Buffname = "" ,ActiveTime = 2, Effect = "Speed", CoolDown = 0},				-- ID 3044
	["BlackCleaver"] = {ItemName = "itemphageminispeed, itemphagespeed", Buffname = "" ,ActiveTime = 2, Effect = "Speed", CoolDown = 0},		-- ID 3071
	["TrinityForcePhage"] = {ItemName = "itemphageminispeed, itemphagespeed", Buffname = "" ,ActiveTime = 2, Effect = "Speed", CoolDown = 0},
	["SerratedDirk"] = {ItemName = "serrateddirk", Buffname = "" ,ActiveTime = 4, Effect = "Bonus Dmg", CoolDown = 0},							-- ID 3134
	["spectralfury"] = {ItemName = "YoumusBlade", Buffname = "spectralfury" ,ActiveTime = 6, Effect = "Attack Speed + Speed", CoolDown =45}, -- Youmuu
	["QSS"] = {ItemName = "QuicksilverSash", Buffname = "" ,ActiveTime = 0, Effect = "Cleanse", CoolDown = 90},
	["MercurialScimitar"] = {ItemName = "ItemMercurial", Buffname = "" ,ActiveTime = 1, Effect = "Cleanse + Speed", CoolDown = 90},
	["DervishBlade"] = {ItemName = "ItemDervishBlade", Buffname = "" ,ActiveTime = 1, Effect = "Cleanse + Speed", CoolDown = 90},
	["Sheen"] = {ItemName = "sheen", Buffname = "" ,ActiveTime = 0, Effect = "Bonus Dmg", CoolDown = 1.5},										-- ID 3057
	["TrinityForceSheen"] = {ItemName = " ", Buffname = "" ,ActiveTime = 0, Effect = "Bonus Dmg", CoolDown = 1.5},								--	<--- Ingame
	["IceBornGauntletSheen"] = {ItemName = "sheen", Buffname = "" ,ActiveTime = 0, Effect = "Bonus Dmg", CoolDown = 1.5},						--	<--- Ingame
	["LichBane"] = {ItemName = "lichbane", Buffname = "" ,ActiveTime = 0, Effect = "Bonus Dmg", CoolDown = 1.5},								--	<--- ID 3100
	["FaceOfTheMountainShield"] = {ItemName = "HealthBomb", Buffname = "" ,ActiveTime = 4, Effect = "Shield", CoolDown = 60},
	["FaceOfTheMountainSlow"] = {ItemName = "HealthBomb", Buffname = "" ,ActiveTime = 2, Effect = "Slow", CoolDown = 60},
	["Tiamat"] = {ItemName = "ItemTiamatCleave", Buffname = "" ,ActiveTime = 0, Effect = "AOE Dmg", CoolDown = 10},
	["RavenousHydra"] = {ItemName = "ItemTiamatCleave", Buffname = "" ,ActiveTime = 0, Effect = "AOE Dmg", CoolDown = 10},
	["AbyssalScepter"] = {ItemName = "abyssalscepteraura", Buffname = "" ,ActiveTime = 0, Effect = "Reduced Magic Resistance", CoolDown = 0},	-- ID 3001
	["SeraphsEmbrace"] = {ItemName = "ItemSeraphsEmbrace", Buffname = "" ,ActiveTime = 0, Effect = "Bonus Dmg", CoolDown = 0}, --Muramana
	["SeraphsEmbraceShield"] = {ItemName = "ItemSeraphsEmbrace", Buffname = "" ,ActiveTime = 3, Effect = "Shield", CoolDown = 120},
	["Muramana"] = {ItemName = "Muramana", Buffname = "" ,ActiveTime = 0, Effect = "Bonus Dmg", CoolDown = 0},
	["ArdentCenser"] = {ItemName = "itemangelhandcheck", Buffname = "" ,ActiveTime = 6, Effect = "Attack Speed + Bonus Dmg", CoolDown = 0},	-- ID 3504
	["BansheesVeil"] = {ItemName = "bansheesveil", Buffname = "" ,ActiveTime = 0, Effect = "Spell Shield", CoolDown = 40},						-- ID 3102
	["DeadMansPlate"] = {ItemName = "dreadnoughtmomentum", Buffname = "" ,ActiveTime = 0, Effect = "Speed", CoolDown = 0},						-- ID 3742
	["FrozenHeart"] = {ItemName = "frozenheartaura", Buffname = "" ,ActiveTime = 0, Effect = "Attack Speed Reduced", CoolDown = 0},				-- ID 3110
	["FrozenMallet"] = {ItemName = "itemslow", Buffname = "" ,ActiveTime = 1.5, Effect = "Slow", CoolDown = 0},								-- ID 3022
	["GuardianAngel"] = {ItemName = "willrevive", Buffname = "willrevive" ,ActiveTime = 4, Effect = "Invulnerable", CoolDown = 300},						-- ID 3026
	["Solari"] = {ItemName = "IronStylus", Buffname = "" ,ActiveTime = 2, Effect = "Shield", CoolDown = 60},
	["LudensEcho"] = {ItemName = "itemmagicshank", Buffname = "" ,ActiveTime = 0, Effect = "Bonus Dmg", CoolDown = 0},							-- ID 3285
	["RanduinsOmen"] = {ItemName = "RanduinsOmen", Buffname = "" ,ActiveTime = 4, Effect = "Slow", CoolDown = 60},
	["RylaisCrystalScepter"] = {ItemName = "rylaivisualslow", Buffname = "" ,ActiveTime = 1.5, Effect = "Slow", CoolDown = 0},					-- ID 3116
	["SteraksGage"] = {ItemName = "itemscepterofauthority", Buffname = "" ,ActiveTime = 8, Effect = "Bonus Dmg + Shield", CoolDown = 45},		-- ID 3748
	["DuskbladeOfDraktharr"] = {ItemName = "itemdusk", Buffname = "" ,ActiveTime = 0, Effect = "Bonus Dmg", CoolDown = 120}						-- ID 3147
}

--[[ChampsTable = {
	["Master Yi"] = {
	[_R] = {SpellName = "Highlander", Buffname = "Highlander" ,CoolDown = 75, ActiveTime = 10}, -- +4 Duration for every takedown
	[_E] = {SpellName = "", Buffname = "", Cooldown = 0, ActiveTime = 6},
	[_P] = {SpellName = "", Buffname = "", Cooldown = 0, ActiveTime = 3}
	}
}]]

--[[ChampsTable = {
	
	["Aatrox"] = {
	[_P] = {SpellName = "Disintegrate", Buffname = "aatroxpassivedeath" ,CoolDown = 225, ActiveTime = 3}
	[_R] = {SpellName = "AatroxR", Buffname = "AatroxR" ,CoolDown = 100, ActiveTime = 12}
	},

	["Akali"] = {
	[_Q] = {SpellName = "AkaliMota", Buffname = "AkaliMota" ,CoolDown = , ActiveTime = 6} -- Akali Q Mark 
	[_W] = {SpellName = "AkaliTwilightShroud", Buffname = "" ,CoolDown = 20 , ActiveTime = 8}
	},

	["Alistar"] = {
	[_R] = {SpellName = "FerociousHowl", Buffname = "Ferocious Howl" ,CoolDown = 120 100 80, ActiveTime = 7}
	},

	["Amumu"] = {
	[_R] = {SpellName = "CurseoftheSadMummy", Buffname = "CurseoftheSadMummy" ,CoolDown = 150 130 110, ActiveTime = 2}
	},

	["Anivia"] = {
	[_P] = {SpellName = "RebirthEgg", Buffname = "" ,CoolDown = 240, ActiveTime = 6}
	[_W] = {SpellName = "IceBlock", Buffname = "" ,CoolDown = 25, ActiveTime = 5}
	},

	["Annie"] = {
	[_P] = {SpellName = "Pyromania", Buffname = "Pyromania" ,CoolDown = 0, ActiveTime = }
	},

	["Azir"] = {
	[_W] = {SpellName = "AzirW", Buffname = "" ,Buffname = "" ,CoolDown = 15, ActiveTime = 4}
	},

	["Bard"] = {
	[_R] = {SpellName = "BardR", Buffname = "BardRStasis" ,Buffname = "" ,CoolDown = 90, ActiveTime = 2.5}
	},
	
	["Blitzcrank"] = {
	[_P] = {SpellName = "ManaBarrier", Buffname = "ManaBarrier" ,Buffname = "" ,CoolDown = 90, ActiveTime = 10} 
	[_W] = {SpellName = "Overdrive", Buffname = "Overdrive" ,Buffname = "" ,CoolDown = 15, ActiveTime = 5}
	[_W2] = {SpellName = "", Buffname = "" ,Buffname = "slow" ,CoolDown =0, ActiveTime = 1.5}
	},

	["Cassiopeia"] = {
	[_W] = {SpellName = "CassiopeiaMiasma", Buffname = "CassiopeiaMiasma" ,Buffname = "" ,CoolDown = 13, ActiveTime = 7}
	},

	["Diana"] = {
	[_W] = {SpellName = "DianaOrbs", Buffname = "DianaOrbs" ,Buffname = "" ,CoolDown = 10, ActiveTime = 5}
	},

	["Dr. Mundo"] = {
	[_R] = {SpellName = "", Buffname = "" ,Buffname = "" ,CoolDown = 100, ActiveTime = 12}
	},

	["Elise"] = { -- 2 = Spiderform
	[_W] = {SpellName = "EliseHumanW", Buffname = "" ,Buffname = "" ,CoolDown = 12, ActiveTime = 3 } 
	[_W2] = {SpellName = "EliseSpiderW", Buffname = "BuffEliseSkitter" ,Buffname = "" ,CoolDown = 12, ActiveTime = 3 }
	[_E2] = {SpellName = "EliseSpiderE", Buffname = "BuffEliseRappel" ,Buffname = "" ,CoolDown = 26, ActiveTime = 2 }
	},

	["Fiddlesticks"] = {
	[_W] = {SpellName = "Drain", Buffname = "Drain" ,Buffname = "" ,CoolDown = 10, ActiveTime = 5}
	[_R1] = {SpellName = "CrowstormSurprise", Buffname = "" ,Buffname = "" ,CoolDown = 150, ActiveTime = 1.5}  -- R Channeltime (not sure)
	[_R2] = {SpellName = "Crowstorm", Buffname = "Crowstorm" ,Buffname = "" ,CoolDown = 0, ActiveTime = 5} -- R Activ
	},
	
	["Fizz"] = {
	[_R] = {SpellName = "FizzMarinerDoom", Buffname = "" ,Buffname = "" ,CoolDown = 100, ActiveTime = 1.5}
	},
	
	["Galio"] = {
	[_R] = {SpellName = "GalioIdolOfDurand", Buffname = "GalioIdolOfDurand" ,Buffname = "" ,CoolDown = 150, ActiveTime = 2}
	},
	
	["Gangplank"] = {
	[_R] = {SpellName = "GangplankR", Buffname = "GangplankRSlow" ,Buffname = "" ,CoolDown = 160, ActiveTime = 8}
	[_R2] = {SpellName = "GangplankR", Buffname = "GangplankRSpeed" ,Buffname = "" ,CoolDown = 160, ActiveTime = 8} -- Upgrade
	},
	
	["Garen"] = {
	[_Q] = {SpellName = "GarenQ", Buffname = "" ,Buffname = "GarenQBuff" ,CoolDown = 8, ActiveTime = 4.5}
	[_W] = {SpellName = "GarenW", Buffname = "" ,Buffname = "GarenW" ,CoolDown = 24, ActiveTime = 2 + (1* enemyHero:GetSpellData(_W).level)}
	[_E] = {SpellName = "GarenE", Buffname = "" ,Buffname = "GarenE" ,CoolDown = 9, ActiveTime = 3}
	},

	["Graves"] = {
	[_W] = {SpellName = "GravesSmokeGrenade", Buffname = "" ,Buffname = "" ,CoolDown = 26, ActiveTime = 4}
	},

	["Illaoi"] = {
	[_R] = {SpellName = "IllaoiR", Buffname = "IllaoiR" ,Buffname = "" ,CoolDown = 120, ActiveTime = 8}
	},

	["Jarvan IV"] = {
	[_E] = {SpellName = "JarvanIVDemacianStandard",Buffname = "JarvanIVDemacianStandard" ,Buffname = "" , CoolDown = 13, ActiveTime = 8}
	},

	["Jax"] = {
	[_R] = {SpellName = "", Buffname = "" ,Buffname = "" ,CoolDown = 80, ActivTime = 8} 
	},

	["Jinx"] = {
	[_E] = {SpellName = "JinxE", Buffname = "JinxEMine" ,Buffname = "" ,CoolDown = 24, ActiveTime = 5}
	},

	["Karthus"] = {
	[_W] = {SpellName = "KarthusWallOfPain", Buffname = "Wall of Pain" ,Buffname = "" ,CoolDown = 18, ActiveTime = 5}
	[_R] = {SpellName = "KarthusFallenOne", Buffname = "KarthusFallenOne" ,Buffname = "" ,CoolDown = 200, ActiveTime = 3}

	},

	["Kayle"] = {
	[_Q] = {SpellName = "JudicatorReckoning", Buffname = "" ,Buffname = "" ,CoolDown = 8, ActiveTime = 3} -- Slow Effect on Target
	[_R] = {SpellName = "JudicatorIntervention", Buffname = "" ,Buffname = "" ,CoolDown = 100, ActiveTime = 2.5} -- 2/2.5/3 Active Time
	},

	["Kennen"] = {
	[_P] = {SpellName = "KennenMarkOfStorm", Buffname = "KennenMarkOfStorm" ,CoolDown = 0, ActiveTime = 6.25} -- Mark of the Storm on Target
	[_E] = {SpellName = "KennenLightningRush", Buffname = "KennenLightningRushBuff" ,CoolDown = 10, ActiveTime = 2} -- E Duration
	[_R] = {SpellName = "KennenShurikenStorm", Buffname = "KennenShurikenStorm" ,CoolDown = 120, ActiveTime = 4} -- 3/4/5 Active Time
	},

	["Kindred"] = {
	[_R] = {SpellName = "KindredR", Buffname = "KindredRNoDeathBuff" ,CoolDown = 160, ActiveTime = 4}
	},

	["LeBlanc"] = {
	[_W] = {SpellName = "LeblancDistortion", Buffname = "" ,CoolDown = 18, ActiveTime = 4}
	[_R] = {SpellName = "LeblancMimic", Buffname = "" ,CoolDown = 40, ActiveTime = 4} -- W R
	},

	["Lee Sin"] = {
	[_Q] = {SpellName = "BlindMonkQOne", Buffname = "BlindMonkSonicWave" ,CoolDown = 11, ActiveTime = 3} -- Q Mark QONE TEST AGAIN TO GET NAME Q2
	[_W] = {SpellName = "BlindMonkWOne", Buffname = "BlindMonkSafeguard" ,CoolDown = 14, ActiveTime = 2} -- W Shield duration EONE TEST AGAIN TO GET NAME E2
	[_E] = {SpellName = "BlindMonkEOne", Buffname = "BlindMonkCripple" ,CoolDown = 10, ActiveTime = 4} -- E2 Slow Duration
	},

	["Leona"] = {
	[_W] = {SpellName = "LeonaSolarBarrier", Buffname = "LeonaSolarBarrier" ,CoolDown = 14, ActiveTime = 3} -- W Duration for explode
	},

	["Lissandra"] = {
	[_R1] = {SpellName = "LissandraR", Buffname = "LissandraR" ,CoolDown = 130, ActiveTime = 1.5} -- Target R
	[_R2] = {SpellName = "LissandraR", Buffname = "LissandraRSelf" ,CoolDown = 130, ActiveTime = 2.5} -- Self R
	},

	["Lulu"] = {
	[_W] = {SpellName = "LuluW", Buffname = "LuluWBuff" ,CoolDown = 18, ActiveTime = 1.75} -- 1.25/1.5/1.75/2/2.25
	[_W2] = {SpellName = "LuluW", Buffname = "LuluWDebuff" ,CoolDown = 18, ActiveTime = 1.75} -- On enemy 1.25/1.5/1.75/2/2.25
	[_R] = {SpellName = "LuluR", Buffname = "LuluR" ,CoolDown = 110, ActiveTime = 7} 
	},

	["Lux"] = {
	[_Q] = {SpellName = "LuxLightBinding", Buffname = "LuxLightBindingMis" ,CoolDown = 15, ActiveTime = 2}
	},

	["Malzahar"] = {
	[_W] = {SpellName = "AlZaharNullZone", Buffname = "AlZaharNullZone" ,CoolDown = 14, ActiveTime = 5}
	[_E] = {SpellName = "AlZaharMaleficVisions", Buffname = "AlZaharMaleficVisions" ,CoolDown = 15, ActiveTime = 4}
	[_R] = {SpellName = "AlZaharNetherGrasp", Buffname = "AlZaharNetherGrasp" ,CoolDown = 120, ActiveTime = 2.5}
	},

	["Master Yi"] = {
	[_R] = {SpellName = "Highlander", Buffname = "Highlander" ,CoolDown = 75, ActiveTime = 10} -- +4 Duration for every takedown
	[_E] = {SpellName = "", Buffname = "", Cooldown = 0, ActiveTime = 6}
	[_P] = {SpellName = "", Buffname = "", Cooldown = 0, ActiveTime = 3}

	},

	["Miss Fortune"] = {
	[_E] = {SpellName = "MissFortuneScattershot", Buffname = "MissFortuneScattershotSlow" ,CoolDown = 14, ActiveTime = 2}
	[_R] = {SpellName = "MissFortuneBulletTime", Buffname = "MissFortuneBulletTime" ,CoolDown = 120, ActiveTime = 3}
	},

	["Mordekaiser"] = {
	[_R] = {SpellName = "MordekaiserChildrenOfTheGrave", Buffname = "MordekaiserCOTGDot" ,CoolDown = 120, ActiveTime = 10}
	},

	["Morgana"] = {
	[_Q] = {SpellName = "DarkBindingMissile",Buffname = "Dark Binding" CoolDown =  , ActiveTime = 2.6} --2 / 2.25 / 2.5 / 2.75 / 3
	[_W] = {SpellName = "TormentedSoil", Buffname = "" ,CoolDown = 10, ActiveTime = 5}
	[_E] = {SpellName = "BlackShield", Buffname = "Black Shield" ,CoolDown = 23, ActiveTime = 5}
	[_R] = {SpellName = "SoulShackles", Buffname = "Soul Shackles" ,CoolDown = 120, ActiveTime = 3.5}
	},

	["Nasus"] = {
	[_W] = {SpellName = "NasusW", Buffname = "NasusW" ,CoolDown = 15, ActiveTime = 5} -- W Slow on unit
	[_E] = {SpellName = "NasusE", Buffname = "NasusE" ,CoolDown = 12, ActiveTime = 5}
	[_R] = {SpellName = "NasusR", Buffname = "NasusR" ,CoolDown = 120, ActiveTime = 15}
	},

	["Nautilus"] = {
	[_W] = {SpellName = "NautilusPiercingGaze", Buffname = "LuxShield" ,CoolDown = 18, ActiveTime = 10} -- Need a Check if shield get destroyed then dont time the W tracker
	},

	["Nocturne"] = {
	[_E] = {SpellName = "NocturneUnspeakableHorror", Buffname = "NocturneUnspeakableHorror" ,CoolDown = 20, ActiveTime = 1.5}
	},
	
	["Nunu"] = {
	[_W] = {SpellName = "BloodBoil", Buffname = "Blood Boil" ,CoolDown 15, ActiveTime = 12} -- AttackSpeed Tracker Ally/Nunuself
	},

	["Olaf"] = {
	[_W] = {SpellName = "OlafFrenziedStrikes", Buffname = "OlafFrenziedStrikes" ,CoolDown = 16, ActiveTime = 6}
	[_R] = {SpellName = "OlafRagnarok", Buffname = "OlafRagnarok" ,CoolDown = 100, ActiveTime = 6}
	},

	["Pantehon"] = {
	[_R] = {SpellName = "PantheonRJump", Buffname = "PantheonR" ,CoolDown = 150, ActiveTime = 3.5} -- 2Sec Channels R & 1.5 sec after reaching pos.x, pos.z
	[_RLand] = {SpellName = "PantheonRFall", Buffname = "PantheonRFallD" ,CoolDown = 150, ActiveTime = 3.5}
	},

	["Poppy"] = {
	[_W] = {SpellName = "PoppyW", Buffname = "PoppyWZone" ,CoolDown = 14, ActiveTime = 2.5}
	},

	["Rammus"] = {
	[_Q] = {SpellName = "", Buffname = "" ,CoolDown = 16, ActiveTime = 7}
	[_W] = {SpellName = "", Buffname = "" ,CoolDown = 14, ActiveTime = 6}
	[_E] = {SpellName = "", Buffname = "" ,CoolDown = 12, ActiveTime = 1.75} -- 1.25/1.5/1.75/2/2.25
	[_R] = {SpellName = "", Buffname = "" ,CoolDown = 60, ActiveTime = 8}
	},
		
	["Riven"] = {
	[_E] = {SpellName = "RivenFeint", Buffname = "RivenFeint" ,CoolDown = 10, ActiveTime = 1.5}
	[_R] = {SpellName = "rivenizunablade", CoolDown 130, ActiveTime = 15}
	},

	["Rumble"] = {
	[_Q] = {SpellName = "RumbleFlameThrower", Buffname = "RumbleFlameThrower" ,CoolDown = 6, ActiveTime = 3}
	[_W] = {SpellName = "RumbleShield", Buffname = "RumbleShield" ,CoolDown = 6, ActiveTime = 2}
	[_R] = {SpellName = "RumbleCarpetBomb", Buffname = "Danger Zone" ,CoolDown = 120, ActiveTime = 5}
	},

	["Shaco"] = {
	[_Q] = {SpellName = "Deceive", Buffname = "Deceive" ,CoolDown = 11, ActivTime = 3.5}
	[_R] = {SpellName = "Hallucinate", Buffname = "Hallucinate" ,CoolDown = 100, ActiveTime = 18.5}
	},

	["Shen"] = {
	[_Q] = {SpellName = "", Buffname = "" ,CoolDown = 8, ActiveTime = 8}
	[_W] = {SpellName = "", Buffname = "" ,CoolDown = 18, ActiveTime = 2}
	[_R] = {SpellName = "", Buffname = "" ,CoolDown = 180, ActiveTime = 5}
	},

	["Shyvana"] = {
	[_W] = {SpellName = "ShyvanaImmolateDragon", Buffname = "ShyvanaScorchedEarth" ,CoolDown = 12, ActiveTime = 3}
	},

	["Singed"] = {
	[_W] = {SpellName = "", Buffname = "" ,CoolDown = 14, ActiveTime = 5}
	[_R] = {SpellName = "", Buffname = "" ,CoolDown = 100, ActiveTime = 25}
	},

	["Sivir"] = {
	[_W] = {SpellName = "SivirW", Buffname = "SivirW" ,CoolDown = 12, ActiveTime = 4}
	[_E] = {SpellName = "SivirE", Buffname = "Spell Shield" ,CoolDown = 22, ActiveTime = 1.5}
	[_R] = {SpellName = "SivirR", Buffname = "On The Hunt" ,CoolDown = 120, ActiveTime = 8}
	},

	["Skarner"] = {
	[_W] = {SpellName = "SkarnerExoskeleton", Buffname = "SkarnerExoskeleton" ,CoolDown = 13, ActiveTime = 6}
	[_R] = {SpellName = "SkarnerImpale",Buffname = "SkarnerImpale" , CoolDown 120, ActiveTime = 1.75}
	},

	["Sona"] = {
	[_Q] = {SpellName = "SonaQ", Buffname = "SonaQZone" ,CoolDown = 8, ActiveTime = 3}
	[_W] = {SpellName = "SonaW", Buffname = "SonaWZone" ,CoolDown 10, ActiveTime = 1.5}
	[_E] = {SpellName = "SonaE", Buffname = "SonaEZone" ,CoolDown = 12, ActiveTime 1.5}
	[_R] = {SpellName = "SonaCrescendo", Buffname = "SonaR" ,CoolDown = 140, ActiveTime = 1.5}
	},

	["Soraka"] = {
	[_E] = {SpellName = "SorakaE", Buffname = "Equinox" ,CoolDown = 24, ActiveTime = 1.5}
	},

	["Swain"] = {
	[_Q] = {SpellName = "SwainDecrepify", Buffname = "" ,CoolDown = 8, ActiveTime = 3}
	[_W] = {SpellName = "SwainShadowGrasp", Buffname = "SwainShadowGraspRoot" ,CoolDown = 18, ActiveTime = 0.875}
	[_E] = {SpellName = "SwainTorment", Buffname = "SwainTormentDoT" ,CoolDown = 10, ActiveTime = 4}
	},

	["Syndra"] = {
	[_Q] = {SpellName = "SyndraQ", Buffname = "" ,CoolDown = 4, ActiveTime = 6} -- balls last 6 Secs
	},

	["Taric"] = {
	[_E] = {SpellName = "", Buffname = "" ,CoolDown = 18, ActiveTime = 1.45 }
	[_R] = {SpellName = "", Buffname = "" ,CoolDown = 75, ActiveTime = 10} -- Allys have buff for 10 Sec
	},

	["Thresh"] = {
	[_W] = {SpellName = "ThreshW", Buffname = "ThreshWShield" ,CoolDown = 22, ActiveTime = 4}
	[_R] = {SpellName = "ThreshRPenta", Buffname = "" ,CoolDown = 150, ActiveTime = 5 }
	},

	["Tristana"] = {
	[_E] = {SpellName = "TristanaE", Buffname = "Detonating Shot" ,CoolDown = 16, ActiveTime = 4} -- Check if E is not already exploded cuz of E AA Stacks
	},

	["Trundle"] = {
	[_W] = {SpellName = "", Buffname = "" ,CoolDown = 15, ActiveTime = 8}
	[_E] = {SpellName = "", Buffname = "" ,CoolDown = 23, ActiveTime = 6}
	[_R] = {SpellName = "TrundlePain", Buffname = "TrundlePainShred" ,CoolDown = 110, ActiveTime = 4}
	},

	["Tryndamere"] = {
	[_R] = {SpellName = "UndyingRage", Buffname = "Undying Rage" ,CoolDown = 110, ActiveTime = 5}
	},

	["Varus"] = {
	[_R] = {SpellName = "VarusR", Buffname = "VarusRRoot" ,CoolDown = 110, ActiveTime = 2}
	},

	["Vayne"] = {
	[_R] = {SpellName = "VayneInquisition", Buffname = "VayneInquisition" ,CoolDown = 100, ActiveTime = 10} -- 8/10/12
	},

	["Veigar"] = {
	[_W] = {SpellName = "VeigarDarkMatter", Buffname = "" ,CoolDown = 10, ActiveTime = 1.25}
	[_E] = {SpellName = "VeigarEventHorizon", Buffname = "" ,CoolDown = 18, ActiveTime = 3}
	},

	["Viktor"] = {
	[_W] = {SpellName = "ViktorGravitonField", Buffname = "ViktorGravitonSlow" ,CoolDown = 17, ActiveTime = 4}
	[_R] = {SpellName = "ViktorChaosStorm", Buffname = "ViktorChaosStormGuide" ,CoolDown = 120, ActiveTime = 7}
	},

	["Vladimir"] = {
	[_W] = {SpellName = "VladimirSanguinePool", Buffname = "VladimirSanguinePool" ,CoolDown = 26, ActiveTime = 2}
	[_R] = {SpellName = "VladimirHemoplague", Buffname = "" ,CoolDown = 150, ActiveTime = 5}
	},

	["Volibear"] = {
	[_P] = {SpellName = "", Buffname = "" ,CoolDown = 120, ActiveTime = 6}
	[_Q] = {SpellName = "", Buffname = "" ,CoolDown = 12, ActiveTime = 4}
	[_R] = {SpellName = "", Buffname = "" ,CoolDown = 100, ActiveTime = 12}
	},

	["Warwick"] = {
	[_W] = {SpellName = "", Buffname = "" ,CoolDown = 24, ActiveTime = 6} -- Also Allys
	[_R] = {SpellName = "", Buffname = "" ,CoolDown = 110, ActiveTime = 1.8}
	},

	["Wukong"] = {
	[_R] = {SpellName = "", Buffname = "" ,CoolDown = 120, ActiveTime = 4}
	},

	["Xin Zhao"] = {
	[_W] = {SpellName = "", Buffname = "" ,CoolDown = 16, ActiveTime = 5}
	},

	["Yasuo"] = {
	[_P] = {SpellName = "YasuoPassive", Buffname = "YasuoPassiveMSShieldOn" ,CoolDown = , ActiveTime = 1} -- Shield duration
	[_W] = {SpellName = "", Buffname = "" ,CoolDown = 26, ActiveTime = 3.75} -- W Shield duration
	},

	["Zac"] = {
	[_P] = {SpellName = "", Buffname = "" ,CoolDown = 300, ActiveTime = 8}
	},

	["Zed"] = {
	[_W] = {SpellName = "ZedW", Buffname = "" ,CoolDown = 18, ActiveTime = 4}
	[_R1] = {SpellName = "ZedUlt", Buffname = "zedrshadowbuff" ,CoolDown = 120, ActiveTime = 0.75} -- 0.75 After he spawn behind me
	[_R2] = {SpellName = "ZedUlt", Buffname = "" ,CoolDown =  , ActiveTime = 6} -- R Shadows duration
	},

	["Ziggs"] = {
	[_E] = {SpellName = "ZiggsE", Buffname = "" ,CoolDown = 16, ActiveTime = 10}
	},

	["Zilean"] = {
	[_R] = {SpellName = "ZileanR", Buffname = "ChronoRevive" ,CoolDown = 120, ActiveTime = 5}
	},

	["Zyra"] = {
	[_R] = {SpellName = "ZyraBrambleZone", Buffname = "" ,CoolDown = 130, ActiveTime = 2}
	}
}]]



--[[
function OnLoad()
	RB = RecallBar()
	RB:AddBar(myHero, true)
	RB:AddBar(myHero, true)
	RB:AddBar(myHero, false)
	RB:AddBar(myHero, true)
	DelayAction(function ()
		RB:RemoveBar(myHero)
	end,2)
end


class "RecallBar"
function RecallBar:__init()
	self.bars = {}
	self.draw = true
	AddDrawCallback(function ()
		self:OnDraw()
	end)
	AddTickCallback(function ()
		self:CheckIfTimeUp()
	end)
end

function RecallBar:AddBar(_hero,_hasbaron)
	if not _hero then return end
	if _hasbaron then
		t = os.clock() + 4
	else
		t = os.clock() + 8
	end
	self.bars[#self.bars+1] = {hero = _hero, time = t, hasbaron = _hasbaron}
end

function RecallBar:RemoveBar(_hero)
	if not _hero then return end
	local sb = {}
	for _,v in pairs(self.bars) do
		if v.hero ~= _hero then
			sb[#sb+1] = v
		end
	end
	self.bars = nil
	self.bars = sb
end

function RecallBar:CheckIfTimeUp()
	local sb = {}
	for _, v in pairs(self.bars) do
		if v.time-os.clock() > 0 then
			sb[#sb+1] = v
		end
	end
	self.bars = nil
	self.bars = sb
end

function RecallBar:OnDraw()
	local w = WINDOW_W
	local h = WINDOW_H
	for i, v in pairs(self.bars) do
		local n = 8
		if v.hasbaron then
			n = 4
		end
		local percentage = ((v.time-os.clock())/n)*1
		local m = w/3-w/1.4
		DrawLineBorder(w/3, h/1.25-20*i+20, w/1.4, h/1.25-20*i+20, 18, ARGB(255,255,255,255), 1)
		DrawLine(w/3, h/1.25-20*i+20, w/1.4+m*percentage, h/1.25-20*i+20, 18, ARGB(128,255,255,255))
		DrawTextA(v.hero.charName.. " is Recalling: "..math.round(v.time-os.clock()),18,w/2.1,h/1.262-20*i+20)
	end
end

]]--
