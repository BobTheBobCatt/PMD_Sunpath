require 'pmd_sunpath.common'
require 'pmd_sunpath.GeneralFunctions'
CharacterActions = {}

-------------------------------
-- Halcyon scripts
-------------------------------

--chara looks around in a rotations amount of directions, turning for turnframes frames, 
--ending facing in enddir direction. if alldirections is true, can look in all directions, otherwise can only face +-2 from original direction
function CharacterActions.LookAround(chara, rotations, turnframes, allDirections, sound, startLeft, enddir)


	if allDirections == nil then allDirections = true end 
	if sound == nil then sound = true end 
	if startLeft == nil then startLeft = true end 
	if enddir == nil then enddir = chara.Direction end

	local dir = 0
	
	--play the looking around sfx if we want a sound to be made
	if sound then SOUND:PlaySE("EVT_Emote_Confused_2") end

	--if all directions, look in any of the 8 directions randomly (except the one we are already facing)
	--if not all directions, alternate between looking 90 degrees left and right from current direction
	--at the end, face towards the enddir if specified
	if allDirections then 
		for i = 1, rotations, 1 do
			local currentDir = chara.Direction
			local numDir = GeneralFunctions.DirToNum(currentDir)
			local diff = 0
			local rand = 0
			repeat
				rand = math.random(0, 7)--pick a random direction
				diff = math.abs(numDir - rand)
			until (diff > 1 and diff < 7)--chosen direction must be at least 90 degrees different 
			dir = GeneralFunctions.NumToDir(rand)
			GROUND:CharAnimateTurnTo(chara, dir, turnframes)
			GAME:WaitFrames(20)--pause
		end 
	else--this is much less random 
		local leftDir = GeneralFunctions.NumToDir(GeneralFunctions.DirToNum(chara.Direction) - 2)
		local rightDir = GeneralFunctions.NumToDir(GeneralFunctions.DirToNum(chara.Direction) + 2)
		local originalDir = chara.Direction
		local turnLeft = startLeft --start by looking left if that's what's been specified, otherwise start by looking right
		for i = 1, rotations, 1 do
			if turnLeft then
				GROUND:CharAnimateTurn(chara, leftDir, turnframes, turnLeft)
				GAME:WaitFrames(10)--pause
				turnLeft = false
			else
				GROUND:CharAnimateTurn(chara, rightDir, turnframes, turnLeft)
				GAME:WaitFrames(10)--pause
				turnLeft = true
			end
		end
	end
	if enddir ~= Direction.None and enddir ~= dir then--if a direction to end on was specified and we aren't facing that way, turn there 
		GROUND:CharAnimateTurnTo(chara, enddir, turnframes)
	else GAME:WaitFrames(turnframes * 2)--wait for some time based off how long it could have taken to turn if we dont turn at the end 
	end
	GAME:WaitFrames(6)--Wait a short duration before ending

end

--This function makes it easy to keep the camera in sync with a character moving
function CharacterActions.MoveCharAndCamera(chara, x, y, run, charSpeed, cameraFrames)
	local startX = chara.Position.X
	local startY = chara.Position.Y
	--characters position starts from their top left corner. 
	local camX = x + 8
	local camY = y + 8
	local default = false
	
	--cameraSpeed should only be given when a custom frame count needs to be used for some reason
	--otherwise, calculate the number of frames needed for smooth transition
	if cameraFrames == nil then cameraFrames = GeneralFunctions.CalculateCameraFrames(startX, startY, x, y, charSpeed) end
	--default run to false 
	if run == nil then run = false end 

	local coro1 = TASK:BranchCoroutine(function() GAME:MoveCamera(camX, camY, cameraFrames, false) end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(chara, x, y, run, charSpeed) end)
	TASK:JoinCoroutines({coro1, coro2})


end

function CharacterActions.ShakeHead(chara, turnframes, startLeft)
	
	if turnframes == nil then turnframes = 4 end
	if startLeft == nil then startLeft = true end 
	
	initDir = chara.Direction
	local leftDir = GeneralFunctions.NumToDir(GeneralFunctions.DirToNum(chara.Direction) - 1)
	local rightDir = GeneralFunctions.NumToDir(GeneralFunctions.DirToNum(chara.Direction) + 1)
	if startLeft then
		GROUND:CharAnimateTurnTo(chara, leftDir, turnframes)
		GROUND:CharAnimateTurnTo(chara, rightDir, turnframes)
		GROUND:CharAnimateTurnTo(chara, leftDir, turnframes)
		GROUND:CharAnimateTurnTo(chara, rightDir, turnframes)
		GROUND:CharAnimateTurnTo(chara, initDir, turnframes)
	else
		GROUND:CharAnimateTurnTo(chara, rightDir, turnframes)
		GROUND:CharAnimateTurnTo(chara, leftDir, turnframes)
		GROUND:CharAnimateTurnTo(chara, rightDir, turnframes)
		GROUND:CharAnimateTurnTo(chara, leftDir, turnframes)
		GROUND:CharAnimateTurnTo(chara, initDir, turnframes)
	end
	
end

--walking in place to "talk"
function CharacterActions.HeroSpeak(chara, duration, anim)
	--anim is the animation we do after walking in place
	if anim == nil then anim = 'None' end 
	GROUND:CharSetAnim(chara, "Walk", true)
	GAME:WaitFrames(duration)
	--GROUND:CharSetAnim(chara, anim, true)
	GROUND:CharEndAnim(chara)
end

--generic emote function with standardized SFX and pause duration. Shouldn't ALWAYS be used to emote, but is useful to cut down on lines...
function CharacterActions.EmoteAndPause(chara, emote, sound, repetitions)
	local sfx = 'null'
	local emt = 'null'
	local pause = 0
	
	if repetitions == nil then repetitions = 1 end
	
	if emote == 'Happy' then
		emt = "happy"
		sfx = "EVT_Emote_Startled_2"
		pause = 20--test this one 
	elseif emote == 'Notice' then --this one is the 3 lines
		emt = "notice"
		sfx = 'EVT_Emote_Exclaim'
		pause = 30
	elseif emote == 'Exclaim' then --this one is the !
		emt = "exclaim"
		sfx = 'EVT_Emote_Exclaim_2'
		pause = 20
	elseif emote == 'Glowing' then 
		emt = "glowing"
		sfx = 'EVT_Emote_Startled_2'
		pause = 20--test this one
	elseif emote == 'Sweating' then
		emt = "sweating"
		sfx = 'EVT_Emote_Sweating'
		pause = 40 
	elseif emote == 'Question' then
		emt = "question"
		sfx = 'EVT_Emote_Confused'
		pause = 40
	elseif emote == 'Angry' then
		emt = "angry"
		sfx = 'EVT_Emote_Complain_2'
		pause = 40 --test this one
	elseif emote == 'Shock' then
		emt = "shock"
		sfx = 'EVT_Emote_Shock'
		pause = 40
	else--sweatdrop
		emt = "sweatdrop"
		sfx = 'EVT_Emote_Sweatdrop'
		pause = 40
	end
	
	GROUND:CharSetEmote(chara, emt, repetitions)
	
	if sound and sfx ~= 'null' then 
		SOUND:PlayBattleSE(sfx)
	end	
	GAME:WaitFrames(pause)
end

--generic function to do an animation once then go back to the anim you were doing before (i.e. nod, get up, be surprised) 
--Has standardized wait times
--has some special instances... 
function CharacterActions.DoAnimation(chara, anim, sound)
	if sound == nil then sound = false end
	--[[local pause = 0
	--todo: return character to their animation from before. For now just end the anim...
	--local prevAnim = 'None'
	
	if anim == 'Nod' then 
		pause = 20
	elseif anim == 'Wake' then
		pause = 40
	elseif anim == 'Hop' then
		pause = 24
	elseif anim == 'DeepBreath' then
		pause = 80
	end
	]]--
	GROUND:CharWaitAnim(chara, anim)
	GROUND:CharEndAnim(chara)

end

--useful for having characters face constantly towards someone who's moving
--offset is if you want the characters to look at 
function CharacterActions.FaceMovingCharacter(chara, target, turnFrames, breakDirection)
	local currentLocX = -999
	local currentLocY = -999
	turnFrames = turnFrames or 4

	breakDirection = breakDirection or Direction.None
	
	GAME:WaitFrames(1)--gives the pokemon a chance to start moving
	while not (currentLocX == target.Position.X and currentLocY == target.Position.Y) do
		if chara.Direction == breakDirection then break end
		GROUND:CharTurnToCharAnimated(chara, target, turnFrames)
		currentLocX = target.Position.X
		currentLocY = target.Position.Y
		GAME:WaitFrames(1)
	end
end

function CharacterActions.Hop(chara, anim, height, duration, pause, sound)
	anim = anim or 'None'
	height = height or 10
	duration = duration or 10
	if pause == nil then pause = true end
	if sound == nil then sound = false end

	local animId = RogueEssence.Content.GraphicsManager.GetAnimIndex(anim)
	GROUND:CharSetAction(chara, RogueEssence.Ground.HopGroundAction(chara.Position, chara.Direction, animId, height, duration))
	
	if sound then
		SOUND:PlayBattleSE("EVT_Emote_Startled")
	end
	
	if pause then 
		GAME:WaitFrames(duration)
	end

end

--do two hops instead of just one
function CharacterActions.DoubleHop(chara, anim, height, duration, pause, sound)
	anim = anim or 'None'
	height = height or 10
	duration = duration or 10
	if pause == nil then pause = true end
	
	if sound then
		SOUND:PlayBattleSE("EVT_Emote_Startled_2")
	end
	
	local animId = RogueEssence.Content.GraphicsManager.GetAnimIndex(anim)
	GROUND:CharSetAction(chara, RogueEssence.Ground.HopGroundAction(chara.Position, chara.Direction, animId, height, duration))
	GAME:WaitFrames(duration)--need to pause no matter what here because only one hop will show otherwise
	GROUND:CharSetAction(chara, RogueEssence.Ground.HopGroundAction(chara.Position, chara.Direction, animId, height, duration))

	if pause then --only pause on 2nd hop if pause needed
		GAME:WaitFrames(duration)
	end

end



--do a quick shake in place.
function CharacterActions.Shake(chara)
  GROUND:CharSetDrawEffect(chara, DrawEffect.Trembling)
  GAME:WaitFrames(8)
  GROUND:CharEndDrawEffect(chara, DrawEffect.Trembling)
end

--shake in place until told to stop. Change animation to the first frame of walking while doing so.
--if you don't want that first frame of walk, use GROUND:CharSetDrawEffect and GROUND:CharEndDrawEffect
function CharacterActions.StartTremble(chara)
  GROUND:CharSetAction(chara, RogueEssence.Ground.FrameGroundAction(chara.Position, chara.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Walk"), 0))
  GROUND:CharSetDrawEffect(chara, DrawEffect.Trembling)

end 

function CharacterActions.StopTremble(chara)
  GROUND:CharEndAnim(chara)
  GROUND:CharEndDrawEffect(chara, DrawEffect.Trembling)

end 

function CharacterActions.Recoil(chara, anim, height, duration, sound, emote)

	anim = anim or 'Hurt'
	height = height or 10
	duration = duration or 10
	if sound == nil then sound = true end
	if emote == nil then emote = true end
	
	if emote then GROUND:CharSetEmote(chara, "shock", 1) end
	if sound then SOUND:PlayBattleSE('EVT_Emote_Startled') end
	local animId = RogueEssence.Content.GraphicsManager.GetAnimIndex(anim)
	GROUND:CharSetAction(chara, RogueEssence.Ground.HopGroundAction(chara.Position, chara.Direction, animId, height, duration))
	GAME:WaitFrames(duration)
	if emote then GROUND:CharSetEmote(chara, "", 0) end
	
end

--have both player and partner turn towards chara at the same time
--shortcut function
function CharacterActions.DuoTurnTowardsChar(chara, heroDelay, turnFrames)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	turnFrames = turnFrames or 4
	heroDelay = heroDelay or 4
	
	local coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(heroDelay) GROUND:CharTurnToCharAnimated(hero, chara, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
	
	TASK:JoinCoroutines({coro1, coro2})

end 

function CharacterActions.TrioTurnTowardsChar(chara, heroDelay, turnFrames)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local partner2 = CH('Teammate2')
	
	turnFrames = turnFrames or 4
	heroDelay = heroDelay or 4
	
	local coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(heroDelay) GROUND:CharTurnToCharAnimated(hero, chara, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
	local coro3 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner2, chara, 4) end)
	
	TASK:JoinCoroutines({coro1, coro2})

end 

--set speaker and emotion beforehand!
function CharacterActions.DuoTurnTowardsCharWithDialogue(chara, dialogue, heroDelay, turnFrames)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	turnFrames = turnFrames or 4
	heroDelay = heroDelay or 4
	
	local coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(heroDelay) GROUND:CharTurnToCharAnimated(hero, chara, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
	UI:WaitShowDialogue(dialogue)
	
	TASK:JoinCoroutines({coro1, coro2, coro3})

end 

function CharacterActions.TrioTurnTowardsCharWithDialogue(chara, dialogue, heroDelay, turnFrames)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local partner2 = CH('Teammate2')
	
	turnFrames = turnFrames or 4
	heroDelay = heroDelay or 4
	
	local coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(heroDelay) GROUND:CharTurnToCharAnimated(hero, chara, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
	local coro3 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner2, chara, 4) end)
	UI:WaitShowDialogue(dialogue)
	
	TASK:JoinCoroutines({coro1, coro2, coro3})

end 

--character hops twice and makes angry noise 
function CharacterActions.Complain(chara, emote)
	if emote == nil then emote = false end 
	
	SOUND:PlayBattleSE('EVT_Emote_Complain_2')
	CharacterActions.Hop(chara)
	CharacterActions.Hop(chara)
	if emote then GROUND:CharSetEmote(chara, "angry", 0) end 
	
end


function CharacterActions.RunInCircle(chara, duration, speed, clockwise, run)
	local originalDir = chara.Direction
	local numDir = GeneralFunctions.DirToNum(chara.Direction)
	if clockwise then clockwise = 1 else clockwise = -1 end 
	
	for i = 0, 7, 1 do 
		GROUND:MoveInDirection(chara, GeneralFunctions.NumToDir(numDir + (i * clockwise)), duration, run, speed)
	end
	
	GROUND:EntTurn(chara, originalDir)
	
end



--used to turn towards a specified position which is needed if chara's position is dynamic
function CharacterActions.TurnTowardsLocation(chara, targetX, targetY, turnduration)

	local x = chara.Position.X + 8
	local y = chara.Position.Y + 8
	turnduration = turnduration or 4


	--In a normal setting, +y is up, but in pmdo +y is down. So I need to flip the sign on the difference in y between char1 and char2
	local y = -1 * (targetY - y)
	local x = targetX - x
	
	local angle = math.atan(y, x)--this is in radians
	local ratio = math.pi / 8 --for readability

	if angle <= (ratio) and angle >= (-1 * ratio) then 
		GROUND:CharAnimateTurnTo(chara, Direction.Right, turnduration)
	elseif angle > (ratio) and angle < (3 * ratio) then
		GROUND:CharAnimateTurnTo(chara, Direction.UpRight, turnduration)
	elseif angle >= (3 * ratio) and angle <= (5 * ratio) then
		GROUND:CharAnimateTurnTo(chara, Direction.Up, turnduration)
	elseif angle > (5 * ratio) and angle < (7 * ratio) then
		GROUND:CharAnimateTurnTo(chara, Direction.UpLeft, turnduration)
	elseif angle >= (7 * ratio) or angle <= (-7 * ratio) then
		GROUND:CharAnimateTurnTo(chara, Direction.Left, turnduration)
	elseif angle > (-7 * ratio) and angle < (-5 * ratio) then
		GROUND:CharAnimateTurnTo(chara, Direction.DownLeft, turnduration)
	elseif angle >= (-5 * ratio) and angle <= (-3 * ratio) then
		GROUND:CharAnimateTurnTo(chara, Direction.Down, turnduration)
	elseif angle > (-3 * ratio) and angle < (-1 * ratio) then
		GROUND:CharAnimateTurnTo(chara, Direction.DownRight, turnduration)
	else
		--i screwed up with the logic somewhere if one of the above cases isn't selected
		--Spin around like a moron if this statement is reached
		--this should be changed to some sort of error, but i dont know how to log errors properly in PMDO
		GROUND:CharSetAnim(chara, 'Spin', true)
	end
end

function CharacterActions.RestoreIdleAnim()
	local player_count = GAME:GetPlayerPartyCount()
	local guest_count = GAME:GetPlayerGuestCount()
	for i = 0, player_count - 1, 1 do 
		local player = GAME:GetPlayerPartyMember(i)
		local anim = RogueEssence.Dungeon.CharAnimIdle(player.CharLoc, player.CharDir)
		TASK:WaitTask(player:StartAnim(anim))
	end

	for i = 0, guest_count - 1, 1 do
		local guest = GAME:GetPlayerGuestMember(i)
		local anim = RogueEssence.Dungeon.CharAnimIdle(guest.CharLoc, guest.CharDir)
		TASK:WaitTask(guest:StartAnim(anim))
	end
end

function CharacterActions.TeamTurnTo(char) 
	local player_count = GAME:GetPlayerPartyCount()
	local guest_count = GAME:GetPlayerGuestCount()
	for i = 0, player_count - 1, 1 do 
		local player = GAME:GetPlayerPartyMember(i)
		if not player.Dead then
			DUNGEON:CharTurnToChar(player, char)
		end
	end

	for i = 0, guest_count - 1, 1 do
		local guest = GAME:GetPlayerGuestMember(i)
		if not guest.Dead then
			DUNGEON:CharTurnToChar(guest, char)
		end
	end
end


------------------------------------
-- Explorers of Sky: Origins scripts
------------------------------------

function CharacterActions.ScaredJump(ent, dir)
	local directions = {Direction.Up, Direction.UpRight, Direction.Right, Direction.DownRight, Direction.Down, Direction.DownLeft, Direction.Left, Direction.UpLeft}
	local dirNum = 0
	
	--find list placement of dir
	for i = 1, #directions do
		if directions[i] == dir then
			dirNum = i
			break
		end
	end
	
	--check if dir was a valid direction
	if dirNum == 0 then
		return error(tostring(dir).." is not a valid direction!")
	end
	
	--find jump offset
	local xoff = 0
	local yoff = 0
	
	--up?
	if dirNum <= 2 or dirNum == 8 then
		yoff = 2
	end
	
	--down?
	if dirNum >= 4 and dirNum <= 6 then
		yoff = -2
	end
	
	--left?
	if dirNum >= 6 and dirNum <= 8 then
		xoff = 2
	end
	
	--right?
	if dirNum >= 2 and dirNum <= 4 then
		xoff = -2
	end

	--actual animation
	local xpos = ent.Position.X
	local ypos = ent.Position.Y
	
	GROUND:AnimateToPosition(ent, "Hurt", dir, (xpos + xoff), (ypos + yoff), 1, 2, 10)
	GROUND:AnimateToPosition(ent, "Hurt", dir, xpos, ypos, 1, 2, 0)
end
