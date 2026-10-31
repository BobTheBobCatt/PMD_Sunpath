CONFIG = {}

--Halcyon code, mostly
function CONFIG.InitializeAll()
SV.Settings = {
    Starters = 0,
    Tutorials = 0
}
end

--Halcyon code
function CONFIG.Initialize(config)
    SV.Settings = SV.Settings or {}
    SV.Settings[config] = SV.Settings[config] or 0
end

--Halcyon code
function CONFIG.RegularStarters()
    CONFIG.Initialize("Starters")
    return SV.Settings.Starters == 0
end

function CONFIG.DoTutorials()
    CONFIG.Initialize("Tutorials")
    return SV.Settings.Tutorials == 0
end