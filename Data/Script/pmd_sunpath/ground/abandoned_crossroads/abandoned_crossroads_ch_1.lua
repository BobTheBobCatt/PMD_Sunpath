require 'origin.common'
require 'pmd_sunpath.PartnerEssentials'
require 'pmd_sunpath.GeneralFunctions'
require 'pmd_sunpath.CharacterEssentials'

abandoned_crossroads_ch_1 = {}

-------------------------------
--Cutscene functions
-------------------------------
function abandoned_crossroads_ch_1.Plot_Cutscene()
	GAME:CutsceneMode(true)
	local hero = CH('PLAYER')
	local marker = MRKR("DustyDuneExitLocation")
	UI:ResetSpeaker()
	SOUND:FadeOutBGM()
	GROUND:TeleportTo(hero, marker.Position.X, marker.Position.Y, Direction.Right)
	
	GAME:FadeIn(120)
	GAME:WaitFrames(120)
	UI:ResetSpeaker()
	GROUND:MoveToPosition(hero, 225, 135, false, 1)
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue("...[pause=0]Wow, I forgot how tiring dungeon exploration can be. It's not like I had a choice, though...")
	GAME:WaitFrames(20)
	GROUND:MoveToPosition(hero, 225, 190, false, 1)
	coro1 = TASK:BranchCoroutine(function () GAME:WaitFrames(20)
									GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
									GAME:WaitFrames(20)
									GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
									GAME:WaitFrames(20)
									GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
									GAME:WaitFrames(20)
									GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
									GAME:WaitFrames(20) end)
	UI:WaitShowDialogue("(No one around for now. That can change at any time though, but they may be friendlier here...)")
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.UpLeft, 4)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("(Hmm, what is that...?)")
	GAME:WaitFrames(20)
	GROUND:MoveToPosition(hero, 189, 180, false, 1)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Bah, just some text I can't read. There is a shown direction though. I wonder what is there...?")
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("(I suppose it doesn't hurt to check it out. Must lead to somewhere if someone left it here.)")
	coro1 = TASK:BranchCoroutine(function () GAME:WaitFrames(20)
									GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
									GAME:WaitFrames(20)
									GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
									GAME:WaitFrames(20)
									GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
									GAME:WaitFrames(20)
									GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
									GAME:WaitFrames(20) end)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("(Alright, I suppose I can go check it out...)")
	GAME:WaitFrames(20)
	GROUND:MoveToPosition(hero, -40, 175, false, 1)
	GAME:FadeOut(false, 20)
	GAME:WaitFrames(60)
	
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("qahil_village_entrance", "Main_Entrance_Marker")	
	
end
