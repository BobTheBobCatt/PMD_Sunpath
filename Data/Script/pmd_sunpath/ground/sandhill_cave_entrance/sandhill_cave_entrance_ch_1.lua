require 'pmd_sunpath.common'
require 'pmd_sunpath.PartnerEssentials'
require 'pmd_sunpath.CharacterEssentials'
require 'pmd_sunpath.CharacterActions'

sandhill_cave_entrance_ch_1 = {}

-------------------------------
--Cutscene functions
-------------------------------
--The cutscene for the Sandhill Cave dungeon before the team enters it.
function sandhill_cave_entrance_ch_1.Story_Cutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local marker = MRKR("Walk_In_Marker")
	UI:ResetSpeaker()
	GROUND:TeleportTo(hero, -30, 186, Direction.Right)
	GROUND:TeleportTo(partner, -30, 207, Direction.Right)
	AI:DisableCharacterAI(partner)
	GAME:CutsceneMode(true)
	
	GAME:FadeIn(120)
	GAME:WaitFrames(60)
	local coro1 = TASK:BranchCoroutine(function () GROUND:MoveToPosition(hero, 5, 186, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function () GAME:WaitFrames(10)
												   GROUND:MoveToPosition(partner, 5, 207, false, 1)
												   GAME:WaitFrames(10) end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function () GAME:WaitFrames(10)
											 GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											 GAME:WaitFrames(5) end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner, true)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue("Alright, we're here.")
	UI:WaitShowDialogue("What I forgot to mention is that this is a mystery dungeon, so please be careful.")
	GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Alright, here we go.")
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function () GROUND:MoveToPosition(partner, 325, 187, false, 1) end)
	coro2 = TASK:BranchCoroutine(function () GAME:WaitFrames(30)
											 GROUND:MoveToPosition(hero, 300, 187, false, 0.98)
											 GAME:WaitFrames(10) end)
	TASK:JoinCoroutines({coro1, coro2})
	GROUND:Hide('Teammate1')
	GAME:FadeOut(false, 20)
	GAME:WaitFrames(60)
	
	SV.Chapter1.TeamEnteredSandCave = true
	GAME:CutsceneMode(false)
	GAME:EnterDungeon("sandhill_cave", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
	
end

--Play this cutscene if you got wiped out in the cave
function sandhill_cave_entrance_ch_1.WipedInCave()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:CutsceneMode(true)
	GAME:MoveCamera(240, 192, 1, false)
	GROUND:TeleportTo(hero, 265, 185, Direction.Right)
	GROUND:TeleportTo(partner, 240, 185, Direction.Right)
	GROUND:CharSetAnim(hero, 'EventSleep', true)
	GROUND:CharSetAnim(partner, 'EventSleep', true)
	
	GAME:FadeIn(40)
	GAME:WaitFrames(120)
	local coro1 = TASK:BranchCoroutine(function () CharacterActions.DoAnimation(hero, 'Wake') end)
	local coro2 = TASK:BranchCoroutine(function () CharacterActions.DoAnimation(partner, 'Wake') end)
	TASK:JoinCoroutines({coro1, coro2})
	
	coro1 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function () CharacterActions.LookAround(hero, 2, 4, false, false, false, Direction.Left) end)
	coro2 = TASK:BranchCoroutine(function () GAME:WaitFrames(10) CharacterActions.LookAround(partner, 2, 4, false, false, false, Direction.Right) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion('Pain')
	CharacterActions.EmoteAndPause(partner, 'Sweating', true)	
	UI:WaitShowDialogue('Ow...No wonder why I was scared of exploring here...')
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion('Surprised')
	UI:WaitShowDialogue('' .. hero:GetDisplayName() .. '! Are you ok?')
	GAME:WaitFrames(20)
	UI:SetSpeaker(hero)
	UI:SetSpeakerEmotion('Worried')
	UI:WaitShowDialogue("Yeah, I'm fine...")
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion('Sigh')
	UI:WaitShowDialogue("That's good, I was afraid I got you hurt.")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion('Worried')
	UI:WaitShowDialogue("Seems like if either of us faints, then both of us get kicked out of the dungeon.")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Strange...I guess we'll have to find out why another time.")
	GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
	GAME:WaitFrames(40)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:WaitShowDialogue("Well, we shouldn't stay here. If it becomes late, the town will try to look for us.")
	UI:WaitShowDialogue("Let's give it another try. I'm sure we can do it this time.")
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 325, 187, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:MoveToPosition(partner, 300, 187, false, 1, 20) end)
	TASK:JoinCoroutines({coro1, coro2})
	GROUND:Hide('PLAYER')
	SOUND:FadeOutBGM()
	GAME:FadeOut(false, 20)
	GAME:WaitFrames(60)
	
	GAME:CutsceneMode(false)

	--sandhill cave re-attempt
	GAME:EnterDungeon("sandhill_cave", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
end 
