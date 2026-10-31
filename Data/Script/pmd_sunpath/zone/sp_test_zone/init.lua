require 'pmd_sunpath.common'

local sp_test_zone = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function sp_test_zone.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_sp_test_zone")
  

end

function sp_test_zone.AllyInteract(chara, target, zone)
  COMMON.DungeonInteract(chara, target, zone)
end

function sp_test_zone.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function sp_test_zone.ExitSegment(zone, result, rescue, segmentID, mapID)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  
end

return sp_test_zone