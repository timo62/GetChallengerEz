--[[ Ez Ryze by timo62
    Have Fun with my First Script!
    If you have any problem here is the Thread for bug reports! 
    Thread: 


]]

local LocalVersion = "0.1"
local AutoUpdate = true

local serveradress = "raw.githubusercontent.com"
local scriptadress = "/timo62/GetChallengerEz/master"
local scriptname = "EZ Ryze"
local scriptmsg = "<font color=\"#AA0000\"><b>[Ez Ryze]</b></font>"
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

if myHero.charName ~= "Ryze" then return end 
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
            -- Print to the chat area
            PrintChat("<font color=\"#AA0000\"><b>[Ez Ryze] </b></font>".."<font color=\"#01cc9c\"><b>Loaded! Good Luck!</b></font>")
            PrintChat("<font color=\"#AA0000\"><b>[Ez Ryze] </b></font>".."<font color=\"#01cc9c\"><b>By: timo62</b></font>")
        end

        function OnLoad()
            FindUpdates()
            -- Minions 
            EnemyMinions = minionManager(MINION_ENEMY, 600, player, MINION_SORT_HEALTH_ASC)
            allyMinions = minionManager(MINION_ALLY, 300, player, MINION_SORT_HEALTH_DES)

            spells = {
            Q = { speed = 1700, delay = 0.25, range = 900, width = 50, collision = true, aoe = false, type = "linear" },
            }
   
            UPL:AddSpell(_Q, spells.Q)
            SayHello()

            -- Menü
            Menu = scriptConfig("{ EZ Ryze } ", "ez ryzee")
                Menu:addSubMenu("Key Settings", "Key")
                    Menu.Key:addParam("combo", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
                    Menu.Key:addParam("laneclear", "Lane Clear Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
                    Menu.Key:addParam("harass", "Harass Key", SCRIPT_PARAM_ONOFF, false, string.byte("C"))
                    Menu.Key:addParam("lasthit", "Last Hit Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte ("X"))
                    Menu.Key:addParam("Toggle", "Auto Skill Farm", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("T"))

                Menu:addSubMenu("Combo", "c")
                    Menu.c:addParam("x1", "-[    Ryze   ]-", SCRIPT_PARAM_INFO, "Ver 1.3")
                    -- Create conditionals in your menu/keybinds or in certain situations
                    Menu.c:addParam("comboMode", "Set Combo Mode", SCRIPT_PARAM_LIST, 1, {"R W Q E", "W Q E Q"}) -- Combo list default set at 1 (Q W E R)

                Menu:addSubMenu("Lane Clear", "l")
                    Menu.l:addParam("x1", "-[    Ryze   ]-", SCRIPT_PARAM_INFO, "Ver 1.3")
                    Menu.l:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                    Menu.l:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
                    Menu.l:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
                    Menu.l:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, false)

                Menu:addSubMenu("Last Hit", "lh")
                    Menu.lh:addParam("x1", "-[    Ryze   ]-", SCRIPT_PARAM_INFO, "Ver 1.3")
                    Menu.lh:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
                    Menu.lh:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
                    Menu.lh:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)

                Menu:addSubMenu("Auto Skill Farm", "tg")
                    Menu.tg:addParam("x1", "-[    Ryze   ]-", SCRIPT_PARAM_INFO, "Ver 1.3")
                    Menu.tg:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)

                Menu:addSubMenu("Prediction", "pred")
                    Menu.pred:addParam("qhs", "Q Hit Chance", SCRIPT_PARAM_SLICE, 1,1,3)
                    UPL:AddToMenu2(Menu.pred)

                Menu:addSubMenu("Drawing", "draw")
                    Menu.draw:addParam("qd", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
                    Menu.draw:addParam("wd", "Draw W Range", SCRIPT_PARAM_ONOFF, true) 
ts = TargetSelector(TARGET_LOW_HP_PRIORITY,650)
ts.name = "Ryze"
Menu:addTS(ts)
        end

        function OnTick()
                checks()
            if Menu.Key.combo and (ts.target ~= nil) then
                if Menu.c.comboMode == 1 then 
                    Combo1()
                else
                    Combo2()
            
            end
                elseif Menu.Key.laneclear then
                    Clear()
                elseif Menu.Key.lasthit then
                    Lasthit()
                elseif Menu.Key.Toggle then
                    Lasthith()
                elseif Menu.Key.harass then
                    Harass()
                end
        end



        function checks()
            ts:update()
            Qready = (myHero:CanUseSpell(_Q) == READY)
            Wready = (myHero:CanUseSpell(_W) == READY)
            Eready = (myHero:CanUseSpell(_E) == READY)
            Rready = (myHero:CanUseSpell(_R) == READY)
            target = ts.target
        end

        -- Combo RWQE during you're passive
        function Combo1()
            if Menu.Key.combo and Rready then
                CastSpell(_R)

            elseif Menu.Key.combo and Wready then
                CastSpell(_W, ts.target)


            elseif Menu.Key.combo and Qready then
                CastQ(ts.target)

            elseif Menu.Key.combo and Eready then
                CastSpell(_E, ts.target)
            end

        end

        -- Combo RWQE during you're passive
        function Combo2()
            if Menu.Key.combo and Rready then
                CastSpell(_R)

            elseif Menu.Key.combo and Wready then
                CastSpell(_W, ts.target)


            elseif Menu.Key.combo and Qready then
                CastQ(ts.target)

            elseif Menu.Key.combo and Eready then
                CastSpell(_E, ts.target)
            end

        end


        -- Combo WQEQ WQEQ ... pref use at 3 Stacks/Harass
        function Harass1()
            if Menu.Key.combo and Menu.c.useW and Menu.c.useQ and Menu.c.useE and Wready and Qready and Eready  then
                CastSpell(_W, ts.target)
                CastQ(ts.target)
                CastSpell(_E, ts.target)
            end
        end

        -- Harass2 soon
        function Harass2( )
            if Menu.Key.combo and Menu.c.useW and Menu.c.useQ and Menu.c.useE and Wready and Qready and Eready  then
                CastSpell(_W, ts.target)
                CastQ(ts.target)
                CastSpell(_E, ts.target)
            end
        end
        
        --LaneClear
        function Clear()
            if  Menu.l.useE  then
                EnemyMinions:update()
                for i, minion in pairs(EnemyMinions.objects) do
                    local wDmg = getDmg("W", minion, myHero)
                        if Menu.l.useW and Wready and wDmg >= minion.health then
                            CastSpell(_W,minion)
                        else 
                            CastSpell(_W, minion)
             
                        end
                    --end vllt.

                    local qDmg = getDmg("Q", minion, myHero)
                        if Menu.l.useQ and Qready and not Qready and GetDistance(myHero,minion) <= 600 and qDmg >= minion.health then
                            CastQ(minion)
                        else
                            CastQ(minion)
                        end

                    local eDmg = getDmg("E", minion, myHero)
                        if Menu.l.useE and Eready and eDmg >= minion.health then
                            CastSpell(_E, minion)
                        else
                            CastSpell(_E, minion)
                        end

                        if Menu.l.useR and Rready then
                            CastSpell(_R)
                        end
                end
            end
        end

  
 
        --Last Hit
        function Lasthit()
            if  Menu.lh.useQ then
                EnemyMinions:update()
                for i, minion in pairs (EnemyMinions.objects) do
                    local qDmg = getDmg("Q", minion, myHero)
                        if Menu.lh.useQ and Qready and qDmg >= (minion.health+20) then
                            CastQ(minion)
                        end
                end
            elseif  Menu.lh.useW then
                    EnemyMinions:update()
                    for i, minion in pairs (EnemyMinions.objects) do
                        local wDmg = getDmg("W", minion, myHero)
                            if Menu.lh.useW and Wready and wDmg >= minion.health then
                                CastSpell(_W,minion)
                            end
                    end
            elseif  Menu.lh.useE then
                    EnemyMinions:update()
                    for i, minion in pairs(EnemyMinions.objects) do
                        local eDmg = getDmg("E", minion, myHero)
                            if Menu.lh.useE and Eready and eDmg >= (minion.health+20) then
                                CastSpell(_E,minion)
                            end
                    end
            end
        end


        --Last Hit Q Auto
        function Lasthith()
            if  Menu.tg.useQ then
                EnemyMinions:update()
                for i, minion in pairs (EnemyMinions.objects) do
                    local qDmg = getDmg("Q", minion, myHero)
                        if Menu.tg.useQ and Qready and qDmg >= (minion.health +20) then
                            CastQ(minion)
                        end
                end
            end
        end


        function CastQ(target, minion)
            if not target and minion then return end
            CastPosition, HitChance, HeroPosition = UPL:Predict(_Q, myHero, target, minion)
                if Qready and HitChance >= Menu.pred.qhs then
                    DelayAction(function ()
                        CastSpell(_Q, CastPosition.x,CastPosition.z)
                end,0.2)
            end
        end
