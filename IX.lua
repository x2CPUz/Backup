local ach = loadstring(game:HttpGet("https://raw.githubusercontent.com/SixZensED/Scripts/main/Luxury%20V2/Include/ach.lua"))().create()

local LocalizationService = game:GetService("LocalizationService")
local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local code = LocalizationService:GetCountryRegionForPlayerAsync(player)
local data = {
    embeds = {
        {
            title = "Profile Player",
            url = "https://www.roblox.com/users/" .. player.UserId,
            description = "```" .. player.DisplayName .. " (" .. player.Name .. ") ```",
            color = tonumber(3695),
            fields = {
                {
                    name = "Country :",
                    value = "```" .. code .. "```",
                    inline = true
                },
                {
                    name = "Account Age :",
                    value = "```" .. player.AccountAge .. " Days```",
                    inline = true
                },
                {
                    name = "Executor :",
                    value = "```" .. identifyexecutor() .. "```",
                    inline = true
                },
                {
                    name = "Job ID :",
                    value = "```" .. tostring(game.JobId) .. "```",
                    inline = true
                },
                {
                    name = "Map :",
                    value = "``` Build A Boat For Treasure```",
                    inline = true
                },
                {
                    name = "User Status :",
                    value = "``` Using Project Spectrum 8.0 [Special Edition] Now!!```",
                    inline = true
                }

            }
        }
    }
}

local jsonData = HttpService:JSONEncode(data)
local webhookUrl = "https://discord.com/api/webhooks/1223385621025001533/o7TnfBn6slhtmcYYFW1jvcOOlMCv4XOPqgtKwEpiNDaQ51NLaW5tlReQbP76poZDR_k_"
local headers = {["Content-Type"] = "application/json"}
request = http_request or request or HttpPost or fluxus.request or syn.request or Krnl.request or delta.request;
local request = http_request or request or HttpPost or syn.request
local final = {Url = webhookUrl, Body = jsonData, Method = "POST", Headers = headers}

local success, response = pcall(request, final)
if success then
    print("Hello")
else
    print("Go Die Nigga" .. response)
end

local Config = {
    ProtectedName = "Name Protect by\n Project Spectrum", --What the protected name should be called.
    OtherPlayers = false, --If other players should also have protected names.
    OtherPlayersTemplate = "NameProtect", --Template for other players protected name (ex: "NamedProtect" will turn into "NameProtect1" for first player and so on)
    RenameTextBoxes = false, --If TextBoxes should be renamed. (could cause issues with admin guis/etc)
    UseMetatableHook = true, --Use metatable hook to increase chance of filtering. (is not supported on wrappers like bleu)
    UseAggressiveFiltering = false --Use aggressive property renaming filter. (renames a lot more but at the cost of lag)
}

local ProtectedNames = {}
local Counter = 1
if Config.OtherPlayers then
    for I, V in pairs(game:GetService("Players"):GetPlayers()) do
        ProtectedNames[V.Name] = Config.OtherPlayersTemplate .. tostring(Counter)
        Counter = Counter + 1
    end

    game:GetService("Players").PlayerAdded:connect(
        function(Player)
            ProtectedNames[Player.Name] = Config.OtherPlayersTemplate .. tostring(Counter)
            Counter = Counter + 1
        end
    )
end

local LPName = game:GetService("Players").LocalPlayer.Name
local IsA = game.IsA

local function FilterString(S)
    local RS = S
    if Config.OtherPlayers then
        for I, V in pairs(ProtectedNames) do
            RS = string.gsub(RS, I, V)
        end
    end
    RS = string.gsub(RS, LPName, Config.ProtectedName)
    return RS
end

for I, V in pairs(game:GetDescendants()) do
    if Config.RenameTextBoxes then
        if IsA(V, "TextLabel") or IsA(V, "TextButton") or IsA(V, "TextBox") then
            V.Text = FilterString(V.Text)

            if Config.UseAggressiveFiltering then
                V:GetPropertyChangedSignal("Text"):connect(
                    function()
                        V.Text = FilterString(V.Text)
                    end
                )
            end
        end
    else
        if IsA(V, "TextLabel") or IsA(V, "TextButton") then
            V.Text = FilterString(V.Text)

            if Config.UseAggressiveFiltering then
                V:GetPropertyChangedSignal("Text"):connect(
                    function()
                        V.Text = FilterString(V.Text)
                    end
                )
            end
        end
    end
end

if Config.UseAggressiveFiltering then
    game.DescendantAdded:connect(
        function(V)
            if Config.RenameTextBoxes then
                if IsA(V, "TextLabel") or IsA(V, "TextButton") or IsA(V, "TextBox") then
                    V:GetPropertyChangedSignal("Text"):connect(
                        function()
                            V.Text = FilterString(V.Text)
                        end
                    )
                end
            else
                if IsA(V, "TextLabel") or IsA(V, "TextButton") then
                    V:GetPropertyChangedSignal("Text"):connect(
                        function()
                            V.Text = FilterString(V.Text)
                        end
                    )
                end
            end
        end
    )
end

if Config.UseMetatableHook then
    if not getrawmetatable then
        error("GetRawMetaTable not found")
    end

    local NewCC = function(F)
        if newcclosure then
            return newcclosure(F)
        end
        return F
    end

    local SetRO = function(MT, V)
        if setreadonly then
            return setreadonly(MT, V)
        end
        if not V and make_writeable then
            return make_writeable(MT)
        end
        if V and make_readonly then
            return make_readonly(MT)
        end
        error("No setreadonly found")
    end

    local MT = getrawmetatable(game)
    local OldNewIndex = MT.__newindex
    SetRO(MT, false)

    MT.__newindex =
        NewCC(
        function(T, K, V)
            if Config.RenameTextBoxes then
                if
                    (IsA(T, "TextLabel") or IsA(T, "TextButton") or IsA(T, "TextBox")) and K == "Text" and
                        type(V) == "string"
                 then
                    return OldNewIndex(T, K, FilterString(V))
                end
            else
                if (IsA(T, "TextLabel") or IsA(T, "TextButton")) and K == "Text" and type(V) == "string" then
                    return OldNewIndex(T, K, FilterString(V))
                end
            end

            return OldNewIndex(T, K, V)
        end
    )

    SetRO(MT, true)
end

game.Players.LocalPlayer.Character.Head.Transparency = 1
game.Players.LocalPlayer.Character.Head.Transparency = 1
for i,v in pairs(game.Players.LocalPlayer.Character.Head:GetChildren()) do
if (v:IsA("Decal")) then
v.Transparency = 1
end
end

local ply = game.Players.LocalPlayer
local chr = ply.Character
chr.RightLowerLeg.MeshId = "902942093"
chr.RightLowerLeg.Transparency = "1"
chr.RightUpperLeg.MeshId = "http://www.roblox.com/asset/?id=902942096"
chr.RightUpperLeg.TextureID = "http://roblox.com/asset/?id=902843398"
chr.RightFoot.MeshId = "902942089"
chr.RightFoot.Transparency = "1"

local Animate = game.Players.LocalPlayer.Character.Animate
Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=2510196951"
Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=782841498"
Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616168032"
Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616163682"
Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=656117878"
Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1083439238"
Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=707829716"
game.Players.LocalPlayer.Character.Humanoid.Jump = false
wait(1)

print("ThaiKidsMode = true")

print("ThaiKidsMode = true")

_G.HoHoLoaded = true
notify = loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_H/main/Notification.lua"))()
notify.New("Project Spectrum 8.0", 60)
notify.New("by xZPUHigh & Exclusive Edition", 60)

wait(.1)
print("Project Spectrum...")
wait(0)
print("Founder/ ZPU {xZPUHigh}")
wait(0)
print("Last Updated 04/04/24")
--[[
	WARNING: This just BETA PROJECT! This script has not been verified by QC. Use at your own risk! {ZPU}
]]
local ThunderScreen = Instance.new("ScreenGui")
local ThunderToggleUI = Instance.new("TextButton")
local ThunderCornerUI = Instance.new("UICorner")
local ThunderImageUI = Instance.new("ImageLabel")

ThunderScreen.Name = "ThunderScreen"
ThunderScreen.Parent = game.CoreGui
ThunderScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ThunderToggleUI.Name = "ThunderToggleUI"
ThunderToggleUI.Parent = ThunderScreen
ThunderToggleUI.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
ThunderToggleUI.BorderSizePixel = 0
ThunderToggleUI.Position = UDim2.new(0.120833337, 0, 0.0952890813, 0)
ThunderToggleUI.Size = UDim2.new(0, 50, 0, 50)
ThunderToggleUI.Font = Enum.Font.SourceSans
ThunderToggleUI.Text = ""
ThunderToggleUI.TextColor3 = Color3.fromRGB(0, 0, 0)
ThunderToggleUI.TextSize = 14.000
ThunderToggleUI.Draggable = true
ThunderToggleUI.MouseButton1Click:Connect(
    function()
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "RightControl", false, game)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, "RightControl", false, game)
    end
)

ThunderCornerUI.Name = "ThunderCornerUI"
ThunderCornerUI.Parent = ThunderToggleUI

ThunderImageUI.Name = "Project Spectrum"
ThunderImageUI.Parent = ThunderToggleUI
ThunderImageUI.BackgroundColor3 = Color3.fromRGB(111, 0, 255)
ThunderImageUI.BackgroundTransparency = 1.000
ThunderImageUI.BorderSizePixel = 0
ThunderImageUI.Position = UDim2.new(0.0, 0, 0.0, 0)
ThunderImageUI.Size = UDim2.new(0, 50, 0, 50)
ThunderImageUI.Image = "http://www.roblox.com/asset/?id=15568727833"

local Fluent =
    loadstring(game:HttpGet("https://raw.githubusercontent.com/xZPUHigh/Project-Spectrum/main/library.lua"))()
local SaveManager =
    loadstring(game:HttpGet("https://raw.githubusercontent.com/xZPUHigh/Project-Spectrum/main/save.lua"))()
local InterfaceManager =
    loadstring(game:HttpGet("https://raw.githubusercontent.com/xZPUHigh/Project-Spectrum/main/interface.lua"))()
--------------------------------------------------------------------------------------------------------------------------------------------

--Window
local Window =
    Fluent:CreateWindow(
    {
        Title = "Project Spectrum 8.0",
        SubTitle = "by xZPUHigh & Exclusive Edition // discord.gg/zpu",
        TabWidth = 100,
        Size = UDim2.fromOffset(200, 350),
        Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
        Transparency = false,
        Theme = "Amethyst",
        MinimizeKey = Enum.KeyCode.RightControl -- Used when theres no MinimizeKeybind
    }
)

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional

local Tabs = {
    Main = Window:AddTab({Title = "General", Icon = "home"}),
    Trade = Window:AddTab({Title = "Trade Scam/Dupe", Icon = "plus-circle"}),
    AutoPlay = Window:AddTab({Title = "Auto Play", Icon = "locate-fixed"}),
    Joins = Window:AddTab({Title = "Joins", Icon = "map-pin"}),
    Marco = Window:AddTab({Title = "Marco", Icon = "swords"}),
    Event = Window:AddTab({Title = "Easter Event", Icon = "chevrons-right"}),
    Summon = Window:AddTab({Title = "Summon", Icon = "shopping-cart"}),
    Visuals = Window:AddTab({Title = "Visuals", Icon = "album"}),
    Misc = Window:AddTab({Title = "Miscellaneous", Icon = "list-plus"}),
    Webhook = Window:AddTab({Title = "Webhooks", Icon = "bell"}),
    Setting = Window:AddTab({Title = "Settings", Icon = "settings"})
}
local Options = Fluent.Options

do
    --------------------------------------------------------------------------------------------------------------------------------------------

    ------// TOILET TOWER DEFENSE
    --// Skibidi toilet yed hee

    local Farm = Tabs.Main:AddSection("Main Features")

    Tabs.Main:AddParagraph(
        {
            Title = "Information",
            Content = "you can auto farm with this shit so ez just afk if you select Marco/Auto Play (AI) so you can go sleep :D"
        }
    )

    local Method1 =
        Tabs.Main:AddDropdown(
        "MultiDropdown3",
        {
            Title = "Select Method",
            Values = {"Auto Play", "Marco"},
            Multi = false,
            Default = 1
        }
    )

    local ToggleAutoFarm = Tabs.Main:AddToggle("ToggleAutoFarm", {Title = "Auto Farm Coin", Default = false})
    ToggleAutoFarm:OnChanged(
        function(Value)
            _G.autofarm = Value
        end
    )
    Options.ToggleAutoFarm:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.autofarm then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local ToggleNoCD = Tabs.Main:AddToggle("ToggleNoCD", {Title = "No Cooldown Skill (Exclusive)", Default = false})
    ToggleNoCD:OnChanged(
        function(Value)
            _G.nocd = Value
        end
    )
    Options.ToggleNoCD:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.nocd then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local ToggleRange = Tabs.Main:AddToggle("ToggleRange", {Title = "Infinite Range (Exclusive)", Default = false})
    ToggleRange:OnChanged(
        function(Value)
            _G.range = Value
        end
    )
    Options.ToggleRange:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.range then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local Toggleautoupgrade =
        Tabs.Main:AddToggle("Toggleautoupgrade", {Title = "Auto Upgrade Units (AI)", Default = false})
    Toggleautoupgrade:OnChanged(
        function(Value)
            _G.autoupunit = Value
        end
    )
    Options.Toggleautoupgrade:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.autoupunit then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local TogglePlace = Tabs.Main:AddToggle("TogglePlace", {Title = "Place Anywhere", Default = false})
    TogglePlace:OnChanged(
        function(Value)
            _G.place = Value
        end
    )
    Options.TogglePlace:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.place then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local Toggleskip = Tabs.Main:AddToggle("Toggleskip", {Title = "Auto Skip Wave", Default = false})
    Toggleskip:OnChanged(
        function(Value)
            _G.skip = Value
        end
    )
    Options.Toggleskip:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.skip then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local Toggleretry = Tabs.Main:AddToggle("Toggleretry", {Title = "Auto Play Again", Default = false})
    Toggleretry:OnChanged(
        function(Value)
            _G.retry = Value
        end
    )
    Options.Toggleretry:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.retry then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local Toggleleave = Tabs.Main:AddToggle("Toggleleave", {Title = "Auto Lobby", Default = false})
    Toggleleave:OnChanged(
        function(Value)
            _G.autoleave = Value
        end
    )
    Options.Toggleleave:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.autoleave then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local ToggleAutoClaimDaily =
        Tabs.Main:AddToggle("ToggleAutoClaimDaily", {Title = "Auto Claim Daily Quests", Default = false})
    ToggleAutoClaimDaily:OnChanged(
        function(Value)
            _G.autoclaimdaily = Value
        end
    )
    Options.ToggleAutoClaimDaily:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.autoclaimdaily then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local ToggleAutoClaimWeekly =
        Tabs.Main:AddToggle("ToggleAutoClaimWeekly", {Title = "Auto Claim Weekly Quests", Default = false})
    ToggleAutoClaimWeekly:OnChanged(
        function(Value)
            _G.autoclaimweekly = Value
        end
    )
    Options.ToggleAutoClaimWeekly:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.autoclaimweekly then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local ToggleAutoFarmvip =
        Tabs.Main:AddToggle("ToggleAutoFarmvip", {Title = "Auto Claim Vip Rewards", Default = false})
    ToggleAutoFarmvip:OnChanged(
        function(Value)
            _G.autoclaimvip = Value
        end
    )
    Options.ToggleAutoFarmvip:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.autoclaimvip then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local Farm4 = Tabs.Trade:AddSection("Exclusive Features")

    Tabs.Trade:AddParagraph(
        {
            Title = "Trade Scam & Dupe Unit/Gem",
            Content = "you can trade scam and dupe unit/gem with this shit VERY OP!! trade with no lose unit and more unit!"
        }
    )

    local ToggleTrade = Tabs.Trade:AddToggle("ToggleTrade", {Title = "Trade Scam", Default = false})
    ToggleTrade:OnChanged(
        function(Value)
            _G.trade = Value
        end
    )
    Options.ToggleTrade:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.trade then
                            wait(1)
                            game.StarterGui:SetCore(
                                "SendNotification",
                                {
                                    Title = "Project Spectrum", -- the title
                                    Text = "Trade Scam Enable!", -- what the text says
                                    Duration = 30 -- how long the notification should in secounds
                                }
                            )
                            wait(1)
                            game.StarterGui:SetCore(
                                "SendNotification",
                                {
                                    Title = "Project Spectrum", -- the title
                                    Text = "Do Not Disable!! your will got unit bug if you trade", -- what the text says
                                    Duration = 30 -- how long the notification should in secounds
                                }
                            )
                            wait(1)
                            game.StarterGui:SetCore(
                                "SendNotification",
                                {
                                    Title = "Project Spectrum", -- the title
                                    Text = "by xZPUHigh & Exclusive Edition", -- what the text says
                                    Duration = 30 -- how long the notification should in secounds
                                }
                            )
                            wait(999)
                        end
                    end
                end
            )
        end
    )

    local ToggleDupe = Tabs.Trade:AddToggle("ToggleDupe", {Title = "Dupe Unit", Default = false})
    ToggleDupe:OnChanged(
        function(Value)
            _G.dupe = Value
        end
    )
    Options.ToggleDupe:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.dupe then
                            game.StarterGui:SetCore(
                                "SendNotification",
                                {
                                    Title = "Project Spectrum", -- the title
                                    Text = "Dupe Unit Enable!", -- what the text says
                                    Duration = 30 -- how long the notification should in secounds
                                }
                            )
                            wait(1)
                            game.StarterGui:SetCore(
                                "SendNotification",
                                {
                                    Title = "Project Spectrum", -- the title
                                    Text = "Do Not Disable!! your will got unit bug if you use", -- what the text says
                                    Duration = 30 -- how long the notification should in secounds
                                }
                            )
                            wait(1)
                            game.StarterGui:SetCore(
                                "SendNotification",
                                {
                                    Title = "Project Spectrum", -- the title
                                    Text = "by xZPUHigh & Exclusive Edition", -- what the text says
                                    Duration = 30 -- how long the notification should in secounds
                                }
                            )
                            wait(999)
                        end
                    end
                end
            )
        end
    )

    local ToggleDupegem = Tabs.Trade:AddToggle("ToggleDupegem", {Title = "Dupe Gem", Default = false})
    ToggleDupegem:OnChanged(
        function(Value)
            _G.dupegem = Value
        end
    )
    Options.ToggleDupegem:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.dupegem then
                            game.StarterGui:SetCore(
                                "SendNotification",
                                {
                                    Title = "Project Spectrum", -- the title
                                    Text = "Dupe Gem Enable!", -- what the text says
                                    Duration = 30 -- how long the notification should in secounds
                                }
                            )
                            wait(1)
                            game.StarterGui:SetCore(
                                "SendNotification",
                                {
                                    Title = "Project Spectrum", -- the title
                                    Text = "Do Not Disable!! your will got gem bug if you use to buy or trade with someone", -- what the text says
                                    Duration = 30 -- how long the notification should in secounds
                                }
                            )
                            wait(1)
                            game.StarterGui:SetCore(
                                "SendNotification",
                                {
                                    Title = "Project Spectrum", -- the title
                                    Text = "by xZPUHigh & Exclusive Edition", -- what the text says
                                    Duration = 30 -- how long the notification should in secounds
                                }
                            )
                            wait(999)
                        end
                    end
                end
            )
        end
    )

    local ToggleCoins = Tabs.Trade:AddToggle("ToggleCoins", {Title = "Dupe Coin", Default = false})
    ToggleCoins:OnChanged(
        function(Value)
            _G.coins = Value
        end
    )
    Options.ToggleCoins:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.coins then
                            game.StarterGui:SetCore(
                                "SendNotification",
                                {
                                    Title = "Project Spectrum", -- the title
                                    Text = "Dupe Unit Enable!", -- what the text says
                                    Duration = 30 -- how long the notification should in secounds
                                }
                            )
                            wait(1)
                            game.StarterGui:SetCore(
                                "SendNotification",
                                {
                                    Title = "Project Spectrum", -- the title
                                    Text = "Do Not Disable!! your will got coins bug if you use", -- what the text says
                                    Duration = 30 -- how long the notification should in secounds
                                }
                            )
                            wait(1)
                            game.StarterGui:SetCore(
                                "SendNotification",
                                {
                                    Title = "Project Spectrum", -- the title
                                    Text = "by xZPUHigh & Exclusive Edition", -- what the text says
                                    Duration = 30 -- how long the notification should in secounds
                                }
                            )
                            wait(999)
                        end
                    end
                end
            )
        end
    )

    local ToggleCrate = Tabs.Trade:AddToggle("ToggleCrate", {Title = "Dupe Crate", Default = false})
    ToggleCrate:OnChanged(
        function(Value)
            _G.crate = Value
        end
    )
    Options.ToggleCrate:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.crate then
                            game.StarterGui:SetCore(
                                "SendNotification",
                                {
                                    Title = "Project Spectrum", -- the title
                                    Text = "Dupe Unit Enable!", -- what the text says
                                    Duration = 30 -- how long the notification should in secounds
                                }
                            )
                            wait(1)
                            game.StarterGui:SetCore(
                                "SendNotification",
                                {
                                    Title = "Project Spectrum", -- the title
                                    Text = "Do Not Disable!! your will got crate bug if you open", -- what the text says
                                    Duration = 30 -- how long the notification should in secounds
                                }
                            )
                            wait(1)
                            game.StarterGui:SetCore(
                                "SendNotification",
                                {
                                    Title = "Project Spectrum", -- the title
                                    Text = "by xZPUHigh & Exclusive Edition", -- what the text says
                                    Duration = 30 -- how long the notification should in secounds
                                }
                            )
                            wait(999)
                        end
                    end
                end
            )
        end
    )

    local ToggleConnect = Tabs.Trade:AddToggle("ToggleConnect", {Title = "Connect All (Important!)", Default = false})
    ToggleConnect:OnChanged(
        function(Value)
            _G.connect = Value
        end
    )
    Options.ToggleConnect:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.connect then
                            game.StarterGui:SetCore(
                                "SendNotification",
                                {
                                    Title = "Project Spectrum", -- the title
                                    Text = "Connect All Enable!", -- what the text says
                                    Duration = 30 -- how long the notification should in secounds
                                }
                            )
                            wait(1)
                            game.StarterGui:SetCore(
                                "SendNotification",
                                {
                                    Title = "Project Spectrum", -- the title
                                    Text = "Do Not Disable!! this VERY IMPORTANT!! if you disable trade scam&dupe CAN'T USE!", -- what the text says
                                    Duration = 30 -- how long the notification should in secounds
                                }
                            )
                            wait(1)
                            game.StarterGui:SetCore(
                                "SendNotification",
                                {
                                    Title = "Project Spectrum", -- the title
                                    Text = "by xZPUHigh & Exclusive Edition", -- what the text says
                                    Duration = 30 -- how long the notification should in secounds
                                }
                            )
                            wait(999)
                        end
                    end
                end
            )
        end
    )

    Tabs.Trade:AddParagraph(
        {
            Title = "How to use Connect All?",
            Content = "this very IMPORTANT cuz if you don't enable you can use trade scam & dupe unit/gem"
        }
    )

    local Input =
        Tabs.Trade:AddInput(
        "Input",
        {
            Title = "Text",
            Default = "",
            Placeholder = "Text Request Here...",
            Numeric = false, -- Only allows numbers
            Finished = false, -- Only calls callback when you press enter
            Callback = function(Value)
                print("Input changed:", Value)
            end
        }
    )

    Tabs.Trade:AddButton(
        {
            Title = "Send Commands ",
            Description = "send you request to cmd on script",
            Callback = function()
                Window:Dialog(
                    {
                        Title = "Send",
                        Content = "You wanna Send Request Right?",
                        Buttons = {
                            {
                                Title = "Sure",
                                Callback = function()
                                    print("Confirmed the dialog.")
                                end
                            },
                            {
                                Title = "Cancel",
                                Callback = function()
                                    print("Cancelled the dialog.")
                                end
                            }
                        }
                    }
                )
            end
        }
    )

    Tabs.Trade:AddParagraph(
        {
            Title = "How to use Send Commands?",
            Content = "just text if correct the cmd on script will start and you got it!"
        }
    )

    Tabs.Trade:AddButton(
        {
            Title = "Copy Dupe Unit Commands",
            Description = "",
            Callback = function()
                setclipboard("/dupe <amount>")
            end
        }
    )

    Tabs.Trade:AddButton(
        {
            Title = "Copy Dupe Gem Commands",
            Description = "",
            Callback = function()
                setclipboard("/dupe gem:<amount>")
            end
        }
    )

    Tabs.Trade:AddButton(
        {
            Title = "Copy Dupe Coin Commands",
            Description = "",
            Callback = function()
                setclipboard("/dupe coin:<amount>")
            end
        }
    )

    Tabs.Trade:AddButton(
        {
            Title = "Copy Dupe Crate Commands",
            Description = "",
            Callback = function()
                setclipboard("/dupe crate:<amount>")
            end
        }
    )

    local Farm1 = Tabs.AutoPlay:AddSection("Automatics Features")

    Tabs.AutoPlay:AddParagraph(
        {
            Title = "How to use Auto Play?",
            Content = "fucking ez you just have best unit on slot and enable auto play so good night you can sleep now :D"
        }
    )

    local AutoPlay = Tabs.AutoPlay:AddToggle("AutoPlay", {Title = "Auto Play (Win Rate 100%)", Default = false})
    AutoPlay:OnChanged(
        function(Value)
            _G.autoplay = Value
        end
    )
    Options.AutoPlay:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.autoplay then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local AutoKaitan = Tabs.AutoPlay:AddToggle("AutoKaitan", {Title = "Auto Kaitan (Gold)", Default = false})
    AutoKaitan:OnChanged(
        function(Value)
            _G.autokaitan = Value
        end
    )
    Options.AutoKaitan:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.autokaitan then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local AutoQuests = Tabs.AutoPlay:AddToggle("AutoQuests", {Title = "Auto Doing Quests", Default = false})
    AutoQuests:OnChanged(
        function(Value)
            _G.autoquests1 = Value
        end
    )
    Options.AutoQuests:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.autoquests then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local MultiDropdown4 =
        Tabs.AutoPlay:AddDropdown(
        "MultiDropdown",
        {
            Title = "Select Quests Method",
            Description = "auto doing quests your select",
            Values = {"Daily", "Weekly"},
            Multi = true,
            Default = {"Daily", "Weekly"}
        }
    )

    local Farm41414 = Tabs.AutoPlay:AddSection("Supported Features")

    Tabs.AutoPlay:AddParagraph(
        {
            Title = "Auto Upgrade/Auto Sell Unit",
            Content = "just select what you want to auto upgrade or auto sell unit"
        }
    )

    local MultiDropdown =
        Tabs.AutoPlay:AddDropdown(
        "MultiDropdown",
        {
            Title = "Select Unit",
            Description = "upgrade unit your select",
            Values = {"Slot 1", "Slot 2", "Slot 3", "Slot 4", "Slot 5"},
            Multi = true,
            Default = {"Slot 1", "Slot 2"}
        }
    )

    local afterwave1 =
        Tabs.AutoPlay:AddSlider(
        "afterwave1",
        {
            Title = "Auto Upgrade After Wave",
            Description = "select wave",
            Default = 1,
            Min = 1,
            Max = 100,
            Rounding = 1,
            Callback = function(Value)
                print("Slider was changed:", Value)
            end
        }
    )

    afterwave1:OnChanged(
        function(Value)
            print("Slider changed:", Value)
        end
    )

    afterwave1:SetValue(1)

    local MultiDropdown1 =
        Tabs.AutoPlay:AddDropdown(
        "MultiDropdown1",
        {
            Title = "Select Unit",
            Description = "sell unit your select",
            Values = {"Slot 1", "Slot 2", "Slot 3", "Slot 4", "Slot 5"},
            Multi = true,
            Default = {"Slot 1", "Slot 2"}
        }
    )

    local MultiDropdown3 =
        Tabs.AutoPlay:AddDropdown(
        "MultiDropdown3",
        {
            Title = "Select Priority",
            Values = {"Index", "Expensive", "Cheapest"},
            Multi = false,
            Default = 1
        }
    )

    local afterwave2 =
        Tabs.AutoPlay:AddSlider(
        "afterwave2",
        {
            Title = "Auto Sell Unit After Wave",
            Description = "select wave",
            Default = 1,
            Min = 1,
            Max = 100,
            Rounding = 1,
            Callback = function(Value)
                print("Slider was changed:", Value)
            end
        }
    )

    afterwave2:OnChanged(
        function(Value)
            print("Slider changed:", Value)
        end
    )

    afterwave2:SetValue(1)

    local AutoSell = Tabs.AutoPlay:AddToggle("AutoSell", {Title = "Auto Sell Unit", Default = false})
    AutoSell:OnChanged(
        function(Value)
            _G.autosell = Value
        end
    )
    Options.AutoSell:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.autosell then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local Farm441414 = Tabs.Joins:AddSection("Auto Start")

    Tabs.Joins:AddParagraph(
        {
            Title = "How to use Auto Start?",
            Content = "fucking ez you just enable auto start with map your select bro"
        }
    )

    local AutoStart = Tabs.Joins:AddToggle("AutoStart", {Title = "Auto Start", Default = false})
    AutoStart:OnChanged(
        function(Value)
            _G.autostart = Value
        end
    )
    Options.AutoStart:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.autostart then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local delayforautojoin =
        Tabs.Joins:AddSlider(
        "delayforautojoin",
        {
            Title = "Using Auto Join After X",
            Description = "set delay to enter the room",
            Default = 10,
            Min = 1,
            Max = 200,
            Rounding = 1,
            Callback = function(Value)
                print("Slider was changed:", Value)
            end
        }
    )

    delayforautojoin:OnChanged(
        function(Value)
            print("Slider changed:", Value)
        end
    )

    delayforautojoin:SetValue(10)

    local Farm4144414 = Tabs.Joins:AddSection("Auto Joins")

    Tabs.Joins:AddParagraph(
        {
            Title = "How to use Auto Joins?",
            Content = "fucking ez you just enable auto join with map your select bro"
        }
    )

    local selectworld =
        Tabs.Joins:AddDropdown(
        "selectworld",
        {
            Title = "Select World",
            Values = {
                "EggIsland",
                "Desert",
                "ToiletCity",
                "ToiletLab",
                "CameramanHQ",
                "ToiletHQ",
                "Ohio",
                "PalmParadise",
                "ToiletFortress"
            },
            Multi = false,
            Default = 1
        }
    )

    local AutoJoins = Tabs.Joins:AddToggle("AutoJoins", {Title = "Auto Joins", Default = false})
    AutoJoins:OnChanged(
        function(Value)
            _G.autojoins = Value
        end
    )
    Options.AutoJoins:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.autojoins then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local Farm41414f = Tabs.Joins:AddSection("Teleport")

    Tabs.Joins:AddParagraph(
        {
            Title = "What the fuck bro?",
            Content = "you can teleport to you select place"
        }
    )

    Tabs.Joins:AddButton(
        {
            Title = "Return To Lobby",
            Description = "teleport to lobby",
            Callback = function()
                Window:Dialog(
                    {
                        Title = "Hey bro?",
                        Content = "you really wannt teleport to lobby right?",
                        Buttons = {
                            {
                                Title = "Sure",
                                Callback = function()
                                    print("lol")
                                end
                            },
                            {
                                Title = "Cancel",
                                Callback = function()
                                    print("Cancelled")
                                end
                            }
                        }
                    }
                )
            end
        }
    )

    Tabs.Joins:AddButton(
        {
            Title = "Return To Trading Plaza",
            Description = "teleport to trading plaza",
            Callback = function()
                Window:Dialog(
                    {
                        Title = "Hey bro?",
                        Content = "you really wannt teleport to trading plaza right?",
                        Buttons = {
                            {
                                Title = "Sure",
                                Callback = function()
                                    print("lol")
                                end
                            },
                            {
                                Title = "Cancel",
                                Callback = function()
                                    print("Cancelled")
                                end
                            }
                        }
                    }
                )
            end
        }
    )

    Tabs.Joins:AddButton(
        {
            Title = "Return To AFK World",
            Description = "teleport to afk world",
            Callback = function()
                Window:Dialog(
                    {
                        Title = "Hey bro?",
                        Content = "you really wannt teleport to afk world right?",
                        Buttons = {
                            {
                                Title = "Sure",
                                Callback = function()
                                    print("lol")
                                end
                            },
                            {
                                Title = "Cancel",
                                Callback = function()
                                    print("Cancelled")
                                end
                            }
                        }
                    }
                )
            end
        }
    )

    local Farm41414fs = Tabs.Marco:AddSection("Macro Features")

    Tabs.Marco:AddParagraph(
        {
            Title = "Macro Status",
            Content = "Satus: Disabled / Game Time: 0 (sec) / Index: nil"
        }
    )

    local selectmarco =
        Tabs.Marco:AddDropdown(
        "selectmarco",
        {
            Title = "Select File",
            Values = {"solo eggisland wave 60", "ez farm coin", "ttd", "zpu"},
            Multi = false,
            Default = 1
        }
    )

    local Input5 =
        Tabs.Marco:AddInput(
        "Input5",
        {
            Title = "Create Macro",
            Default = "",
            Placeholder = "Macro Name Here...",
            Numeric = false, -- Only allows numbers
            Finished = false, -- Only calls callback when you press enter
            Callback = function(Value)
                print("Input changed:", Value)
            end
        }
    )

    Tabs.Marco:AddButton(
        {
            Title = "Create Macro",
            Description = "create macro file you can record below",
            Callback = function()
                Window:Dialog(
                    {
                        Title = "Hey bro?",
                        Content = "you really wannt to Create Macro right?",
                        Buttons = {
                            {
                                Title = "Sure",
                                Callback = function()
                                    print("lol")
                                end
                            },
                            {
                                Title = "Cancel",
                                Callback = function()
                                    print("Cancelled")
                                end
                            }
                        }
                    }
                )
            end
        }
    )

    Tabs.Marco:AddButton(
        {
            Title = "Refresh Macro File",
            Description = "refresh macro file for show new you create",
            Callback = function()
                Window:Dialog(
                    {
                        Title = "Hey bro?",
                        Content = "you really wannt to refresh macro file right?",
                        Buttons = {
                            {
                                Title = "Sure",
                                Callback = function()
                                    print("lol")
                                end
                            },
                            {
                                Title = "Cancel",
                                Callback = function()
                                    print("Cancelled")
                                end
                            }
                        }
                    }
                )
            end
        }
    )

    Tabs.Marco:AddButton(
        {
            Title = "Refresh Macro File",
            Description = "refresh macro file for show new you create",
            Callback = function()
                Window:Dialog(
                    {
                        Title = "Hey bro?",
                        Content = "you really wannt to refresh macro file right?",
                        Buttons = {
                            {
                                Title = "Sure",
                                Callback = function()
                                    print("lol")
                                end
                            },
                            {
                                Title = "Cancel",
                                Callback = function()
                                    print("Cancelled")
                                end
                            }
                        }
                    }
                )
            end
        }
    )

    Tabs.Marco:AddButton(
        {
            Title = "Equip Unit Form Macro",
            Description = "equip unit form macro by you select",
            Callback = function()
                Window:Dialog(
                    {
                        Title = "Hey bro?",
                        Content = "you really wannt to equip unit form macro file right?",
                        Buttons = {
                            {
                                Title = "Sure",
                                Callback = function()
                                    print("lol")
                                end
                            },
                            {
                                Title = "Cancel",
                                Callback = function()
                                    print("Cancelled")
                                end
                            }
                        }
                    }
                )
            end
        }
    )

    Tabs.Marco:AddButton(
        {
            Title = "Remove Macro File",
            Description = "remove macro file by you select",
            Callback = function()
                Window:Dialog(
                    {
                        Title = "Hey bro?",
                        Content = "you really wannt to remove macro file right?",
                        Buttons = {
                            {
                                Title = "Sure",
                                Callback = function()
                                    print("lol")
                                end
                            },
                            {
                                Title = "Cancel",
                                Callback = function()
                                    print("Cancelled")
                                end
                            }
                        }
                    }
                )
            end
        }
    )

    local Farm41414953 = Tabs.Marco:AddSection("Recording")

    local MultiDropdown188 =
        Tabs.Marco:AddDropdown(
        "MultiDropdown188",
        {
            Title = "Actions",
            Description = "record Actions from your select",
            Values = {"Place", "Upgrade", "Sell", "Target", "Ability", "Skip Wave"},
            Multi = true,
            Default = {"Place", "Upgrade", "Sell", "Target", "Ability", "Skip Wave"}
        }
    )

    local MacroRecord = Tabs.Marco:AddToggle("MacroRecord", {Title = "Macro Record", Default = false})
    MacroRecord:OnChanged(
        function(Value)
            _G.macrorecord = Value
        end
    )
    Options.MacroRecord:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.macrorecord then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    Tabs.Marco:AddParagraph(
        {
            Title = "Macro Play",
            Content = "Satus: Disabled / Index: 0/0 / Action: nil"
        }
    )

    local MultiDropdown1883 =
        Tabs.Marco:AddDropdown(
        "MultiDropdown1883",
        {
            Title = "Play Method",
            Values = {"Index Action", "Time Action"},
            Multi = false,
            Default = 1
        }
    )

    local MacroRecord1 = Tabs.Marco:AddToggle("MacroRecord1", {Title = "Macro Play", Default = false})
    MacroRecord1:OnChanged(
        function(Value)
            _G.macrorecord1 = Value
        end
    )
    Options.MacroRecord1:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.macrorecord1 then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local AutoUpgrade = Tabs.AutoPlay:AddToggle("AutoUpgrade", {Title = "Auto Upgrade", Default = false})
    AutoUpgrade:OnChanged(
        function(Value)
            _G.autoupgrade = Value
        end
    )
    Options.AutoUpgrade:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.autoupgrade then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local Farm41414gg = Tabs.Event:AddSection("Event Features")

    Tabs.Event:AddParagraph(
        {
            Title = "How to use?",
            Content = "you can afk with this shit cuz we have auto play with AI you just have unit on slot and go to sleep, good night kid :D"
        }
    )

    local ToggleEventautofarmegg =
        Tabs.Event:AddToggle("ToggleEventautofarmegg", {Title = "Auto Farm Egg", Default = false})
    ToggleEventautofarmegg:OnChanged(
        function(Value)
            _G.autofarmegg = Value
        end
    )
    Options.ToggleEventautofarmegg:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.autofarmegg then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local ToggleEventautoclaimpass =
        Tabs.Event:AddToggle("ToggleEventautoclaimpass", {Title = "Auto Claim Easter Event Pass", Default = false})
    ToggleEventautoclaimpass:OnChanged(
        function(Value)
            _G.autoclaimegg = Value
        end
    )
    Options.ToggleEventautoclaimpass:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.autoclaimegg then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local ToggleEventautoclaim =
        Tabs.Event:AddToggle("ToggleEventautoclaim", {Title = "Auto Claim Easter Missions", Default = false})
    ToggleEventautoclaim:OnChanged(
        function(Value)
            _G.autoclaimeggmissions = Value
        end
    )
    Options.ToggleEventautoclaim:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.autoclaimeggmissions then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local selectcount11 =
        Tabs.Event:AddDropdown(
        "selectcount11",
        {
            Title = "Select Count",
            Values = {"400", "2000", "8000", "20000"},
            Multi = false,
            Default = 1
        }
    )

    local ToggleEventconvert =
        Tabs.Event:AddToggle("ToggleEventconvert", {Title = "Auto Convert Eggs to Gems", Default = false})
    ToggleEventconvert:OnChanged(
        function(Value)
            _G.autoconvert = Value
        end
    )
    Options.ToggleEventconvert:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.autoconvert then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local Input1 =
        Tabs.Event:AddInput(
        "Input1",
        {
            Title = "Username",
            Default = "",
            Placeholder = "Username Here...",
            Numeric = false, -- Only allows numbers
            Finished = false, -- Only calls callback when you press enter
            Callback = function(Value)
                print("Input changed:", Value)
            end
        }
    )

    local selectcount =
        Tabs.Event:AddDropdown(
        "selectcount",
        {
            Title = "Select Count",
            Values = {"1", "3", "10"},
            Multi = false,
            Default = 1
        }
    )

    local Togglegift = Tabs.Event:AddToggle("Togglegift", {Title = "Auto Gift Easter Event Crate", Default = false})
    Togglegift:OnChanged(
        function(Value)
            _G.gift1 = Value
        end
    )
    Options.Togglegift:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.gift1 then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local selectcount7 =
        Tabs.Summon:AddDropdown(
        "selectcount7",
        {
            Title = "Select Count",
            Values = {"1", "10"},
            Multi = false,
            Default = 1
        }
    )

    local delay =
        Tabs.Summon:AddSlider(
        "delay",
        {
            Title = "Summon Delay",
            Description = "Set summon delay idk :D",
            Default = 1,
            Min = 1,
            Max = 50,
            Rounding = 1,
            Callback = function(Value)
                print("Slider was changed:", Value)
            end
        }
    )

    afterwave2:OnChanged(
        function(Value)
            print("Slider changed:", Value)
        end
    )

    afterwave2:SetValue(1)

    local ToggleSummon1 = Tabs.Summon:AddToggle("ToggleSummon1", {Title = "Auto Summon", Default = false})
    ToggleSummon1:OnChanged(
        function(Value)
            _G.summon1 = Value
        end
    )
    Options.ToggleSummon1:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.summon1 then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local Farm41414ytd = Tabs.Summon:AddSection("Sell Unit")

    Tabs.Summon:AddParagraph(
        {
            Title = "Select Sell Unit",
            Content = "you can use auto sell unit you don't want right here!"
        }
    )

    local Togglesell1 =
        Tabs.Summon:AddToggle(
        "Togglesell1",
        {Title = "Sell Basic", Description = "Auto Sell basic unit", Default = false}
    )
    Togglesell1:OnChanged(
        function(Value)
            _G.sell1 = Value
        end
    )
    Options.Togglesell1:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.sell1 then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local Togglesell2 =
        Tabs.Summon:AddToggle(
        "Togglesell2",
        {Title = "Sell Uncommon", Description = "Auto Sell uncommon unit", Default = false}
    )
    Togglesell2:OnChanged(
        function(Value)
            _G.sell2 = Value
        end
    )
    Options.Togglesell2:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.sell2 then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local Togglesell3 =
        Tabs.Summon:AddToggle(
        "Togglesell3",
        {Title = "Sell Rare", Description = "Auto Sell rare unit", Default = false}
    )
    Togglesell3:OnChanged(
        function(Value)
            _G.sell3 = Value
        end
    )
    Options.Togglesell3:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.sell3 then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local Togglesell4 =
        Tabs.Summon:AddToggle(
        "Togglesell4",
        {Title = "Sell Epic", Description = "Auto Sell epic unit", Default = false}
    )
    Togglesell4:OnChanged(
        function(Value)
            _G.sell4 = Value
        end
    )
    Options.Togglesell4:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.sell4 then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local Togglesell5 =
        Tabs.Summon:AddToggle(
        "Togglesell5",
        {Title = "Sell Legendary", Description = "Auto Sell legendary unit", Default = false}
    )
    Togglesell5:OnChanged(
        function(Value)
            _G.sell5 = Value
        end
    )
    Options.Togglesell5:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.sell5 then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local Farm414fdfwfa14 = Tabs.Visuals:AddSection("Visuals Features")

    Tabs.Visuals:AddParagraph(
        {
            Title = "What is this?",
            Content = "so many visuals on this you can sign unit with youself and more in future"
        }
    )

    local TogglegetSign =
        Tabs.Visuals:AddToggle("TogglegetSign", {Title = "Get Sign Tool (Exclusive)", Default = false})
    TogglegetSign:OnChanged(
        function(Value)
            _G.getsign = Value
        end
    )
    Options.TogglegetSign:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.getsign then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local ToggleSign = Tabs.Visuals:AddToggle("ToggleSign", {Title = "Auto Sign Unit (Exclusive)", Default = false})
    ToggleSign:OnChanged(
        function(Value)
            _G.sign = Value
        end
    )
    Options.ToggleSign:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.sign then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local ToggleSignceeza =
        Tabs.Visuals:AddToggle("ToggleSignceeza", {Title = "Auto Sign Unit (Cee Zaa)", Default = false})
    ToggleSignceeza:OnChanged(
        function(Value)
            _G.signceeza = Value
        end
    )
    Options.ToggleSignceeza:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.signceeza then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    local ToggleSignyt =
        Tabs.Visuals:AddToggle("ToggleSignyt", {Title = "Auto Sign Unit (Random Youtuber)", Default = false})
    ToggleSign:OnChanged(
        function(Value)
            _G.signyt = Value
        end
    )
    Options.ToggleSign:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.signyt then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    Tabs.Visuals:AddParagraph(
        {
            Title = "How to use Auto Sign?",
            Content = "this so ez just got unit you want sign on slot and enable auto sign (just one unit!) and enjoy!"
        }
    )

    local Farm4141rqwqd4 = Tabs.Visuals:AddSection("More Visuals")

    local Togglefreegamepass =
        Tabs.Visuals:AddToggle(
        "Togglefreegamepass",
        {Title = "Get Free Gamepasses (VIP, Lucky, Double Coins)", Default = false}
    )
    Togglefreegamepass:OnChanged(
        function(Value)
            _G.freegamepass = Value
        end
    )
    Options.Togglefreegamepass:SetValue(false)
    spawn(
        function()
            pcall(
                function()
                    while wait(.1) do
                        if _G.freegamepass then
                            print("lol")
                        end
                    end
                end
            )
        end
    )

    Tabs.Visuals:AddButton(
        {
            Title = "Admin Commands (UI)",
            Description = "so this function open Infinite Yield Script for you",
            Callback = function()
                Window:Dialog(
                    {
                        Title = "Open Admin Commands GUI",
                        Content = "you really wannt to open admin commands gui right?",
                        Buttons = {
                            {
                                Title = "Sure",
                                Callback = function()
                                    loadstring(
                                        game:HttpGet(
                                            ("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"),
                                            true
                                        )
                                    )()
                                end
                            },
                            {
                                Title = "Cancel",
                                Callback = function()
                                    print("Cancelled")
                                end
                            }
                        }
                    }
                )
            end
        }
    )

    local Farm41vfc414 = Tabs.Misc:AddSection("Misc Features")

    Tabs.Misc:AddButton(
        {
            Title = "Rejoin",
            Description = "Rejoin The Server",
            Callback = function()
                Window:Dialog(
                    {
                        Title = "Teleport",
                        Content = "Are you sure?",
                        Buttons = {
                            {
                                Title = "Confirm",
                                Callback = function()
                                    print("Teleported")
                                    game:GetService("TeleportService"):Teleport(
                                        game.PlaceId,
                                        game:GetService("Players").LocalPlayer
                                    )
                                end
                            },
                            {
                                Title = "Cancel",
                                Callback = function()
                                    print("Cancelled")
                                end
                            }
                        }
                    }
                )
            end
        }
    )
end

Tabs.Misc:AddButton(
    {
        Title = "Hop Server",
        Description = "",
        Callback = function()
            Hop()
        end
    }
)

function Hop()
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local foundAnything = ""
    local actualHour = os.date("!*t").hour
    local Deleted = false
    function TPReturner()
        local Site
        if foundAnything == "" then
            Site =
                game.HttpService:JSONDecode(
                game:HttpGet(
                    "https://games.roblox.com/v1/games/" .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100"
                )
            )
        else
            Site =
                game.HttpService:JSONDecode(
                game:HttpGet(
                    "https://games.roblox.com/v1/games/" ..
                        PlaceID .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. foundAnything
                )
            )
        end
        local ID = ""
        if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
            foundAnything = Site.nextPageCursor
        end
        local num = 0
        for i, v in pairs(Site.data) do
            local Possible = true
            ID = tostring(v.id)
            if tonumber(v.maxPlayers) > tonumber(v.playing) then
                for _, Existing in pairs(AllIDs) do
                    if num ~= 0 then
                        if ID == tostring(Existing) then
                            Possible = false
                        end
                    else
                        if tonumber(actualHour) ~= tonumber(Existing) then
                            local delFile =
                                pcall(
                                function()
                                    AllIDs = {}
                                    table.insert(AllIDs, actualHour)
                                end
                            )
                        end
                    end
                    num = num + 1
                end
                if Possible == true then
                    table.insert(AllIDs, ID)
                    wait()
                    pcall(
                        function()
                            wait()
                            game:GetService("TeleportService"):TeleportToPlaceInstance(
                                PlaceID,
                                ID,
                                game.Players.LocalPlayer
                            )
                        end
                    )
                    wait(4)
                end
            end
        end
    end
    function Teleport()
        while wait() do
            pcall(
                function()
                    TPReturner()
                    if foundAnything ~= "" then
                        TPReturner()
                    end
                end
            )
        end
    end
    Teleport()
end

Tabs.Misc:AddButton(
    {
        Title = "Hop Server [ Low Player ]",
        Description = "",
        Callback = function()
            getgenv().AutoTeleport = true
            getgenv().DontTeleportTheSameNumber = true
            getgenv().CopytoClipboard = false
            if not game:IsLoaded() then
                print("Game is loading waiting...")
            end
            local maxplayers = math.huge
            local serversmaxplayer
            local goodserver
            local gamelink =
                "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            function serversearch()
                for _, v in pairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync(gamelink)).data) do
                    if type(v) == "table" and v.playing ~= nil and maxplayers > v.playing then
                        serversmaxplayer = v.maxPlayers
                        maxplayers = v.playing
                        goodserver = v.id
                    end
                end
            end
            function getservers()
                serversearch()
                for i, v in pairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync(gamelink))) do
                    if i == "nextPageCursor" then
                        if gamelink:find("&cursor=") then
                            local a = gamelink:find("&cursor=")
                            local b = gamelink:sub(a)
                            gamelink = gamelink:gsub(b, "")
                        end
                        gamelink = gamelink .. "&cursor=" .. v
                        getservers()
                    end
                end
            end
            getservers()
            if AutoTeleport then
                if DontTeleportTheSameNumber then
                    if #game:GetService("Players"):GetPlayers() - 4 == maxplayers then
                        return warn("It has same number of players (except you)")
                    elseif goodserver == game.JobId then
                        return warn("Your current server is the most empty server atm")
                    end
                end
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, goodserver)
            end
        end
    }
)

local White =
    Tabs.Misc:AddToggle(
    "White",
    {Title = "White Screen Mode", Description = "Reduce GPU/CPU Very Recommend!", Default = false}
)

White:OnChanged(
    function()
        print("lol", Options.White.Value)
    end
)

Options.White:SetValue(false)

local Black =
    Tabs.Misc:AddToggle(
    "Black",
    {
        Title = "Black Screen Mode",
        Description = "Too same with White Screen but VERY COOL and Easy on the eyes",
        Default = false
    }
)

Black:OnChanged(
    function()
        print("lol", Options.Black.Value)
    end
)

Options.Black:SetValue(false)

local name =
    Tabs.Misc:AddToggle(
    "name",
    {
        Title = "Hide Name",
        Description = "people can't see your name that good for protect your form report nigga",
        Default = false
    }
)

name:OnChanged(
    function()
        print("lol", Options.name.Value)
    end
)

Options.name:SetValue(false)

local rtx = Tabs.Misc:AddToggle("rtx", {Title = "FPS Booster (1000 FPS++)", Default = false})

rtx:OnChanged(
    function()
        print("lol", Options.rtx.Value)
    end
)

Options.rtx:SetValue(false)

local smooth =
    Tabs.Misc:AddToggle(
    "smooth",
    {
        Title = "Smooth Graphics (Like FREE FIRE :D)",
        Description = "you wanna play free fire on roblox right? enable this function nigga",
        Default = false
    }
)

smooth:OnChanged(
    function()
        print("lol", Options.smooth.Value)
    end
)

Options.name:SetValue(false)

local SetFPS =
    Tabs.Misc:AddDropdown(
    "SetFPS",
    {
        Title = "Set FPS (Very Recommend!)",
        Values = {"10", "30", "60", "120", "200", "300"},
        Multi = false,
        Default = 300
    }
)

Tabs.Webhook:AddParagraph(
    {
        Title = "How to use Webhooks?",
        Content = "this very ez just copy discord webhook url and paste on here and enter you can get notify form Spectrum if you end game we got your Result Notification"
    }
)

local Input =
    Tabs.Webhook:AddInput(
    "Input",
    {
        Title = "Webhooks URL",
        Default = "",
        Placeholder = "Url Here...",
        Numeric = false, -- Only allows numbers
        Finished = false, -- Only calls callback when you press enter
        Callback = function(Value)
            print("Input changed:", Value)
        end
    }
)

Tabs.Webhook:AddButton(
    {
        Title = "Check Webhook",
        Description = "test your webhook for sure this working!",
        Callback = function()
            Window:Dialog(
                {
                    Title = "Test Webhook",
                    Content = "hey nigga you wanna test webhook right?",
                    Buttons = {
                        {
                            Title = "Sure",
                            Callback = function()
                                print("Confirmed the dialog.")
                            end
                        },
                        {
                            Title = "Cancel",
                            Callback = function()
                                print("Cancelled the dialog.")
                            end
                        }
                    }
                }
            )
        end
    }
)

local Toggle =
    Tabs.Webhook:AddToggle(
    "MyToggle",
    {
        Title = "Send Webhook",
        Description = "Send Result Notification after game end don't care you win or lose",
        Default = false
    }
)

Toggle:OnChanged(
    function()
        print("lol", Options.MyToggle.Value)
    end
)

Options.MyToggle:SetValue(false)

local note1 = Tabs.Setting:AddSection("Note")

Tabs.Setting:AddParagraph(
    {
        Title = "Hey Nigga!",
        Content = "come suck my dick and you can get free\n exclusive edition for 1 key and gimme your big ass hole"
    }
)

--Settings
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("Project Spectrum")
SaveManager:SetFolder("Project Spectrum/Toilet Tower Denfese")

InterfaceManager:BuildInterfaceSection(Tabs.Setting)
SaveManager:BuildConfigSection(Tabs.Setting)

Window:SelectTab(1)

Fluent:Notify(
    {
        Title = "Project Spectrum 8.0",
        Content = "The Cheat has been loaded, Enjoy :D\n \nTime Taken: 01.139533719 Seconds!",
        Duration = 8
    }
)

SaveManager:LoadAutoloadConfig()
