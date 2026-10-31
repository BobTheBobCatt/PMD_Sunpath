--[[
    common.lua
    A collection of frequently used functions and values!
]]--

require 'origin.common_gen'
require 'pmd_sunpath.common_shop'
require 'pmd_sunpath.common_vars'
require 'pmd_sunpath.menu.member_return'
require 'pmd_sunpath.config'
MissionGen = require("pmd_sunpath.missiongen_lib.missiongen_lib")


COMMON.MISSION_TYPE_RESCUE = 0
COMMON.MISSION_TYPE_ESCORT = 1
COMMON.MISSION_TYPE_OUTLAW = 2
COMMON.MISSION_TYPE_EXPLORATION = 3
COMMON.MISSION_TYPE_LOST_ITEM = 4
COMMON.MISSION_TYPE_OUTLAW_ITEM = 5
COMMON.MISSION_TYPE_OUTLAW_FLEE = 6
COMMON.MISSION_TYPE_OUTLAW_MONSTER_HOUSE = 7
COMMON.MISSION_TYPE_DELIVERY = 8


COMMON.MISSION_INCOMPLETE = 0
COMMON.MISSION_COMPLETE = 1

COMMON.MISSION_BOARD_MISSION = 0
COMMON.MISSION_BOARD_OUTLAW = 1
COMMON.MISSION_BOARD_TAKEN = 2

-------------------------------
--Halcyon scripts
-------------------------------
-- Used in checks for flee outlaws when ongoing missions and returning back to the same floor
-- It might be better just to have a flag on each mission that marks if it's "valid" but this works
COMMON.FLEE_BACKREFERENCE = -2

COMMON.PERSONALITY = {}

--indexing on these start at 0001; 1000 for hero
COMMON.PERSONALITY[50] = { --Hero


}

--Partner personalities are below
--default
COMMON.PERSONALITY[51] = { 
	FULL = {0001, 0002, 0003, 0004, 0005, 0006, 0007, 0008, 0009, 0010, 0011},
	HALF = {0001, 0002, 0003, 0004, 0005},
	PINCH = {0001, 0002, 0003, 0004, 0005},
	WAIT = {0001}
	
}

--Rescue mission on this floor
COMMON.PERSONALITY[52] = {
	FULL = {0020, 0021, 0022, 0023, 0024},
	HALF = {0020, 0021, 0022},
	PINCH = {0020, 0021, 0022},
	WAIT = {0001}
}

--Escort mission on this floor
COMMON.PERSONALITY[53] = {
	FULL = {0030, 0031, 0032, 0033, 0034},
	HALF = {0030, 0031, 0032},
	PINCH = {0030, 0031, 0032},
	WAIT = {0001}
}

--Delivery mission on this floor -- you have the item
COMMON.PERSONALITY[54] = {
	FULL = {0040, 0041, 0042},
	HALF = {0040, 0041},
	PINCH = {0040, 0041},
	WAIT = {0001}
	
	
}--Delivery mission on this floor -- you lack the item
COMMON.PERSONALITY[55] = {
	FULL = {0051, 0052, 0053},
	HALF = {0051, 0052},
	PINCH = {0051, 0052},
	WAIT = {0001}
}

--Lost Item mission on this floor
COMMON.PERSONALITY[56] = {
	FULL = {0060, 0061, 0062, 0063, 0064},
	HALF = {0060, 0061, 0062},
	PINCH = {0060, 0061, 0062},
	WAIT = {0001}
}

--Escort is with you, current floor has no active job
COMMON.PERSONALITY[57] = {
	FULL = {1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1060, 1061, 1062},
	HALF = {1000, 1001, 1002, 1003, 1004, 1060, 1061},
	PINCH = {1000, 1001, 1002, 1003, 1004, 1060, 1061},
	WAIT = {0001}
}

--Exploration escort is with you, current floor has no active job
COMMON.PERSONALITY[58] = {
	FULL = {1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1070, 1071, 1072},
	HALF = {1000, 1001, 1002, 1003, 1004, 1070, 1071},
	PINCH = {1000, 1001, 1002, 1003, 1004, 1070, 1071},
	WAIT = {0001}
}


--Outlaw mission on this floor
COMMON.PERSONALITY[59] = {
	FULL = {0070, 0071, 0072, 0073, 0074},
	HALF = {0070, 0071, 0072},
	PINCH = {0070, 0071, 0072},
	WAIT = {0001}
}

--These have 1 or more default ones removed typically, and a few custom ones added in specific to that place.
--Sandhill Cave - Chapter 1
COMMON.PERSONALITY[60] = { 
	FULL = {0080, 0081, 0082, 0083, 0084, 0085, 0086, 0087, 0088, 0089, 0090},
	HALF = {0080, 0081, 0082, 0083, 0084},
	PINCH = {0080, 0081, 0082, 0083, 0084},
	WAIT = {0001}
	
}

--These have 1 or more default ones removed typically, and a few custom ones added in specific to that place.
--Parched Steppes - Chapter 1
COMMON.PERSONALITY[61] = { 
	FULL = {0080, 0081, 0082, 0083, 0084, 0085, 0086, 0087, 0088, 0089, 0090},
	HALF = {0080, 0081, 0082, 0083, 0084},
	PINCH = {0080, 0081, 0082, 0083, 0084},
	WAIT = {0001}
	
}

--These have 1 or more default ones removed typically, and a few custom ones added in specific to that place.
--Dry Woods - Chapter 2
COMMON.PERSONALITY[62] = { 
	FULL = {0080, 0081, 0082, 0083, 0084, 0085, 0086, 0087, 0088, 0089, 0090},
	HALF = {0080, 0081, 0082, 0083, 0084},
	PINCH = {0080, 0081, 0082, 0083, 0084},
	WAIT = {0001}
	
}




--Invalid, default personality. Lets you know there was an error and it defaulted to this as a result.
COMMON.PERSONALITY[999] = {
	FULL = {9999},
	HALF = {9999},
	PINCH = {9999},
	WAIT = {1000}
}

--Edited PMDO/Halcyon script for Sunpath
function COMMON.RespawnAllies(reviveAll)
  GROUND:RefreshPlayer()
 
  local party = GAME:GetPlayerPartyTable()
  local playeridx = GAME:GetTeamLeaderIndex()
  local partnerPosition = nil
  local partnerDirection = nil
  local partner2Position = nil
  local partner2Direction = nil
 
 --custom Halcyon addition to handle partner respawning 
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
	
  --Halcyon change: reviveAll parameter. If false, only respawn player+partner. If true, then revive player+Teammates1-3
  --Place player teammates
  if reviveAll == nil then reviveAll = false end
  local allies = 2
  if reviveAll then 
	allies = 3
  end
  
  for i = 1,allies,2
  do
    GROUND:RemoveCharacter("Teammate" .. tostring(i))
  end
  local total = 1
  for i,p in ipairs(party) do
    if i ~= (playeridx + 1) and i <= allies + 1  then --Indices in lua tables begin at 1. Only spawn Teammate1 and Teammate2 if reviveAll was false
      GROUND:SpawnerSetSpawn("TEAMMATE_" .. tostring(total),p)
      local chara = GROUND:SpawnerDoSpawn("TEAMMATE_" .. tostring(total))
      --GROUND:GiveCharIdleChatter(chara)
      total = total + 1
    end
  end
  
  partner = CH('Teammate1')
  partner2 = CH('Teammate2')

  --custom Halcyon addition: Move partner to their original Position and direction
  if partner ~= nil and partnerPosition ~= nil and partnerDirection ~= nil then 
	GROUND:TeleportTo(partner, partnerPosition.X, partnerPosition.Y, partnerDirection)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
    partner.CollisionDisabled = true 
  end
  
  --custom Halcyon/Sunpath addition: Move other partner to their original Position and direction
  if partner2 ~= nil and partner2Position ~= nil and partner2Direction ~= nil then 
	GROUND:TeleportTo(partner2, partner2Position.X, partner2Position.Y, partner2Direction)
	AI:SetCharacterAI(partner2, "origin.ai.ground_partner", CH('PLAYER'), partner2.Position)
    partner2.CollisionDisabled = true 
  end
	
end

--Halcyon script
function COMMON.RespawnAlliesChapter1And2(reviveAll)
  GROUND:RefreshPlayer()
 
  local party = GAME:GetPlayerPartyTable()
  local playeridx = GAME:GetTeamLeaderIndex()
  local partnerPosition = nil
  local partnerDirection = nil
 
 --custom Halcyon addition to handle partner respawning 
  local partner = CH('Teammate1')
  if partner ~= nil then
	partnerPosition = partner.Position
	partnerDirection = partner.Direction
  end
	
  --Halcyon change: reviveAll parameter. If false, only respawn player+partner. If true, then revive player+Teammates1-3
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

  --custom Halcyon addition: Move partner to their original Position and direction
  if partner ~= nil and partnerPosition ~= nil and partnerDirection ~= nil then 
	GROUND:TeleportTo(partner, partnerPosition.X, partnerPosition.Y, partnerDirection)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
    partner.CollisionDisabled = true 
  end
	
end

-------------------------------
--Nebula's Mission Board scripts
-------------------------------

function COMMON.ShowDestinationMenu(dungeon_entrances, ground_entrances, force_list, speaker, confirm_msg)
    local job_dests = MissionGen:LoadJobDestinations()

    local open_dests = {}
    -- check for unlock of grounds
    for ii = 1, #ground_entrances, 1 do
        if ground_entrances[ii].Flag then
            local ground_id = ground_entrances[ii].Zone
            local zone_summary = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(ground_id)
            local ground = _DATA:GetGround(zone_summary.Grounds[ground_entrances[ii].ID])
            local ground_name = ground:GetColoredName()
            table.insert(open_dests, {
                Name = ground_name,
                Dest = RogueEssence.Dungeon.ZoneLoc(ground_id, -1, ground_entrances[ii].ID, ground_entrances[ii].Entry)
            })
        end
    end

    -- check for unlock of dungeons
    for ii = 1, #dungeon_entrances, 1 do
        if GAME:DungeonUnlocked(dungeon_entrances[ii]) then
            local zone_summary = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(dungeon_entrances[ii])
            if zone_summary.Released then
                local zone_name = ""
                if _DATA.Save:GetDungeonUnlock(dungeon_entrances[ii]) ==
                    RogueEssence.Data.GameProgress.UnlockState.Completed then
                    zone_name = zone_summary:GetColoredName()
                else
                    zone_name = "[color=#00FFFF]" .. zone_summary.Name:ToLocal() .. "[color]"
                end
                zone_name = MissionGen:FormatDestinationMenuZoneName(job_dests, dungeon_entrances[ii], zone_name) -- missiongen_lib.lua file

                table.insert(open_dests, {
                    Name = zone_name,
                    Dest = RogueEssence.Dungeon.ZoneLoc(dungeon_entrances[ii], 0, 0, 0)
                })
            end
        end
    end

    local dest = RogueEssence.Dungeon.ZoneLoc.Invalid
    if #open_dests > 1 or force_list then

        SOUND:PlaySE("Menu/Skip")
        local default_choice = 1
        while true do
            UI:ResetSpeaker()
            UI:DestinationMenu(open_dests, default_choice)
            UI:WaitForChoice()
            default_choice = UI:ChoiceResult()

            if default_choice == nil then
                break
            end
            local ask_dest = open_dests[default_choice].Dest
            if ask_dest.StructID.Segment >= 0 then
                -- chosen dungeon entry
                if speaker ~= nil then
                    UI:SetSpeaker(speaker)
                else
                    UI:ResetSpeaker(false)
                end
                UI:DungeonChoice(open_dests[default_choice].Name, ask_dest)
                UI:WaitForChoice()
                if UI:ChoiceResult() then
                    dest = ask_dest
                    break
                end
            else
                dest = ask_dest
                break
            end
        end
    elseif #open_dests == 1 then
        if open_dests[1].Dest.StructID.Segment < 0 then
            -- single ground entry
            if speaker ~= nil then
                UI:SetSpeaker(speaker)
            else
                UI:ResetSpeaker(false)
                SOUND:PlaySE("Menu/Skip")
            end
            UI:ChoiceMenuYesNo(STRINGS:FormatKey("DLG_ASK_ENTER_GROUND", open_dests[1].Name))
            UI:WaitForChoice()
            if UI:ChoiceResult() then
                dest = open_dests[1].Dest
            end
        else
            -- single dungeon entry
            if speaker ~= nil then
                UI:SetSpeaker(speaker)
            else
                UI:ResetSpeaker(false)
                SOUND:PlaySE("Menu/Skip")
            end
            UI:DungeonChoice(open_dests[1].Name, open_dests[1].Dest)
            UI:WaitForChoice()
            if UI:ChoiceResult() then
                dest = open_dests[1].Dest
            end
        end
    else
        PrintInfo("No valid destinations found!")
    end

    if dest:IsValid() then
        if confirm_msg ~= nil then
            UI:WaitShowDialogue(confirm_msg)
        end
        if dest.StructID.Segment > -1 then
            -- pre-loads the zone on a separate thread while we fade out, just for a little optimization
            _DATA:PreLoadZone(dest.ID)
            SOUND:PlayBGM("", true)
            GAME:FadeOut(false, 20)
            GAME:EnterDungeon(dest.ID, dest.StructID.Segment, dest.StructID.ID, dest.EntryPoint,
                RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
        else
            SOUND:PlayBGM("", true)
            GAME:FadeOut(false, 20)
            GAME:EnterZone(dest.ID, dest.StructID.Segment, dest.StructID.ID, dest.EntryPoint)
        end
    end
end

function COMMON.EnterDungeonMissionCheck(zoneId, segmentID)
    local escort_jobs, removed_names = MissionGen:EnterDungeonPrepareParty(zoneId)
    MissionGen:PrintSentHome(removed_names)

    local added_names = MissionGen:EnterDungeonAddJobEscorts(zoneId, escort_jobs)
    for _, name in ipairs(COMMON.GetSortedKeys(SV.missions.Missions)) do
        local mission = SV.missions.Missions[name]
        if mission.Complete == COMMON.MISSION_INCOMPLETE and zoneId == mission.DestZone and segmentID ==
            mission.DestSegment then
            if mission.Type == 1 then -- escort
                -- add escort to team
                local mon_id = mission.EscortSpecies
                local new_mob = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 50, "", -1)
                _DATA.Save.ActiveTeam.Guests:Add(new_mob)

                local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("EscortInteract")
                new_mob.ActionEvents:Add(talk_evt)

                local tbl = LTBL(new_mob)
                tbl.Escort = name

                table.insert(added_names, new_mob.Name)
            end
        end
    end
    MissionGen:PrintEscortAdd(added_names)
end

-------------------------------
--Sunpath scripts
-------------------------------

--Edited version of PMDO's shop script
function COMMON.EndDayCycle()
  --reshuffle items

  SV.adventure.Thief = false
  SV.adventure.Tutors = { }
  SV.base_shop = { }
  SV.base_shop_desert = { }
  
  math.randomseed(GAME:GetDailySeed())
  --roll a random index from 1 to length of category
  --add the item in that index category to the shop
  --2 essentials, always (for desert shop)
  local type_count = 3
	for ii = 1, type_count, 1 do
		local base_data = COMMON.ESSENTIALSDESERT[math.random(1, #COMMON.ESSENTIALSDESERT)]
		table.insert(SV.base_shop_desert, base_data)
	end
	
  --5-8 essentials, always
  type_count = math.random(6, 9)
	for ii = 1, type_count, 1 do
		local base_data = COMMON.ESSENTIALS[math.random(1, #COMMON.ESSENTIALS)]
		table.insert(SV.base_shop, base_data)
	end
  
  --1-3 ammo, always
  type_count = math.random(1, 3)
	for ii = 1, type_count, 1 do
		local base_data = COMMON.AMMO[math.random(1, #COMMON.AMMO)]
		table.insert(SV.base_shop, base_data)
	end
	
  --1-2 ammo, always (for desert shop)
  type_count = math.random(1, 2)
	for ii = 1, type_count, 1 do
		local base_data = COMMON.AMMO[math.random(1, #COMMON.AMMO)]
		table.insert(SV.base_shop_desert, base_data)
	end
  
  --2-3 utilities, always
  type_count = math.random(3, 4)
	for ii = 1, type_count, 1 do
		local base_data = COMMON.UTILITIES[math.random(1, #COMMON.UTILITIES)]
		table.insert(SV.base_shop, base_data)
	end
	
  --1-2 utilities, always (for desert shop)
  type_count = math.random(1, 2)
	for ii = 1, type_count, 1 do
		local base_data = COMMON.UTILITIES[math.random(1, #COMMON.UTILITIES)]
		table.insert(SV.base_shop_desert, base_data)
	end
  
  --2-3 orbs, always
  type_count = math.random(3, 4)
	for ii = 1, type_count, 1 do
		local base_data = COMMON.ORBS[math.random(1, #COMMON.ORBS)]
		table.insert(SV.base_shop, base_data)
	end
	
  --1-2 orbs, always (for desert shop)
  type_count = math.random(1, 2)
	for ii = 1, type_count, 1 do
		local base_data = COMMON.ORBS[math.random(1, #COMMON.ORBS)]
		table.insert(SV.base_shop_desert, base_data)
	end
  
  --2 special item, always
  type_count = 2
	for ii = 1, type_count, 1 do
		local base_data = COMMON.SPECIAL[math.random(1, #COMMON.SPECIAL)]
		table.insert(SV.base_shop, base_data)
	end
	
  --1-2 held items, always
  type_count = math.random(1, 2)
	for ii = 1, type_count, 1 do
		local base_data = COMMON.HELD[math.random(1, #COMMON.HELD)]
		table.insert(SV.base_shop, base_data)
	end
	
  --1-2 gummis, always
  type_count = math.random(1, 2)
	for ii = 1, type_count, 1 do
		local base_data = COMMON.GUMMIS[math.random(1, #COMMON.GUMMIS)]
		table.insert(SV.base_shop, base_data)
	end
	
  --2-3 status items, always
  type_count = math.random(3, 4)
	for ii = 1, type_count, 1 do
		local base_data = COMMON.STATUS[math.random(1, #COMMON.STATUS)]
		table.insert(SV.base_shop, base_data)
	end
	
  --1-2 status items, always (for desert shop)
  type_count = math.random(1, 2)
	for ii = 1, type_count, 1 do
		local base_data = COMMON.STATUS[math.random(1, #COMMON.STATUS)]
		table.insert(SV.base_shop_desert, base_data)
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
	
	
  --COMMON.UpdateDayEndVarsSunpath() -- Placeholder for now
end
