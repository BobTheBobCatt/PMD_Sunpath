require 'pmd_sunpath.common'
GeneralFunctions = {}

--[[These are functions/procedures that are useful in a multitude of different maps or situations. Things such as
reseting daily flags, a function to have the pokemon look in a random number of randections, etc.

List of custom variables attached to pokemon:
Importance: used mainly to mark the Hero and the Partner. is equal to 'Hero' if hero and 'Partner' if partner.
nil otherwise, but may be used in future to flag other party members/npcs as being important in someway.

AddBack: Marks the character to be added back when the party is reset,value is the slot to add them back at.
If it's nil then don't add them back. Set it to nil after adding them back
]]--

--------------------------
--Halcyon scripts
--------------------------

function GeneralFunctions.UpdateDailyFlags()
	SV.DailyFlags = 
	{
	  RedMerchantItem = "",
	  RedMerchantBought = false,
	  GreenMerchantItem = "",
	  GreenMerchantBought = false,
	  
	  GreenKecleonRefreshedStock = false,
	  GreenKecleonStock = {},
	  PurpleKecleonRefreshedStock = false,
	  PurpleKecleonStock = {}
	}
	
	--reset cafe special
    --[[SV.metano_cafe.CafeSpecial = ""
	SV.metano_cafe.BoughtSpecial = false
	
	--finish fermenting any pending items if there are any
	if SV.metano_cafe.FermentedItem ~= "" then 
		SV.metano_cafe.ItemFinishedFermenting = true
	end]]
	
	--Reset amount of times audino was summoned on that day 
	SV.TemporaryFlags.AudinoSummonCount = 0
	
	--Generate jobs
	MISSION_GEN.ResetBoards()
	MISSION_GEN.RemoveMissionBackReference()
	MISSION_GEN.GenerateBoard(COMMON.MISSION_BOARD_MISSION)
	MISSION_GEN.GenerateBoard(COMMON.MISSION_BOARD_OUTLAW)
	MISSION_GEN.SortMission()
	MISSION_GEN.SortOutlaw()
end 

--to be called at the end of the day. A generic function for generic days (i.e. no cutscene) 
function GeneralFunctions.EndOfDay()
	SV.ChapterProgression.DaysPassed = SV.ChapterProgression.DaysPassed + 1
	GeneralFunctions.UpdateDailyFlags()

end

--this places Common.EndDungeonDay
function GeneralFunctions.EndDungeonRun(result, zone, structure, mapid, entryid, display, fanfare)
	--todo: more sophisticated logic once more stuff is figured out
	--outcome can be things like wipe, success, completed a mission, etc
	DEBUG.EnableDbgCoro() --Enable debugging this coroutine
	
	GAME:EndDungeonRun(result, zone, structure, mapid, entryid, display, fanfare)
	GAME:WaitFrames(20)
	GAME:EnterZone(zone, structure, mapid, entryid)

	--GAME:EnterGroundMap("guild_heros_room", "Main_Entrance_Marker")
end

--given the line to travel between two points, how many frames must the camera move for to get the desired speed?
--2 is standard walking speed... This will mostly be useful for diagonal lines
--will round the result up, so for consistency try to keep the answer as a whole number...
function GeneralFunctions.CalculateCameraFrames(startX, startY, endX, endY, speed)
	local distX = startX - endX
	local distY = startY - endY
	
	local distance = math.sqrt((distX * distX) + (distY * distY))
	
	return math.floor(distance / speed)
	
end 





--randomly returns true or false
function GeneralFunctions.RandBool()
	return math.random(0, 1) == 0
end

--assigns a number value to each direction, useful for figuring out how many turn a direction is from another
function GeneralFunctions.DirToNum(dir)
	--up is 0, upright is 1, ... up left is 7
	local num = -1
	if dir == Direction.Up then
		num = 0
	elseif dir == Direction.UpRight then
		num = 1
	elseif dir == Direction.Right then
		num = 2
	elseif dir == Direction.DownRight then
		num = 3
	elseif dir == Direction.Down then
		num = 4
	elseif dir == Direction.DownLeft then
		num = 5
	elseif dir == Direction.Left then
		num = 6
	elseif dir == Direction.UpLeft then
		num = 7
	end
	
	return num
	
end

function GeneralFunctions.GenderToNum(gender)
	local res = -1
	if gender == Gender.Genderless then
		res = 0
	elseif gender == Gender.Male then
		res = 1
	elseif gender == Gender.Female then
		res = 2
	end
	return res
end

function GeneralFunctions.NumToGender(num)
	local res = Gender.Unknown
	if num == 0 then
		res = Gender.Genderless
	elseif num == 1 then
		res = Gender.Male
	elseif num == 2 then
		res = Gender.Female
	end
	return res
end

--converts a number to a direction
function GeneralFunctions.NumToDir(num)
	local dir = Direction.None
	if num % 8 == 0 then 
		dir = Direction.Up
	elseif num % 8 == 1 then
		dir = Direction.UpRight
	elseif num % 8 == 2 then
		dir = Direction.Right
	elseif num % 8 == 3 then
		dir = Direction.DownRight
	elseif num % 8 == 4 then
		dir = Direction.Down
	elseif num % 8 == 5 then
		dir = Direction.DownLeft
	elseif num % 8 == 6 then
		dir = Direction.Left
	elseif num % 8 == 7 then
		dir = Direction.UpLeft
	end

	return dir
end

	
--easy speed control on camera movements
function GeneralFunctions.MoveCamera(x, y, speed)
	if speed == nil then speed = 2 end
	
	local cameraFrames = GeneralFunctions.CalculateCameraFrames(GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, x, y, speed)
	GAME:MoveCamera(x, y, cameraFrames, false)
end

--centers the camera on the given characters. Moves at a rate of speed.
--give no speed for instant speed 
function GeneralFunctions.CenterCamera(charList, startX, startY, speed)
	local totalX = 0
	local totalY = 0
	local length = 0
	local frameDur = 0
	DEBUG.EnableDbgCoro()

	for key, value in pairs(charList) do
		totalX = totalX + value.Position.X + 8--offset char's pos by 8 to get camera on their center
		totalY = totalY + value.Position.Y + 8
		length = length + 1
		--print(value:GetDisplayName() .. "'s position: " .. value.Position.X .. " " .. value.Position.Y)
	end
	
	local avgX = math.floor(totalX / length)
	local avgY = math.floor(totalY / length)
	
	if speed == nil or startX == nil or startY == nil then
		frameDur = 1
	else
		frameDur = GeneralFunctions.CalculateCameraFrames(startX, startY, avgX, avgY, speed)
	end
	
	--print('CenterCamera: X = ' .. avgX .. '    Y = ' .. avgY)
	GAME:MoveCamera(avgX, avgY, frameDur, false)
	
end

--pan the camera back towards the target location, horizontally first then vertically
--give no parameters to center on player
function GeneralFunctions.PanCamera(startX, startY, toPlayer, speed, endX, endY)
	endX = endX or CH('PLAYER').Position.X + 8
	endY = endY or CH('PLAYER').Position.Y + 8
	speed = speed or 1
	startX = startX or GAME:GetCameraCenter().X
	startY = startY or GAME:GetCameraCenter().Y
	toPlayer = toPlayer or true
	local difference = 0
	local duration = 0
	
	if endX ~= startX then
		difference = math.abs(endX - startX)
		duration = math.ceil(difference / speed)
		GAME:MoveCamera(endX, startY, duration, false)
	end
	
	if endY ~= startY then
		difference = math.abs(endY - startY)
		duration = math.ceil(difference / speed)
		GAME:MoveCamera(endX, endY, duration, false)
	end
	
	if toPlayer then GAME:MoveCamera(0, 0, 1, true) end
	
	
end

--Edited Halcyon script for Sunpath
--Notes are from Halcyon:
--set party to Hero as 1st, partner as 2nd member, second partner as 3rd member. 
--Just those two if others is false, allow other party members to remain in 4th slot if false
--if spawn is true run spawners for teammates 1 and teammate 2 (through 3 if applicable)
--this is somewhat shoddily written, i feel like it will break with the right conditions...
function GeneralFunctions.DefaultParty(spawn, others, in_dungeon)
	--Clear party 
	local partyCount = GAME:GetPlayerPartyCount()
	local p = 0
	local tbl = 0
	others = others or false
	in_dungeon = in_dungeon or false
	
	--this depends on partner and hero not being able to be shifted out of slot 1 and 2... keep in mind
    for i = partyCount,1,-1 do
      p = GAME:GetPlayerPartyMember(i-1)
	  GAME:RemovePlayerTeam(i-1)
	  GAME:AddPlayerAssembly(p)
	  tbl = LTBL(p)
	  if tbl.Importance ~= 'Hero' and tbl.Importance ~= 'Partner' and tbl.Important ~= 'Partner2' and others then
		tbl.AddBack = i
	  end
	end
    
	--set party (player then partner)
	local assemblyCount = GAME:GetPlayerAssemblyCount()
	local found = 1 --start at 1 due to indexing
	local bufferTable = {'dummy', 'dummy', 'dummy', 'dummy'}
	
	for i = 1, assemblyCount, 1 do
		p = GAME:GetPlayerAssemblyMember(i - found)
		tbl = LTBL(p)
		--print(tbl.Importance)
		--print(p.Nickname)
		if tbl.Importance == 'Hero' then --hero goes in slot 1
			GAME:RemovePlayerAssembly(i-found)
			bufferTable[1] = p
			found = found + 1
		elseif tbl.Importance == 'Partner' then --partner in slot 2
			GAME:RemovePlayerAssembly(i-found)
			bufferTable[2] = p
			found = found + 1
			--if spawn then --call teammate 1 spawner
			--	GROUND:SpawnerSetSpawn('TEAMMATE_1', p)
			--	GROUND:SpawnerDoSpawn("TEAMMATE_1", p)
			--end
		elseif tbl.Importance == 'Partner2' then --partner in slot 2
			GAME:RemovePlayerAssembly(i-found)
			bufferTable[3] = p
			found = found + 1
			--if spawn then --call teammate 2 spawner
			--	GROUND:SpawnerSetSpawn('TEAMMATE_2', p)
			--	GROUND:SpawnerDoSpawn("TEAMMATE_2", p)
			--end
		elseif tbl.AddBack ~= nil then--misc goons go in remaining slots
			GAME:RemovePlayerAssembly(i-found)
			bufferTable[tbl.AddBack] = p
			found = found + 1
			--if spawn then --WARNING: Most places won't have teammate 3 spawners.
			--	GROUND:SpawnerSetSpawn('TEAMMATE_' .. tostring(tbl.AddBack - 1), p)
			--	GROUND:SpawnerDoSpawn("TEAMMATE_" .. tostring(tbl.AddBack - 1), p)	
			--	GROUND:SpawnerDoSpawn("TEAMMATE_" .. tostring(tbl.AddBack - 1), p)	
			--end
			tbl.AddBack = nil--clear addback flag
		end
	end 
	
	--add characters back into team in order, set leader to 1st member
	for i = 1, found - 1, 1 do
		GAME:AddPlayerTeam(bufferTable[i])
	end
	
	--TODO: Remove this when audino updates set team leader index to work in dungeons. Only dungeon init scripts should have the in dungeon parameter set
	if in_dungeon then
		_DATA.Save.ActiveTeam.LeaderIndex = 0
	else 
		GAME:SetTeamLeaderIndex(0)--this doesn't work in dungeons right now
	end
	
	
	--guests are temporary and are for plot or missions. Delete them all, if they're needed again, whatever put them into your team will place them back in
	local guestCount = GAME:GetPlayerGuestCount()
	for i = 1, guestCount, 1 do 
		local g = GAME:RemovePlayerGuest(i-1)
	end

	
	if spawn then 	
		COMMON.RespawnAllies()
		--AI:SetCharacterAI(CH('Teammate1'), "origin.ai.ground_partner", CH('PLAYER'),CH('Teammate1').Position)
		--AI:SetCharacterAI(CH('Teammate2'), "origin.ai.ground_partner", CH('PLAYER'),CH('Teammate2').Position)
	end
	_DATA.Save:UpdateTeamProfile(true)

		
		
end

--The default party before the second partner is met
--Edited Halcyon script for Sunpath
function GeneralFunctions.DefaultPartyCH1(spawn, others, in_dungeon)
	--Clear party 
	local partyCount = GAME:GetPlayerPartyCount()
	local p = 0
	local tbl = 0
	others = others or false
	in_dungeon = in_dungeon or false
	
	--this depends on partner and hero not being able to be shifted out of slot 1 and 2... keep in mind
    for i = partyCount,1,-1 do
      p = GAME:GetPlayerPartyMember(i-1)
	  GAME:RemovePlayerTeam(i-1)
	  GAME:AddPlayerAssembly(p)
	  tbl = LTBL(p)
	  if tbl.Importance ~= 'Hero' and tbl.Importance ~= 'Partner' and others then
		tbl.AddBack = i
	  end
	end
    
	--set party (player then partner)
	local assemblyCount = GAME:GetPlayerAssemblyCount()
	local found = 1 --start at 1 due to indexing
	local bufferTable = {'dummy', 'dummy', 'dummy', 'dummy'}
	
	for i = 1, assemblyCount, 1 do
		p = GAME:GetPlayerAssemblyMember(i - found)
		tbl = LTBL(p)
		--print(tbl.Importance)
		--print(p.Nickname)
		if tbl.Importance == 'Hero' then --hero goes in slot 1
			GAME:RemovePlayerAssembly(i-found)
			bufferTable[1] = p
			found = found + 1
		elseif tbl.Importance == 'Partner' then --partner in slot 2
			GAME:RemovePlayerAssembly(i-found)
			bufferTable[2] = p
			found = found + 1
			--if spawn then --call teammate 1 spawner
			--	GROUND:SpawnerSetSpawn('TEAMMATE_1', p)
			--	GROUND:SpawnerDoSpawn("TEAMMATE_1", p)
			--end
		elseif tbl.AddBack ~= nil then--misc goons go in remaining slots
			GAME:RemovePlayerAssembly(i-found)
			bufferTable[tbl.AddBack] = p
			found = found + 1
			--if spawn then --WARNING: Most places won't have teammate 2 and 3 spawners. Cafe and zone grounds are probably it.
			--	GROUND:SpawnerSetSpawn('TEAMMATE_' .. tostring(tbl.AddBack - 1), p)
			--	GROUND:SpawnerDoSpawn("TEAMMATE_" .. tostring(tbl.AddBack - 1), p)	
			--end
			tbl.AddBack = nil--clear addback flag
		end
	end 
	
	--add characters back into team in order, set leader to 1st member
	for i = 1, found - 1, 1 do
		GAME:AddPlayerTeam(bufferTable[i])
	end
	
	--TODO: Remove this when audino updates set team leader index to work in dungeons. Only dungeon init scripts should have the in dungeon parameter set
	if in_dungeon then
		_DATA.Save.ActiveTeam.LeaderIndex = 0
	else 
		GAME:SetTeamLeaderIndex(0)--this doesn't work in dungeons right now
	end
	
	
	--guests are temporary and are for plot or missions. Delete them all, if they're needed again, whatever put them into your team will place them back in
	local guestCount = GAME:GetPlayerGuestCount()
	for i = 1, guestCount, 1 do 
		local g = GAME:RemovePlayerGuest(i-1)
	end

	
	if spawn then 	
		COMMON.RespawnAlliesChapter1And2()
		--AI:SetCharacterAI(CH('Teammate1'), "origin.ai.ground_partner", CH('PLAYER'),CH('Teammate1').Position)
	end
	_DATA.Save:UpdateTeamProfile(true)

		
		
end

function GeneralFunctions.PromptSaveAndQuit()
	UI:ResetSpeaker()
	UI:BeginChoiceMenu("What would you like to do?", {"Save and continue.", "Save and quit.", "Cancel"}, 1, 3)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()
	if result == 1 then 
		GAME:GroundSave()
		UI:ResetSpeaker()
		UI:WaitShowDialogue("Game saved!")
		GAME:WaitFrames(20)
	elseif result == 2 then 
		GAME:GroundSave()
		UI:ResetSpeaker()
		UI:WaitShowDialogue("Game saved! Returning to title.")
		GAME:WaitFrames(20)
		GAME:FadeOut(false, 40)
		GAME:RestartToTitle()
	end
end


function GeneralFunctions.PromptSave()
	UI:ResetSpeaker()
	UI:ChoiceMenuYesNo("Would you like to save your game?")
	UI:WaitForChoice()
	local result = UI:ChoiceResult()
	if result then 
		GAME:GroundSave()
		UI:ResetSpeaker()
		UI:WaitShowDialogue("Game saved!")
		GAME:WaitFrames(20)
	end
end

--used for chapter end save and quit prompts. Needs to be its own function as we can't call a map transition after if we choose save and quit.
--this should really only ever be called if the ground you want to enter next is the one you're already on.
--also this is kind of a workaround method due to how map transitions and reset to title works.

function GeneralFunctions.PromptChapterSaveAndQuit(ground, marker, ground_id)
	UI:ResetSpeaker()
	UI:BeginChoiceMenu("What would you like to do?", {"Save and continue.", "Save and quit.", "Cancel"}, 1, 3)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()
	if result == 1 then 
		UI:ResetSpeaker()
		_DATA.Save.NextDest = RogueEssence.Dungeon.ZoneLoc("sp_test_zone", -1, ground_id, 0)--set next destination to whatever map we were going to go to on a continue. Just in case player quits out after selecting this option.
		GAME:GroundSave()
		UI:WaitShowDialogue("Game saved!")
		GAME:EnterGroundMap(ground, marker)
	elseif result == 2 then 
		UI:ResetSpeaker()
		GAME:FadeOut(false, 40)
		_DATA.Save.NextDest = RogueEssence.Dungeon.ZoneLoc("sp_test_zone", -1, ground_id, 0)--set next destination to whatever map we were going to go to on a continue
		GAME:GroundSave()
		UI:WaitShowDialogue("Game saved! Returning to title.")
		GAME:RestartToTitle()
	else
		GAME:EnterGroundMap(ground, marker)
	end
end

--sends all bagged items and money to storage. There is no practical limit on storage size (it stores as many as an int32, so... lol)
function GeneralFunctions.SendInvToStorage(sendItems, sendMoney, keepEquips)
	local itemCount = GAME:GetPlayerBagCount()
	local money = GAME:GetPlayerMoney()
	local item
	
	--only send money/items if we specify it. By default, send items AND money to storage.
	if sendItems == nil then sendItems = true end
	if sendMoney == nil then sendMoney = true end
	if keepEquips == nil then keepEquips = false end
	
	if sendMoney then 
		--move player's money to the bank
		GAME:RemoveFromPlayerMoney(money)
		GAME:AddToPlayerMoneyBank(money)
	end
	
	if sendItems then 
		for i = 1, itemCount, 1 do
			item = GAME:GetPlayerBagItem(0)
			GAME:TakePlayerBagItem(0, true)
			GAME:GivePlayerStorageItem(item)
		end
		
		if not keepEquips then
			--send equipped items to storage
			for i = 1, GAME:GetPlayerPartyCount(), 1 do
				item = GAME:GetPlayerEquippedItem(i-1)
				if item.ID ~= "" then 
					GAME:TakePlayerEquippedItem(i-1, true)
					GAME:GivePlayerStorageItem(item)
				end
			end
		end
	end
end

--used to reward items to the player, sends the item to storage if inv is full
function GeneralFunctions.RewardItem(itemID, money, amount)
	--if money is true, the itemID is instead the amount of money to award
	if money == nil then money = false end 
	
	UI:ResetSpeaker(false)--disable text noise
	UI:SetCenter(true)
	
	
	SOUND:PlayFanfare("Fanfare/Item")
	
	if money then 
		UI:WaitShowDialogue("Team " .. GAME:GetTeamName() .. " received " .. "[color=#00FFFF]" .. itemID .. "[color]" .. STRINGS:Format("\\uE024") .. ".[pause=40]") 
		GAME:AddToPlayerMoney(itemID)
	else	
		local itemEntry = RogueEssence.Data.DataManager.Instance:GetItem(itemID)
		
		--give at least 1 item
		if amount == nil then amount = math.max(1, itemEntry.MaxStack) end 

		local item = RogueEssence.Dungeon.InvItem(itemID, false, amount)
		
		local article = "a"
		
		local first_letter = string.upper(string.sub(_DATA:GetItem(item.ID).Name:ToLocal(), 1, 1))
		
		if first_letter == "A" or first_letter == 'E' or first_letter == 'I' or first_letter == 'O' or first_letter == 'U' then article = 'an' end

		UI:WaitShowDialogue("Team " .. GAME:GetTeamName() .. " received " .. article .. " " .. item:GetDisplayName() ..".[pause=40]") 
		
		--bag is full - equipped count is separate from bag and must be included in the calc
		if GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount() >= GAME:GetPlayerBagLimit() then
			UI:WaitShowDialogue("The " .. item:GetDisplayName() .. " was sent to storage.")
			GAME:GivePlayerStorageItem(item.ID, amount)
		else
			GAME:GivePlayerItem(item.ID, amount)
		end
	
	end
	UI:SetCenter(false)
	UI:ResetSpeaker()
			
		
end


local function FirstToUpper(str)
	return (str:gsub("^%l", string.upper))
end

--a or an before an item?
function GeneralFunctions.GetItemArticle(item, uppercase)
	if uppercase == nil then uppercase = false end 
	
	local article = 'a'
	local first_letter = string.upper(string.sub(_DATA:GetItem(item.ID).Name:ToLocal(), 1, 1))

	if first_letter == "A" or first_letter == 'E' or first_letter == 'I' or first_letter == 'O' or first_letter == 'U' then article = 'an' end
	
	if uppercase then article = FirstToUpper(article) end
	
	return article
end

--gives adventurer points
function GeneralFunctions.RewardPoints(amount, silent)
	if silent == nil then silent = false end
	
	UI:ResetSpeaker(false)--disable text noise. Apparently, sky doesn't actually do this for rewarding points for some reason, but it seems weird to keep it on.
	UI:SetCenter(true)
	
	if not silent then 
		SOUND:PlayFanfare("Fanfare/Item")
		UI:WaitShowDialogue("Team " .. GAME:GetTeamName() .. " earned\n[color=#00FFFF]" .. amount .. "[color] Adventurer Rank Points![pause=40]")
	end
	
	--check if a rank up is needed
	local current_rank = _DATA.Save.ActiveTeam.Rank
	local to_go = _DATA:GetRank(current_rank).FameToNext - _DATA.Save.ActiveTeam.Fame 

	--rank up if there's another rank to go. FameToNext will be 0 or -1 if there's no more ranks after.
	if amount >= to_go and _DATA:GetRank(current_rank).FameToNext > 0 then
		--rank up!
		GeneralFunctions.RankUp(amount - to_go)
	else
		--add points to fame 
		_DATA.Save.ActiveTeam.Fame = _DATA.Save.ActiveTeam.Fame + amount
	end
	UI:ResetSpeaker(true)
	UI:SetCenter(false)
end


--Notifies the player they ranked up, what they rewarded for ranking up
function GeneralFunctions.RankUp(leftover_points)
	local current_rank = _DATA.Save.ActiveTeam.Rank
	local next_rank = _DATA:GetRank(current_rank).Next
	
	print(current_rank)
	print(next_rank)
	
	--reset fame, go to next rank
	_DATA.Save.ActiveTeam:SetRank(next_rank)
	_DATA.Save.ActiveTeam.Fame = 0
	
	SOUND:PlayFanfare("Fanfare/RankUp")
	UI:ResetSpeaker()
	UI:SetCenter(true)
	
	UI:WaitShowDialogue("Congratulations!")
	UI:WaitShowDialogue("Team " .. GAME:GetTeamName() .. " went up in rank from the\n[color=#FFA5FF]" .. current_rank:gsub("^%l", string.upper) .. " Rank[color] to the [color=#FFA5FF]" .. next_rank:gsub("^%l", string.upper) .. " Rank[color]!") 
	
	--notify of bag size increase
	if  _DATA:GetRank(current_rank).BagSize < _DATA:GetRank(next_rank).BagSize then
		UI:WaitShowDialogue("The number of items you can store in your Treasure Bag has increased from [color=#00FFFF]" .. tostring(_DATA:GetRank(current_rank).BagSize) .. "[color] to [color=#00FFFF]" .. tostring(_DATA:GetRank(next_rank).BagSize) .. "[color].")
	end

	--depending on the specific rank up achieved, reward the player with different goodies.
	--The goodies and actual rewards are up for change, but this should serve fine for now. Should review in future though.
	local reward_id
	if next_rank == "copper" then 
		reward_id = "boost_hp_up"
	elseif next_rank == "bronze" then 
		reward_id = "boost_hp_up"
	elseif next_rank == "silver" then 
		reward_id = "boost_protein"
	elseif next_rank == "gold" then 
		reward_id = "boost_iron"
	elseif next_rank == "platinum" then 
		reward_id = "boost_calcium"
	elseif next_rank == "diamond" then 
		reward_id = "boost_zinc"
	elseif next_rank == "ace" then 
		reward_id = "boost_carbos"
	elseif next_rank == "super" then 
		reward_id = "boost_nectar"
	elseif next_rank == "ultra" then 
		reward_id = "gummi_wonder"
	elseif next_rank == "hyper" then 
		reward_id = "gummi_wonder"
	elseif next_rank == "master" then 
		reward_id = "seed_joy"
	elseif next_rank == "grandmaster" then 
		reward_id = "seed_golden"
	else--shouldnt ever happen
		reward_id = "food_grimy"
	end
	
	local item = RogueEssence.Dungeon.InvItem(reward_id, false, 1)
	SOUND:PlayFanfare("Fanfare/Item")
	UI:WaitShowDialogue("For advancing in rank,[pause=10] your team was awarded a " .. item:GetDisplayName() ..".[pause=40]") 
	
	--bag is full - equipped count is separate from bag and most be included in the calc
	if GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount() >= GAME:GetPlayerBagLimit() then
		UI:WaitShowDialogue("The " .. item:GetDisplayName() .. " was sent to storage.")
		GAME:GivePlayerStorageItem(item.ID)
	else
		GAME:GivePlayerItem(item.ID)
	end
	
	UI:SetCenter(false)

	
	--silently award any leftover points.
	if leftover_points > 0 then GeneralFunctions.RewardPoints(leftover_points, true) end
end 


--gets the ID of the gummi that matches one of the types of the given pokemon. Chooses the type randomly if they have multiple.
function GeneralFunctions.GetFavoriteGummi(chara)
	local mon = _DATA:GetMonster(chara.CurrentForm.Species)
	local forme = mon.Forms[chara.CurrentForm.Form]
	local typing = forme.Element1
	if forme.Element2 ~= "none" then
		local rand = GeneralFunctions.RandBool()
		if rand then typing = forme.Element2 end
	end
	
	local gummis = {bug = "gummi_green",
					dark = "gummi_black", 
					dragon = "gummi_royal", 
					electric = "gummi_yellow", 
					fairy = "gummi_magenta", 
					fighting = "gummi_orange", 
					fire = "gummi_red", 
					flying = "gummi_sky", 
					ghost = "gummi_purple",
					grass = "gummi_grass", 
					ground = "gummi_brown", 
					ice = "gummi_clear", 
					normal = "gummi_white", 
					poison = "gummi_pink",
					psychic = "gummi_gold",
					rock = "gummi_gray", 
					steel = "gummi_silver", 
					water = "gummi_blue" }
	
	return gummis[typing]
					
end

--feed it a list of pairs of values and weights, it will return a value randomly with regards to the weights
 --[[
	Example:
	local ammo_stock = 
	{
		{{Index = 200, Hidden = 9, Price = 45}, 50},--stick 
		{{Index = 203, Hidden = 9, Price = 45}, 50}--iron thorn 
	}
	
]]--
function GeneralFunctions.WeightedRandom (weights)
    local summ = 0
    for i, value in pairs (weights) do
        summ = summ + value[2]
    end
    if summ == 0 then return end
    -- local value = math.random (summ) -- for integer weights only
    local rand = summ*math.random ()
    summ = 0
    for i, value in pairs (weights) do
        summ = summ + value[2]
        if rand <= summ then
            return value[1]--, weight
        end
    end
end



--Halcyon edit for COMMON.GroundInteract; basically just adds a start and end conversation call to it. Removes a charturntochar as well
function GeneralFunctions.GroundInteract(chara, target)
  UI:SetSpeaker(target)
  
  local mon = RogueEssence.Data.DataManager.Instance:GetMonster(target.CurrentForm.Species)
  local form = mon.Forms[target.CurrentForm.Form]
  
  local personality = form:GetPersonalityType(target.Data.Discriminator)
  
  local personality_group = COMMON.PERSONALITY[personality]
  local pool = personality_group.WAIT
  local key = "TALK_WAIT_%04d"
  
  local running_pool = {table.unpack(pool)}
  local valid_quote = false
  local chosen_quote = ""
  
  while not valid_quote and #running_pool > 0 do
    valid_quote = true
    local chosen_idx = math.random(1, #running_pool)
	local chosen_pool_idx = running_pool[chosen_idx]
    chosen_quote = RogueEssence.StringKey(string.format(key, chosen_pool_idx)):ToLocal()
	
    chosen_quote = string.gsub(chosen_quote, "%[hero%]", chara:GetDisplayName())
    
	if not valid_quote then
      -- PrintInfo("Rejected "..chosen_quote)
	  table.remove(running_pool, chosen_idx)
	  chosen_quote = ""
	end
  end
  -- PrintInfo("Selected "..chosen_quote)
  
  
  GeneralFunctions.StartConversation(target, chosen_quote)
  GeneralFunctions.EndConversation(target)
end


function GeneralFunctions.RemoveCharEffects(char)
	char.StatusEffects:Clear();
	char.ProxyAtk = -1;
	char.ProxyDef = -1;
	char.ProxyMAtk = -1;
	char.ProxyMDef = -1;
	char.ProxySpeed = -1;
end

--called whenever to warp the party out, including guests
function GeneralFunctions.WarpOut()
	local player_count = GAME:GetPlayerPartyCount()
	local guest_count = GAME:GetPlayerGuestCount()
	for i = 0, player_count - 1, 1 do 
		local player = GAME:GetPlayerPartyMember(i)
		if not player.Dead then
			GAME:WaitFrames(60)
			local anim = RogueEssence.Dungeon.CharAbsentAnim(player.CharLoc, player.CharDir)
			GeneralFunctions.RemoveCharEffects(player)
			TASK:WaitTask(_DUNGEON:ProcessBattleFX(player, player, _DATA.SendHomeFX))
			TASK:WaitTask(player:StartAnim(anim))
		end
	end

	for i = 0, guest_count - 1, 1 do
		local guest = GAME:GetPlayerGuestMember(i)
		if not guest.Dead then
			GAME:WaitFrames(60)
			local anim = RogueEssence.Dungeon.CharAbsentAnim(guest.CharLoc, guest.CharDir)
			GeneralFunctions.RemoveCharEffects(guest)
			TASK:WaitTask(_DUNGEON:ProcessBattleFX(guest, guest, _DATA.SendHomeFX))
			TASK:WaitTask(guest:StartAnim(anim))
		end
	end
end

--called whenever a mission is completed
function GeneralFunctions.AskMissionWarpOut()
	local function MissionWarpOut()
		GeneralFunctions.WarpOut()
		GAME:WaitFrames(80)
		--Set minimap state back to old setting
		_DUNGEON.ShowMap = SV.TemporaryFlags.PriorMapSetting
		SV.TemporaryFlags.PriorMapSetting = nil
		TASK:WaitTask(_GAME:EndSegment(RogueEssence.Data.GameProgress.ResultType.Escaped))
	end
	
	local function SetMinimap()
		--to prevent accidentally doing something by pressing the button to select yes
		GAME:WaitFrames(10)
		--Set minimap state back to old setting
		_DUNGEON.ShowMap = SV.TemporaryFlags.PriorMapSetting
		SV.TemporaryFlags.PriorMapSetting = nil
	end
	
	local has_ongoing_mission = false
	local curr_floor = GAME:GetCurrentFloor().ID + 1
	local curr_zone = _ZONE.CurrentZoneID
	local curr_segment = _ZONE.CurrentMapID.Segment

	for _, mission in ipairs(SV.TakenBoard) do
		if mission.Floor > curr_floor and mission.Taken and mission.Completion == COMMON.MISSION_INCOMPLETE and curr_zone == mission.Zone and curr_segment == mission.Segment then
			has_ongoing_mission = true
			break
		end
	end


	UI:ResetSpeaker()
	local state = 0
	while state > -1 do
		if state == 0 then
			if has_ongoing_mission then
				UI:ChoiceMenuYesNo("You have more ongoing missions, but would you like to leave the dungeon now?", true)
				UI:WaitForChoice()
				local leave_dungeon = UI:ChoiceResult()
				if leave_dungeon then
					UI:ChoiceMenuYesNo("Do you really want to leave?", true)
					UI:WaitForChoice()
					local leave_confirm = UI:ChoiceResult()
					if leave_confirm then
						state = -1
						MissionWarpOut()
					else
						--pause between textboxes if player de-confirms
						GAME:WaitFrames(20)
					end
				else
					state = -1
					SetMinimap()
				end
			else
				UI:ChoiceMenuYesNo("You have no more ongoing missions beyond this point.\nWould you like to leave the dungeon now?", false)
				UI:WaitForChoice()
				local leave_dungeon = UI:ChoiceResult()
				if leave_dungeon then
						state = -1
						MissionWarpOut()
				else
					state = -1
					SetMinimap()
				end
			end
		end
	end
end

--does a double flash like in a boss transition
function GeneralFunctions.DoubleFlash(sound)
    local center = GAME:GetCameraCenter()
    local emitter = RogueEssence.Content.FlashEmitter()
    emitter.FadeInTime = 2
    emitter.HoldTime = 2
    emitter.FadeOutTime = 2
    emitter.StartColor = Color(0, 0, 0, 0)
    emitter.Layer = DrawLayer.Top
    emitter.Anim = RogueEssence.Content.BGAnimData("White", 0)
    GROUND:PlayVFX(emitter, center.X, center.Y)
    if sound then SOUND:PlayBattleSE("EVT_Battle_Flash") end
    GAME:WaitFrames(16)
    GROUND:PlayVFX(emitter, center.X, center.Y)
    if sound then SOUND:PlayBattleSE("EVT_Battle_Flash") end
end


--debug function used to print plot variables
--Edited Halcyon script for Sunpath
function GeneralFunctions.PrintPlotVariables()
	print("Chapter = " .. tostring(SV.ChapterProgression.Chapter))
	print("Chapter 1")
	print("PlayedIntroCutscene = " .. tostring(SV.Chapter1.PlayedIntroCutscene))
	print("PlayerEnteredDune = " .. tostring(SV.Chapter1.PlayerEnteredDune))
	print('PlayerCompletedDune = ' .. tostring(SV.Chapter1.PlayerCompletedDune))
	print("PartnerEnteredDune = " .. tostring(SV.Chapter1.PartnerEnteredDune))
	print('PartnerCompletedDune = ' .. tostring(SV.Chapter1.PartnerCompletedDune))
	print('PlayerEnteredVillage = ' .. tostring(SV.Chapter1.PlayerEnteredVillage))
	print('PlayerAllowedInVillage = ' .. tostring(SV.Chapter1.PlayerAllowedInVillage))
	print('PartnerEnteredVillage = ' .. tostring(SV.Chapter1.PartnerEnteredVillage))
	print('PlayerSleptInVillage = ' .. tostring(SV.Chapter1.PlayerSleptInVillage))
	print('PlayerMetPartner = ' .. tostring(SV.Chapter1.PlayerMetPartner))
	--print('MetX = ' .. tostring(SV.Chapter1.MetX))
	print('TutorialProgression = ' .. tostring(SV.Chapter1.TutorialProgression))
	
	--print("Chapter 2")
	--print('PlayerMetPartner2 = ' .. tostring(SV.Chapter2.PlayerMetPartner2))
	--print('TeamJoinedGuild = ' .. tostring(SV.Chapter2.TeamJoinedGuild))

	--print("Chapter 3")

end 

function GeneralFunctions.TableContains(table, val)
	for i=1,#table do
		 if table[i] == val then 
				return true
		 end
	end
	return false
end

function GeneralFunctions.RemoveAllItems()
	local save = _DATA.Save
	local inv_count = save.ActiveTeam:GetInvCount() - 1

  --remove bag items
  for i = inv_count, 0, -1 do
    local entry = _DATA:GetItem(save.ActiveTeam:GetInv(i).ID)
    --if not entry.CannotDrop then
      save.ActiveTeam:RemoveFromInv(i)
    --end
  end
  
  --remove equips
  local player_count = save.ActiveTeam.Players.Count
  for i = 0, player_count - 1, 1 do 
    local player = save.ActiveTeam.Players[i]
    if player.EquippedItem.ID ~= '' and player.EquippedItem.ID ~= nil then 
      local entry = _DATA:GetItem(player.EquippedItem.ID)
      if not entry.CannotDrop then
         player:SilentDequipItem()
      end
    end
  end
end

function GeneralFunctions.RemoveAllGuests()
	local guest_count = GAME:GetPlayerGuestCount()
	for i = 0, guest_count - 1, 1 do --beam everyone else out
		PrintInfo("REMOVING GUESTS")
		GAME:RemovePlayerGuest(0)
	end
end

--When you need a multipaged Choice Menu. Returns the result, so use it as the BeginChoiceMenu, WaitFroChoice, and UIChoiceResult block.
--One potential byproduct of using this menu is that it sets the text speed to instant, then back to normal. If you set text speed before to instant
--it'll get undone by this function potentially, so be aware.
function GeneralFunctions.PagedChoiceMenu(message, choices, defaultchoice, cancelchoice)
	local choice_amount = #choices
	local choice_submenus = {}
	local submenu_length = 10
	local result
	
	--if you see weird - and + 1 with a modulo, its indexing shenanigans.
	if choice_amount > submenu_length then
		--populate choice_submenus 
		for i = 1, choice_amount, 1 do 
			if i % submenu_length == 1 then table.insert(choice_submenus, {}) end --add an empty table in if we need to start a new subtable
			choice_submenus[math.ceil(i / submenu_length)][((i - 1) % submenu_length) + 1] = choices[i]
		end 
		
		for i = 1, #choice_submenus, 1 do
			table.insert(choice_submenus[i], "Prev Page")
			table.insert(choice_submenus[i], "Next Page")
		end
		
		local continue = false 
		local current_submenu = 1
		local total_submenus = #choice_submenus
		local default_cursor_option  = 1--stay on whatever we selected last (next or last page)
		--Loop submenus until player chooses an actual option.
		while not continue do
			UI:BeginChoiceMenu(message, choice_submenus[current_submenu], default_cursor_option, # choice_submenus[current_submenu])
			UI:WaitForChoice()
			result = UI:ChoiceResult()
			UI:SetAutoFinish(true)--so submenus dont have to repeat the entire query.
			
			--prev page 
			if result == #choice_submenus[current_submenu] - 1 then 
				current_submenu = ((current_submenu - 2) % total_submenus) + 1
				default_cursor_option = #choice_submenus[current_submenu] - 1
			--next page 
			elseif result == #choice_submenus[current_submenu] then
				current_submenu = (current_submenu % total_submenus) + 1
				default_cursor_option = #choice_submenus[current_submenu]
			--an actual choice. Need to adjust the result according to the submenu.
			else 
				result = result + ((current_submenu - 1) * submenu_length)
				continue = true 
				UI:SetAutoFinish(false)--set this back to not auto finish. No way to check if it is on or off before we get here, so typical situation we'd want is to turn it back off. Destructive, but what can you do.
			end 
		end 
	else
		UI:BeginChoiceMenu(message, choices, defaultchoice, cancelchoice)
		UI:WaitForChoice()
		result = UI:ChoiceResult()
	end 
	
	--print("result is: " .. tostring(result))
	return result
	
end 


function GeneralFunctions.PrintMissionType(mission)
	local val = mission.Type

	if val == COMMON.MISSION_TYPE_RESCUE then
		PrintInfo("=====RESCUE=====")
  elseif val == COMMON.MISSION_TYPE_ESCORT then
		PrintInfo("=====ESCORT=====")
	elseif val == COMMON.MISSION_TYPE_EXPLORATION then
		PrintInfo("=====EXPLORATION=====")
  elseif val == COMMON.MISSION_TYPE_OUTLAW then 
		PrintInfo("=====OUTLAW=====")
	elseif val == COMMON.MISSION_TYPE_OUTLAW_FLEE then
		PrintInfo("=====OUTLAW_FLEE=====")
	elseif val == COMMON.MISSION_TYPE_OUTLAW_MONSTER_HOUSE then
		PrintInfo("=====OUTLAW_MONSTER_HOUSE=====")
	elseif val == COMMON.MISSION_TYPE_LOST_ITEM then 
		PrintInfo("=====LOST_ITEM=====")
	elseif val == COMMON.MISSION_TYPE_DELIVERY then 
		PrintInfo("=====OUTLAW_MONSTER_HOUSE=====")
  elseif val == COMMON.MISSION_TYPE_OUTLAW_ITEM then 
		PrintInfo("=====OUTLAW_ITEM=====")
  end
end 


function GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
	local hero = CH('PLAYER')
    local partner = CH('Teammate1')
    partner.IsInteracting = true
    GROUND:CharSetAnim(partner, 'None', true)
    GROUND:CharSetAnim(hero, 'None', true)		
    GeneralFunctions.TurnTowardsLocation(hero, obj.Position.X + obj.Width // 2, obj.Position.Y + obj.Height // 2)
    GeneralFunctions.TurnTowardsLocation(partner, obj.Position.X + obj.Width // 2, obj.Position.Y + obj.Height // 2)
	
	
	local state = 0

	while state > - 1 do 
		local has_items = GAME:GetPlayerBagCount() > 0
		local has_equipment = GAME:GetPlayerEquippedCount() > 0
		local has_storage = GAME:GetPlayerStorageCount() > 0
				
		local choices = { { STRINGS:FormatKey('MENU_STORAGE_STORE'), has_items or has_equipment},
		{ STRINGS:FormatKey('MENU_STORAGE_TAKE_ITEM'), has_storage},
		{ STRINGS:FormatKey('MENU_STORAGE_STORE_ALL'), has_items},
		{ STRINGS:FormatKey('MENU_STORAGE_MONEY'), true},
		{ "Save", true},
		{ STRINGS:FormatKey("MENU_CANCEL"), true}}	
	
		UI:ResetSpeaker()
		UI:SetCenter(true)
		UI:SetAutoFinish(true)
		UI:BeginChoiceMenu("What would you like to do?", choices, 1, #choices)
		UI:WaitForChoice()
		local result = UI:ChoiceResult()
		UI:SetCenter(false)
		UI:SetAutoFinish(false)
		
		
		if result == 1 then
			UI:StorageMenu()
			UI:WaitForChoice()
		elseif result == 2 then
			UI:WithdrawMenu()
			UI:WaitForChoice()
		elseif result == 3 then
			GeneralFunctions.SendInvToStorage(true, false, true)
			UI:SetCenter(true)
			UI:WaitShowDialogue("All unequipped items have been stored.")
			UI:SetCenter(false)
		elseif result == 4 then
			UI:BankMenu()
			UI:WaitForChoice()
		elseif result == 5 then
			state = -1
			GeneralFunctions.PromptSaveAndQuit()
		else
			state = -1
		end
	end
	
	partner.IsInteracting = false
	
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	
end

--------------------------
--Knightcore scripts
--------------------------

function GeneralFunctions.FadeOutRefreshParty()
    GAME:FadeOut(false, 20)
	COMMON.RespawnAllies()
    GAME:FadeIn(20)
end

--------------------------
--Sunpath scripts
--------------------------

