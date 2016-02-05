--[[
EzSprites needed for this Script.
Credits: timo62 & help from HiranN

]]

IgnoreList = {
["Udyr"] = true, ["TwistedFate"] = true,
}

if not IgnoreList[myHero.charName] then
local MyChamp = GetSprite("\\EzSprites\\"..myHero.charName..".png") end
local EzRiven = GetSprite("\\EzSprites\\EzRiven.png")
local UdyrUrf = GetSprite("\\EzSprites\\UdyrUrf.png")
local UdyrTurtle = GetSprite("\\EzSprites\\UdyrTurtle.png")
local UdyrPhoenix = GetSprite("\\EzSprites\\UdyrPhoenix.png")
local UdyrTiger = GetSprite("\\EzSprites\\UdyrTiger.png")
local UdyrBear = GetSprite("\\EzSprites\\UdyrBear.png")
local HrTwistedFate = GetSprite("\\EzSprites\\HrTwistedFate.png")

function OnLoad()
	Menu = scriptConfig ("HUD - "..myHero.charName, "HUD")
    Menu:addSubMenu("HUD Settings", "HUDSettings")
        Menu.HUDSettings:addParam("useHUD", "Use HUD", SCRIPT_PARAM_ONOFF, true)
        Menu.HUDSettings:addParam("HUDx", "HUD x Position", SCRIPT_PARAM_SLICE, 20, 0.1, 255, 0.1)
        Menu.HUDSettings:addParam("HUDz", "HUD z Position", SCRIPT_PARAM_SLICE, 1.23, 0.5, 10, 0.5)

    Menu:addSubMenu("HUD's", "HUDs")
    	if myHero.charName == "Riven" then 
    	Menu.HUDs:addParam("HUDlist", "Choose Hud", SCRIPT_PARAM_LIST, 1, {" "..myHero.charName, "Ez Riven"})
    	elseif myHero.charName == "TwistedFate" then
    	Menu.HUDs:addParam("HUDlist", "Choose Hud", SCRIPT_PARAM_LIST, 1, {" "..myHero.charName, "Hr TwistedFate"})
    	else
    	Menu.HUDs:addParam("HUDlist", "Choose Hud", SCRIPT_PARAM_LIST, 1, {" "..myHero.charName})
    	end
end

function OnDraw()
	if myHero.charName == "Riven" and Menu.HUDSettings.useHUD then
	if Menu.HUDs.HUDlist == 1 then
	MyChamp:Draw(WINDOW_W/Menu.HUDSettings.HUDx, WINDOW_H/Menu.HUDSettings.HUDz, 255)

	elseif Menu.HUDs.HUDlist == 2 then
	EzRiven:Draw(WINDOW_W/Menu.HUDSettings.HUDx, WINDOW_H/Menu.HUDSettings.HUDz, 255)
	end
	end

	if myHero.charName == "TwistedFate" and Menu.HUDSettings.useHUD then
	if Menu.HUDs.HUDlist == 1 then
	MyChamp:Draw(WINDOW_W/Menu.HUDSettings.HUDx, WINDOW_H/Menu.HUDSettings.HUDz, 255)
	elseif Menu.HUDs.HUDlist == 2 then
	HrTwistedFate:Draw(WINDOW_W/Menu.HUDSettings.HUDx, WINDOW_H/Menu.HUDSettings.HUDz, 255)
	end
	end


	if myHero.charName == "Udyr" and Menu.HUDSettings.useHUD then
	if UdyrSPELL == nil then
	UdyrUrf:Draw(WINDOW_W/Menu.HUDSettings.HUDx, WINDOW_H/Menu.HUDSettings.HUDz, 255)
	elseif UdyrSPELL:lower():find("tiger") then
	UdyrTiger:Draw(WINDOW_W/Menu.HUDSettings.HUDx, WINDOW_H/Menu.HUDSettings.HUDz, 255)
	elseif UdyrSPELL:lower():find("turtle") then
	UdyrTurtle:Draw(WINDOW_W/Menu.HUDSettings.HUDx, WINDOW_H/Menu.HUDSettings.HUDz, 255)
	elseif UdyrSPELL:lower():find("bear") then
	UdyrBear:Draw(WINDOW_W/Menu.HUDSettings.HUDx, WINDOW_H/Menu.HUDSettings.HUDz, 255)
	elseif UdyrSPELL:lower():find("phoenix") then
	UdyrPhoenix:Draw(WINDOW_W/Menu.HUDSettings.HUDx, WINDOW_H/Menu.HUDSettings.HUDz, 255)
	end
	end

	IgnoreList2 = {
	["Riven"] = true, ["Udyr"] = true, ["TwistedFate"] = true,
	}

    if Menu.HUDSettings.useHUD and not IgnoreList2[myHero.charName] then
	DrawSprite()
	end

end

function OnProcessSpell(unit, spell)
	if unit and spell and unit.isMe and myHero.charName == "Udyr" then
	if spell.name:lower():find("udyr") and spell.name:lower():find("stance") then
	UdyrSPELL = spell.name
	end
	end
end

function DrawSprite()
    MyChamp:Draw(WINDOW_W/Menu.HUDSettings.HUDx, WINDOW_H/Menu.HUDSettings.HUDz, 255)
end