local decalsyeeted = false

local g = game
local w = g.Workspace
local l = g.Lighting
local t = w.Terrain

t.WaterWaveSize = 0
t.WaterWaveSpeed = 0
t.WaterReflectance = 0
t.WaterTransparency = 0

l.GlobalShadows = false
l.FogEnd = 9e9
l.Brightness = 0

settings().Rendering.QualityLevel = "Level10"

for i, v in pairs(g:GetDescendants()) do
    if v:IsA("Part") or v.ClassName:find("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
        v.Material = "Plastic"
        v.Reflectance = 0
    elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
        v.Transparency = 1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v.Lifetime = NumberRange.new(0)
    elseif v:IsA("Explosion") then
        v.BlastPressure = 1
        v.BlastRadius = 1
    elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
        v.Enabled = false
    elseif v:IsA("MeshPart") then
        v.Material = "Plastic"
        v.Reflectance = 0
    end
end

for i, e in pairs(l:GetChildren()) do
    if e.ClassName:find("Effect") then
        e.Enabled = false
    end
end