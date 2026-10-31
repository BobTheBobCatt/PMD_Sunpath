require 'pmd_sunpath.common'

require 'pmd_sunpath.CharacterEssentials'

RedirectionType = luanet.import_type('PMDC.Dungeon.Redirected')

----------------------
--Sunpath scripts
----------------------

--Makes it so that a Focus Sash is dropped when an attack is endured.
--Code from Trio
function BATTLE_SCRIPT.EndureDropEvent(owner, ownerChar, context, args)

	local EndureStateType = luanet.import_type('PMDC.Dungeon.AttackEndure')
	local item = RogueEssence.Dungeon.InvItem("held_focus_sash")
	if context.ContextStates:Contains(luanet.ctype(EndureStateType)) and context.Target.HP == 1 then
		TASK:WaitTask(context.Target:DequipItem())
		local endLoc = _DUNGEON:MoveShotUntilBlocked(context.User, context.Target.CharLoc, context.User.CharDir, 2, RogueEssence.Dungeon.Alignment.None, false, false)
		TASK:WaitTask(_DUNGEON:DropItem(item, endLoc, context.Target.CharLoc))
	end

end

--A system that adds a chance-based system to endure an attack if an item or move has the battle event script. 1 is ignored in this case, so 2-5 would produce a 25% chance to endure an attack.
--Assisted coding with Nebula
function BATTLE_SCRIPT.EndureChanceEvent(owner, ownerChar, context, args)

	local endurechance = _DATA.Save.Rand:Next(1,5)
	if endurechance == 1 then
		context.ContextStates:Set(PMDC.Dungeon.AttackEndure())
	end

end

--Makes it so that the Pokemon is healed by 1/10 of total HP and has all statuses cured when they pick up Poke while holding a Prosper Ribbon
--Improved code by Mocha
function ITEM_SCRIPT.ProsperEvent(owner, ownerChar, context, args)
    local heal = math.max(1, context.User.MaxHP / 10)
    local statusList = {
        "poison", 
        "poison_toxic", 
        "burn", 
        "confuse", 
        "paralyze", 
        "perish_song", 
        "in_love", 
        "cursed", 
        "frostbite", 
        "calcify", 
        "drowsy", 
        "disable", 
        "encore", 
        "taunted"
    }

    if context.Item.IsMoney then
        SOUND:PlayBattleSE("DUN_Heal")
        TASK:WaitTask(context.User:RestoreHP(heal, true))

        for i = 1, #statusList, 1 do
            local status = statusList[i]
            if context.User:GetStatusEffect(status) ~= nil then
                TASK:WaitTask(context.User:RemoveStatusEffect(status))
            end
        end
    end
end

--Feature where the stairs are revealed whenever a Guiding Orb is used
--Code by Trio
function BATTLE_SCRIPT.GuidingEvent(owner, ownerChar, context, loc)
	local stairsIds = {
					["stairs_go_down"] = true,
					["stairs_go_up"] = true,
	}

	for xx = 0, _ZONE.CurrentMap.Width - 1, 1 do
		for yy = 0, _ZONE.CurrentMap.Height - 1, 1 do
			local loc = RogueElements.Loc(xx, yy)
			local tl = _ZONE.CurrentMap:GetTile(loc)
			if stairsIds[tl.Effect.ID] then
				_ZONE.CurrentMap.DiscoveryArray[xx][yy] = RogueEssence.Dungeon.Map.DiscoveryState.Traversed
			end
		end
	end
end

--Feature where a Pokemon restores twice as much hunger when eating items while a Big Eater Belt is held. Game engine supposedly does not support belly-restore value multiplication at this moment without some very convoluted methods, so try not to follow the scripting here
--[[function BATTLE_SCRIPT.BigEaterEvent(owner, ownerChar, context, args)

	local BellyRestore = luanet.import_type('PMDC.Dungeon.RestoreBellyEvent')
	local BigEaterBellyRestore = BellyRestore(math.max(1, context.Item.Heal * 2), false)
	if context.User.EquippedItem.ID == "held_big_eater_belt" then
		TASK:WaitTask(context.Item:Heal(BigEaterBellyRestore, false))
	end

end]]

--Feature where a Pokemon gets an HP boost while a Blue Scarf is held. Game engine supposedly does not support temporary max HP boost at this moment, so try not to follow the scripting here
--[[function ITEM_SCRIPT.BlueScarfEvent(owner, ownerChar, context, args)

	if context.User.EquippedItem.ID == "held_blue_scarf" then
		status.StatusStates.Set(PMDC.Dungeon.HPState(math.max(1, context.User.MaxHP * 1.1)))
	end

end]]

--Test script that displays a message via Battle Script Event.
function BATTLE_SCRIPT.Test2(owner, ownerChar, context, args)

	print("Running Script")

end

--Attempt script that tries to mimic the Freeze event for Petrify.
function BATTLE_SCRIPT.PetrifyEvent(owner, ownerChar, context, args)
	local element = context.Data.Element
	local CountDownType = luanet.import_type('RogueEssence.Dungeon.CountDownState')
	local CurerState = luanet.import_type('PMDC.Dungeon.CurerState')
	if context.UsageSlot == RogueEssence.Dungeon.BattleContext.FORCED_SLOT then
		return
	end
	
	if element == "steel" or element == "ground" then
		TASK:WaitTask(context.Target:RemoveStatusEffect("petrified"))
	end
	
	if context.ActionType == RogueEssence.Dungeon.BattleActionType.Item then
		if ItemStates:Contains(luanet.ctype(CurerState)) then
			return
		end
	end
	
	if owner.StatusStates:GetWithDefault(luanet.ctype(CountDownType)).Counter > 0 then
		_DUNGEON:LogMsg(STRINGS:Format(RogueEssence.StringKey("MSG_PETRIFY"):ToLocal(), context.User:GetDisplayName(false)))
	end
	context.CancelState.Cancel = true
	
end

--Attempt script that tries to dispel the Petrify status by using a specific move-type, and makes the enemy Pokemon unable to be hit under the effect.
function BATTLE_SCRIPT.PetrifyThawEvent(owner, ownerChar, context, args)
	local element = context.Data.Element
	local AccMult = luanet.import_type('PMDC.Dungeon.AccMult')
	local CureAttack = luanet.import_type('PMDC.Dungeon.CureAttack')
	if element == "steel" or element == "ground" then
		TASK:WaitTask(context.Target:RemoveStatusEffect("petrified"))
	end
	
	if context.ContextStates:Contains(luanet.ctype(CureAttack)) then
		return
	end
	
	if context.Data.Category ~= RogueEssence.Data.BattleData.SkillCategory.None then
		_DUNGEON:LogMsg(STRINGS:Format(RogueEssence.StringKey("MSG_PETRIFY"):ToLocal(), context.Target:GetDisplayName(false)))
		context:AddContextStateMult(luanet.ctype(AccMult), false, -1, 1)
	end
	
end

--Script that checks for the personality condition to apply a buff and debuff dependent on MultiplyCategory & potentially MultiplyAccuracy
--Code from Nebula
function CONDITION_SCRIPT.ApplyNatureCheck(_, _, _, args)
	local stat = args[1] -- the stat to check
	local modifier = args[2] --either "up" or "down"
	local nature = SV.PlayerNature --or whatever
	if GeneralFunctions.Natures[nature] then --you would put the real path to the table here
		return GeneralFunctions.Natures[nature][modifier] == stat
	end
	return false
end

--Tutorial text for picking up a food item
--Improved code by Mocha
function ITEM_SCRIPT.ItemTutorialFood(owner, ownerChar, context, args)
    if CONFIG.DoTutorials() then
		local inv_count = _DATA.Save.ActiveTeam:GetInvCount() - 1
		for i = inv_count, 0, -1 do
		local item = _DATA.Save.ActiveTeam:GetInv(i)
		local prefix = "food_"
    	UI:ResetSpeaker()
			if string.sub(item.ID, 1, #prefix) == prefix and not SV.Tutorials.PickedUpFood then
				GAME:WaitFrames(40)
			    SOUND:PlayFanfare("Fanfare/Note")
				GAME:WaitFrames(10)
				UI:WaitShowDialogue("An Apple or Yucca Fruit restores hunger.")
				UI:WaitShowDialogue("If you get hungry, eat a food item such as an Apple or Yucca Fruit. If your Belly becomes empty, you will slowly lose health until you faint or eat something.")
				SV.Tutorials.PickedUpFood = true
			end
		end
	end
end

--Tutorial text for picking up an oran berry
function ITEM_SCRIPT.ItemTutorialOran(owner, ownerChar, context, args)
    if CONFIG.DoTutorials() then
		local inv_count = _DATA.Save.ActiveTeam:GetInvCount() - 1
		for i = inv_count, 0, -1 do
		local item = _DATA.Save.ActiveTeam:GetInv(i)
    	UI:ResetSpeaker()
			if not SV.Tutorials.PickedUpOranBerry then
		    	if item.ID == "berry_oran" or item.ID == "berry_oran_tiny" then
					GAME:WaitFrames(40)
			    	SOUND:PlayFanfare("Fanfare/Note")
					GAME:WaitFrames(10)
			    	UI:WaitShowDialogue("An Oran Berry restores HP.")
			    	UI:WaitShowDialogue("Keep watch of your HP at the top of the screen. If a Pokémon's HP reaches 0, it will faint!")
			   		UI:WaitShowDialogue("If you faint, you will be kicked out of the dungeon. So be careful so that this doesn't happen.")
			    	SV.Tutorials.PickedUpOranBerry = true
				end
			end
		end
	end
end

--Tutorial text for picking up a leppa berry
function ITEM_SCRIPT.ItemTutorialLeppa(owner, ownerChar, context, args)
    if CONFIG.DoTutorials() then
		local inv_count = _DATA.Save.ActiveTeam:GetInvCount() - 1
		for i = inv_count, 0, -1 do
		local item = _DATA.Save.ActiveTeam:GetInv(i)
    	UI:ResetSpeaker()
			if not SV.Tutorials.PickedUpLeppaBerry then
				if item.ID == "berry_leppa" or item.ID == "berry_leppa_tiny" then
					GAME:WaitFrames(40)
			    	SOUND:PlayFanfare("Fanfare/Note")
					GAME:WaitFrames(10)
			    	UI:WaitShowDialogue("A Leppa Berry restores a Pokemon's Power Points (PP).")
					UI:WaitShowDialogue("If a move runs out of PP, you'll be unable to use that move again until a Leppa Berry is eaten or PP is restored.")
			    	SV.Tutorials.PickedUpLeppaBerry = true
		    	end
			end
		end
	end
end

--Tutorial text for picking up a seed item	
--Improved code by Mocha
function ITEM_SCRIPT.ItemTutorialSeed(owner, ownerChar, context, args)
    if CONFIG.DoTutorials() then
		local inv_count = _DATA.Save.ActiveTeam:GetInvCount() - 1
		for i = inv_count, 0, -1 do
		local item = _DATA.Save.ActiveTeam:GetInv(i)
		local prefix = "seed_"
    	UI:ResetSpeaker()
			if string.sub(item.ID, 1, #prefix) == prefix and not SV.Tutorials.PickedUpSeed then
				GAME:WaitFrames(40)
			    SOUND:PlayFanfare("Fanfare/Note")
				GAME:WaitFrames(10)
				UI:WaitShowDialogue("A seed is an item that has various effects.")
				UI:WaitShowDialogue("If a seed has a negative effect, you can throw it at an enemy Pokemon to use their effect on them!")
				UI:WaitShowDialogue("If a seed has a positive effect instead, you can use it on yourself or a team member via eating it.")
				SV.Tutorials.PickedUpSeed = true
			end
		end
	end
end

--Tutorial text for picking up money
function ITEM_SCRIPT.ItemTutorialMoney(owner, ownerChar, context, args)
    if CONFIG.DoTutorials() then
    	UI:ResetSpeaker()
		if not SV.Tutorials.PickedUpMoney then
		    if context.Item.IsMoney then
				GAME:WaitFrames(40)
			    SOUND:PlayFanfare("Fanfare/Note")
				GAME:WaitFrames(10)
				UI:WaitShowDialogue("Poké is this world's currency. Save it up to purchase useful items for your adventures!")
				SV.Tutorials.PickedUpMoney = true
		    end
		end
	end
end

--Tutorial text for picking up an orb item
--Improved code by Mocha
function ITEM_SCRIPT.ItemTutorialOrb(owner, ownerChar, context, args)
    if CONFIG.DoTutorials() then
		local inv_count = _DATA.Save.ActiveTeam:GetInvCount() - 1
		for i = inv_count, 0, -1 do
		local item = _DATA.Save.ActiveTeam:GetInv(i)
		local prefix = "orb_"
    	UI:ResetSpeaker()
			if string.sub(item.ID, 1, #prefix) == prefix and not SV.Tutorials.PickedUpOrb then
				GAME:WaitFrames(40)
			    SOUND:PlayFanfare("Fanfare/Note")
				GAME:WaitFrames(10)
				UI:WaitShowDialogue("A orb is an item that has various powerful effects.")
				UI:WaitShowDialogue("Orbs usually have area effects, in comparison to single-target effects that seeds and wands have.")
				UI:WaitShowDialogue("Be sure to read the orb's item description to make sure what it does!")
				SV.Tutorials.PickedUpOrb = true
			end
		end
	end
end

--Tutorial text for picking up a wand item
--Improved code by Mocha
function ITEM_SCRIPT.ItemTutorialWand(owner, ownerChar, context, args)
    if CONFIG.DoTutorials() then
		local inv_count = _DATA.Save.ActiveTeam:GetInvCount() - 1
		for i = inv_count, 0, -1 do
		local item = _DATA.Save.ActiveTeam:GetInv(i)
		local prefix = "wand_"
		UI:ResetSpeaker()
			if string.sub(item.ID, 1, #prefix) == prefix and not SV.Tutorials.PickedUpWand then
				GAME:WaitFrames(40)
			    SOUND:PlayFanfare("Fanfare/Note")
				GAME:WaitFrames(10)
				UI:WaitShowDialogue("A wand is an item that has various powerful effects and is waved at a target.")
				UI:WaitShowDialogue("Wands usually have single-target effects, similar to seeds. However, they can be useful against seed-resistant targets.")
				UI:WaitShowDialogue("Wands also can not be eaten from other Pokémon with certain moves or abilities.")
				UI:WaitShowDialogue("Be sure to read the wand's item description to make sure what it does!")
				SV.Tutorials.PickedUpWand = true
			end
		end
	end
end

--Tutorial text for picking up a status-restore berry item
function ITEM_SCRIPT.ItemTutorialStatusBerry(owner, ownerChar, context, args)
    if CONFIG.DoTutorials() then
		local inv_count = _DATA.Save.ActiveTeam:GetInvCount() - 1
		for i = inv_count, 0, -1 do
		local item = _DATA.Save.ActiveTeam:GetInv(i)
    	UI:ResetSpeaker()
			if not SV.Tutorials.PickedUpStatusBerry then
		    	if item.ID == "berry_aspear" or item.ID == "berry_cheri" or item.ID == "berry_chesto" or item.ID == "berry_eggant" or item.ID == "berry_kuo" or item.ID == "berry_lum" or item.ID == "berry_pecha" then
					GAME:WaitFrames(40)
			    	SOUND:PlayFanfare("Fanfare/Note")
					GAME:WaitFrames(10)
					UI:WaitShowDialogue("Certain berries can cure certain status effects caused by specific moves, items or tiles.")
					UI:WaitShowDialogue("Specific berries usually can restore certain status effects.")
					UI:WaitShowDialogue("Lum berries, however, cure all status effects. They are less common to find, however.")
					SV.Tutorials.PickedUpStatusBerry = true
		    	end
			end
		end
	end
end

--Code from Trio
--Changes an enemy tactic
function STATUS_SCRIPT.ChangeTacticEvent(owner, ownerChar, context, args)
	if context.Status == owner then
		if context.msg then
			local old_tactic = context.Target.Tactic.ID
			local tbl = LTBL(context.Target)
			tbl.OldTactic = old_tactic

			local tactic_name = args.Tactic
			local tactic = _DATA:GetAITactic(tactic_name)
			context.Target.Tactic = RogueEssence.Data.AITactic(tactic)
			--context.Target.Tactic:Initialize(context.Target)
		end
	end
end

--Code from Trio
--Restores original enemy tactic
function STATUS_SCRIPT.RestoreTacticEvent(owner, ownerChar, context, args)
	if context.Status == owner then
		if context.msg then
			local old_tactic = context.Target.Tactic.ID
			local tbl = LTBL(context.Target)

			local tactic_name = tbl.OldTactic
			local tactic = _DATA:GetAITactic(tactic_name)
			context.Target.Tactic = RogueEssence.Data.AITactic(tactic)
			--context.Target.Tactic:Initialize(context.Target)
		end
	end
end
















----------------------
--Halcyon scripts
----------------------
--special Halcyon script for the partner
--Script edited for this mod
function BATTLE_SCRIPT.PartnerInteract(owner, ownerChar, context, args)
	local chara = context.User
	local target = context.Target
	local action_cancel = context.CancelState
	local turn_cancel = context.TurnCancel
	
	action_cancel.Cancel = true

  if COMMON.CanTalk(target) then
    
    UI:SetSpeaker(target)

    local ratio = target.HP * 100 // target.MaxHP
    
    local mon = _DATA:GetMonster(target.BaseForm.Species)
    local form = mon.Forms[target.BaseForm.Form]
    
	--Partner has a different personality for each pool of quotes, with pools having different quotes to have additional comments on specific plotstate.
	--If no special quotes are needed because you're not doing the current story dungeon or whatever, use the default partner personality of 51.
	
    local personality = 51
	
	local dungeon = GAME:GetCurrentDungeon().Name:ToLocal()
	local segment = _ZONE.CurrentMapID.Segment
    
	local tbl = LTBL(target)
	local outlaw = nil
	local rescuee = nil
	local mission = nil
	local objective_item = nil
	local escort = tbl.EscortMissionNum
	if tbl.MissionNumber ~= nil then
		mission = SV.TakenBoard[tbl.MissionNumber]
		if tbl.MissionType == COMMON.MISSION_BOARD_MISSION then
			rescuee = COMMON.FindNpcWithTable(false, "Mission", tbl.MissionNumber)
		elseif tbl.MissionType == COMMON.MISSION_BOARD_OUTLAW then
			outlaw = COMMON.FindNpcWithTable(true, "Mission", tbl.MissionNumber)
		end
				
		if mission.Type == COMMON.MISSION_TYPE_LOST_ITEM then 
			objective_item = mission.Item
		end
	end
	PrintInfo(tostring(rescuee))
	PrintInfo(tostring(outlaw))
	PrintInfo(tostring(tbl.MissionNumber))
	PrintInfo(tostring(tbl.EscortMissionNum))
	
	
	
	if rescuee ~= nil then--comment on rescue target
		if mission.Type == COMMON.MISSION_TYPE_RESCUE then
			personality = 52
		elseif mission.Type == COMMON.MISSION_TYPE_ESCORT then
			personality = 53
		elseif mission.Type == COMMON.MISSION_TYPE_DELIVERY then
			local inv_slot = GAME:FindPlayerItem(mission.Item, false, true)
			local team_slot = GAME:FindPlayerItem(mission.Item, true, false)
			local has_item = inv_slot:IsValid() or team_slot:IsValid()
			--partner comments change depending on whether you actually have the delivery item or not
			if has_item then
				personality = 54
			else
				UI:SetSpeakerEmotion("Worried")
				personality = 55
			end
		end
	elseif outlaw ~= nil then--comment on outlaw target
		personality = 59
		UI:SetSpeakerEmotion("Determined")--this is overriden to worried/pain if hp is low enough
	elseif objective_item ~= nil and mission.Completion == COMMON.MISSION_INCOMPLETE then --comment on needing to find the item
		personality = 56
	elseif escort ~= nil and SV.TakenBoard[escort].Completion == COMMON.MISSION_INCOMPLETE then 
		if SV.TakenBoard[escort].Type == COMMON.MISSION_TYPE_ESCORT then
			personality = 57
		else
			personality = 58
		end	
	else
		--Story personalities
		if SV.ChapterProgression.Chapter == 1 and dungeon == 'Sandhill Cave' then
			personality = 60
		elseif SV.ChapterProgression.Chapter == 1 and dungeon == 'Parched Steppes' then
			personality = 61
		elseif SV.ChapterProgression.Chapter == 2 and dungeon == 'Dry Woods' then
			personality = 62
		end
	end
	PrintInfo("Personality in use: " .. tostring(personality))
    
    local personality_group = COMMON.PERSONALITY[personality]
    local pool = {}
    local key = ""
    if ratio <= 25 then
      UI:SetSpeakerEmotion("Pain")
      pool = personality_group.PINCH
      key = "TALK_PARTNER_PINCH_%04d"
    elseif ratio <= 50 then
      UI:SetSpeakerEmotion("Worried")
      pool = personality_group.HALF
      key = "TALK_PARTNER_HALF_%04d"
    else
      pool = personality_group.FULL
      key = "TALK_PARTNER_FULL_%04d"
    end
    
    local running_pool = {table.unpack(pool)}
    local valid_quote = false
    local chosen_quote = ""
    
    while not valid_quote and #running_pool > 0 do
      valid_quote = true


      local chosen_idx = math.random(1, #running_pool)
  	  local chosen_pool_idx = running_pool[chosen_idx]
	  
	  --for use with [(name)] replacing
	  local char_list = {}
	  local char_count = 0
	  
      chosen_quote = RogueEssence.StringKey(string.format(key, chosen_pool_idx)):ToLocal()

	  --[(stuff)] indicates that the item inside (in this case stuff) is a pokemon's identifer and should be fed to CharacterEssentials to get their name. THANKS NO NICKNAME ENTHUSIASTS I HATE YOU
	  --NOTE/TODO: This breaks for characters who have _ (or other special chars) in their character call name. If this situation pops up, either address it here or remove the underscore from all instances of that character call name.
	  for i in string.gmatch(chosen_quote, "%[%((%a+)%)%]") do
		char_count = char_count + 1
		char_list[char_count] = i
	  end
	  
	  for i = 1, #char_list, 1 do
		chosen_quote = string.gsub(chosen_quote, "%[%(" .. char_list[i] .. "%)%]", CharacterEssentials.GetCharacterName(char_list[i]))
	  end

  	
      chosen_quote = string.gsub(chosen_quote, "%[player%]", chara:GetDisplayName(true))
      chosen_quote = string.gsub(chosen_quote, "%[myname%]", target:GetDisplayName(true))

      if string.find(chosen_quote, "%[move%]") then
        local moves = {}
  	    for move_idx = 0, 3 do
  	      if target.BaseSkills[move_idx].SkillNum ~= "" then
  	        table.insert(moves, target.BaseSkills[move_idx].SkillNum)
  	      end
  	    end
  	    if #moves > 0 then
  	      local chosen_move = _DATA:GetSkill(moves[math.random(1, #moves)])
  	      chosen_quote = string.gsub(chosen_quote, "%[move%]", chosen_move:GetIconName())
  	    else
  	      valid_quote = false
  	    end
      end
      
      if string.find(chosen_quote, "%[kind%]") then
  	    if GAME:GetCurrentFloor().TeamSpawns.CanPick then
          local team_spawn = GAME:GetCurrentFloor().TeamSpawns:Pick(GAME.Rand)
  	      local chosen_list = team_spawn:ChooseSpawns(GAME.Rand)
  	      if chosen_list.Count > 0 then
  	        local chosen_mob = chosen_list[math.random(0, chosen_list.Count-1)]
  	        local mon = _DATA:GetMonster(chosen_mob.BaseForm.Species)
            chosen_quote = string.gsub(chosen_quote, "%[kind%]", mon:GetColoredName())
  	      else
  	        valid_quote = false
  	      end
  	    else
  	      valid_quote = false
  	    end
      end
      
      if string.find(chosen_quote, "%[item%]") then
        if GAME:GetCurrentFloor().ItemSpawns.CanPick then
          local item = GAME:GetCurrentFloor().ItemSpawns:Pick(GAME.Rand)
          chosen_quote = string.gsub(chosen_quote, "%[item%]", item:GetDisplayName())
  	    else
  	      valid_quote = false
  	    end
      end
  	
	      
      if string.find(chosen_quote, "%[mission_client%]") then
        if mission ~= nil then
          chosen_quote = string.gsub(chosen_quote, "%[mission_client%]", _DATA:GetMonster(mission.Client):GetColoredName())
		elseif escort ~= nil then 
		    chosen_quote = string.gsub(chosen_quote, "%[mission_client%]", _DATA:GetMonster(SV.TakenBoard[escort].Client):GetColoredName())
  	    else
  	      valid_quote = false
  	    end
      end
	 
	   if string.find(chosen_quote, "%[mission_target%]") then
        if mission ~= nil then
          chosen_quote = string.gsub(chosen_quote, "%[mission_target%]", _DATA:GetMonster(mission.Target):GetColoredName())
  	   	elseif escort ~= nil then 
		  chosen_quote = string.gsub(chosen_quote, "%[mission_target%]", _DATA:GetMonster(SV.TakenBoard[escort].Target):GetColoredName())
        else
  	      valid_quote = false
  	    end
      end
	  
	  
	  if string.find(chosen_quote, "%[mission_item%]") then
        if mission ~= nil then
          chosen_quote = string.gsub(chosen_quote, "%[mission_item%]", RogueEssence.Dungeon.InvItem(mission.Item):GetDisplayName())
  	    else
  	      valid_quote = false
  	    end
      end
	  
	
	
  	  if not valid_quote then
        PrintInfo("Rejected "..chosen_quote)
  	    table.remove(running_pool, chosen_idx)
  	    chosen_quote = ""
  	  end
    end
    -- PrintInfo("Selected "..chosen_quote)
	
	local oldDir = target.CharDir
    DUNGEON:CharTurnToChar(target, chara)
  
  
    UI:WaitShowDialogue(chosen_quote)
  
    target.CharDir = oldDir
  else
  
    UI:ResetSpeaker()
	
	local chosen_quote = RogueEssence.StringKey("TALK_CANT"):ToLocal()
    chosen_quote = string.gsub(chosen_quote, "%[myname%]", target:GetDisplayName(true))
	
    UI:WaitShowDialogue(chosen_quote)
  
  end
end












--special Sunpath script for the other partner
--Edited Halcyon script for the second partner
function BATTLE_SCRIPT.Partner2Interact(owner, ownerChar, context, args)
	local chara = context.User
	local target = context.Target
	local action_cancel = context.CancelState
	local turn_cancel = context.TurnCancel
	
	action_cancel.Cancel = true

  if COMMON.CanTalk(target) then
    
    UI:SetSpeaker(target)

    local ratio = target.HP * 100 // target.MaxHP
    
    local mon = _DATA:GetMonster(target.BaseForm.Species)
    local form = mon.Forms[target.BaseForm.Form]
    
	--Partner has a different personality for each pool of quotes, with pools having different quotes to have additional comments on specific plotstate.
	--If no special quotes are needed because you're not doing the current story dungeon or whatever, use the default partner personality of 51.
	
    local personality = 51
	
	local dungeon = GAME:GetCurrentDungeon().Name:ToLocal()
	local segment = _ZONE.CurrentMapID.Segment
    
	local tbl = LTBL(target)
	local outlaw = nil
	local rescuee = nil
	local mission = nil
	local objective_item = nil
	local escort = tbl.EscortMissionNum
	if tbl.MissionNumber ~= nil then
		mission = SV.TakenBoard[tbl.MissionNumber]
		if tbl.MissionType == COMMON.MISSION_BOARD_MISSION then
			rescuee = COMMON.FindNpcWithTable(false, "Mission", tbl.MissionNumber)
		elseif tbl.MissionType == COMMON.MISSION_BOARD_OUTLAW then
			outlaw = COMMON.FindNpcWithTable(true, "Mission", tbl.MissionNumber)
		end
				
		if mission.Type == COMMON.MISSION_TYPE_LOST_ITEM then 
			objective_item = mission.Item
		end
	end
	PrintInfo(tostring(rescuee))
	PrintInfo(tostring(outlaw))
	PrintInfo(tostring(tbl.MissionNumber))
	PrintInfo(tostring(tbl.EscortMissionNum))
	
	
	
	if rescuee ~= nil then--comment on rescue target
		if mission.Type == COMMON.MISSION_TYPE_RESCUE then
			personality = 52
		elseif mission.Type == COMMON.MISSION_TYPE_ESCORT then
			personality = 53
		elseif mission.Type == COMMON.MISSION_TYPE_DELIVERY then
			local inv_slot = GAME:FindPlayerItem(mission.Item, false, true)
			local team_slot = GAME:FindPlayerItem(mission.Item, true, false)
			local has_item = inv_slot:IsValid() or team_slot:IsValid()
			--partner comments change depending on whether you actually have the delivery item or not
			if has_item then
				personality = 54
			else
				UI:SetSpeakerEmotion("Worried")
				personality = 55
			end
		end
	elseif outlaw ~= nil then--comment on outlaw target
		personality = 59
		UI:SetSpeakerEmotion("Determined")--this is overriden to worried/pain if hp is low enough
	elseif objective_item ~= nil and mission.Completion == COMMON.MISSION_INCOMPLETE then --comment on needing to find the item
		personality = 56
	elseif escort ~= nil and SV.TakenBoard[escort].Completion == COMMON.MISSION_INCOMPLETE then 
		if SV.TakenBoard[escort].Type == COMMON.MISSION_TYPE_ESCORT then
			personality = 57
		else
			personality = 58
		end	
	else
		--Story personalities
		if SV.ChapterProgression.Chapter == 4 and dungeon == 'Dungeon 4' then
			if not SV.Chapter3.EncounteredBoss and segment == 0 then --dungeon, havent fought boss yet
				personality = 62
			elseif SV.Chapter3.EncounteredBoss and not SV.Chapter3.DefeatedBoss and not SV.Chapter3.FinishedRootScene and segment == 0 then --dungeon, lost to boss already
				personality = 63
			elseif SV.Chapter3.EncounteredBoss and not SV.Chapter3.DefeatedBoss and not SV.Chapter3.FinishedRootScene and segment == 1 then
				personality = 64
				UI:SetSpeakerEmotion("Determined")--this is overriden to worried/pain if hp is low enough
			end
		elseif SV.ChapterProgression.Chapter == 5 and dungeon == 'Dungeon 5' then
			if not SV.Chapter4.ReachedGlade then
				personality = 65
			elseif not SV.Chapter4.FinishedGrove then
				personality = 66
			end
		end
	end
	PrintInfo("Personality in use: " .. tostring(personality))
    
    local personality_group = COMMON.PERSONALITY[personality]
    local pool = {}
    local key = ""
    if ratio <= 25 then
      UI:SetSpeakerEmotion("Pain")
      pool = personality_group.PINCH
      key = "TALK_PINCH_%04d"
    elseif ratio <= 50 then
      UI:SetSpeakerEmotion("Worried")
      pool = personality_group.HALF
      key = "TALK_HALF_%04d"
    else
      pool = personality_group.FULL
      key = "TALK_FULL_%04d"
    end
    
    local running_pool = {table.unpack(pool)}
    local valid_quote = false
    local chosen_quote = ""
    
    while not valid_quote and #running_pool > 0 do
      valid_quote = true


      local chosen_idx = math.random(1, #running_pool)
  	  local chosen_pool_idx = running_pool[chosen_idx]
	  
	  --for use with [(name)] replacing
	  local char_list = {}
	  local char_count = 0
	  
      chosen_quote = RogueEssence.StringKey(string.format(key, chosen_pool_idx)):ToLocal()

	  --[(stuff)] indicates that the item inside (in this case stuff) is a pokemon's identifer and should be fed to CharacterEssentials to get their name. THANKS NO NICKNAME ENTHUSIASTS I HATE YOU
	  --NOTE/TODO: This breaks for characters who have _ (or other special chars) in their character call name. If this situation pops up, either address it here or remove the underscore from all instances of that character call name.
	  for i in string.gmatch(chosen_quote, "%[%((%a+)%)%]") do
		char_count = char_count + 1
		char_list[char_count] = i
	  end
	  
	  for i = 1, #char_list, 1 do
		chosen_quote = string.gsub(chosen_quote, "%[%(" .. char_list[i] .. "%)%]", CharacterEssentials.GetCharacterName(char_list[i]))
	  end

  	
      chosen_quote = string.gsub(chosen_quote, "%[player%]", chara:GetDisplayName(true))
      chosen_quote = string.gsub(chosen_quote, "%[myname%]", target:GetDisplayName(true))

      if string.find(chosen_quote, "%[move%]") then
        local moves = {}
  	    for move_idx = 0, 3 do
  	      if target.BaseSkills[move_idx].SkillNum ~= "" then
  	        table.insert(moves, target.BaseSkills[move_idx].SkillNum)
  	      end
  	    end
  	    if #moves > 0 then
  	      local chosen_move = _DATA:GetSkill(moves[math.random(1, #moves)])
  	      chosen_quote = string.gsub(chosen_quote, "%[move%]", chosen_move:GetIconName())
  	    else
  	      valid_quote = false
  	    end
      end
      
      if string.find(chosen_quote, "%[kind%]") then
  	    if GAME:GetCurrentFloor().TeamSpawns.CanPick then
          local team_spawn = GAME:GetCurrentFloor().TeamSpawns:Pick(GAME.Rand)
  	      local chosen_list = team_spawn:ChooseSpawns(GAME.Rand)
  	      if chosen_list.Count > 0 then
  	        local chosen_mob = chosen_list[math.random(0, chosen_list.Count-1)]
  	        local mon = _DATA:GetMonster(chosen_mob.BaseForm.Species)
            chosen_quote = string.gsub(chosen_quote, "%[kind%]", mon:GetColoredName())
  	      else
  	        valid_quote = false
  	      end
  	    else
  	      valid_quote = false
  	    end
      end
      
      if string.find(chosen_quote, "%[item%]") then
        if GAME:GetCurrentFloor().ItemSpawns.CanPick then
          local item = GAME:GetCurrentFloor().ItemSpawns:Pick(GAME.Rand)
          chosen_quote = string.gsub(chosen_quote, "%[item%]", item:GetDisplayName())
  	    else
  	      valid_quote = false
  	    end
      end
  	
	      
      if string.find(chosen_quote, "%[mission_client%]") then
        if mission ~= nil then
          chosen_quote = string.gsub(chosen_quote, "%[mission_client%]", _DATA:GetMonster(mission.Client):GetColoredName())
		elseif escort ~= nil then 
		    chosen_quote = string.gsub(chosen_quote, "%[mission_client%]", _DATA:GetMonster(SV.TakenBoard[escort].Client):GetColoredName())
  	    else
  	      valid_quote = false
  	    end
      end
	 
	   if string.find(chosen_quote, "%[mission_target%]") then
        if mission ~= nil then
          chosen_quote = string.gsub(chosen_quote, "%[mission_target%]", _DATA:GetMonster(mission.Target):GetColoredName())
  	   	elseif escort ~= nil then 
		  chosen_quote = string.gsub(chosen_quote, "%[mission_target%]", _DATA:GetMonster(SV.TakenBoard[escort].Target):GetColoredName())
        else
  	      valid_quote = false
  	    end
      end
	  
	  
	  if string.find(chosen_quote, "%[mission_item%]") then
        if mission ~= nil then
          chosen_quote = string.gsub(chosen_quote, "%[mission_item%]", RogueEssence.Dungeon.InvItem(mission.Item):GetDisplayName())
  	    else
  	      valid_quote = false
  	    end
      end
	  
	
	
  	  if not valid_quote then
        PrintInfo("Rejected "..chosen_quote)
  	    table.remove(running_pool, chosen_idx)
  	    chosen_quote = ""
  	  end
    end
    -- PrintInfo("Selected "..chosen_quote)
	
	local oldDir = target.CharDir
    DUNGEON:CharTurnToChar(target, chara)
  
  
    UI:WaitShowDialogue(chosen_quote)
  
    target.CharDir = oldDir
  else
  
    UI:ResetSpeaker()
	
	local chosen_quote = RogueEssence.StringKey("TALK_CANT"):ToLocal()
    chosen_quote = string.gsub(chosen_quote, "%[myname%]", target:GetDisplayName(true))
	
    UI:WaitShowDialogue(chosen_quote)
  
  end
end










--special Halcyon interact script for the hero
--very simplified version of partner script, only dialogue possible is "(.........)"
--Script obviously modified for this mod
function BATTLE_SCRIPT.HeroInteract(owner, ownerChar, context, args)
	local chara = context.User
	local target = context.Target
	local action_cancel = context.CancelState
	local turn_cancel = context.TurnCancel
	 
    UI:SetSpeaker(target)

	action_cancel.Cancel = true
  -- TODO: create a charstate for being unable to talk and have talk-interfering statuses cause it
  if target:GetStatusEffect("sleep") == nil and target:GetStatusEffect("freeze") == nil then
    
    local ratio = target.HP * 100 // target.MaxHP 

    if ratio <= 25 then
      UI:SetSpeakerEmotion("Pain")
    elseif ratio <= 50 then
      UI:SetSpeakerEmotion("Worried")
    else
	  UI:SetSpeakerEmotion("Normal")
    end

    local chosen_quote = ""
    
   
	
	local oldDir = target.CharDir
    DUNGEON:CharTurnToChar(target, chara)
  
	chosen_quote = '(.........)'
  
    UI:WaitShowDialogue(chosen_quote)
  
    target.CharDir = oldDir
  else
  
    UI:ResetSpeaker()
	
	local chosen_quote = RogueEssence.StringKey("TALK_CANT"):ToLocal()
    chosen_quote = string.gsub(chosen_quote, "%[myname%]", target:GetDisplayName(true))
	
    UI:WaitShowDialogue(chosen_quote)
  
  end
end

----------------------
--Nebula's Mission Board scripts
----------------------

local base_game_escort_interact = BATTLE_SCRIPT.EscortInteract
function BATTLE_SCRIPT.EscortInteract(owner, ownerChar, context, args)
    if (context.Target.LuaData.JobReference) then
        MissionGen:EscortInteract(owner, ownerChar, context, args)
    else
        base_game_escort_interact(owner, ownerChar, context, args)
    end
end

function BATTLE_SCRIPT.EscortReached(owner, ownerChar, context, args)
    MissionGen:EscortReached(owner, ownerChar, context, args)
end

function BATTLE_SCRIPT.RescueReached(owner, ownerChar, context, args)
    MissionGen:RescueReached(owner, ownerChar, context, args)
end

----------------------
--Deprecated scripts
----------------------

--Test battle event script.
--[[function BATTLE_SCRIPT.EndureStateEvent(owner, ownerChar, context, args)

	EndureStateType = luanet.import_type('PMDC.Dungeon.AttackEndure')
	local endure = context.ContextStates:Contains(luanet.ctype(EndureStateType))

end]]

--Test battle event script.
--[[function BATTLE_SCRIPT.DropEvent(owner, ownerChar, context, args)

	local dropEvent = PMDC.Dungeon.DropItemEvent()
	dropEvent:Apply(owner, ownerChar, context)

end]]

--Feature where a player restores HP and cures statuses whenever a Prosper Ribbon is held and Poke is picked up.
--Older version of current ProsperEvent, only here for future reference.
--[[function ITEM_SCRIPT.ProsperEventTest(owner, ownerChar, context, args)

	local prosperheal = math.max(1, context.User.MaxHP / 10)
	local emitter = RogueEssence.Content.RepeatEmitter()
	local emitterAnim = RogueEssence.Content.AnimData("Stat_White_Ring", 3, 0, 0, 255, Dir8.Up)
	emitter.Anims:Add(RogueEssence.Content.EmittingAnim(emitterAnim, X, DrawLayer.Bottom, 1, 3))
	emitter.LocHeight = -6
	emitter.Bursts = 4
	emitter.BrustTime = 9
	emitter.Layer = DrawLayer.Bottom
	local emitter2 = RogueEssence.Content.FiniteSprinkleEmitter()
	local emitter2Anim = RogueEssence.Content.AnimData("Event_Gather_Sparkle", 8, 0, 0, 255, Dir8.Up) 
	emitter2.Anims:Add(RogueEssence.Content.ParticleAnim(emitter2Anim, 1, 8))
	emitter2.TotalParticles = 8
	emitter2.Range = 18
	emitter2.Speed = 36
	emitter2.SpeedDiff = 12
	emitter2.StartHeight = 4
	emitter2.Layer = DrawLayer.Normal
	if context.Item.IsMoney then
		SOUND:PlayBattleSE("DUN_Heal")
		DUNGEON:PlayVFX(emitter, context.User.MapLoc.X, context.User.MapLoc.Y)
		DUNGEON:PlayVFX(emitter2, context.User.MapLoc.X, context.User.MapLoc.Y)
		TASK:WaitTask(context.User:RestoreHP(prosperheal, false))
		if context.User:GetStatusEffect("poison") ~= nil then
			TASK:WaitTask(context.User:RemoveStatusEffect("poison"))
		elseif context.User:GetStatusEffect("poison_toxic") ~= nil then
			TASK:WaitTask(context.User:RemoveStatusEffect("poison_toxic"))
		elseif context.User:GetStatusEffect("burn") ~= nil then
			TASK:WaitTask(context.User:RemoveStatusEffect("burn"))
		elseif context.User:GetStatusEffect("confuse") ~= nil then
			TASK:WaitTask(context.User:RemoveStatusEffect("confuse"))
		elseif context.User:GetStatusEffect("paralyze") ~= nil then
			TASK:WaitTask(context.User:RemoveStatusEffect("paralyze"))
		elseif context.User:GetStatusEffect("frostbite") ~= nil then
			TASK:WaitTask(context.User:RemoveStatusEffect("frostbite"))
		elseif context.User:GetStatusEffect("perish_song") ~= nil then
			TASK:WaitTask(context.User:RemoveStatusEffect("perish_song"))
		elseif context.User:GetStatusEffect("in_love") ~= nil then
			TASK:WaitTask(context.User:RemoveStatusEffect("in_love"))
		elseif context.User:GetStatusEffect("petrify") ~= nil then
			TASK:WaitTask(context.User:RemoveStatusEffect("petrify"))
		end
	end

end]]




