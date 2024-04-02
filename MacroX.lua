-- //  Made by Paint (x1_EE) - The Happy Meal Guy

local libURL = "https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua"
local UILibrary = loadstring(game:HttpGet(libURL))()

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
    Uptime = 0,
    Magnitude = 50,
    
    CurrentField = "",

    IsConverting = false,

    Detection = {
        Vicious = false,
        Puffshrooms = false,
    },

    Farming = {
        Tool = false, ToolCache = false,
        Tokens = false, TokensCache = false,
        Flames = false, FlamesCache = false,
        Bubbles = false, BubblesCache = false,
        Fuzzy = false, FuzzyCache = false,
        Crosshairs = false, CrosshairsCache = false,

        ConvertAtHive = false,
        ConvertBalloon = false,
    },

    Consumables = {
        Enzymes = false,
        Oil = false,
        Glue = false,
        RedExtract = false,
        BlueExtract = false,
        PurplePotion = false,
        TropicalDrink = false,
    },

    Crosshair = {
        Crosshair = false,
        Crosshairs = {},
    },

    Toys = {
        WealthClock = false,
        RedFieldBooster = false,
        BlueFieldBooster = false,
        MountainTopFieldBooster = false,
        StrawberryDispenser = false,
        BlueberryDispenser = false,
        GlueDispenser = false,
        RoyalJellyDispenser = false,
    },

    BeesmasToys = {
        Samovar = false,
        Stockings = false,
        HoneyWreath = false,
        HoneyCandles = false,
        BeesmasFeast = false,
        OnettsLidArt = false,
        Snowflakes = false,
    },

    Combat = {
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
    Combat = Window:CreateTab("Combat"),
    Boost = Window:CreateTab("Boost"),
    Items = Window:CreateTab("Items"),
    Misc = Window:CreateTab("Misc"),
    Settings = Window:CreateTab("Settings"),
    Logs = Window:CreateTab("Debug/Logs"),
}

local Sections = {
    Farming = {
        Collection = Tabs.Farming:CreateSection("Collection", false),
        Hive = Tabs.Farming:CreateSection("Hive", false),
    },

    Combat = {
        Mobs = Tabs.Combat:CreateSection("Mobs", false),
        Significant = Tabs.Combat:CreateSection("Significant", false),
    },

    Boost = {
        Stickers = Tabs.Boost:CreateSection("Stickers"),
        MiniBoosts = Tabs.Boost:CreateSection("Mini Boosts"),
        Boosters = Tabs.Boost:CreateSection("Boosters"),
    },

    Items = {
        Gear = Tabs.Items:CreateSection("Gear", false),
        Consumables = Tabs.Items:CreateSection("Consumables", false),
        Planters = Tabs.Items:CreateSection("Planters", false),
    },

    Misc = {
        Prioritising = Tabs.Misc:CreateSection("Prioritising", false),
        Blacklisting = Tabs.Misc:CreateSection("Blacklisting", false),
    },

    Settings = {
        Player = Tabs.Misc:CreateSection("Player", false),
        Macro = Tabs.Misc:CreateSection("Macro", false),
        Webhooks = Tabs.Misc:CreateSection("Webhooks", false),
    },

    Logs = {
        Logs = Tabs.Misc:CreateSection("Debug/Logs", false),
    }
}

function TitleCase(str)
    return (str:gsub("%u", " %1"):gsub("^.", string.upper)):sub(2)
end

function CreateToggle(tab, name, sectionParent, dir)
    tab:CreateToggle({
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
    Hive = Sections.Farming.Hive,
    Boosters = Sections.Boost.Boosters,
    Consumables = Sections.Items.Consumables
}

local sdir = {
    Farming = shared.MacroX.Farming,
    Toys = shared.MacroX.Toys,
    Consumables = shared.MacroX.Consumables,
}

local Toggles = {
    Farming = {
        Tool = CreateToggle(Tabs.Farming, "Tool", ssec.Collection, sdir.Farming),
        Tokens = CreateToggle(Tabs.Farming, "Tokens", ssec.Collection, sdir.Farming),
        Flames = CreateToggle(Tabs.Farming, "Flames", ssec.Collection, sdir.Farming),
        Bubble = CreateToggle(Tabs.Farming, "Bubbles", ssec.Collection, sdir.Farming),
        Fuzzy = CreateToggle(Tabs.Farming, "Fuzzy", ssec.Collection, sdir.Farming),
        Crosshairs = CreateToggle(Tabs.Farming, "Crosshairs", ssec.Collection, sdir.Farming),
        ConvertAtHive = CreateToggle(Tabs.Farming, "ConvertAtHive", ssec.Hive, sdir.Farming),
        ConvertBalloon = CreateToggle(Tabs.Farming, "ConvertBalloon", ssec.Hive, sdir.Farming),
    },
    Combat = {},
    Boost = {
        RedFieldBooster = CreateToggle(Tabs.Boost, "RedFieldBooster", ssec.Boosters, sdir.Toys),
        BlueFieldBooster = CreateToggle(Tabs.Boost, "BlueFieldBooster", ssec.Boosters, sdir.Toys),
        MountainTopFieldBooster = CreateToggle(Tabs.Boost, "MountainTopFieldBooster", ssec.Boosters, sdir.Toys),
    },
    Items = {
        Enzymes = CreateToggle(Tabs.Items, "Enzymes", ssec.Consumables, sdir.Consumables),
        Oil = CreateToggle(Tabs.Items, "Oil", ssec.Consumables, sdir.Consumables),
        Glue = CreateToggle(Tabs.Items, "Glue", ssec.Consumables, sdir.Consumables),
        RedExtract = CreateToggle(Tabs.Items, "RedExtract", ssec.Consumables, sdir.Consumables),
        BlueExtract = CreateToggle(Tabs.Items, "BlueExtract", ssec.Consumables, sdir.Consumables),
        PurplePotion = CreateToggle(Tabs.Items, "PurplePotion", ssec.Consumables, sdir.Consumables),
        TropicalDrink = CreateToggle(Tabs.Items, "TropicalDrink", ssec.Consumables, sdir.Consumables),
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

local Functions = {
    Tool = function()
        -- //  mouse1click()
    end,
    
    Tokens = function() -- //  means priority is on.
        local PIDtbl = shared.MacroX.Importance.PriorityIDs
        for e,r in next, game:GetService("Workspace").Collectibles:GetChildren() do
            if r:FindFirstChildOfClass("Decal") then
                local tokenid = r:FindFirstChildOfClass("Decal").Texture:split('rbxassetid://')[2]
                if tokenid ~= nil and FindValue(PIDtbl, tokenid) then
                    if (r.Name == Player.Name
                        and (not FindValue(shared.MacroX.PriorityTokenStore, r)))
                        or CompareMagnitudes(r) then

                        Farm(r)
                        break
                    end
                end
                local BlacklistedToken = false
                if FindValue(shared.MacroX.Importance.BlacklistedIDs, tokenid) then
                    BlacklistedToken = true
                end
                if CompareMagnitudes(r) and not BlacklistedToken then
                    Farm(r)
                end
            end
        end
    end,
    
    Flames = function()
        for i,v in pairs(PlayerFlames:GetChildren()) do
            if CompareMagnitudes(v) then
                Farm(v)
                break
            end
        end
    end,
    
    Bubbles = function()
        for i,v in pairs(Particles:GetChildren()) do
            if string.find(v.Name, "Bubble") and CompareMagnitudes(v) then
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
                -- // api.walkTo(instance.Position)
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
            for i,v in pairs(Particles:GetChildren()) do
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
        for i,v in pairs(Balloons.FieldBalloons:GetChildren()) do
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

function ActivateTravelPath(path)
    -- //  path must be a direct path from the Sequences table.
    -- //  reset
    -- //  travel to middle spawn location

    for i, v in pairs(path) do
        TravelTo(v)
    end
end

-- //  detections
task.spawn(function()
    Particles.ChildAdded:Connect(function(instance)
        if string.find(instance.Name, "Vicious") then
            shared.MacroX.Detection.Vicious = true
        end
    end)

    Particles.ChildRemoved:Connect(function(instance)
        if string.find(instance.Name, "Vicious") then
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
        if part:IsA("BasePart") and (part.Parent.Name == "Bush" or part.Parent.Name == "Blue Flower") then 
            task.wait(0.05)
            part.CanCollide = false
            part.Transparency = 0.5
        end 
    end

    for i,v in pairs(Decorations.Misc:GetDescendants()) do 
        if v.Parent.Name == "Mushroom" then
            v.CanCollide = false
            v.Transparency = 0.5
        end
    end
end)

print(table.concat({
    "All methods here present are safe/decently safe.",
    "Nothing in this Macro does actions that a normal player can't.",
    "Use this Macro alone to prevent damaging interactions.",
    "Report all disconnects and kicks by the game to the server.",
    "I thank you for choosing MacroX!",
}, "\n"))

-- //  Farming
task.spawn(function()
    while true do
        task.wait(0.7)
        shared.MacroX.Uptime += 0.7
        --[[
        for i, v in pairs(shared.MacroX.Farming) do
            if not (i == "Tool") and v then
                shared.MacroX.IsFarming = true
            end
        end
        
        if shared.MacroX.IsFarming then
            shared.MacroX.IsConverting = false
        end
        
        if shared.MacroX.IsConverting then
            shared.MacroX.IsFarming = falsedd
            for i, v in pairs({"Tool", "Tokens", "Flames", "Bubbles", "Fuzzy", "Crosshairs"}) do
                shared.MacroX.Farming[v] = false
            end
        end]]
        
        shared.MacroX.IsConverting = CoreStats.Pollen.Value > CoreStats.Capacity.Value * 0.95
        
        if not shared.MacroX.IsConverting then
            for i, v in pairs(shared.MacroX.Farming) do
                if FindValue(FarmingValueNames, i) and v then
                     Functions[i]()
                end
            end
        end
    end
end)
