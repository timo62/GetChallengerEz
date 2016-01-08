--[[ Ez Ryze by timo62
    Have Fun with my First Script!
    If you have any problem here is the Thread for bug reports! 
    Thread: 


]]

if myHero.charName ~= "ryze" then return end

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
    Menu = scriptConfig("EZ Ryze", "ez ryzee")
    Menu:addSubMenu("Key Binds", "Key")
        Menu.Key:addParam("combo", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
        Menu.Key:addParam("harass", "Harass Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
        Menu.Key:addParam("laneclear", "Lane Clear Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
 
    Menu:addSubMenu("Combo", "c")
        Menu.c:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Menu.c:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        Menu.c:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
        Menu.c:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, true)

    Menu:addSubMenu("Harass", "h")
        Menu.h:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Menu.h:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        Menu.h:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)

    Menu:addSubMenu("Lane Clear", "l")
        Menu.l:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Menu.l:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        Menu.l:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)

    Menu:addSubMenu("Prediction", "pred")
        Menu.pred:addParam("qhs", "Q Hit Chance", SCRIPT_PARAM_SLICE, 1,1,3)
        UPL:AddToMenu2(Menu.pred)
 
end
 
-- Execute 10 times per second
function OnTick()
        -- Make the target selector look for closer enemys again
            ts:update()

      if Menu.Key.laneclear then
      Clear()
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


        --Harass
    if (ts.target ~= nil) then
                -- C pressed & Spell Q
        if (Menu.Key.harass and Menu.h.useQ) then
            CastQ(ts.target)
        end
 
        -- ^ & Spell W
        if (Menu.Key.harass and Menu.h.useW) then
            if(myHero:CanUseSpell(_W) == READY) then
                -- Cast spell on enemy
                CastSpell(_W, ts.target)
            end
        end
        -- ^ & Spell E            
        if (Menu.Key.harass and Menu.h.useE) then
            if (myHero:CanUseSpell(_E) == READY) then
                -- Cast spell on enemy
                CastSpell(_E, ts.target)
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
                CastSpell(_E,minion)
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
        end
    end
 end
 


function CastQ(target)
    if not target then return end
    CastPosition, HitChance, HeroPosition = UPL:Predict(_Q, myHero, target)
    if(myHero:CanUseSpell(_Q) == READY) and HitChance >= Menu.pred.qhs then
        DelayAction(function ()
            CastSpell(_Q, CastPosition.x,CastPosition.z)
        end,0.2)
    end
end
