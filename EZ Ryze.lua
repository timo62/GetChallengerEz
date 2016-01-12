--[[ Ez Ryze by timo62
    Have Fun with my First Script!
    If you have any problem here is the Thread for bug reports! 
    Thread: 


]]

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
        PrintChat("Script by timo62")
        PrintChat("Ez Ryze Loaded! Good Luck! ;)")
end
 
-- We will store the target selector on this variable
ts = TargetSelector(TARGET_LOW_HP_PRIORITY,650)
--Minion

 
-- Execute only at start of the game
function OnLoad()
            -- Minions 
            EnemyMinions = minionManager(MINION_ENEMY, 600, player, MINION_SORT_HEALTH_ASC)
            allyMinions = minionManager(MINION_ALLY, 300, player, MINION_SORT_HEALTH_DES)
    SayHello()
 
     spells = {
        Q = { speed = 1700, delay = 0.25, range = 900, width = 50, collision = true, aoe = false, type = "linear" },
    }
   
    UPL:AddSpell(_Q, spells.Q)
        --MENU
    Menu = scriptConfig("{ EZ Ryze } ", "ez ryzee")
    Menu:addSubMenu("Key Settings", "Key")
        Menu.Key:addParam("combo", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
        Menu.Key:addParam("laneclear", "Lane Clear Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
        Menu.Key:addParam("lasthit", "Last Hit Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte ("X"))
        Menu.Key:addParam("Toggle", "Auto Skill Farm", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("T"))
 
    Menu:addSubMenu("Combo", "c")
        Menu.c:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Menu.c:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        Menu.c:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
        Menu.c:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, true)

    Menu:addSubMenu("Lane Clear", "l")
        Menu.l:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Menu.l:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        Menu.l:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
        Menu.l:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, false)

    Menu:addSubMenu("Last Hit", "lh")
        Menu.lh:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Menu.lh:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
        Menu.lh:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)

    Menu:addSubMenu("Auto Skill Farm", "tg")
        Menu.tg:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)

    Menu:addSubMenu("Prediction", "pred")
        Menu.pred:addParam("qhs", "Q Hit Chance", SCRIPT_PARAM_SLICE, 1,1,3)
        UPL:AddToMenu2(Menu.pred)

    Menu:addSubMenu("Drawing", "draw")
        Menu.draw:addParam("qd", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
        Menu.draw:addParam("wd", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
 
end
 
-- Execute 10 times per second
function OnTick()
        -- Make the target selector look for closer enemys again
            ts:update()

        if Menu.Key.laneclear then
            Clear()
        end

        if Menu.Key.lasthit then
            Lasthit()
        end


        if Menu.Key.Toggle then
            Lasthith()
        end

        if Menu.Key.harass then
            Harass()
        end
     
        --Combo
    if (ts.target ~= nil) then
                -- Spacebar pressed ?
        if (Menu.Key.combo and Menu.c.useQ) then
            CastQ(ts.target)
        end
 
        -- Can we cast W ?
        if (Menu.Key.combo and Menu.c.useW) then
            if(myHero:CanUseSpell(_W) == READY) then
                -- Cast spell on enemy
                CastSpell(_W, ts.target)
            end
        end
                     
        if (Menu.Key.combo and Menu.c.useE) then
            if (myHero:CanUseSpell(_E) == READY) then
                -- Cast spell on enemy
                CastSpell(_E, ts.target)
            end
        end
        if (Menu.Key.combo and Menu.c.useR)then
            if (myHero:CanUseSpell(_R) == READY) then
                -- Cast spell on enemy
                CastSpell(_R)
            end
        end
    end  
end



        --LaneClear
function Clear()

    if  Menu.l.useE  then
        EnemyMinions:update()
        for i, minion in pairs(EnemyMinions.objects) do
            local eDmg = getDmg("E", minion, myHero)
            if Menu.l.useE and myHero:CanUseSpell(_E) == READY and eDmg >= minion.health then
                CastSpell(_E,minion)
            else 
                CastSpell(_E, minion)
             
            end
            local wDmg = getDmg("W", minion, myHero)
            if Menu.l.useW and myHero:CanUseSpell(_W) == READY and not myHero:CanUseSpell(_E) == READY and wDmg >= minion.health then
                CastSpell(_W,minion)
            else
                CastSpell(_W,minion)
            end
            local qDmg = getDmg("Q", minion, myHero)
            if Menu.l.useQ and myHero:CanUseSpell(_Q) == READY and GetDistance(myHero,minion) <= 600 and qDmg >= minion.health then
                CastQ(minion)
            else
                CastQ(minion)
            end

            if Menu.l.useR and myHero:CanUseSpell(_R) == READY then
                CastSpell(_R)
            end

        end
    end
 end
 
        --Last Hit
        function Lasthit()
                if Menu.lh.useQ then
                    EnemyMinions:update()
                    for i, minion in pairs (EnemyMinions.objects) do
                        local qDmg = getDmg("Q", minion, myHero)
                        if Menu.lh.useQ and myHero:CanUseSpell(_Q) == READY and qDmg >= (minion.health+20) then
                            CastQ(minion)
                        end
                    end
                end
        

                if Menu.lh.useW then
                    EnemyMinions:update()
                    for i, minion in pairs (EnemyMinions.objects) do
                        local wDmg = getDmg("W", minion, myHero)
                        if Menu.lh.useW and myHero:CanUseSpell(_W) == READY and wDmg >= minion.health then
                            CastSpell(_W,minion)
                        end
                    end
                end

                if Menu.lh.useE then
                    EnemyMinions:update()
                    for i, minion in pairs(EnemyMinions.objects) do
                        local eDmg = getDmg("E", minion, myHero)
                        if Menu.lh.useE and myHero:CanUseSpell(_E) == READY and eDmg >= (minion.health+20) then
                            CastSpell(_E,minion)

                        end
                    end
                end
        end


        -- 
        --Last Hit Q Auto
        function Lasthith()
                if Menu.tg.useQ then
                    EnemyMinions:update()
                    for i, minion in pairs (EnemyMinions.objects) do
                        local qDmg = getDmg("Q", minion, myHero)
                        if Menu.tg.useQ and myHero:CanUseSpell(_Q) == READY and qDmg >= (minion.health +20) then
                            CastQ(minion)
                        end
                    end
                end
        end


function CastQ(target, minion)
    if not target and minion then return end
    CastPosition, HitChance, HeroPosition = UPL:Predict(_Q, myHero, target, minion)
    if(myHero:CanUseSpell(_Q) == READY) and HitChance >= Menu.pred.qhs then
        DelayAction(function ()
            CastSpell(_Q, CastPosition.x,CastPosition.z)
        end,0.2)
    end
<<<<<<< HEAD
end
=======
end

-- Drawing graphics
function OnDraw()
    if (Menu.draw.qd) then
        -- Q Range
        DrawCircle(myHero.x, myHero.y, myHero.z, 900, 0x111111)
    end

    if (Menu.draw.wd) then
        -- W Range
        DrawCircle(myHero.x, myHero.y, myHero.z, 600, 0x113211)
    end
end
>>>>>>> origin/master
