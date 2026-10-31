--[[
    Example Service
    
    This is an example to demonstrate how to use the BaseService class to implement a game service.
    
    **NOTE:** After declaring you service, you have to include your package inside the main.lua file!
]]--
require 'pmd_sunpath.common'
require 'origin.services.baseservice'
require 'origin.recruit_list'

--Declare class DebugTools
local DebugTools = Class('DebugTools', BaseService)

--[[---------------------------------------------------------------
    DebugTools:initialize()
      DebugTools class constructor
---------------------------------------------------------------]]
function DebugTools:initialize()
  BaseService.initialize(self)
  PrintInfo('DebugTools:initialize()')
end

--[[---------------------------------------------------------------
    DebugTools:__gc()
      DebugTools class gc method
      Essentially called when the garbage collector collects the service.
	  TODO: Currently causes issues.  debug later.
  ---------------------------------------------------------------]]
--function DebugTools:__gc()
--  PrintInfo('*****************DebugTools:__gc()')
--end

--[[---------------------------------------------------------------
    DebugTools:OnInit()
      Called on initialization of the script engine by the game!
---------------------------------------------------------------]]
function DebugTools:OnInit()
  assert(self, 'DebugTools:OnInit() : self is null!')
	PrintInfo("\n<!> DebugTools: Init..")
end

--[[---------------------------------------------------------------
    DebugTools:OnDeinit()
      Called on de-initialization of the script engine by the game!
---------------------------------------------------------------]]
function DebugTools:OnDeinit()
  assert(self, 'DebugTools:OnDeinit() : self is null!')
  PrintInfo("\n<!> DebugTools: Deinit..")
end


--[[---------------------------------------------------------------
    DebugTools:OnNewGame()
      When a debug save file is loaded this is called!
---------------------------------------------------------------]]
--Version for testing current story progression
function DebugTools:OnNewGame()
  assert(self, 'DebugTools:OnNewGame() : self is null!')
  
  if _DATA.Save.ActiveTeam.Players.Count > 0 then
     local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("HeroInteract")
    _DATA.Save.ActiveTeam.Players[0].ActionEvents:Add(talk_evt)
	_DATA.Save:RegisterMonster(_DATA.Save.ActiveTeam.Players[0].BaseForm.Species)
	
	_DATA.Save.ActiveTeam:SetRank("normal")
	if not GAME:InRogueMode() then
      _DATA.Save.ActiveTeam.Bank = 1000
	end
  else	
		PrintInfo("\n<!> ExampleSvc: Preparing debug save file")
	  _DATA.Save.ActiveTeam:SetRank("none")
	  _DATA.Save.ActiveTeam.Name = "Telvanni"
	  _DATA.Save.ActiveTeam.Money = 1000
	  _DATA.Save.ActiveTeam.Bank = 999999
	  _DATA.Save.NoSwitching = true--switching is not allowed

	  
	  local mon_id = RogueEssence.Dungeon.MonsterID("sprigatito", 0, "normal", Gender.Male)
	  local p = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 5, "", 0)
	  local tbl = LTBL(p)
	  tbl.Importance = 'Hero'
	  p.IsFounder = true
	  p.IsPartner = true
	  p.Nickname = 'Sprigatito'
	  _DATA.Save.ActiveTeam.Players:Add(p)
	  
	  mon_id = RogueEssence.Dungeon.MonsterID("fennekin", 0, "normal", Gender.Male)
	  p = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 5, "", 0)
	  tbl = LTBL(p)
	  tbl.Importance = 'Partner'
	  p.IsFounder = true
	  p.IsPartner = true
	  p.Nickname = 'Fennekin'
	  _DATA.Save.ActiveTeam.Players:Add(p)
	  
	  _DATA.Save.ActiveTeam:SetRank("bronze")

	  talk_evt = RogueEssence.Dungeon.BattleScriptEvent("HeroInteract")
	  _DATA.Save.ActiveTeam.Players[0].ActionEvents:Add(talk_evt)
	  talk_evt = RogueEssence.Dungeon.BattleScriptEvent("PartnerInteract")
	  _DATA.Save.ActiveTeam.Players[1].ActionEvents:Add(talk_evt)
		
	  --Placeholder code from Halcyon for if I decide to do something like this at a later point.
	  --mon_id = RogueEssence.Dungeon.MonsterID("zigzagoon", 0, "normal", Gender.Female)
	  --_DATA.Save.ActiveTeam.Players:Add(_DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id,100, "", 0))
	  --_DATA.Save.ActiveTeam.Players[3].Nickname = 'Almotz'
	 
	    _DATA.Save.ActiveTeam:SetRank("bronze")
	    _DATA.Save:UpdateTeamProfile(true)
		SV.ChapterProgression.UnlockedAssembly = true
		SV.ChapterProgression.Chapter = 1  
		
		
		local dungeon_keys = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:GetOrderedKeys(false)
		for ii = 0, dungeon_keys.Count-1 ,1 do
			GAME:UnlockDungeon(dungeon_keys[ii])
		end
	  
	  SV.base_camp.ExpositionComplete = true
	  SV.base_camp.IntroComplete = true
	end 
end

--Version for testing early game dungeons
--[[function DebugTools:OnNewGame()
  assert(self, 'DebugTools:OnNewGame() : self is null!')
  
  if _DATA.Save.ActiveTeam.Players.Count > 0 then
     local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("HeroInteract")
    _DATA.Save.ActiveTeam.Players[0].ActionEvents:Add(talk_evt)
	_DATA.Save:RegisterMonster(_DATA.Save.ActiveTeam.Players[0].BaseForm.Species)
	
	_DATA.Save.ActiveTeam:SetRank("normal")
	if not GAME:InRogueMode() then
      _DATA.Save.ActiveTeam.Bank = 1000
	end
  else	
		PrintInfo("\n<!> ExampleSvc: Preparing debug save file")
	  _DATA.Save.ActiveTeam:SetRank("none")
	  _DATA.Save.ActiveTeam.Name = "Telvanni"
	  _DATA.Save.ActiveTeam.Money = 1000
	  _DATA.Save.ActiveTeam.Bank = 999999
	  _DATA.Save.NoSwitching = true--switching is not allowed

	  
	  local mon_id = RogueEssence.Dungeon.MonsterID("sprigatito", 0, "normal", Gender.Male)
	  local p = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 5, "", 0)
	  local tbl = LTBL(p)
	  tbl.Importance = 'Hero'
	  p.IsFounder = true
	  p.IsPartner = true
	  p.Nickname = 'Sprigatito'
	  _DATA.Save.ActiveTeam.Players:Add(p)
	  
	  mon_id = RogueEssence.Dungeon.MonsterID("fennekin", 0, "normal", Gender.Male)
	  p = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 5, "", 0)
	  tbl = LTBL(p)
	  tbl.Importance = 'Partner'
	  p.IsFounder = true
	  p.IsPartner = true
	  p.Nickname = 'Fennekin'
	  _DATA.Save.ActiveTeam.Players:Add(p)
	  
	  mon_id = RogueEssence.Dungeon.MonsterID("misdreavus", 0, "normal", Gender.Female)
	  p = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 5, "", 0)
	  tbl = LTBL(p)
	  tbl.Importance = 'Partner2'
	  p.IsFounder = true
	  p.IsPartner = true
	  p.Nickname = 'Misdreavus'
	  _DATA.Save.ActiveTeam.Players:Add(p)
	  
	  _DATA.Save.ActiveTeam:SetRank("bronze")

	  talk_evt = RogueEssence.Dungeon.BattleScriptEvent("HeroInteract")
	  _DATA.Save.ActiveTeam.Players[0].ActionEvents:Add(talk_evt)
	  talk_evt = RogueEssence.Dungeon.BattleScriptEvent("PartnerInteract")
	  _DATA.Save.ActiveTeam.Players[1].ActionEvents:Add(talk_evt)
	  talk_evt = RogueEssence.Dungeon.BattleScriptEvent("Partner2Interact")
	  _DATA.Save.ActiveTeam.Players[2].ActionEvents:Add(talk_evt)
	 
	    _DATA.Save.ActiveTeam:SetRank("bronze")
	    _DATA.Save:UpdateTeamProfile(true)
		SV.ChapterProgression.UnlockedAssembly = true
		SV.ChapterProgression.Chapter = 1
		
		
		local dungeon_keys = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:GetOrderedKeys(false)
		for ii = 0, dungeon_keys.Count-1 ,1 do
			GAME:UnlockDungeon(dungeon_keys[ii])
		end
	  
	  SV.base_camp.ExpositionComplete = true
	  SV.base_camp.IntroComplete = true
	end 
end]]

--Version for testing mid-game dungeons
--[[function DebugTools:OnNewGame()
  assert(self, 'DebugTools:OnNewGame() : self is null!')
  
  if _DATA.Save.ActiveTeam.Players.Count > 0 then
     local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("HeroInteract")
    _DATA.Save.ActiveTeam.Players[0].ActionEvents:Add(talk_evt)
	_DATA.Save:RegisterMonster(_DATA.Save.ActiveTeam.Players[0].BaseForm.Species)
	
	_DATA.Save.ActiveTeam:SetRank("normal")
	if not GAME:InRogueMode() then
      _DATA.Save.ActiveTeam.Bank = 1000
	end
  else	
		PrintInfo("\n<!> ExampleSvc: Preparing debug save file")
	  _DATA.Save.ActiveTeam:SetRank("none")
	  _DATA.Save.ActiveTeam.Name = "Telvanni"
	  _DATA.Save.ActiveTeam.Money = 1000
	  _DATA.Save.ActiveTeam.Bank = 999999
	  _DATA.Save.NoSwitching = true--switching is not allowed

	  
	  local mon_id = RogueEssence.Dungeon.MonsterID("floragato", 0, "normal", Gender.Male)
	  local p = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 30, "", 0)
	  local tbl = LTBL(p)
	  tbl.Importance = 'Hero'
	  p.IsFounder = true
	  p.IsPartner = true
	  p.Nickname = 'Floragato'
	  _DATA.Save.ActiveTeam.Players:Add(p)
	  
	  mon_id = RogueEssence.Dungeon.MonsterID("braixen", 0, "normal", Gender.Male)
	  p = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 30, "", 0)
	  tbl = LTBL(p)
	  tbl.Importance = 'Partner'
	  p.IsFounder = true
	  p.IsPartner = true
	  p.Nickname = 'Braixen'
	  _DATA.Save.ActiveTeam.Players:Add(p)
	  
	  mon_id = RogueEssence.Dungeon.MonsterID("mismagius", 0, "normal", Gender.Female)
	  p = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 30, "", 0)
	  tbl = LTBL(p)
	  tbl.Importance = 'Partner2'
	  p.IsFounder = true
	  p.IsPartner = true
	  p.Nickname = 'Mismagius'
	  _DATA.Save.ActiveTeam.Players:Add(p)
	  
	  _DATA.Save.ActiveTeam:SetRank("bronze")

	  talk_evt = RogueEssence.Dungeon.BattleScriptEvent("HeroInteract")
	  _DATA.Save.ActiveTeam.Players[0].ActionEvents:Add(talk_evt)
	  talk_evt = RogueEssence.Dungeon.BattleScriptEvent("PartnerInteract")
	  _DATA.Save.ActiveTeam.Players[1].ActionEvents:Add(talk_evt)
	  talk_evt = RogueEssence.Dungeon.BattleScriptEvent("Partner2Interact")
	  _DATA.Save.ActiveTeam.Players[2].ActionEvents:Add(talk_evt)
	 
	    _DATA.Save.ActiveTeam:SetRank("bronze")
	    _DATA.Save:UpdateTeamProfile(true)
		SV.ChapterProgression.UnlockedAssembly = true
		SV.ChapterProgression.Chapter = 1  
		
		
		local dungeon_keys = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:GetOrderedKeys(false)
		for ii = 0, dungeon_keys.Count-1 ,1 do
			GAME:UnlockDungeon(dungeon_keys[ii])
		end
	  
	  SV.base_camp.ExpositionComplete = true
	  SV.base_camp.IntroComplete = true
	end 
end]]

--Version for testing late-game dungeons
--[[function DebugTools:OnNewGame()
  assert(self, 'DebugTools:OnNewGame() : self is null!')
  
  if _DATA.Save.ActiveTeam.Players.Count > 0 then
     local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("HeroInteract")
    _DATA.Save.ActiveTeam.Players[0].ActionEvents:Add(talk_evt)
	_DATA.Save:RegisterMonster(_DATA.Save.ActiveTeam.Players[0].BaseForm.Species)
	
	_DATA.Save.ActiveTeam:SetRank("normal")
	if not GAME:InRogueMode() then
      _DATA.Save.ActiveTeam.Bank = 1000
	end
  else	
		PrintInfo("\n<!> ExampleSvc: Preparing debug save file")
	  _DATA.Save.ActiveTeam:SetRank("none")
	  _DATA.Save.ActiveTeam.Name = "Telvanni"
	  _DATA.Save.ActiveTeam.Money = 1000
	  _DATA.Save.ActiveTeam.Bank = 999999
	  _DATA.Save.NoSwitching = true--switching is not allowed

	  
	  local mon_id = RogueEssence.Dungeon.MonsterID("meowscarada", 0, "normal", Gender.Male)
	  local p = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 50, "", 0)
	  local tbl = LTBL(p)
	  tbl.Importance = 'Hero'
	  p.IsFounder = true
	  p.IsPartner = true
	  p.Nickname = 'Meowscarada'
	  _DATA.Save.ActiveTeam.Players:Add(p)
	  
	  mon_id = RogueEssence.Dungeon.MonsterID("delphox", 0, "normal", Gender.Male)
	  p = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 50, "", 0)
	  tbl = LTBL(p)
	  tbl.Importance = 'Partner'
	  p.IsFounder = true
	  p.IsPartner = true
	  p.Nickname = 'Delphox'
	  _DATA.Save.ActiveTeam.Players:Add(p)
	  
	  mon_id = RogueEssence.Dungeon.MonsterID("mismagius", 0, "normal", Gender.Female)
	  p = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 50, "", 0)
	  tbl = LTBL(p)
	  tbl.Importance = 'Partner2'
	  p.IsFounder = true
	  p.IsPartner = true
	  p.Nickname = 'Mismagius'
	  _DATA.Save.ActiveTeam.Players:Add(p)
	  
	  _DATA.Save.ActiveTeam:SetRank("bronze")

	  talk_evt = RogueEssence.Dungeon.BattleScriptEvent("HeroInteract")
	  _DATA.Save.ActiveTeam.Players[0].ActionEvents:Add(talk_evt)
	  talk_evt = RogueEssence.Dungeon.BattleScriptEvent("PartnerInteract")
	  _DATA.Save.ActiveTeam.Players[1].ActionEvents:Add(talk_evt)
	  talk_evt = RogueEssence.Dungeon.BattleScriptEvent("Partner2Interact")
	  _DATA.Save.ActiveTeam.Players[2].ActionEvents:Add(talk_evt)
	 
	    _DATA.Save.ActiveTeam:SetRank("bronze")
	    _DATA.Save:UpdateTeamProfile(true)
		SV.ChapterProgression.UnlockedAssembly = true
		SV.ChapterProgression.Chapter = 1 
		
		
		local dungeon_keys = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:GetOrderedKeys(false)
		for ii = 0, dungeon_keys.Count-1 ,1 do
			GAME:UnlockDungeon(dungeon_keys[ii])
		end
	  
	  SV.base_camp.ExpositionComplete = true
	  SV.base_camp.IntroComplete = true
	end 
end]]

--Version for testing early story dungeons without the second partner
--[[function DebugTools:OnNewGame()
  assert(self, 'DebugTools:OnNewGame() : self is null!')
  
  if _DATA.Save.ActiveTeam.Players.Count > 0 then
     local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("HeroInteract")
    _DATA.Save.ActiveTeam.Players[0].ActionEvents:Add(talk_evt)
	_DATA.Save:RegisterMonster(_DATA.Save.ActiveTeam.Players[0].BaseForm.Species)
	
	_DATA.Save.ActiveTeam:SetRank("normal")
	if not GAME:InRogueMode() then
      _DATA.Save.ActiveTeam.Bank = 1000
	end
  else	
		PrintInfo("\n<!> ExampleSvc: Preparing debug save file")
	  _DATA.Save.ActiveTeam:SetRank("none")
	  _DATA.Save.ActiveTeam.Name = "Telvanni"
	  _DATA.Save.ActiveTeam.Money = 1000
	  _DATA.Save.ActiveTeam.Bank = 999999
	  _DATA.Save.NoSwitching = true--switching is not allowed

	  
	  local mon_id = RogueEssence.Dungeon.MonsterID("sprigatito", 0, "normal", Gender.Male)
	  local p = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 5, "", 0)
	  local tbl = LTBL(p)
	  tbl.Importance = 'Hero'
	  p.IsFounder = true
	  p.IsPartner = true
	  p.Nickname = 'Sprigatito'
	  _DATA.Save.ActiveTeam.Players:Add(p)
	  
	  mon_id = RogueEssence.Dungeon.MonsterID("fennekin", 0, "normal", Gender.Male)
	  p = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 5, "", 0)
	  tbl = LTBL(p)
	  tbl.Importance = 'Partner'
	  p.IsFounder = true
	  p.IsPartner = true
	  p.Nickname = 'Fennekin'
	  _DATA.Save.ActiveTeam.Players:Add(p)
	  
	  _DATA.Save.ActiveTeam:SetRank("bronze")

	  talk_evt = RogueEssence.Dungeon.BattleScriptEvent("HeroInteract")
	  _DATA.Save.ActiveTeam.Players[0].ActionEvents:Add(talk_evt)
	  talk_evt = RogueEssence.Dungeon.BattleScriptEvent("PartnerInteract")
	  _DATA.Save.ActiveTeam.Players[1].ActionEvents:Add(talk_evt)
	 
	    _DATA.Save.ActiveTeam:SetRank("bronze")
	    _DATA.Save:UpdateTeamProfile(true)
		SV.ChapterProgression.UnlockedAssembly = true
		SV.ChapterProgression.Chapter = 1  
		
		
		local dungeon_keys = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:GetOrderedKeys(false)
		for ii = 0, dungeon_keys.Count-1 ,1 do
			GAME:UnlockDungeon(dungeon_keys[ii])
		end
	  
	  SV.base_camp.ExpositionComplete = true
	  SV.base_camp.IntroComplete = true
	end 
end]]




--Reset most variables to their default if they don't exist
--This needs to be upkept whenever I add new variables to the game.
--Yanderedev ftw
function DebugTools:OnUpgrade()
  assert(self, 'DebugTools:OnUpgrade() : self is null!')
  
  PrintInfo("=>> Loading version")

--Placeholder variables from Halcyon; These will be changed at a later time.
--daily flags
 --[[if SV.DailyFlags.RedMerchantItem == nil then SV.DailyFlags.RedMerchantItem = "" end
 if SV.DailyFlags.RedMerchantBought == nil then SV.DailyFlags.RedMerchantBought = false end
 if SV.DailyFlags.GreenMerchantItem == nil then SV.DailyFlags.GreenMerchantItem = "" end
 if SV.DailyFlags.GreenMerchantBought == nil then SV.DailyFlags.GreenMerchantBought = false end
 if SV.DailyFlags.GreenKecleonRefreshedStock == nil then SV.DailyFlags.GreenKecleonRefreshedStock = false end
 if SV.DailyFlags.GreenKecleonStock == nil then SV.DailyFlags.GreenKecleonStock = {} end
 if SV.DailyFlags.PurpleKecleonRefreshedStock == nil then SV.DailyFlags.PurpleKecleonRefreshedStock = false end
 if SV.DailyFlags.PurpleKecleonStock == nil then SV.DailyFlags.PurpleKecleonStock = {} end]]

--temporary flags
 if SV.TemporaryFlags.OldDirection == nil then SV.TemporaryFlags.OldDirection = Direction.None end
 if SV.TemporaryFlags.Dinnertime == nil then SV.TemporaryFlags.Dinnertime = false end 
 if SV.TemporaryFlags.Bedtime == nil then SV.TemporaryFlags.Bedtime = false end
 if SV.TemporaryFlags.MorningWakeup == nil then SV.TemporaryFlags.MorningWakeup = false end
 if SV.TemporaryFlags.MorningAddress == nil then SV.TemporaryFlags.MorningAddress = false end 
 if SV.TemporaryFlags.JustWokeUp == nil then SV.TemporaryFlags.JustWokeUp = false end 
 if SV.TemporaryFlags.LastDungeonEntered == nil then SV.TemporaryFlags.LastDungeonEntered = '' end
 if SV.TemporaryFlags.MissionCompleted == nil then SV.TemporaryFlags.MissionCompleted = false end
 if SV.TemporaryFlags.PostJobsGround == nil then SV.TemporaryFlags.PostJobsGround = '' end
 if SV.TemporaryFlags.AudinoSummonCount == nil then SV.TemporaryFlags.AudinoSummonCount = 0 end
 
 
 if SV.adventure == nil then SV.adventure = {} end
 if SV.adventure.Thief == nil then SV.adventure.Thief = false end
  

 --Placeholder variables from Halcyon; These will be changed at a later time.
 --[[if SV.metano_cafe.CafeSpecial == nil then SV.metano_cafe.CafeSpecial = "" end
 if SV.metano_cafe.BoughtSpecial == nil then SV.metano_cafe.BoughtSpecial = false end
 if SV.metano_cafe.FermentedItem == nil then SV.metano_cafe.FermentedItem = "" end
 if SV.metano_cafe.ItemFinishedFermenting == nil then SV.metano_cafe.ItemFinishedFermenting = false end
 if SV.metano_cafe.NewDrinkUnlocked == nil then SV.metano_cafe.NewDrinkUnlocked = false end]]
  
  
 --Placeholder variables from Halcyon; These will be changed at a later time.
 --[[if SV.Dojo.LessonCompletedGeneric == nil then SV.Dojo.LessonCompletedGeneric = false end
 if SV.Dojo.TrainingCompletedGeneric == nil then SV.Dojo.TrainingCompletedGeneric = false end
 if SV.Dojo.TrialCompletedGeneric == nil then SV.Dojo.TrialCompletedGeneric = false end
 if SV.Dojo.LessonFailedGeneric == nil then SV.Dojo.LessonFailedGeneric = false end
 if SV.Dojo.TrainingFailedGeneric == nil then SV.Dojo.TrainingFailedGeneric = false end
 if SV.Dojo.TrialFailedGeneric == nil then SV.Dojo.TrialFailedGeneric = false end
 if SV.Dojo.NewMazeUnlocked == nil then SV.Dojo.NewMazeUnlocked = false end
 if SV.Dojo.NewLessonUnlocked == nil then SV.Dojo.NewLessonUnlocked = false end
 if SV.Dojo.NewTrialUnlocked == nil then SV.Dojo.NewTrialUnlocked = false end
 if SV.Dojo.SkippedTutorialNotifiedTeamMode == nil then SV.Dojo.SkippedTutorialNotifiedTeamMode = false end
 if SV.Dojo.LastZone == nil then SV.Dojo.LastZone = "master_zone" end]]
  
  
 if SV.ChapterProgression.DaysPassed == nil then SV.ChapterProgression.DaysPassed = 0 end 
 if SV.ChapterProgression.DaysToReach == nil then SV.ChapterProgression.DaysToReach = -1 end 
 if SV.ChapterProgression.Chapter == nil then SV.ChapterProgression.Chapter = 1 end 
 if SV.ChapterProgression.CurrentStoryDungeon == nil then SV.ChapterProgression.CurrentStoryDungeon = "" end 
 if SV.ChapterProgression.UnlockedAssembly == nil then SV.ChapterProgression.UnlockedAssembly = false end 
 
 
 if SV.adventure == nil then SV.adventure = {} end 
 if SV.adventure.Thief == nil then SV.adventure.Thief = false end
 
 if SV.DungeonFlags.GenericEnding == nil then SV.DungeonFlags.GenericEnding = false end
 
 
 --Placeholder dungeons from Halcyon; These will be changed at a later time.
 --dungeon unlocks that didnt exist for old versions
--[[if SV.ChapterProgression.Chapter >= 3 and not GAME:DungeonUnlocked("crooked_cavern") then
	GAME:UnlockDungeon("grass_maze")--unlock new mazes at ledian dojo
	GAME:UnlockDungeon("fire_maze")--unlock new mazes at ledian dojo
	GAME:UnlockDungeon("water_maze")--unlock new mazes at ledian dojo
	GAME:UnlockDungeon("crooked_cavern")--unlock chapter 3 dungeon
	SV.Dojo.NewMazeUnlocked = true
end]]	
 
 --set current story dungeon in case current one is not accurate
 --[[if SV.ChapterProgression.Chapter == 3 and not SV.Chapter3.DefeatedBoss then
 	SV.ChapterProgression.CurrentStoryDungeon = "crooked_cavern" -- Crooked Cavern
 end]] 
 
 
 if SV.DestinationFloorNotified == nil then SV.DestinationFloorNotified = false end
 if SV.MonsterHouseMessageNotified == nil then SV.MonsterHouseMessageNotified = false end
 if SV.OutlawDefeated == nil then SV.OutlawDefeated = false end
 if SV.OutlawGoonsDefeated == nil then SV.OutlawGoonsDefeated = false end
 if SV.OutlawItemPickedUp == nil then SV.OutlawItemPickedUp = false end

 if SV.TakenBoard == nil then
	SV.TakenBoard =
	{
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = "",
			BackReference = -1
		},
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = "",
			BackReference = -1
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = "",
			BackReference = -1
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = "",
			BackReference = -1
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = "",
			BackReference = -1
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = "",
			BackReference = -1
		},
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = "",
			BackReference = -1
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = "",
			BackReference = -1
		}

	}
	end 
	
	if SV.MissionBoard == nil then
		SV.MissionBoard =
		{
			{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
		},
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
		},
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
		}

	}
	end
	
	if SV.OutlawBoard == nil then
		SV.OutlawBoard =
		{
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
		},
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
		},
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
		}
	}
	end
 
  PrintInfo("=>> Loaded version")
end

--[[---------------------------------------------------------------
    DebugTools:OnLossPenalty()
      Called when the player fails a dungeon in main progress
  ---------------------------------------------------------------]]
function DebugTools:OnLossPenalty(save) 
  assert(self, 'DebugTools:OnLossPenalty() : self is null!')
 
  --remove money. You'll keep 15-25% of what you had. Thieves keep nothing
  local remainder = math.random(1500, 2500) 
  if SV.adventure.Thief then remainder = 0 end
  save.ActiveTeam.Money = math.floor((save.ActiveTeam.Money * remainder) / 10000)
 

  local inv_count = save.ActiveTeam:GetInvCount() - 1
  --remove bag items
  for i = inv_count, 0, -1 do
    local entry = _DATA:GetItem(save.ActiveTeam:GetInv(i).ID)
    if not entry.CannotDrop then
		if math.random(1, 4) > 1 or SV.adventure.Thief then --1/4 chance an individual item will be kept. Thieves keep NOTHING
			save.ActiveTeam:RemoveFromInv(i)
		end
    end
  end
  
  --DO NOT remove equips unless the player was a thief
  
  if SV.adventure.Thief then
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
  
end

-- function DebugTools:OnDungeonMapInit(mapname, mapobj)
-- 	if GAME:GetPlayerPartyCount() > 1 then
-- 		local partner = GAME:GetPlayerPartyMember(1)
-- 		local tbl = LTBL(partner)
-- 		if tbl.MissionType == COMMON.MISSION_BOARD_OUTLAW then
-- 			local origin = _DATA.Save.ActiveTeam.Leader.CharLoc
-- 			local radius = 2
-- 			local mission_num = tbl.MissionNumber
-- 			SpawnOutlaw(origin, radius, mission_num)
-- 		end
-- 	end
-- end

---Summary
-- Subscribe to all channels this service wants callbacks from
function DebugTools:Subscribe(med)
  med:Subscribe("DebugTools", EngineServiceEvents.Init,                function() self.OnInit(self) end )
  med:Subscribe("DebugTools", EngineServiceEvents.Deinit,              function() self.OnDeinit(self) end )
  med:Subscribe("DebugTools", EngineServiceEvents.NewGame,        function() self.OnNewGame(self) end )
  med:Subscribe("DebugTools", EngineServiceEvents.UpgradeSave,        function() self.OnUpgrade(self) end )
  med:Subscribe("DebugTools", EngineServiceEvents.LossPenalty,        function(_, args) self.OnLossPenalty(self, args[0]) end )
	-- med:Subscribe("DebugTools", EngineServiceEvents.DungeonMapInit,        function(_, args) self.OnDungeonMapInit(self, args[0], args[1]) end )
  --  med:Subscribe("DebugTools", EngineServiceEvents.GraphicsUnload,      function() self.OnGraphicsUnload(self) end )
  --  med:Subscribe("DebugTools", EngineServiceEvents.Restart,             function() self.OnRestart(self) end )
end

---Summary
-- un-subscribe to all channels this service subscribed to
function DebugTools:UnSubscribe(med)
end

---Summary
-- The update method is run as a coroutine for each services.
function DebugTools:Update(gtime)
--  while(true)
--    coroutine.yield()
--  end
end

--Add our service
SCRIPT:AddService("DebugTools", DebugTools:new())
return DebugTools