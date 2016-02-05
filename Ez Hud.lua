--[[
Credits: timo62 & help from HiranN.
]]

IgnoreList = {
["Udyr"] = true,
}

function OnLoad()
	Version = 0.2
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
    SendMsg("Loaded version: "..Version)
    CheckSprites()
    CheckUpdates()
end

function CheckSprites()
	if not DirectoryExist(SPRITE_PATH.."EzSprites") then
    CreateDirectory(SPRITE_PATH.."EzSprites//")
	end

	if not IgnoreList[myHero.charName] then
  	--[[local ServerVersionDATA = GetWebResult("http://raw.githubusercontent.com/timo62/GetChallengerEz/master/EzSprites/"..myHero.charName..".png")
  	if not ServerVersionDATA then
  	SendMsg("Sprite not found in Dev GitHub")
  	NotSprites = true
  	return
  	end]]
	if not FileExist(SPRITE_PATH.."EzSprites/"..myHero.charName..".png") then
	NotSprites = true
	SendMsg("Downloading Sprites")
  	DownloadFile("http://raw.githubusercontent.com/timo62/GetChallengerEz/master/EzSprites/"..myHero.charName..".png", SPRITE_PATH.."EzSprites/"..myHero.charName..".png", function ()
  	SendMsg("Sprites Downloaded, press 2x F9")
  	end)
	end	
	end
	List = {
	["Riven"] = "EzRiven",
	["Udyr"] = "UdyrUrf", "UdyrPhoenix", "UdyrBear", "UdyrTiger",
	["TwistedFate"] = "HrTwistedFate",
	}
	if not FileExist(SPRITE_PATH.."EzSprites/"..List[myHero.charName]..".png") then
	NotSprites = true
	SendMsg("Downloading Sprites")
  	DownloadFile("http://raw.githubusercontent.com/timo62/GetChallengerEz/master/EzSprites/UdyrUrf.png", SPRITE_PATH.."EzSprites/UdyrUrf.png",function()end)
  	DownloadFile("http://raw.githubusercontent.com/timo62/GetChallengerEz/master/EzSprites/UdyrPhoenix.png", SPRITE_PATH.."EzSprites/UdyrPhoenix.png",function()end)
  	DownloadFile("http://raw.githubusercontent.com/timo62/GetChallengerEz/master/EzSprites/UdyrBear.png", SPRITE_PATH.."EzSprites/UdyrBear.png",function()end)
  	DownloadFile("http://raw.githubusercontent.com/timo62/GetChallengerEz/master/EzSprites/UdyrTiger.png", SPRITE_PATH.."EzSprites/UdyrTiger.png",function()end)
  	DownloadFile("http://raw.githubusercontent.com/timo62/GetChallengerEz/master/EzSprites/EzRiven.png", SPRITE_PATH.."EzSprites/EzRiven.png",function()end)
  	DownloadFile("http://raw.githubusercontent.com/timo62/GetChallengerEz/master/EzSprites/HrTwistedFate.png", SPRITE_PATH.."EzSprites/HrTwistedFate.png",function()end)
  	DownloadFile("http://raw.githubusercontent.com/timo62/GetChallengerEz/master/EzSprites/UdyrTurtle.png", SPRITE_PATH.."EzSprites/UdyrTurtle.png", function ()
  	SendMsg("Sprites Downloaded, press 2x F9")
  	end)
	end
if NotSprites then return end
if not IgnoreList[myHero.charName] and myHero.charName ~= "Riven" then
MyChamp = GetSprite("\\EzSprites\\"..myHero.charName..".png")  
elseif myHero.charName == "Riven" then
MyChamp = GetSprite("\\EzSprites\\"..myHero.charName..".png") 
EzRiven = GetSprite("\\EzSprites\\EzRiven.png")
elseif myHero.charName == "Udyr" then
UdyrUrf = GetSprite("\\EzSprites\\UdyrUrf.png")
UdyrTurtle = GetSprite("\\EzSprites\\UdyrTurtle.png")
UdyrPhoenix = GetSprite("\\EzSprites\\UdyrPhoenix.png")
UdyrTiger = GetSprite("\\EzSprites\\UdyrTiger.png")
UdyrBear = GetSprite("\\EzSprites\\UdyrBear.png")
elseif myHero.charName == "TwistedFate" then
MyChamp = GetSprite("\\EzSprites\\"..myHero.charName..".png") 
HrTwistedFate = GetSprite("\\EzSprites\\HrTwistedFate.png")
end
end

function OnDraw()
	if NotSprites then return end

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

function SendMsg(msg)
	PrintChat("<font color=\"#444444\"><b>[Ez Hud]</b></font> ".."<font color=\"#bb0033\"><b>"..msg..".</b></font>")
end

local serveradress = "raw.githubusercontent.com"
local scriptadress = "/timo62/GetChallengerEz/master"
local scriptname = "Ez Hud"
local adressfull = "http://"..serveradress..scriptadress.."/"..scriptname..".lua"
function CheckUpdates()
  	local ServerVersionDATA = GetWebResult(serveradress , scriptadress.."/"..scriptname..".version")
  	if ServerVersionDATA then
    local ServerVersion = tonumber(ServerVersionDATA)
    if ServerVersion then
    if ServerVersion > tonumber(Version) then
    SendMsg("Updating, don't press F9")
    DownloadUpdate()
    else
    SendMsg("You have the latest version")
    end
    else
    SendMsg("An error occured, while updating")	
    end
  	else
  	SendMsg("Could not connect to update Server")
end
end

function DownloadUpdate()  	
  	DownloadFile(adressfull, SCRIPT_PATH..scriptname..".lua", function ()
  	SendMsg("Updated, press 2x F9")
  	end)
end
