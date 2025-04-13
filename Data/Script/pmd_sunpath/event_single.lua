require 'origin.common'
require 'origin.event_battle'

--custom Halcyon/Sunpath SINGLE_CHAR_SCRIPT scripts

--Check to make sure the partner or hero is not dead, or anyone else marked as "IsPartner"
--checks guests as well
--if one is dead, then cause an instant game over
--if someone died and they aren't "IsPartner", then send them home automatically.
function SINGLE_CHAR_SCRIPT.AllyDeathCheck(owner, ownerChar, context, args)
	local player_count = GAME:GetPlayerPartyCount()
	local guest_count = GAME:GetPlayerGuestCount()
	if player_count < 1 then return end--If there's no party members then we dont need to do anything
	for i = 0, player_count - 1, 1 do 
		local player = GAME:GetPlayerPartyMember(i)
		if player.Dead and player.IsPartner then --someone died 
			for j = 0, player_count - 1, 1 do --beam everyone else out
				player = GAME:GetPlayerPartyMember(j)
				if not player.Dead then--dont beam out whoever died
					--delay between beam outs
					GAME:WaitFrames(60)
					TASK:WaitTask(_DUNGEON:ProcessBattleFX(player, player, _DATA.SendHomeFX))
					player.Dead = true
				end
			end
			--beam out guests
			for j = 0, guest_count - 1, 1 do --beam everyone else out
				guest = GAME:GetPlayerGuestMember(j)
				if not guest.Dead then--dont beam out whoever died
					--delay between beam outs
					GAME:WaitFrames(60)
					TASK:WaitTask(_DUNGEON:ProcessBattleFX(guest, guest, _DATA.SendHomeFX))
					guest.Dead = true
				end
			end
			--TASK:WaitTask(_GAME:EndSegment(RogueEssence.Data.GameProgress.ResultType.Failed))
			return--cut the script short here if someone died, no need to check guests
		elseif player.Dead and not player.IsPartner then 
			--Send them back to the assembly and boot them from the current team if they died and aren't important.
			TASK:WaitTask(_DUNGEON:SilentSendHome(i))
		end
	end
	
	--check guests as well
	if guest_count < 1 then return end--If there's no guest members then we dont need to do anything
	for i = 0, guest_count - 1, 1 do 
		local guest = GAME:GetPlayerGuestMember(i)
		if guest.Dead and guest.IsPartner then --someone died 
			--beam player's team out first
			for j = 0, player_count - 1, 1 do --beam everyone else out
				player = GAME:GetPlayerPartyMember(j)
				if not player.Dead then--dont beam out whoever died
					TASK:WaitTask(_DUNGEON:ProcessBattleFX(player, player, _DATA.SendHomeFX))
					player.Dead = true
					GAME:WaitFrames(60)
				end
			end
			for j = 0, guest_count - 1, 1 do --beam everyone else out
				guest = GAME:GetPlayerGuestMember(j)
				if not guest.Dead then--dont beam out whoever died
					TASK:WaitTask(_DUNGEON:ProcessBattleFX(guest, guest, _DATA.SendHomeFX))
					guest.Dead = true
					GAME:WaitFrames(60)
				end
			end
			--TASK:WaitTask(_GAME:EndSegment(RogueEssence.Data.GameProgress.ResultType.Failed))
		end
	end
			
end

--sets critical health status if teammate's health is low. This just adds a cosmetic Exclamation point over their head.
function SINGLE_CHAR_SCRIPT.SetCriticalHealthStatus(owner, ownerChar, context, args)
	local player_count = GAME:GetPlayerPartyCount()
	local critical = RogueEssence.Dungeon.StatusEffect("critical_health")
	for i = 0, player_count - 1, 1 do 
	local player = GAME:GetPlayerPartyMember(i)
		if player.HP <= player.MaxHP / 4 and player:GetStatusEffect("critical_health") == nil then 
			TASK:WaitTask(player:AddStatusEffect(nil, critical, false))
			--print("Set crit health!")
		elseif player.HP > player.MaxHP / 4 and player:GetStatusEffect("critical_health") ~= nil then
			TASK:WaitTask(player:RemoveStatusEffect("critical_health"))
			--print("Remove crit health!")
		end
	end
end

--sets critical health status if teammate's 2nd partner's health is low. This just adds a cosmetic Exclamation point over their head.
function SINGLE_CHAR_SCRIPT.SetCriticalHealthStatus(owner, ownerChar, context, args)
	local player_count = GAME:GetPlayerPartyCount()
	local critical = RogueEssence.Dungeon.StatusEffect("critical_health")
	for i = 0, player_count - 2, 1 do 
	local player = GAME:GetPlayerPartyMember(i)
		if player.HP <= player.MaxHP / 4 and player:GetStatusEffect("critical_health") == nil then 
			TASK:WaitTask(player:AddStatusEffect(nil, critical, false))
			--print("Set crit health!")
		elseif player.HP > player.MaxHP / 4 and player:GetStatusEffect("critical_health") ~= nil then
			TASK:WaitTask(player:RemoveStatusEffect("critical_health"))
			--print("Remove crit health!")
		end
	end
end




--Halcyon/Sunpath dungeon scripts

function SINGLE_CHAR_SCRIPT.CheckOngoingMissions(owner, ownerChar, context, args)
	local curr_zone = _ZONE.CurrentZoneID
	local curr_segment = _ZONE.CurrentMapID.Segment
	local curr_floor = GAME:GetCurrentFloor().ID + 1
	for _, mission in ipairs(SV.TakenBoard) do
		if mission.BackReference ~= COMMON.FLEE_BACKREFERENCE and mission.Taken and mission.Completion == COMMON.MISSION_INCOMPLETE and curr_floor == mission.Floor and curr_zone == mission.Zone and curr_segment == mission.Segment then
			UI:ResetSpeaker()
			UI:ChoiceMenuYesNo("You currently have an ongoing mission on this floor.\nDo you still want to proceed?", true)
			UI:WaitForChoice()
			local continue = UI:ChoiceResult()
			if not continue then
				context.CancelState.Cancel = true
				context.TurnCancel.Cancel = true
				break
			end
		end
	end
end

function SINGLE_CHAR_SCRIPT.DustyDuneFlipStairs(owner, ownerChar, context, args)
	if context.User == _DUNGEON.ActiveTeam.Leader then
		local map = _ZONE.CurrentMap
		for xx = 0, map.Width - 1, 1 do
			for yy = 0, map.Height - 1, 1 do
				local loc = RogueElements.Loc(xx, yy)
				local tl = map:GetTile(loc)
				local sec_loc = RogueEssence.Dungeon.SegLoc(0, -1)
				local dest_state = PMDC.Dungeon.DestState(sec_loc, true)
				dest_state.PreserveMusic = true
				if tl.Effect.ID == "stairs_go_up" then
					tl.Effect.TileStates:Set(dest_state)
					tl.Effect.ID = "stairs_back_down"
				end
			end
		end
	end
end


--Halcyon/Sunpath script
--Popups with information on how to play the game in Dusty Dune's first pass-throughs
function SINGLE_CHAR_SCRIPT.DustyDuneTutorial(owner, ownerChar, context, args)
    --note: each floor has a few messages as the player progresses throughout the first dungeon.
    UI:ResetSpeaker()
    if args.Floor == 5 then
		if SV.Chapter1.TutorialProgression < 1 then
			SOUND:PlayFanfare("Fanfare/Note")
			UI:WaitShowDialogue("Go for the stairs![pause=0] While doing so, you can attack enemies by pressing " .. STRINGS:LocalKeyString(2) .. ". Enemies don't attack or move until you do so first.")
			UI:WaitShowDialogue("Also, press " .. STRINGS:LocalKeyString(0) .. " to confirm selections or press " .. STRINGS:LocalKeyString(1) .. " to cancel.")
			UI:WaitShowDialogue("Moves also have varying effects; To use moves, hold " .. STRINGS:LocalKeyString(4) .. ", then press " .. STRINGS:LocalKeyString(21) .. ", " .. STRINGS:LocalKeyString(22) .. ", " .. STRINGS:LocalKeyString(23) .. ", or " .. STRINGS:LocalKeyString(24) .. " to use the selected move.")
			UI:WaitShowDialogue("You can also press " .. STRINGS:LocalKeyString(9) .. " and choose the Moves option or press " .. STRINGS:LocalKeyString(11) .. " to access the Moves menu too.")
			SV.Chapter1.TutorialProgression = 1
			GAME:WaitFrames(20)
		end 		
    elseif args.Floor == 4 then
	  	if SV.Chapter1.TutorialProgression < 2 then
			SOUND:PlayFanfare("Fanfare/Note")
			UI:WaitShowDialogue("You can carry a number of items; Items that you find have a number of various uses and effects.")
			UI:WaitShowDialogue("To see what items you are carrying, press " .. STRINGS:LocalKeyString(9) .. " and select the Items menu. You can also use this to see what an item does.")
			UI:WaitShowDialogue("You can also press " .. STRINGS:LocalKeyString(12) .. " to access the item menu faster.") 
			SV.Chapter1.TutorialProgression = 2
			GAME:WaitFrames(20)
		end 
    elseif args.Floor == 3 then
		if SV.Chapter1.TutorialProgression < 3 then
			SOUND:PlayFanfare("Fanfare/Note")
			UI:WaitShowDialogue("Sometimes, you may come across a black tile with a green arrow. This is called a Wonder Tile.")
			UI:WaitShowDialogue("Step on one to heal or reset any stat changes of yourself and anyone near you.")
			UI:WaitShowDialogue("Also, if you want to change settings such as window size, battle speed, or controls, press " .. STRINGS:LocalKeyString(9) .. " and check the Others menu.")
			UI:WaitShowDialogue("You can view a history of recent actions by pressing " .. STRINGS:LocalKeyString(10) .. "as well.")
			SV.Chapter1.TutorialProgression = 3
			GAME:WaitFrames(20)
		end 
    elseif args.Floor == 2 then
	  	if SV.Chapter1.TutorialProgression < 4 then
			SOUND:PlayFanfare("Fanfare/Note")
			UI:WaitShowDialogue("You can change minimap modes using " .. STRINGS:LocalKeyString(8) .. ", and view the status of your team using " .. STRINGS:LocalKeyString(14) .. ".")
			UI:WaitShowDialogue("You can also hold " .. STRINGS:LocalKeyString(3) .. " to run! This doesn't allow you to travel more distance in a single turn, but it does help you navigate faster.")
			UI:WaitShowDialogue("Additionally, holding " .. STRINGS:LocalKeyString(5) .. " and pressing a direction also allows you to look that way without moving or using up a turn.")
			UI:WaitShowDialogue("Lastly, you can hold " .. STRINGS:LocalKeyString(6) .. " to only allow movement in a diagonal direction.")
			SV.Chapter1.TutorialProgression = 4
			GAME:WaitFrames(20)
		end
    elseif args.Floor == 1 then
		if SV.Chapter1.TutorialProgression < 5 then
			SOUND:PlayFanfare("Fanfare/Note")
			UI:WaitShowDialogue("Keep watch of your HP at the top of the screen. If a Pokémon's HP reaches 0, it will faint!")
			UI:WaitShowDialogue("If you faint, you will be ejected from the dungeon. So be careful so that this doesn't happen.")
			UI:WaitShowDialogue("On the topic of which, if you get hungry, eat a food item such as an apple or yucca fruit. If your Belly runs empty, you will slowly lose health until you faint or eat something.")
			UI:WaitShowDialogue("Also, to earn Exp. Points, a Pokémon must use at least one move against an enemy rather than just its basic " .. STRINGS:LocalKeyString(2) .. " attack.")
			UI:WaitShowDialogue("Team members will receive Exp. Points when enemies are defeated. When a teammate gets enough Exp., they will level up.")
			UI:WaitShowDialogue("When a Pokémon levels up, they will get more HP, higher stats, and possibly even a new move.")
			SV.Chapter1.TutorialProgression = 5
			GAME:WaitFrames(20)
		end
    end
end


