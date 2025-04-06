require 'origin.common'
require 'pmd_sunpath.CharacterEssentials'

--Test battle event script.
function BATTLE_SCRIPT.EndureStateEvent(owner, ownerChar, context, args)

  EndureStateType = luanet.import_type('PMDC.Dungeon.AttackEndure')
  local endure = context.ContextStates:Contains(luanet.ctype(EndureStateType))

end

--Test battle event script.
function BATTLE_SCRIPT.DropEvent(owner, ownerChar, context, args)

  local dropEvent = PMDC.Dungeon.DropItemEvent()
  dropEvent:Apply(owner, ownerChar, context)

end

--Makes it so that a Focus Sash is dropped when an attack is endured.
function BATTLE_SCRIPT.EndureDropEvent(owner, ownerChar, context, args)

  EndureStateType = luanet.import_type('PMDC.Dungeon.AttackEndure')
  local item = RogueEssence.Dungeon.InvItem("held_focus_sash")
  if context.ContextStates:Contains(luanet.ctype(EndureStateType)) and context.Target.HP == 1 then
  TASK:WaitTask(context.Target:DequipItem())
    local endLoc = _DUNGEON:MoveShotUntilBlocked(context.User, context.Target.CharLoc, context.User.CharDir, 2, RogueEssence.Dungeon.Alignment.None, false, false)
    TASK:WaitTask(_DUNGEON:DropItem(item, endLoc, context.Target.CharLoc))
  end

end

--A system that adds a chance-based system to endure an attack if an item or move has the battle event script. 1 is ignored in this case, so 2-5 would produce a 25% chance to endure an attack.
function BATTLE_SCRIPT.EndureChanceEvent(owner, ownerChar, context, args)

  local endurechance = _DATA.Save.Rand:Next(1,5)
  if endurechance == 1 then
    context.ContextStates:Set(PMDC.Dungeon.AttackEndure())
  end

end

--Test script that displays a message via Battle Script Event.
function BATTLE_SCRIPT.Test2(owner, ownerChar, context, args)

  print("Running Script")

end












--special Halcyon script for the partner
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
		if SV.ChapterProgression.Chapter == 1 and dungeon == 'Relic Forest' then
			personality = 60
		elseif SV.ChapterProgression.Chapter == 2 and dungeon == 'Illuminant Riverbed' then
			personality = 61
		elseif SV.ChapterProgression.Chapter == 3 and dungeon == 'Crooked Cavern' then
			if not SV.Chapter3.EncounteredBoss and segment == 0 then --dungeon, havent fought boss yet
				personality = 62
			elseif SV.Chapter3.EncounteredBoss and not SV.Chapter3.DefeatedBoss and not SV.Chapter3.FinishedRootScene and segment == 0 then --dungeon, lost to boss already
				personality = 63
			elseif SV.Chapter3.EncounteredBoss and not SV.Chapter3.DefeatedBoss and not SV.Chapter3.FinishedRootScene and segment == 1 then
				personality = 64
				UI:SetSpeakerEmotion("Determined")--this is overriden to worried/pain if hp is low enough
			end
		elseif SV.ChapterProgression.Chapter == 4 and dungeon == 'Apricorn Grove' then
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

--custom Halcyon script for Ledian, the dojomaster/sensei, for use during dojo lessons (tutorials)
function BATTLE_SCRIPT.SenseiInteract(owner, ownerChar, context, args)
	local chara = context.User--player 
	local target = context.Target--ledian
	UI:SetSpeaker(target)
	
	context.CancelState.Cancel = false
	context.TurnCancel.Cancel = true

	local olddir = target.CharDir
	DUNGEON:CharTurnToChar(target, chara)
	UI:BeginChoiceMenu("Do you need something,[pause=10] my student?", {"Help", "Reset floor", "Nothing"}, 3, 3)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()
	if result == 1 then 
		args.Speech = SV.Tutorial.Progression
		SV.Tutorial.Progression = -1 --temporarily clear progression flag so speech can happen. -1 to prevent pausing before script trigger
		BeginnerLessonSpeechHelper(owner, ownerChar, target, args)
	elseif result == 2 then
		UI:WaitShowDialogue("Wahtah![pause=0] Very well![pause=0] Allow me to reset this floor!")
		GAME:WaitFrames(20)
		UI:SetSpeakerEmotion("Determined")
		UI:WaitShowDialogue(".........")
		GAME:WaitFrames(20)
		UI:SetSpeakerEmotion("Shouting")
		--setup flashes
		local emitter = RogueEssence.Content.FlashEmitter()
		emitter.FadeInTime = 2
		emitter.HoldTime = 4
		emitter.FadeOutTime = 2
		emitter.StartColor = Color(0, 0, 0, 0)
		emitter.Layer = DrawLayer.Top
		emitter.Anim = RogueEssence.Content.BGAnimData("White", 0)
		--setup hop animation
		local action = RogueEssence.Dungeon.CharAnimAction()
		action.BaseFrameType = 43 --hop
		action.AnimLoc = target.CharLoc
		action.CharDir = target.CharDir
		TASK:WaitTask(target:StartAnim(action))
		
		DUNGEON:PlayVFX(emitter, target.MapLoc.X, target.MapLoc.Y)
	    SOUND:PlayBattleSE("EVT_Battle_Flash")
	    GAME:WaitFrames(15)
	    DUNGEON:PlayVFX(emitter, target.MapLoc.X, target.MapLoc.Y)
	    SOUND:PlayBattleSE("EVT_Battle_Flash")
		UI:WaitShowTimedDialogue("HWACHA!", 40)		
		--Reset floor
		local resetEvent = PMDC.Dungeon.ResetFloorEvent()
		local charaContext = RogueEssence.Dungeon.SingleCharContext(chara)
		TASK:WaitTask(resetEvent:Apply(owner, ownerChar, charaContext))
	else 
		UI:WaitShowDialogue("Hoiyah![pause=0] Onwards with the lesson then!")
	end
end




