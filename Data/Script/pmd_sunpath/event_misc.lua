require 'pmd_sunpath.common'

--------------------------
--Halcyon scripts
--------------------------

function GROUND_ITEM_EVENT_SCRIPT.GroundWonderGummiEvent(context, args)
  -- { Heal = 20, Msg = true, Change = 2, BoostedStat = "none" }
  GROUND_ITEM_EVENT_SCRIPT.GroundVitaminEvent(context, args)
  GROUND_ITEM_EVENT_SCRIPT.GroundRestoreBellyEvent(context, args)
end

-- Reimplementation of the RestoreBellyEvent (BattleEvent) in PMDC.Dungeon but for ground usage
function GROUND_ITEM_EVENT_SCRIPT.GroundRestoreBellyEvent(context, args)

  local MIN_MAX_FULLNESS = 50;
  local MAX_MAX_FULLNESS = 150;

  local heal = args.Heal
  local msg = args.Msg
  local add_max_belly = args.AddMaxBelly
  local need_full_belly = args.NeedFullBelly

  if add_max_belly == nil then add_max_belly = 0 end

  local full_belly = context.User.Fullness == context.User.MaxFullness

  context.User.Fullness = context.User.Fullness + heal

  if heal < 0 then
    if msg then
      if context.User.Fullness <= 0 then
        UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_HUNGER_EMPTY"):ToLocal(), context.User:GetDisplayName(true)))
      else
        UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_HUNGER_DROP"):ToLocal(), context.User:GetDisplayName(false)))
      end
    end
    --SOUND:PlayBattleSE("DUN_Hunger")
  else
    if msg then
      UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_HUNGER_FILL"):ToLocal(), context.User:GetDisplayName(false)))
    end
  end

  if add_max_belly ~= 0 and (full_belly or not need_full_belly) then
    if msg then
      if add_max_belly < 0 then
        UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_MAX_HUNGER_DROP"):ToLocal(), context.User:GetDisplayName(false)))
      else
        UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_MAX_HUNGER_BOOST"):ToLocal(), context.User:GetDisplayName(false)))
      end
    end

    context.User.MaxFullness = context.User.MaxFullness + add_max_belly
    if context.User.MaxFullness < MIN_MAX_FULLNESS then
      context.User.MaxFullness = MIN_MAX_FULLNESS
    end

    if context.User.MaxFullness > MAX_MAX_FULLNESS then
      context.User.MaxFullness = MAX_MAX_FULLNESS
    end
  end

  if context.User.Fullness < 0 then
    context.User.Fullness = 0
  end

  if context.User.Fullness >= context.User.MaxFullness then
    context.User.Fullness = context.User.MaxFullness
    context.User.FullnessRemainder = 0
  end
end

function GROUND_ITEM_EVENT_SCRIPT.GroundVitaminEvent(context, args)
  local lookup_table = {}

  lookup_table["hp"] = RogueEssence.Data.Stat.HP
  lookup_table["attack"] = RogueEssence.Data.Stat.Attack
  lookup_table["defense"] = RogueEssence.Data.Stat.Defense
  lookup_table["special_attack"] = RogueEssence.Data.Stat.MAtk
  lookup_table["special_defense"] = RogueEssence.Data.Stat.MDef
  lookup_table["speed"] = RogueEssence.Data.Stat.Speed
  lookup_table["none"] = RogueEssence.Data.Stat.None

  assert(lookup_table[args.BoostedStat] ~= nil, "Stat type needs to be initialized")
  assert(args.Change ~= nil, "Change amount needs to be initialized")
  local sound = ""
  if args.Sound == nil then
    sound = "DUN_Drink"
  else
    sound = args.Sound
  end

  local boosted = false
  local boosted_stat = lookup_table[args.BoostedStat]
  local change = args.Change

  UI:ResetSpeaker()
  SOUND:PlayBattleSE(sound)
  if boosted_stat ~= RogueEssence.Data.Stat.None then
    boosted = boosted or BoostStat(boosted_stat, change, context.User)
  else
    boosted = BoostStat(RogueEssence.Data.Stat.HP, change, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.Attack, change, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.Defense, change, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.MAtk, change, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.MDef, change, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.Speed, change, context.User) or boosted
  end

  if not boosted then
    UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_NOTHING_HAPPENED"):ToLocal()))
  end
end

--------------------------
--Sunpath scripts
--------------------------


