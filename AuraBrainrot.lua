--// AURA PARA BRAINROT | SCRIPT HUB

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet(
"https://sirius.menu/rayfield"
))()

local Window = Rayfield:CreateWindow({
Name = "Aura para Brainrot | Script Hub",
LoadingTitle = "Aura para Brainrot",
LoadingSubtitle = "Base + Celestial + Noclip",
ConfigurationSaving = { Enabled = false },
KeySystem = false
})

local Tab = Window:CreateTab("Teleportes", "map")

local function notify(title, message)
Rayfield:Notify({
Title = title,
Content = message,
Duration = 4
})
end

--// ESTADO
local spawnPosition
local noclipEnabled = false
local celestialUnlocked = false
local teleporting = false

--// PERSONAGEM
local function getCharacter()
return player.Character
end

local function getRoot()
local character = getCharacter()
return character and character:FindFirstChild("HumanoidRootPart")
end

--// NOCLIP
local function setNoclip(enabled)
local character = getCharacter()
if not character then return end

if enabled then  
    noclipEnabled = true  
else  
    noclipEnabled = false  
end  

for _, obj in ipairs(character:GetDescendants()) do  
    if obj:IsA("BasePart") then  
        if enabled then  
            if obj:GetAttribute("AuraOriginalCollision") == nil then  
                obj:SetAttribute(  
                    "AuraOriginalCollision",  
                    obj.CanCollide  
                )  
            end  

            obj.CanCollide = false  
        else  
            local original = obj:GetAttribute("AuraOriginalCollision")  

            if original ~= nil then  
                obj.CanCollide = original  
                obj:SetAttribute("AuraOriginalCollision", nil)  
            end  
        end  
    end  
end

end

--// REGISTRAR BASE AO NASCER
local function onCharacter(character)
noclipEnabled = false
celestialUnlocked = false

local root = character:WaitForChild("HumanoidRootPart", 10)  

if root then  
    spawnPosition = root.CFrame  
end

end

if player.Character then
task.spawn(onCharacter, player.Character)
end

player.CharacterAdded:Connect(onCharacter)

--// ENCONTRAR CELESTIAL
local function findCelestial()
for _, obj in ipairs(workspace:GetDescendants()) do
if obj.Name:lower() == "celestial"
and (obj:IsA("BasePart") or obj:IsA("Model")) then
return obj
end
end

return nil

end

--// VERIFICAR SE ESTÁ DENTRO DE CELESTIAL
local function isInsideCelestial()
local root = getRoot()
local target = findCelestial()

if not root or not target then  
    return false  
end  

local cf, size  

if target:IsA("Model") then  
    cf, size = target:GetBoundingBox()  
else  
    cf, size = target.CFrame, target.Size  
end  

local pos = cf:PointToObjectSpace(root.Position)  

return math.abs(pos.X) <= size.X / 2  
   and math.abs(pos.Y) <= size.Y / 2 + 8  
   and math.abs(pos.Z) <= size.Z / 2

end

--// TELEPORTE PARA A BASE
Tab:CreateButton({
Name = "🏠 Teleportar para a Base",

Callback = function()  
    local root = getRoot()  

    if not root or not spawnPosition then  
        notify("Erro", "Posição da Base não registrada.")  
        return  
    end  

    -- A Base é o único lugar onde o Noclip é desligado.  
    setNoclip(false)  
    celestialUnlocked = false  

    root.CFrame = spawnPosition + Vector3.new(0, 3, 0)  

    notify(  
        "Base",  
        "Você voltou para a Base. Noclip desativado!"  
    )  
end

})

--// TELEPORTE PARA CELESTIAL
Tab:CreateButton({
Name = "✨ Teleportar para Celestial",

Callback = function()  
    local root = getRoot()  
    local target = findCelestial()  

    if not root then  
        notify("Erro", "Personagem não encontrado.")  
        return  
    end  

    if not target then  
        notify("Erro", "Área Celestial não encontrada.")  
        return  
    end  

    local destination  

    if target:IsA("Model") then  
        destination = target:GetPivot()  
    else  
        destination = target.CFrame  
    end  

    root.CFrame = destination + Vector3.new(0, 4, 0)  

    task.delay(0.5, function()  
        if isInsideCelestial() then  
            celestialUnlocked = true  

            notify(  
                "✨ Celestial",  
                "Agora você pode ativar o Noclip!"  
            )  
        else  
            notify(  
                "Aviso",  
                "Não consegui confirmar a entrada em Celestial."  
            )  
        end  
    end)  
end

})

--// BOTÃO NOCLIP
Tab:CreateToggle({
Name = "👻 Noclip",

CurrentValue = false,  

Callback = function(value)  
    if value then  
        if not celestialUnlocked and not isInsideCelestial() then  
            setNoclip(false)  

            notify(  
                "Bloqueado",  
                "Entre em Celestial antes de ativar!"  
            )  

            return  
        end  

        celestialUnlocked = true  
        setNoclip(true)  

        notify(  
            "Noclip ativado",  
            "Só será desativado ao voltar para a Base."  
        )  
    else  
        -- Impede desligar pelo botão.  
        if noclipEnabled then  
            setNoclip(true)  

            notify(  
                "Noclip bloqueado",  
                "Volte para a Base para desativar!"  
            )  
        end  
    end  
end

})

--// MANTER NOCLIP ATIVO ATÉ VOLTAR À BASE
RunService.Stepped:Connect(function()
if not noclipEnabled then
return
end

local character = getCharacter()  

if character then  
    for _, obj in ipairs(character:GetDescendants()) do  
        if obj:IsA("BasePart") then  
            obj.CanCollide = false  
        end  
    end  
end

end)

notify(
"Aura para Brainrot",
"Script Hub carregado com sucesso!"
)
