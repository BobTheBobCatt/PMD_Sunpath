require 'origin.common'
require 'pmd_sunpath.PartnerEssentials'
require 'pmd_sunpath.GeneralFunctions'
require 'pmd_sunpath.CharacterEssentials'

abandoned_crossroads_ch_1 = {}

-------------------------------
--Cutscene functions
-------------------------------
function qahil_village_entrnace_ch_1.Plot_Cutscene()
	GAME:CutsceneMode(true)
	local hero = CH('PLAYER')
	local marker = MRKR("AbandonedCrossroadsExitLocation")
	UI:ResetSpeaker()
	SOUND:FadeOutBGM()
	GROUND:TeleportTo(hero, marker.Position.X, marker.Position.Y, Direction.Right)
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	UI:SetSpeakerEmotion('Pain')
	UI:WaitShowDialogue("...[pause=0]Man...I have been walking for hours.[pause=0] Does this road ever end...?")
	
	GAME:FadeIn(120)
	GAME:WaitFrames(120)
	UI:ResetSpeaker()
	GROUND:MoveToPosition(hero, 225, 135, false, 1)
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue("")
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
	UI:WaitShowDialogue("")
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.UpLeft, 4)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("")
	GAME:WaitFrames(20)
	GROUND:MoveToPosition(hero, 189, 180, false, 1)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("")
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("")
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
	UI:WaitShowDialogue("")
	GAME:WaitFrames(20)
	GROUND:MoveToPosition(hero, -40, 175, false, 1)
	GAME:FadeOut(false, 20)
	GAME:WaitFrames(60)
	
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("qahil_village", "Main_Entrance_Marker")	
	
end
