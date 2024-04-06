-- //  Made by Paint (x1_EE) - The Happy Meal Guy
-- //  If large logic statements are present, they have been chopped into multiple lines

local GITHUB = "https://raw.githubusercontent.com"
local PSTBIN = "https://pastebin.com/raw"

local URLs = {
    UILib = GITHUB .. "/UI-Interface/CustomFIeld/main/RayField.lua",
}

local UILibrary = loadstring(game:HttpGet(URLs.UILib))()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Character = Player.Character
local Humanoid = Character.Humanoid
local HumanoidRootPart = Character.HumanoidRootPart

local AnnounceInteractions = true

local PlayerFlames = Workspace.PlayerFlames
local Particles = Workspace.Particles
local Balloons = Workspace.Balloons
local FieldDecos = Workspace:FindFirstChild("FieldDecos")
local Decorations = Workspace:FindFirstChild("Decorations")

local CoreStats = Player.CoreStats

local Window = UILibrary:CreateWindow({
    Name = "MacroX",
    LoadingTitle = "MacroX by Paint",
    LoadingSubtitle = "Well hello there, sir.",
})

-- //  print(game.Players.LocalPlayer.CoreStats.Pollen.Value)
-- //  print(game.Players.LocalPlayer.CoreStats.Capacity.Value)
-- //  print(game.Players.LocalPlayer.CoreStats.Honey.Value)

shared.MacroX = {
    Version = "1.0.0",
    HoneyAtStart = Player.CoreStats.Honey.Value,
    Magnitude = 50,
    
    CurrentField = "",

    IsConverting = false,
    IsFarming = true,
    IsTravelling = false,

    TravellingTo = "Hives",

    Detection = {
        Vicious = false,
        Puffshrooms = false,
    },

    Farming = { -- // code layout/buttons done, still needs to be coded
        Tool = false, ToolCache = false,
        Tokens = false, TokensCache = false,
        Flames = false, FlamesCache = false,
        Bubbles = false, BubblesCache = false,
        Fuzzy = false, FuzzyCache = false,
        Crosshairs = false, CrosshairsCache = false,

        ConvertAtHive = false,
        ConvertBalloon = false,
    },

    Consumables = { -- // code layout/buttons done, still needs to be coded
        Enzymes = false,
        Oil = false,
        Glue = false,
        RedExtract = false,
        BlueExtract = false,
        PurplePotion = false,
        TropicalDrink = false,
        SuperSmoothie = false,
    },

    Crosshair = {
        Crosshair = false,
        Crosshairs = {},
    },

    Toys = { -- // code layout/buttons done, still needs to be coded
        WealthClock = false,
        RedFieldBooster = false,
        BlueFieldBooster = false,
        MountainTopFieldBooster = false,
        StrawberryDispenser = false,
        BlueberryDispenser = false,
        GlueDispenser = false,
        RoyalJellyDispenser = false,
    },

    BeesmasToys = { -- // code layout/buttons done, still needs to be coded
        Samovar = false,
        Stockings = false,
        HoneyWreath = false,
        HoneyCandles = false,
        BeesmasFeast = false,
        OnettsLidArt = false,
        Snowflakes = false,
    },

    Combat = {
        BugRun = false,
        Crab = false,
        Snail = false,
        Commando = false,
    },

    Misc = {},

    Importance = {
        PriorityIDs = {},
        BlacklistedIDs = {},
    },

    PriorityTokenStore = {},

    Session = {
        Honey = 0,
        BugKills = 0,
        QuestsComplete = 0,
        Uptime = 0,
    }
}

local FarmingValueNames = {
    "Tool",
    "Tokens",
    "Flames",
    "Bubbles",
    "Fuzzy",
    "Crosshairs",
}

local Tabs = {
    Farming = Window:CreateTab("Farming"),
    Toys = Window:CreateTab("Toys"),
    Combat = Window:CreateTab("Combat"),
    Items = Window:CreateTab("Items"),
    Settings = Window:CreateTab("Settings"),
}

local Sections = {
    Farming = {
        Collection = Tabs.Farming:CreateSection("Collection", false),
        Hive = Tabs.Farming:CreateSection("Hive", false),
    },

    Toys = {
        Normal = Tabs.Toys:CreateSection("Normal", false),
        Beesmas = Tabs.Toys:CreateSection("Beesmas", false),
    },

    Combat = {
        Mobs = Tabs.Combat:CreateSection("Mobs", false),
        Bosses = Tabs.Combat:CreateSection("Bosses", false),
    },

    Items = {
        Gear = Tabs.Items:CreateSection("Gear", false),
        Consumables = Tabs.Items:CreateSection("Consumables", false),
        Planters = Tabs.Items:CreateSection("Planters", false),
    },

    Settings = {
        Player = Tabs.Settings:CreateSection("Player", false),
        Macro = Tabs.Settings:CreateSection("Macro", false),
        Webhooks = Tabs.Settings:CreateSection("Webhooks", false),
    },
}

function TitleCase(str)
    return (str:gsub("%u", " %1"):gsub("^.", string.upper)):sub(2)
end

function Toggle(tab, name, sectionParent, dir)
    tab:Toggle({
        SectionParent = sectionParent,
        Name = TitleCase(name),
        Info = "",
        CurrentValue = false,
        Flag = name,    
        Callback = function(Value)
            dir[name] = Value

            if dir[name.."Cache"] then
                dir[name.."Cache"] = Value
            end

            if AnnounceInteractions then
                print(name, "was changed to", Value)
            end
        end,
    })
end

local ssec = {
    Collection = Sections.Farming.Collection,
    Toys = Sections.Toys.Normal,
    Hive = Sections.Farming.Hive,
    Consumables = Sections.Items.Consumables,
    Combat = Sections.Combat
}

local sdir = {
    Farming = shared.MacroX.Farming,
    Toys = shared.MacroX.Toys,
    BToys = shared.MacroX.BeesmasToys,
    Consumables = shared.MacroX.Consumables,
}

local Toggles = {
    Farming = {
        Tool = Toggle(Tabs.Farming, "Tool", ssec.Collection, sdir.Farming),
        Tokens = Toggle(Tabs.Farming, "Tokens", ssec.Collection, sdir.Farming),
        Flames = Toggle(Tabs.Farming, "Flames", ssec.Collection, sdir.Farming),
        Bubble = Toggle(Tabs.Farming, "Bubbles", ssec.Collection, sdir.Farming),
        Fuzzy = Toggle(Tabs.Farming, "Fuzzy", ssec.Collection, sdir.Farming),
        Crosshairs = Toggle(Tabs.Farming, "Crosshairs", ssec.Collection, sdir.Farming),
        ConvertAtHive = Toggle(Tabs.Farming, "ConvertAtHive", ssec.Hive, sdir.Farming),
        ConvertBalloon = Toggle(Tabs.Farming, "ConvertBalloon", ssec.Hive, sdir.Farming),
    },
    Toys = {
        WealthClock = Toggle(Tabs.Toys, "WealthClock", ssec.Toys.Normal, sdir.Toys),
        StrawberryDispenser = Toggle(Tabs.Toys, "StrawberryDispenser", ssec.Toys.Normal, sdir.Toys),
        BlueberryDispenser = Toggle(Tabs.Toys, "BlueberryDispenser", ssec.Toys.Normal, sdir.Toys),
        GlueDispenser = Toggle(Tabs.Toys, "GlueDispenser", ssec.Toys.Normal, sdir.Toys),
        RoyalJellyDispenser = Toggle(Tabs.Toys, "RoyalJellyDispenser", ssec.Toys.Normal, sdir.Toys),
        Samovar = Toggle(Tabs.Toys, "Samovar", ssec.Toys.Beesmas, sdir.BToys),
        Stockings = Toggle(Tabs.Toys, "Stockings", ssec.Toys.Beesmas, sdir.BToys),
        HoneyWreath = Toggle(Tabs.Toys, "HoneyWreath", ssec.Toys.Beesmas, sdir.BToys),
        HoneyCandles = Toggle(Tabs.Toys, "HoneyCandles", ssec.Toys.Beesmas, sdir.BToys),
        BeesmasFeast = Toggle(Tabs.Toys, "BeesmasFeast", ssec.Toys.Beesmas, sdir.BToys),
        OnettsLidArt = Toggle(Tabs.Toys, "OnettsLidArt", ssec.Toys.Beesmas, sdir.BToys),
        Snowflakes = Toggle(Tabs.Toys, "Snowflakes", ssec.Toys.Beesmas, sdir.BToys),
        RedFieldBooster = Toggle(Tabs.Toys, "RedFieldBooster", ssec.Toys.Normal, sdir.Toys),
        BlueFieldBooster = Toggle(Tabs.Toys, "BlueFieldBooster", ssec.Toys.Normal, sdir.Toys),
        MountainTopFieldBooster = Toggle(Tabs.Toys, "MountainTopFieldBooster", ssec.Toys.Normal, sdir.Toys),

    },
    Combat = {
        BugRun = Toggle(Tabs.Combat, "BugRun", ssec.Combat.Mobs, sdir.Combat),
        Crab = Toggle(Tabs.Combat, "Crab", ssec.Combat.Bosses, sdir.Combat),
        Snail = Toggle(Tabs.Combat, "Snail", ssec.Combat.Bosses, sdir.Combat),
        Commando = Toggle(Tabs.Combat, "Commando", ssec.Combat.Bosses, sdir.Combat),
    },
    Items = {
        Enzymes = Toggle(Tabs.Items, "Enzymes", ssec.Consumables, sdir.Consumables),
        Oil = Toggle(Tabs.Items, "Oil", ssec.Consumables, sdir.Consumables),
        Glue = Toggle(Tabs.Items, "Glue", ssec.Consumables, sdir.Consumables),
        RedExtract = Toggle(Tabs.Items, "RedExtract", ssec.Consumables, sdir.Consumables),
        BlueExtract = Toggle(Tabs.Items, "BlueExtract", ssec.Consumables, sdir.Consumables),
        PurplePotion = Toggle(Tabs.Items, "PurplePotion", ssec.Consumables, sdir.Consumables),
        TropicalDrink = Toggle(Tabs.Items, "TropicalDrink", ssec.Consumables, sdir.Consumables),
    },
    Misc = {},
    Settings = {},
    Logs = {},
}

-- //  actual code

-- //  functions

function IsToken(token)
    if not token.Parent then
        return false
    end

    if token then
        if token.Orientation.Z ~= 0 then
            return false
        end

        if not token:FindFirstChild("FrontDecal") then
            return false
        end

        if not (token.Name == "C") then
            return false
        end

        if not token:IsA("Part") then
            return false
        end

        return true
    end

    return false
end

function Farm(trying)
    Humanoid:MoveTo(trying.Position)
    repeat
        task.wait()
    until (trying.Position-HumanoidRootPart.Position).magnitude <=4 or not IsToken(trying)
end

function TravelTo(trying)
    Humanoid:MoveTo(trying.Position)
    repeat
        task.wait()
    until (trying.Position-HumanoidRootPart.Position).magnitude <=4
end

function CompareMagnitudes(v, cust)
    return (v.Position-HumanoidRootPart.Position).magnitude < (cust or shared.MacroX.Magnitude/1.4)
end

function FindValue(Table, Value)
    if type(Table) == "table" then
        for index, value in pairs(Table) do
            if value == Value then
                return true
            end
        end
    else
        return false
    end
    return false
end

function WalkTo(v3)
    Character.Humanoid:MoveTo(v3)
end

function MakeMessage(input, extra)
    extra = extra or "N/A"

    local messages = {
        Died = "Your character has died",
        Converting = "Now converting backpack: " .. extra,
        Finding = "Attempting to find: " .. extra,
        Attacking = "You are now attacking: " .. extra,
        Travelling = "You are travelling to: " .. extra,
        HoneyCount = "You currently have " .. CoreStats.Honey.Value,
        Killed = "You have killed: " .. extra,
    }

    return messages[input] or "None"
end

local FarmingFunctions = {
    Tool = function()
        -- //  mouse1click()
    end,
    
    Tokens = function() -- //  means priority is on.
        local PIDtbl = shared.MacroX.Importance.PriorityIDs
        for _, v in next, game:GetService("Workspace").Collectibles:GetChildren() do
            if v:FindFirstChildOfClass("Decal") then
                local tokenid = v:FindFirstChildOfClass("Decal").Texture:split('rbxassetid://')[2]
                if tokenid ~= nil and FindValue(PIDtbl, tokenid) then
                    if (v.Name == Player.Name
                        and (not FindValue(shared.MacroX.PriorityTokenStore, v)))
                        or CompareMagnitudes(v) then

                        Farm(v)
                        break
                    end
                end
                local BlacklistedToken = false
                if FindValue(shared.MacroX.Importance.BlacklistedIDs, tokenid) then
                    BlacklistedToken = true
                end
                if CompareMagnitudes(v) and not BlacklistedToken then
                    Farm(v)
                end
            end
        end
    end,
    
    Flames = function()
        for _, v in pairs(PlayerFlames:GetChildren()) do
            if CompareMagnitudes(v) then
                Farm(v)
                break
            end
        end
    end,
    
    Bubbles = function()
        for _, v in pairs(Particles:GetChildren()) do
            if v.Name:find("Bubble") and CompareMagnitudes(v) then
                Farm(v)
                break
            end
        end
    end,
    
    Crosshairs = function()
        local crshtbl = shared.MacroX.Crosshair.Crosshairs
        local crshrActive = shared.MacroX.Crosshair.Crosshair
        if #crshtbl == 0 then
            return
        end
        local instance = crshtbl[math.random(1, #crshtbl)]
        if instance.BrickColor ~= BrickColor.new("Lime green") 
            and instance.BrickColor ~= BrickColor.new("Flint") then
            if crshrActive then 
                repeat
                    task.wait(0.1)
                until not crshrActive
            end
            shared.MacroX.Crosshair.Crosshair = true
            Farm(instance)
            repeat
                task.wait(0.1)
                Farm(instance)
            until not instance.Parent or instance.BrickColor == BrickColor.new("Forest green")
            task.wait(0.1)
            crshrActive = false
            table.remove(crshtbl, FindValue(crshtbl, instance))
        else
            table.remove(crshtbl, FindValue(crshtbl, instance))
        end
    end,
    
    Fuzzy = function()
        pcall(function()
            for _, v in pairs(Particles:GetChildren()) do
                if v.Name == "DustBunnyInstance" and CompareMagnitudes(v.Plane) then
                    if v:FindFirstChild("Plane") then
                        Farm(v:FindFirstChild("Plane"))
                        break
                    end
                end
            end
        end)
    end,
    
    Duped = function()

    end,
    
    UnderBalloons = function()
        for _, v in pairs(Balloons.FieldBalloons:GetChildren()) do
            if v:FindFirstChild("BalloonRoot") and v:FindFirstChild("PlayerName") then
                if v:FindFirstChild("PlayerName").Value == Player.Name then
                    if CompareMagnitudes(v.BalloonRoot) then
                        WalkTo(v.BalloonRoot)
                    end
                end
            end
        end
    end,
}

local ToysFunctions = {}
local BeesmasToysFunctions = {}
local ConsumablesFunctions = {}

-- //  how the "travel and travel sequence" system works?
-- //  it resets your character then travels inbetween the
-- //  daily and total honey lb
-- //  then what it does is it executes a pre-made 
-- //  path by me to follow whereever
-- //  this may be unreliable esp for things like travel back to hive
-- //  i have a method in place to do where i 
-- //  reverse the order but that may not be possible
-- //  this sequence will support: SZ, 5BZ, 10BZ, 
-- //  15BZ, 25BZ, 35BZ (not 20BZ (except for ant/glue disp.) and 30BZ)
-- //  travel sequences for dispensers, fields and "toys" will be added later on.

local Sequences = {}

Sequences.Fields = {
    Bees0 = {
        Sunflower = {},
        Dandelion = {},
        Mushroom = {},
        BlueFlower = {},
        Clover = {},
    },

    Bees5 = {
        Strawberry = {},
        Spider = {},
        Bamboo = {},
    },

    Bees10 = {
        Pineapple = {},
        Stump = {},
    },

    Bees15 = {
        Cactus = {},
        PineTree = {},
        Pumpkin = {},
        Rose = {},
    },

    Bees25 = {
        MountainTop = {},
    },

    Bees35 = {
        Coconut = {},
        Pepper = {},
    }
}

Sequences.Dispensers = {
    BlueberryDispenser = {},
    BlueFieldBooster = {},
    StrawberryDispenser = {},
    RedFieldBooster = {},
    MountainTopFieldBooster = {},
    TreatDispenser = {},
    GlueDispenser = {},
}

Sequences.Landmarks = {
    BlueHQ = {},
    RedHQ = {},
    BadgeBearersGuild = {},
}

Sequences.GetZoneFromField = function(field)
    for i, v in pairs(Sequences.Fields) do
        for a, b in pairs(v) do
            if a == field then
                return i
            end
        end
    end
end

function ActivateTravelPath(path)
    -- //  path must be a direct path from the Sequences table.
    -- //  reset
    -- //  travel to middle spawn location

    for _, v in pairs(path) do
        TravelTo(v)
    end
end

-- //  Detection
task.spawn(function()
    Particles.ChildAdded:Connect(function(instance)
        if instance.Name:find("Vicious") then
            shared.MacroX.Detection.Vicious = true
        end
    end)

    Particles.ChildRemoved:Connect(function(instance)
        if instance.Name:find("Vicious") then
            shared.MacroX.Detection.Vicious = false
        end
    end)

    Particles.ChildAdded:Connect(function(v)
        if v.Name == "Crosshair"
            and v ~= nil 
            and v.BrickColor ~= BrickColor.new("Forest green") 
            and v.BrickColor ~= BrickColor.new("Flint") 
            and CompareMagnitudes(v) then

            if #shared.MacroX.Crosshair.Crosshairs <= 3 then
                table.insert(shared.MacroX.Crosshair.Crosshairs, v)
            end
        end
    end)
end)

-- //  exec on startup
task.spawn(function()
    for _, part in pairs(FieldDecos:GetDescendants()) do
        task.wait(0.05)
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.Transparency = 0.5
        end
    end

    for _, part in pairs(Decorations:GetDescendants()) do
        if part:IsA("BasePart") and (part.Parent.Name == "Bush" 
        or part.Parent.Name == "Blue Flower") or part.Parent.Name == "Mushroom" then 
            task.wait(0.05)
            part.CanCollide = false
            part.Transparency = 0.5
        end
    end
end)

-- //  Farming

task.spawn(function()
    while true do
        task.wait(0.7)
        shared.MacroX.Uptime += 0.7
        
        -- //  shared.MacroX.IsConverting = CoreStats.Pollen.Value > CoreStats.Capacity.Value * 0.95

        if shared.MacroX.IsFarming and not (shared.MacroX.IsConverting and shared.MacroX.IsTravelling) then
            if not shared.MacroX.IsConverting then
                for i, v in pairs(shared.MacroX.Farming) do
                    if FindValue(FarmingValueNames, i) and FarmingFunctions[i] and v then
                        FarmingFunctions[i]()
                    end
                end
            end
        end
    end
end)

-- //  Toys and Consumables

task.spawn(function()
    while true do
        task.wait(60)
        -- //  Normal

        for i, v in pairs(shared.MacroX.Toys) do
            if ToysFunctions[i] and v then
                ToysFunctions[i]()
            end
        end

        -- //  Beesmas

        for i, v in pairs(shared.MacroX.BeesmasToys) do
            if BeesmasToysFunctions[i] and v then
                BeesmasToysFunctions[i]()
            end
        end

        -- //  Consumables

        for i, v in pairs(shared.MacroX.Consumables) do
            if ConsumablesFunctions[i] and v then
                ConsumablesFunctions[i]()
            end
        end
    end
end)
