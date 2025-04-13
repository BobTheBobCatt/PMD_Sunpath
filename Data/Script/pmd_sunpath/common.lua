require 'origin.common_gen'
require 'origin.common_shop'
require 'pmd_sunpath.menu.member_return'
require 'pmd_sunpath.config'

function COMMON.RespawnAllies(reviveAll)
  GROUND:RefreshPlayer()
 
  local party = GAME:GetPlayerPartyTable()
  local playeridx = GAME:GetTeamLeaderIndex()
  local partnerPosition = nil
  local partnerDirection = nil
  local partner2Position = nil
  local partner2Direction = nil
 
 --custom Halcyon/Sunpath addition to handle partner respawning 
  local partner = CH('Teammate1')
  if partner ~= nil then
	partnerPosition = partner.Position
	partnerDirection = partner.Direction
  end
  
   --custom Halcyon/Sunpath addition to handle 2nd partner respawning 
  local partner2 = CH('Teammate2')
  if partner2 ~= nil then
	partner2Position = partner2.Position
	partner2Direction = partner2.Direction
  end
	
  --Halcyon/Sunpath change: reviveAll parameter. If false, only respawn player+partner. If true, then revive player+Teammates1-3
  --Place player teammates
  if reviveAll == nil then reviveAll = false end
  local allies = 1
  if reviveAll then 
	allies = 3
  end
  
  for i = 1,allies,1
  do
    GROUND:RemoveCharacter("Teammate" .. tostring(i))
  end
  local total = 1
  for i,p in ipairs(party) do
    if i ~= (playeridx + 1) and i <= allies + 1  then --Indices in lua tables begin at 1. Only spawn Teammate1 if reviveAll was false
      GROUND:SpawnerSetSpawn("TEAMMATE_" .. tostring(total),p)
      local chara = GROUND:SpawnerDoSpawn("TEAMMATE_" .. tostring(total))
      --GROUND:GiveCharIdleChatter(chara)
      total = total + 1
    end
  end
  
  partner = CH('Teammate1')
  partner2 = CH('Teammate2')

  --custom Halcyon/Sunpath addition: Move partner to their original Position and direction
  if partner ~= nil and partnerPosition ~= nil and partnerDirection ~= nil then 
	GROUND:TeleportTo(partner, partnerPosition.X, partnerPosition.Y, partnerDirection)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
    partner.CollisionDisabled = true 
  end
  
  --custom Halcyon/Sunpath addition: Move partner to their original Position and direction
  if partner2 ~= nil and partner2Position ~= nil and partner2Direction ~= nil then 
	GROUND:TeleportTo(partner2, partner2Position.X, partner2Position.Y, partner2Direction)
	AI:SetCharacterAI(partner2, "ai.ground_partner2", CH('PLAYER'), partner2.Position)
    partner2.CollisionDisabled = true 
  end
	
end

function COMMON.EndDayCycle()
  --reshuffle items

  SV.adventure.Thief = false
  SV.adventure.Tutors = { }
  SV.base_shop = { }
  
  math.randomseed(GAME:GetDailySeed())
  --roll a random index from 1 to length of category
  --add the item in that index category to the shop
  --2 essentials, always
  local type_count = math.random(3, 8)
	for ii = 1, type_count, 1 do
		local base_data = COMMON.ESSENTIALS[math.random(1, #COMMON.ESSENTIALS)]
		table.insert(SV.base_shop, base_data)
	end
  
  --1-2 ammo, always
  type_count = math.random(1, 3)
	for ii = 1, type_count, 1 do
		local base_data = COMMON.AMMO[math.random(1, #COMMON.AMMO)]
		table.insert(SV.base_shop, base_data)
	end
  
  --2-3 utilities, always
  type_count = math.random(3, 4)
	for ii = 1, type_count, 1 do
		local base_data = COMMON.UTILITIES[math.random(1, #COMMON.UTILITIES)]
		table.insert(SV.base_shop, base_data)
	end
  
  --1-2 orbs, always
  type_count = math.random(1, 3)
	for ii = 1, type_count, 1 do
		local base_data = COMMON.ORBS[math.random(1, #COMMON.ORBS)]
		table.insert(SV.base_shop, base_data)
	end
  
  --1-2 gummis, always
  type_count = math.random(1, 2)
	for ii = 1, type_count, 1 do
		local base_data = COMMON.GUMMIS[math.random(1, #COMMON.GUMMIS)]
		table.insert(SV.base_shop, base_data)
	end
  
  --2-3 held, always
  type_count = 1
	for ii = 1, type_count, 1 do
		local base_data = COMMON.HELD[math.random(1, #COMMON.HELD)]
		table.insert(SV.base_shop, base_data)
	end
  
  --2-3 tms, always
  type_count = math.random(1, 2)
	for ii = 1, type_count, 1 do
		local base_data = COMMON.TMS[math.random(1, #COMMON.TMS)]
		table.insert(SV.base_shop, base_data)
	end
  
  --2-3 status, always
  type_count = math.random(1, 4)
	for ii = 1, type_count, 1 do
		local base_data = COMMON.STATUS[math.random(1, #COMMON.STATUS)]
		table.insert(SV.base_shop, base_data)
	end
  
  --2 special item, always
  type_count = 2
	for ii = 1, type_count, 1 do
		local base_data = COMMON.SPECIAL[math.random(1, #COMMON.SPECIAL)]
		table.insert(SV.base_shop, base_data)
	end
  
  
  local catalog = {}
  
  for ii = 1, #COMMON_GEN.TRADES_RANDOM, 1 do
    local base_data = { Item=COMMON_GEN.TRADES_RANDOM[ii].Item, ReqItem=COMMON_GEN.TRADES_RANDOM[ii].ReqItem }
    
    -- check if the item has been acquired before, or if it's a 1* item and dex has been seen
    if SV.unlocked_trades[COMMON_GEN.TRADES_RANDOM[ii].Item] ~= nil then
      table.insert(catalog, base_data)
    elseif #COMMON_GEN.TRADES_RANDOM[ii].ReqItem == 2 then
      if _DATA.Save:GetMonsterUnlock(COMMON_GEN.TRADES_RANDOM[ii].Dex) == RogueEssence.Data.GameProgress.UnlockState.Discovered then
        table.insert(catalog, base_data)
      end
    end
  end

  SV.base_trades = { }
  if #catalog < 25 then
    type_count = 0
  elseif #catalog < 50 then
    type_count = 1
  elseif #catalog < 75 then
    type_count = 2
  elseif #catalog < 100 then
    type_count = 3
  elseif #catalog < 150 then
    type_count = 4
  elseif #catalog < 250 then
    type_count = 5
  elseif #catalog < 350 then
    type_count = 6
  else
    type_count = 7
  end
  
	for ii = 1, type_count, 1 do
		local idx = math.random(1, #catalog)
		local base_data = catalog[idx]
		table.insert(SV.base_trades, base_data)
		table.remove(catalog, idx)
	end
	
	
  COMMON.UpdateDayEndVars()
end
