require 'origin.common'
require 'pmd_sunpath.PartnerEssentials'
require 'pmd_sunpath.GeneralFunctions'
require 'pmd_sunpath.CharacterEssentials'

dusty_dune_ch_1 = {}

-------------------------------
--Cutscene functions
-------------------------------
function dusty_dune_ch_1.Intro_Cutscene()
	local partner = GAME:GetPlayerPartyMember(1)--and send the partner to assembly for now
	local partner2 = GAME:GetPlayerPartyMember(2)--and send the 2nd partner to assembly for now
	GAME:RemovePlayerTeam(2)
	GAME:AddPlayerAssembly(partner2)
	GAME:RemovePlayerTeam(1)
	GAME:AddPlayerAssembly(partner)
	--COMMON.RespawnAllies()

	GAME:CutsceneMode(true)
	local hero = CH('PLAYER')
	local marker = MRKR("WakeupLocation")
	UI:ResetSpeaker()
	SOUND:FadeOutBGM()
	GROUND:CharSetAnim(hero, 'Laying', true)
	GROUND:TeleportTo(hero, marker.Position.X, marker.Position.Y, Direction.Right)
	
	--set auto finish has it so the voiceover fades in and out as the complete line
	--rather than typing it out like in the personality quiz
	UI:SetAutoFinish(true)

	--chapter 1 title card
	local coro1 = TASK:BranchCoroutine(function() UI:WaitShowTitle("Chapter 1\n\nNewcomer\n", 20)
												  GAME:WaitFrames(180)
												  UI:WaitHideTitle(20) end)
	local coro2 = TASK:BranchCoroutine(function() UI:WaitShowBG("Chapter_1", 180, 20)
												  GAME:WaitFrames(180)
												  UI:WaitHideBG(20) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(180)
	
	
  	UI:WaitShowVoiceOver(".........", -1)  
	UI:WaitShowVoiceOver("...Others live, requiring the same needs but have different experiences...", -1) 
	UI:WaitShowVoiceOver("...Of which can define a personality of a being...", -1)  
	UI:WaitShowVoiceOver("...After all, the world is rarely ever fair.", -1)  
	UI:WaitShowVoiceOver("...In turn, some turn good, some turn indifferent, and some turn evil.", -1)  
	UI:WaitShowVoiceOver(".........", -1)  
	UI:WaitShowVoiceOver("So which are you?", -1) 
	
	UI:SetAutoFinish(false)
	
	GAME:WaitFrames(120)
	
	GAME:FadeIn(120)
	GAME:WaitFrames(120)
	UI:ResetSpeaker()
	GROUND:CharSetAnim(hero, 'Laying', true)
	GROUND:TeleportTo(hero, marker.Position.X, marker.Position.Y, Direction.Right)
	coro1 = TASK:BranchCoroutine(function () GAME:WaitFrames(20)
									GeneralFunctions.Shake(hero)
									GAME:WaitFrames(20)
									GeneralFunctions.DoAnimation(hero, 'Wake') 
									GAME:WaitFrames(20)
									GeneralFunctions.LookAround(hero, 3, 4, false, false, true, Direction.Down)
									GAME:WaitFrames(20) end)
	SOUND:PlayBGM('In The Depths of the Pit.ogg', true)
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue("(...[pause=0]Alright,[pause=0] seems like I am awake again.[pause=0] That's good, at least.)")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("(...[pause=0]I don't hear anyone,[pause=0] it seems kinda quiet, actually.)")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("(Staying here wouldn't be a good idea, though.[pause=0] I should get moving...)")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("(...[pause=0]Here's hoping that I can find someplace to stay soon...)")
	GAME:WaitFrames(20)
	GROUND:MoveToPosition(hero, 55, 190, false, 1)
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function () GAME:WaitFrames(20)
									GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
									GAME:WaitFrames(20)
									GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
									GAME:WaitFrames(20)
									GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
									GAME:WaitFrames(20)
									GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
									GAME:WaitFrames(20) end)
	UI:WaitShowDialogue("(...[pause=0]Alright, so no one is here for now. That can change, though. So I'll get out of here...)")
	GAME:WaitFrames(20)
	GROUND:MoveToPosition(hero, 55, 415, false, 1)
	GAME:FadeOut(false, 20)
	GAME:WaitFrames(60)
	
	SV.Chapter1.PlayedIntroCutscene = true
	SV.Chapter1.PlayerEnteredDune = true
	GAME:CutsceneMode(false)
	GAME:EnterDungeon("dusty_dune", 0, 4, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
	
end

----play this cutscene if you got wiped in the dune somehow
function dusty_dune_ch_1.WipedInDune()
	local hero = CH('PLAYER')	
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("dusty_dune")
	GAME:CutsceneMode(true)
	UI:ResetSpeaker()
	GROUND:TeleportTo(hero, 230, 345, Direction.Right)
	GROUND:CharSetAnim(hero, 'EventSleep', true)
	GAME:FadeIn(40)
	
	--wake up and look around
	GAME:WaitFrames(120)
	GeneralFunctions.DoAnimation(hero, 'Wake')
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
	GAME:WaitFrames(20)
	GeneralFunctions.LookAround(hero, 2, 4, false, false, false, Direction.Down)
	
	UI:SetSpeaker(hero)
	UI:SetSpeakerEmotion('Pain')
	GeneralFunctions.EmoteAndPause(hero, 'Sweating', true)
	
	UI:WaitShowDialogue('Ick... I got roughed up...')
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue('I got knocked out,[pause=10] so the dungeon sent me back to where I was...')
	UI:SetSpeakerEmotion('Pain')
	UI:WaitShowDialogue('Exploring or exiting can be difficult sometimes, why did I even come here...?')
	
	GAME:WaitFrames(40)
	GeneralFunctions.ShakeHead(hero, 4)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue("Alright.[pause=0] I think I'm ready to give it another shot.")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("I'm sure I can make it out this time.")
	
	GAME:WaitFrames(20)
	GROUND:MoveToPosition(hero, 230, 400, false, 1)
	SOUND:FadeOutBGM()
	GAME:FadeOut(false, 40)
	
	GAME:CutsceneMode(false)
	--dusty dune
	GAME:EnterDungeon("dusty_dune", 0, 4, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)

end 
