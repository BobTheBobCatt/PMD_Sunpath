--[[
  main.lua
  
  This file is loaded persistently.
  Its main purpose is to include anything that needs to stay persistently in the lua state.
  Things like services.
]]--

--------------------------------------------------------------------------------------------------------------
-- Service Packages
--------------------------------------------------------------------------------------------------------------
require 'pmd_sunpath.services.debug_tools'
require 'pmd_sunpath.services.menu_tools'
require 'pmd_sunpath.services.upgrade_tools'
require 'pmd_sunpath.services.config_tools'
require 'pmd_sunpath.missiongen_lib.missiongen_service'

math.randomseed(os.time())