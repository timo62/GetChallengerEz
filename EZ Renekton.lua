--[[ Ez Renekton by timo62
    Features:
    - Combo 
    - Harass
    - Furrymanager(soon)
    - & more.

]]

--Updater
local LocalVersion = "0.2"
local AutoUpdate = true

local serveradress = "raw.githubusercontent.com"
local scriptadress = "/timo62/GetChallengerEz/master"
local scriptname = "EZ Renekton"
local scriptmsg = "<font color=\"#AA0000\"><b>[Ez Renekton]</b></font>"
    function FindUpdates()
    if not AutoUpdate then return end
    local ServerVersionDATA = GetWebResult(serveradress , scriptadress.."/"..scriptname..".version")
    if ServerVersionDATA then
        local ServerVersion = tonumber(ServerVersionDATA)
        if ServerVersion then
            if ServerVersion > tonumber(LocalVersion) then
            PrintChat(scriptmsg.."<font color=\"#01cc9c\"><b> Updating, don't press F9.</b></font>")
            Update()
            else
            PrintChat(scriptmsg.."<font color=\"#01cc9c\"><b> You have the latest version.</b></font>")
            end
        else
        PrintChat(scriptmsg.."<font color=\"#01cc9c\"><b> An error occured, while updating, please reload.</b></font>")
        end
    else
    PrintChat(scriptmsg.."<font color=\"#01cc9c\"><b> Could not connect to update Server.</b></font>")
    end
end

function Update()
    DownloadFile("http://"..serveradress , scriptadress.."/"..scriptname..".lua",SCRIPT_PATH..scriptname..".lua", function()
    PrintChat(scriptmsg.."<font color=\"#01cc9c\"><b> Updated, press 2x F9.</b></font>")
    end)
end

-- Updater

if myHero.charName ~= "Renekton" then return end
    local ts
        if not _G.UPLloaded then
            if FileExist(LIB_PATH .. "/UPL.lua") then
                require("UPL")
                _G.UPL = UPL()
            else
                print("Downloading UPL, please don't press F9")
                DelayAction(function() DownloadFile("https://raw.github.com/nebelwolfi/BoL/master/Common/UPL.lua".."?rand="..math.random(1,10000), LIB_PATH.."UPL.lua", function () print("Successfully downloaded UPL. Press F9 twice.") end) end, 3)
                return
            end
        end

            function SayHello()
                PrintChat("<font color=\"#AA0000\"><b>[Ez Renekton] </b></font>".."<font color=\"#01cc9c\"><b>Loaded! Good Luck!</b></font>")
            PrintChat("<font color=\"#AA0000\"><b>[Ez Renekton] </b></font>".."<font color=\"#01cc9c\"><b>By: timo62</b></font>")
            end

            function RequireXA(t)
                    local tries = 0
                        if not t then tries = 1 else tries = t + 1 end
                            if not _G.XawarenessLoaded then
                                if tries < 5 then
                                    DelayAction(function()
                                      print("Trying Again :"..tries)
                                      RequireXA(tries)
                                    end,0.25)
                                else
                                if FileExist(LIB_PATH.."Xawareness.lua") then
                                    print("Loaded Xawareness")
                                    require "Xawareness"
                                    Xawareness(Menu)
                                else
                                    print("Xawareness could not be loaded")
                                end
                            end
                        end
                end

            function OnLoad()

                FindUpdates()
                -- Minions 
                EnemyMinions = minionManager(MINION_ENEMY, 600, player, MINION_SORT_HEALTH_ASC)
                allyMinions = minionManager(MINION_ALLY, 300, player, MINION_SORT_HEALTH_DES)
                jungleMinions = minionManager(MINION_JUNGLE, 700, myHero, MINION_SORT_MAXHEALTH_DEC)

                spells = {
                E = { speed = 1225, delay = 0.25, range = 450, width = 150, collision = false, aoe = false, type = "linear" },
                }
   
                UPL:AddSpell(_E, spells.E)

                SayHello()

                


                -- MenÃ¼
                Menu = scriptConfig("| { EZ Renekton } ", "ez renek")
                    Menu:addSubMenu("|->Key Setting", "Key")
                        Menu.Key:addParam("combo", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
                        Menu.Key:addParam("laneclear", "Lane Clear Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("K"))
                        --Menu.Key:addParam("jungleclear", "Jungle Clear Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
                        Menu.Key:addParam("harass", "Harass Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
                        --Menu.Key:addParam("lasthit", "Last Hit Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
                        Menu.Key:addParam("flee", "Fast E", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
                    Menu:addSubMenu("|->Combo", "c")
                        Menu.c:addParam("x1", "-[    Renekton    ]-", SCRIPT_PARAM_INFO, "Ver 1.0")
                        Menu.c:addParam("comboMode", "Set Combo Mode", SCRIPT_PARAM_LIST, 1, {"E W Q E"--[["W E Q E"]]})
                        Menu.c:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                        Menu.c:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
                        Menu.c:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)

                    Menu:addSubMenu("|->Harass", "h")
                        Menu.h:addParam("x1", "-[    Renekton    ]-", SCRIPT_PARAM_INFO, "Ver 1.0")
                        Menu.h:addParam("harassOn", "Harass Mode On/Off", SCRIPT_PARAM_ONOFF, false)
                        Menu.h:addParam("harassMode", "Set Harass Mode", SCRIPT_PARAM_LIST, 1, {"E W Q E"})
                        Menu.h:addParam("x2", "Harass will Auto E back after combo", SCRIPT_PARAM_INFO, " ")

                    Menu:addSubMenu("|->Lane Clear", "l")
                        Menu.l:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                        Menu.l:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
                        Menu.l:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
                        Menu.l:addParam("useItems", "Use Items", SCRIPT_PARAM_ONOFF, true)

                   --[[ Menu:addSubMenu("|->Last Hit", "lh")
                        Menu.lh:addParam ("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                        Menu.lh:addParam ("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
                        Menu.lh:addParam ("useE", "Use E", SCRIPT_PARAM_ONOFF, true)]]

                    Menu:addSubMenu("|->Auto R","r")
                        Menu.r:addParam ("autoR", "Auto R at % life", SCRIPT_PARAM_SLICE, 20, 0, 100)

                    Menu:addSubMenu("|->Prediction", "pred")
                        Menu.pred:addParam("ehs", "E Hit Chance", SCRIPT_PARAM_SLICE, 1,1,3)
                        UPL:AddToMenu2(Menu.pred)

                    Menu:addSubMenu("|->Drawing", "draw")
                        Menu.draw:addParam ("qd", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
                        Menu.draw:addParam ("ed", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
                        Menu.draw:addParam ("aad", "Draw AA Range", SCRIPT_PARAM_ONOFF, true)

                    Menu:addSubMenu("|->Target Selector", "TargetSelector")
                        Menu.TargetSelector:addParam ("drawtext", "Draw Target Select Text", SCRIPT_PARAM_ONOFF, true)
                        Menu.TargetSelector:addParam ("hitbox", "Target-Selector", SCRIPT_PARAM_LIST, 1, {"Hitbox", "3D Circle"})


                    ts = TargetSelector(TARGET_LOW_HP_PRIORITY, 650)
                    ts.name = "Renekton"
                    Menu:addTS(ts)

                RequireXA(0)
            end


            function OnTick()


                if SelectedTarget ~= nil then 
                    Target = SelectedTarget 
                else Target = ts.target 
                end

                --function OnDraw()
                --  DrawTextA(myHero:getItem(ITEM_1).id)
                --end

                    if myHero.health <= (myHero.maxHealth*Menu.r.autoR/100) and Rready then 
                        CastSpell(_R)
                    end

                checks()

                if Menu.Key.combo and (Target ~= nil) then
                    if Menu.c.comboMode == 1 then
                        Combo1()
                   -- else
                       -- Combo2()
                end

                    elseif Menu.Key.laneclear then
                        Clear()
                    elseif Menu.Key.lasthit then 
                        lasthit()
                    elseif Menu.Key.harass then
                        Harass1()
                    elseif Menu.Key.flee then
                        flee()
                    end 
            end




        function OnWndMsg(msg, key)
            if msg == WM_LBUTTONDOWN then
                local minD = 200
                    for i, unit in ipairs(GetEnemyHeroes()) do
                        if ValidTarget(unit) and not unit.dead then
                            if GetDistance(unit, mousePos) <= minD or target == nil then
                                minD = GetDistance(unit, mousePos)
                                target = unit
                            end
                        end
                    end
                        if target and minD < 200 then
                            if SelectedTarget and target.charName == SelectedTarget.charName then
                                SelectedTarget = nil
                                if Menu.TargetSelector.drawtext then
                                print("Target unselected")
                                end
                            else
                                SelectedTarget = target
                                if Menu.TargetSelector.drawtext then
                                print("Target Selected: "..SelectedTarget.charName)
                                end
                            end
                        end
            end
        end



            function checks()
            ts:update()
            Qready = (myHero:CanUseSpell(_Q) == READY)
            Wready = (myHero:CanUseSpell(_W) == READY)
            Eready = (myHero:CanUseSpell(_E) == READY)
            Rready = (myHero:CanUseSpell(_R) == READY)
            Target = ts.target
            end
        

            -- Combo EWQE

            function Combo1()
                
                -- Funktionert alles nicht, WEIL if Menu.Key.combo dann fÃ¼hrt er das erste aus & die anderen nicht mehr.
                --if ValidTarget(unit) and unit ~= nil and unit.type == myHero.type and Menu.Key.combo then
                if Menu.Key.combo then
                    checks()



                    if Eready and Menu.c.useE and GetDistance(Target) <= 550 then
                        CastSpell(_E, mousePos.x, mousePos.z)
                    end


                    if Wready and Menu.c.useW and GetDistance(Target) <= 205 then
                        CastSpell(_W, ts.target)
                    end


                    --if Target ~= nil and GetDistance(Target) <= 185 then
                               -- CastItem(3077)
                               -- CastItem(3074)
                   -- end

                    if Qready and Menu.c.useQ and GetDistance(Target) <= 260 then 
                        CastSpell(_Q, Target)
                    end
                    
                end
            end


            -- E Q E
            function Harass1()
                checks()
                if Menu.Key.harass and Eready and GetDistance(Target) <= 450 then
                    CastSpell(_E, Target.x, Target.z)
                    CastSpell(_Q)
                    CastSpell(_E, Target.x, Target.y)
                end

                --elseif Menu.Key.harass and Qready then
                    --CastSpell(_Q)

                --elseif Menu.Key.harass and Eready then
                    --CastE(Target)
                
            end

            function flee()
                checks()
                if Menu.Key.flee and Eready then
                    CastSpell(_E, mousePos.x, mousePos.z)
                    CastSpell(_E, mousePos.x, mousePos.z)
                end

            end

            --function FWQ()
             --   if Menu.Key.FWQ and Eready and Qready and 
           -- end

            function Clear()
                EnemyMinions:update()
            if  Menu.l.useE  then
                for i, minion in pairs(EnemyMinions.objects) do
                    local qDmg = getDmg("Q", minion, myHero)
                        if Menu.l.useQ and Qready and GetDistance(myHero,minion) <= 225 and qDmg >= minion.health then
                            CastSpell(_Q,minion)
                        elseif GetDistance (myHero,minion) <= 225 then 
                            CastSpell(_Q, minion)
             
                        end
                    --end vllt.

                    local wDmg = getDmg("W", minion,myHero)
                        if Menu.l.useW and Wready and GetDistance(myHero,minion) <= 200 and wDmg >= minion.health then
                            CastSpell(_W,minion)
                        else
                            CastSpell(_W,minion)
                        end

                    local eDmg = getDmg("E", minion, myHero)
                        if Menu.l.useE and Eready and eDmg >= minion.health then
                            CastE(minion)
                        else
                            CastE(minion)
                        end
                end
            end
        end


            function CastE(target, minion)
                if not target and minion then return end
                CastPosition, HitChance, HeroPosition = UPL:Predict(_E, myHero, target, minion)
                    if Eready and HitChance >= Menu.pred.ehs then
                        DelayAction(function ()
                            CastSpell(_E, CastPosition.x,CastPosition.z)
                    end,0.2)
                end
            end


            function DrawCircle3D(x, y, z, radius, width, color, quality)
                radius = radius or 325
                quality = quality and 2 * math.pi / quality or 2 * math.pi / (radius / 5)
                local points = {}
                    for theta = 0, 2 * math.pi + quality, quality do
                        local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
                        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
                    end
                DrawLines2(points, width or 1, color or 2294967295)
            end

            function DrawCircle3D2(x, y, z, radius, width, color, quality)
                radius = radius or 450
                quality = quality and 2 * math.pi / quality or 2 * math.pi / (radius / 5)
                local points = {}
                    for theta = 0, 2 * math.pi + quality, quality do
                        local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
                        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
                    end
                DrawLines2(points, width or 1, color or 4294967295)
            end

            function DrawCircle3D3(x, y, z, radius, width, color, quality)
                radius = radius or 205
                quality = quality and 2 * math.pi / quality or 2 * math.pi / (radius / 5)
                local points = {}
                    for theta = 0, 2 * math.pi + quality, quality do
                        local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
                        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
                    end
                DrawLines2(points, width or 1, color or 6294967295)
            end

            function DrawCircle3D4(x, y, z, radius, width, color, quality)
                radius = radius or 100
                quality = quality and 2 * math.pi / quality or 2 * math.pi / (radius / 5)
                local points = {}
                    for theta = 0, 2 * math.pi + quality, quality do
                        local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
                        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
                    end
                DrawLines2(points, width or 1, color or 8294967295)
            end

            function DrawHitBox(object, linesize, linecolor)
                if object and object.valid and object.minBBox then
                    DrawLine3D(object.minBBox.x, object.minBBox.y, object.minBBox.z, object.minBBox.x, object.minBBox.y, object.maxBBox.z, linesize, linecolor)
                    DrawLine3D(object.minBBox.x, object.minBBox.y, object.maxBBox.z, object.maxBBox.x, object.minBBox.y, object.maxBBox.z, linesize, linecolor)
                    DrawLine3D(object.maxBBox.x, object.minBBox.y, object.maxBBox.z, object.maxBBox.x, object.minBBox.y, object.minBBox.z, linesize, linecolor)
                    DrawLine3D(object.maxBBox.x, object.minBBox.y, object.minBBox.z, object.minBBox.x, object.minBBox.y, object.minBBox.z, linesize, linecolor)
                    DrawLine3D(object.minBBox.x, object.minBBox.y, object.minBBox.z, object.minBBox.x, object.maxBBox.y, object.minBBox.z, linesize, linecolor)
                    DrawLine3D(object.minBBox.x, object.minBBox.y, object.maxBBox.z, object.minBBox.x, object.maxBBox.y, object.maxBBox.z, linesize, linecolor)
                    DrawLine3D(object.maxBBox.x, object.minBBox.y, object.maxBBox.z, object.maxBBox.x, object.maxBBox.y, object.maxBBox.z, linesize, linecolor)
                    DrawLine3D(object.maxBBox.x, object.minBBox.y, object.minBBox.z, object.maxBBox.x, object.maxBBox.y, object.minBBox.z, linesize, linecolor)
                    DrawLine3D(object.minBBox.x, object.maxBBox.y, object.minBBox.z, object.minBBox.x, object.maxBBox.y, object.maxBBox.z, linesize, linecolor)
                    DrawLine3D(object.minBBox.x, object.maxBBox.y, object.maxBBox.z, object.maxBBox.x, object.maxBBox.y, object.maxBBox.z, linesize, linecolor)
                    DrawLine3D(object.maxBBox.x, object.maxBBox.y, object.maxBBox.z, object.maxBBox.x, object.maxBBox.y, object.minBBox.z, linesize, linecolor)
                    DrawLine3D(object.maxBBox.x, object.maxBBox.y, object.minBBox.z, object.minBBox.x, object.maxBBox.y, object.minBBox.z, linesize, linecolor)
                end
            end



            function OnDraw()


                if myHero.health <= (myHero.maxHealth*Menu.r.autoR/100) and Rready then
                    DrawText("You're life is under"..Menu.r.autoR.."%, Auto R Activated", 18, 100, 100, 0xFFFFFF00)  
                end



                if (Menu.draw.qd) then
                    -- Q Range
                    DrawCircle3D(myHero.x, myHero.y, myHero.z)
                end



                if (Menu.draw.ed) then
                    -- E Range
                    DrawCircle3D2(myHero.x, myHero.y, myHero.z)
                end


                
                if (Menu.draw.aad) then
                    -- AA Range
                    DrawCircle3D3(myHero.x, myHero.y, myHero.z)
                end


                if SelectedTarget ~= nil and Menu.TargetSelector.hitbox == 1 then 
                    DrawHitBox(SelectedTarget)

                end

                if SelectedTarget ~= nil and Menu.TargetSelector.hitbox == 2 then
                    DrawCircle3D4(SelectedTarget.x, SelectedTarget.y, SelectedTarget.z)
                end
            end
