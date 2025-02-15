local luacompactImports = {}
local luacompactModules = {}

function resolvePath(dir, luacompactTable)
	while string.sub(dir, 1, 1) == "." or string.sub(dir, 1, 1) == "/" do
		dir = string.sub(dir, 2)
	end

	if luacompactTable[dir..".lua"] then
		dir = dir..".lua"
	elseif luacompactTable[dir..".luau"] then
		dir = dir..".luau"
	end
	return dir
end

function getFileType(filePath,file)
    if not filePath or not file then
        return
    end

    local currentFileExtension = filePath:match("^.+%.([^.]+)$")

    if currentFileExtension == "luau" then
        return typeof(file)
    end

    return type(file)
end

function load(dir)
	local path = resolvePath(dir, luacompactModules)
	local loadedScript = luacompactModules[path]
	if getFileType(path,loadedScript) == "function" then
		return loadedScript()
	end
	return "Invalid script path."
end

function import(dir)
	local path = resolvePath(dir, luacompactImports)
	local importedFile = luacompactImports[path]
	if getFileType(path,importedFile) == "function" then
		return importedFile()
	end
	return "Invalid file path."
end

luacompactModules["libs/linkvertise.lua"] = function()
	-- Linkvertise API for Roblox

	local linkvertise = {}

	-- Convert string to base64
	local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

	local function btoa(str)
	    return crypt.base64encode(str)
	end

	-- URL encode function
	local function urlEncode(str)
	    return str:gsub("[^%w%.%-_~]", function(c)
	        if c == "/" or c == ":" then
	            return c
	        end
	        return string.format("%%%02X", string.byte(c))
	    end)
	end

	-- Generate linkvertise URL
	function linkvertise.create(userid, link)
	    if type(userid) ~= "string" and type(userid) ~= "number" then
	        return nil, "UserID must be string or number"
	    end
	    
	    if type(link) ~= "string" then
	        return nil, "Link must be string"
	    end
	    
	    if not userid or not link then
	        return nil, "Missing required parameters"
	    end

	    local random = math.floor(math.random() * 1000)
	    local base_url = string.format("https://link-to.net/%s/%d/dynamic", tostring(userid), random)
	    local base64_link = btoa(link)
	    local href = base_url .. "?r=" .. base64_link
	    
	    return href
	end
	-- print(linkvertise.create(870731, "https://web.telegram.org/"))
	-- setclipboard(linkvertise.create(870731, "https://web.telegram.org/"))
	return linkvertise
end
luacompactModules["libs/ui.lua"] = function()
	--[[
		Roblox2Lua
		----------
		
		This code was generated using
		Deluct's Roblox2Lua plugin.
	]]
	--

	local UIComponents = {}

	-- Constants
	local COLORS = {
		BACKGROUND = Color3.new(0.109804, 0.0980392, 0.0901961),
		TEXT_PRIMARY = Color3.new(0.941176, 0.941176, 0.941176),
		TEXT_SECONDARY = Color3.new(0.792157, 0.792157, 0.792157),
		BUTTON_GREEN = Color3.new(0.133333, 0.772549, 0.368627),
		STROKE = Color3.new(0.152941, 0.152941, 0.164706),
		INPUT = {
			BACKGROUND = Color3.new(1, 1, 1),
			TEXT = Color3.new(0.941176, 0.941176, 0.941176),
			PLACEHOLDER = Color3.new(0.611765, 0.611765, 0.647059),
			LABEL = Color3.new(0.941176, 0.941176, 0.941176),
			DESCRIPTION = Color3.new(0.941176, 0.941176, 0.941176),
		},
		VERIFY_BUTTON = {
			BACKGROUND = Color3.new(0.133333, 0.772549, 0.368627),
			TEXT = Color3.new(0.035, 0.035, 0.043),
			LINK = Color3.new(0.133333, 0.772549, 0.368627),
			SECONDARY_TEXT = Color3.new(0.792157, 0.792157, 0.792157),
		},
	}

	local STYLES = {
		CORNER_RADIUS = UDim.new(0, 6),
		PADDING = {
			DEFAULT = UDim.new(0, 6),
			SMALL = UDim.new(0, 8),
			MEDIUM = UDim.new(0, 16),
			LARGE = UDim.new(0, 24),
		},
		INPUT = {
			FONT = Enum.Font.Gotham,
			TEXT_SIZE = 14,
			PADDING = UDim.new(0, 12),
			HEIGHT = 40,
			SPACING = UDim.new(0, 8),
		},
		VERIFY_BUTTON = {
			HEIGHT = 40,
			FONT = Enum.Font.Gotham,
			TEXT_SIZE = 14,
			PADDING = {
				TOP = UDim.new(0, 8),
				BOTTOM = UDim.new(0, 8),
				LEFT = UDim.new(0, 16),
				RIGHT = UDim.new(0, 16),
			},
			SPACING = UDim.new(0, 8),
		},
	}

	-- Helper Functions
	local function createTextLabel(props)
		local label = Instance.new("TextLabel")
		for key, value in pairs(props) do
			label[key] = value
		end
		return label
	end

	local function createButton(props)
		local button = Instance.new("TextButton")
		for key, value in pairs(props) do
			button[key] = value
		end
		return button
	end

	-- UI Components Creation
	function createMainWindow()
		local screen_gui = Instance.new("ScreenGui")
		screen_gui.IgnoreGuiInset = false
		screen_gui.ResetOnSpawn = false
		screen_gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		screen_gui.Parent = game.CoreGui

		local main_frame = Instance.new("Frame")
		main_frame.Name = "key"
		main_frame.AnchorPoint = Vector2.new(0.5, 0.5)
		main_frame.Position = UDim2.new(0.5, 0, 0.5, 0)
		main_frame.Size = UDim2.new(0, 600, 0, 400)
		main_frame.BackgroundColor3 = COLORS.BACKGROUND

		local corner = Instance.new("UICorner")
		corner.CornerRadius = STYLES.CORNER_RADIUS
		corner.Parent = main_frame

		main_frame.Parent = screen_gui
		return main_frame
	end

	function createHeader(parent, layoutOrder)
		local top = Instance.new("Frame")
		top.AutomaticSize = Enum.AutomaticSize.Y
		top.BackgroundTransparency = 1
		top.BorderSizePixel = 0
	    top.LayoutOrder = layoutOrder
		top.Size = UDim2.new(1, 0, 0, 0)
		top.Parent = parent

		local uilist_layout_2 = Instance.new("UIListLayout")
		uilist_layout_2.Padding = STYLES.PADDING.DEFAULT
		uilist_layout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uilist_layout_2.SortOrder = Enum.SortOrder.LayoutOrder
		uilist_layout_2.Parent = top

		local title = Instance.new("TextLabel")
		title.Font = Enum.Font.GothamMedium
		title.Text = "Check Your Key"
		title.TextColor3 = COLORS.TEXT_PRIMARY
		title.TextSize = 30
		title.AutomaticSize = Enum.AutomaticSize.Y
		title.BackgroundTransparency = 1
		title.BorderSizePixel = 0
		title.Size = UDim2.new(1, 0, 0, 0)
		title.Visible = true
		title.Parent = top

		local desc = Instance.new("TextLabel")
		desc.Font = Enum.Font.Gotham
		desc.Text = "Enter your key to access exclusive features."
		desc.TextColor3 = COLORS.TEXT_SECONDARY
		desc.TextSize = 16
		desc.AutomaticSize = Enum.AutomaticSize.Y
		desc.BackgroundTransparency = 1
		desc.BorderSizePixel = 0
		desc.Size = UDim2.new(1, 0, 0, 0)
		desc.Visible = true
		desc.Parent = top
	end

	function createInputSection(parent, layoutOrder)
		-- Container frame
		local input_container = Instance.new("Frame")
		input_container.Name = "keyinput"
		input_container.AutomaticSize = Enum.AutomaticSize.Y
		input_container.BackgroundTransparency = 1
	    input_container.LayoutOrder = layoutOrder
		input_container.Size = UDim2.new(1, 0, 0, 0)
		input_container.Parent = parent

		-- Input wrapper
		local input_wrapper = Instance.new("Frame")
		input_wrapper.Name = "boxinput"
		input_wrapper.AutomaticSize = Enum.AutomaticSize.Y
		input_wrapper.BackgroundTransparency = 1
		input_wrapper.Size = UDim2.new(1, 0, 0, 0)
		input_wrapper.Parent = input_container

		-- Layout for wrapper
		local list_layout = Instance.new("UIListLayout")
		list_layout.Padding = STYLES.INPUT.SPACING
		list_layout.SortOrder = Enum.SortOrder.LayoutOrder
		list_layout.Parent = input_wrapper

		-- Input label
		local label = createTextLabel({
			Name = "tag",
			Text = "Key",
			Font = STYLES.INPUT.FONT,
			TextSize = STYLES.INPUT.TEXT_SIZE,
			TextColor3 = COLORS.INPUT.LABEL,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, 0, 0, STYLES.INPUT.TEXT_SIZE),
			BackgroundTransparency = 1,
		})
		label.Parent = input_wrapper

		-- Text input
		local text_box = Instance.new("TextBox")
		text_box.Name = "KeyInput"
		text_box.Font = STYLES.INPUT.FONT
		text_box.TextSize = STYLES.INPUT.TEXT_SIZE
		text_box.TextColor3 = COLORS.INPUT.TEXT
		text_box.PlaceholderText = "Enter your key"
		text_box.PlaceholderColor3 = COLORS.INPUT.PLACEHOLDER
		text_box.Text = ""
		text_box.TextXAlignment = Enum.TextXAlignment.Left
		text_box.BackgroundTransparency = 1
		text_box.Size = UDim2.new(1, 0, 0, STYLES.INPUT.HEIGHT)
	    text_box.TextTruncate = Enum.TextTruncate.AtEnd
		text_box.Parent = input_wrapper

		-- Input styling
		local corner = Instance.new("UICorner")
		corner.CornerRadius = STYLES.CORNER_RADIUS
		corner.Parent = text_box

		local padding = Instance.new("UIPadding")
		padding.PaddingBottom = STYLES.INPUT.PADDING
		padding.PaddingLeft = STYLES.INPUT.PADDING
		padding.PaddingRight = STYLES.INPUT.PADDING
		padding.PaddingTop = STYLES.INPUT.PADDING
		padding.Parent = text_box

		local stroke = Instance.new("UIStroke")
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Color = COLORS.STROKE
		stroke.Parent = text_box

		-- Description text
		local description = createTextLabel({
			Name = "tagdesc",
			Text = "Don't have a key? You can get one by joining our Discord community.",
			Font = STYLES.INPUT.FONT,
			TextSize = STYLES.INPUT.TEXT_SIZE,
			TextColor3 = COLORS.INPUT.DESCRIPTION,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
		})
		description.Parent = input_wrapper

		-- Return both container and textbox for external access
		return {
			container = input_container,
			textbox = text_box,
		}
	end

	-- Update the createVerifyButton function to handle layout order correctly
	function createVerifyButton(parent, layoutOrder)
	    -- Button container with proper layout order
	    local button_container = Instance.new("Frame")
	    button_container.Name = "ButtonContainer"
	    button_container.AutomaticSize = Enum.AutomaticSize.Y
	    button_container.BackgroundTransparency = 1
	    button_container.LayoutOrder = layoutOrder -- Fix typo in parameter name
	    button_container.Size = UDim2.new(1, 0, 0, STYLES.VERIFY_BUTTON.HEIGHT)
	    button_container.Parent = parent

	    -- Container layout
	    local container_layout = Instance.new("UIListLayout")
	    container_layout.Padding = STYLES.VERIFY_BUTTON.SPACING
	    container_layout.SortOrder = Enum.SortOrder.LayoutOrder
	    container_layout.Parent = button_container

	    -- Main verify button
	    local verify_button = createButton({
	        Name = "VerifyButton",
	        Text = "Verify Key",
	        Font = STYLES.VERIFY_BUTTON.FONT,
	        TextSize = STYLES.VERIFY_BUTTON.TEXT_SIZE,
	        TextColor3 = COLORS.VERIFY_BUTTON.TEXT,
	        BackgroundColor3 = COLORS.VERIFY_BUTTON.BACKGROUND,
	        Size = UDim2.new(1, 0, 0, STYLES.VERIFY_BUTTON.HEIGHT),
	        BorderSizePixel = 0,
	        AutoButtonColor = false,
	        LayoutOrder = 1, -- First element
	    })

	    -- Button styling
	    local corner = Instance.new("UICorner")
	    corner.CornerRadius = STYLES.CORNER_RADIUS
	    corner.Parent = verify_button

	    local padding = Instance.new("UIPadding")
	    padding.PaddingTop = STYLES.VERIFY_BUTTON.PADDING.TOP
	    padding.PaddingBottom = STYLES.VERIFY_BUTTON.PADDING.BOTTOM
	    padding.PaddingLeft = STYLES.VERIFY_BUTTON.PADDING.LEFT
	    padding.PaddingRight = STYLES.VERIFY_BUTTON.PADDING.RIGHT
	    padding.Parent = verify_button

	    verify_button.Parent = button_container

	    -- Help text container
	    local help_text = Instance.new("Frame")
	    help_text.Name = "HelpText"
	    help_text.AutomaticSize = Enum.AutomaticSize.XY
	    help_text.BackgroundTransparency = 1
	    help_text.Size = UDim2.new(1, 0, 0, 0)
	    help_text.LayoutOrder = 2 -- Second element
	    help_text.Parent = button_container

	    -- Help text layout
	    local help_layout = Instance.new("UIListLayout")
	    help_layout.Padding = UDim.new(0, 0) -- Add small padding between help text elements
	    help_layout.FillDirection = Enum.FillDirection.Horizontal
	    help_layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	    help_layout.VerticalAlignment = Enum.VerticalAlignment.Center
	    help_layout.Parent = help_text

	    -- Help text components with sequential layout orders
	    local text_prefix = createTextLabel({
	        Text = "Need Key? Join our ",
	        Name = "1",
	        Font = STYLES.VERIFY_BUTTON.FONT,
	        TextSize = STYLES.VERIFY_BUTTON.TEXT_SIZE,
	        TextColor3 = COLORS.VERIFY_BUTTON.SECONDARY_TEXT,
	        AutomaticSize = Enum.AutomaticSize.XY,
	        LayoutOrder = 1,
	        BackgroundTransparency = 1,
	    })
	    text_prefix.Parent = help_text

	    local discord_button = createButton({
	        Text = "Discord",
	        Name = "2",
	        Font = STYLES.VERIFY_BUTTON.FONT,
	        TextSize = STYLES.VERIFY_BUTTON.TEXT_SIZE,
	        TextColor3 = COLORS.VERIFY_BUTTON.LINK,
	        AutomaticSize = Enum.AutomaticSize.XY,
	        BackgroundTransparency = 1,
	        LayoutOrder = 2,
	        RichText = true,
	    })
	    discord_button.Parent = help_text

	    local text_separator = createTextLabel({
	        Text = " or ",
	        Name = "3",
	        Font = STYLES.VERIFY_BUTTON.FONT,
	        TextSize = STYLES.VERIFY_BUTTON.TEXT_SIZE,
	        TextColor3 = COLORS.VERIFY_BUTTON.SECONDARY_TEXT,
	        AutomaticSize = Enum.AutomaticSize.XY,
	        BackgroundTransparency = 1,
	        LayoutOrder = 3,
	    })
	    text_separator.Parent = help_text

	    local getkey_button = createButton({
	        Text = "getkey",
	        Name = "4",
	        Font = STYLES.VERIFY_BUTTON.FONT,
	        TextSize = STYLES.VERIFY_BUTTON.TEXT_SIZE,
	        TextColor3 = COLORS.VERIFY_BUTTON.LINK,
	        AutomaticSize = Enum.AutomaticSize.XY,
	        BackgroundTransparency = 1,
	        LayoutOrder = 4,
	        RichText = true,
	    })
	    getkey_button.Parent = help_text

	    return {
	        container = button_container,
	        verifyButton = verify_button,
	        discordButton = discord_button,
	        getkeyButton = getkey_button,
	    }
	end

	-- Main UI Creation
	-- Update the init function to set correct layout orders
	function UIComponents.init()
	    local main_window = createMainWindow()
	    local content_holder = Instance.new("Frame")
	    content_holder.Name = "hold"
	    content_holder.Size = UDim2.new(0, 380, 0, 0)
	    content_holder.Position = UDim2.new(0.5, 0, 0.5, 0)
	    content_holder.AnchorPoint = Vector2.new(0.5, 0.5)
	    content_holder.BackgroundTransparency = 1
	    content_holder.AutomaticSize = Enum.AutomaticSize.Y

	    -- Add layout first
	    local list_layout = Instance.new("UIListLayout")
	    list_layout.Padding = STYLES.PADDING.LARGE
	    list_layout.SortOrder = Enum.SortOrder.LayoutOrder -- Make sure sort order is set
	    list_layout.Parent = content_holder

	    -- Create components with explicit layout orders
	    createHeader(content_holder, 1) -- First
	    local input_section = createInputSection(content_holder, 2) -- Second
	    local verify_section = createVerifyButton(content_holder, 3) -- Third

	    -- local key_text = input_section.textbox.Text -- Get the current text
		-- input_section.textbox.Changed:Connect(function(property)
		-- 	if property == "Text" then
		-- 		local new_text = input_section.textbox.Text
		-- 		-- Do something with the new text
		-- 	end
		-- end)

		-- -- Add click handlers
		-- verify_section.verifyButton.MouseButton1Click:Connect(function()
		-- 	-- Handle verify button click
		-- end)

		-- verify_section.discordButton.MouseButton1Click:Connect(function()
		-- 	-- Handle Discord button click
		-- end)

		-- verify_section.getkeyButton.MouseButton1Click:Connect(function()
		-- 	-- Handle getkey button click
		-- end)

	    content_holder.Parent = main_window
	    return {
	        container = main_window,
	        input = input_section.textbox,
	        verify = verify_section,
	    }
	end

	return UIComponents
	
end
local UIComponents = load("libs/ui.lua")
local Library =
	"https://raw.githubusercontent.com/Panda-Repositories/PandaKS_Libraries/refs/heads/main/library/LuaLib/ROBLOX/PandaSVALLib.lua"
local PandaAuth = loadstring(game:HttpGet(Library))()

local Notif = loadstring(game:HttpGet("https://raw.githubusercontent.com/NOOBARMYSCRIPTER/SirHub/refs/heads/main/main/Utils/notify.lua"))()

local linkvertise = load("libs/linkvertise.lua")

local KeySystem = {}
KeySystem.Settings = {
	DISCORD_INVITE = "https://discord.gg/yourinvite",
	SAVE_FILE = "bestkey.txt",
	SERVICE_NAME = "BestKeyUI",
	API_KEY = "YOUR_API_KEY_HERE",
	Display_Name = "BestKeyUI",
	Is_Debug = true,
	Allow_BlacklistUsers = false,
	EnableWebhook = false,
}

local function saveKey(key)
	local file = io.open(KeySystem.Settings.SAVE_FILE, "w")
	if file then
		file:write(key)
		file:close()
	end
end

local function loadSavedKey()
	local file = io.open(KeySystem.Settings.SAVE_FILE, "r")
	if file then
		local key = file:read("*all")
		file:close()
		return key
	end
	return nil
end

function KeySystem:Initialize(callback)
	-- Initialize PandaAuth
	PandaAuth:Initialize({
		Service = self.Settings.SERVICE_NAME,
		API_Key = self.Settings.API_KEY,
		DisplayName = self.Settings.Display_Name,
		IsDebug = self.Settings.Is_Debug,
		Allow_BlacklistUsers = self.Settings.Allow_BlacklistUsers,
		GUIVersion = false,
		EnableWebhook = self.Settings.EnableWebhook,
		Authenticated = function()
			-- print("[BestKeyUI] Key authenticated successfully!")
			if callback then
				callback(true)
			end
		end,
		NotAuthenticated = function()
			-- print("[BestKeyUI] Authentication failed!")
			if callback then
				callback(false)
			end
		end,
	})

	-- Create UI
	local ui = UIComponents.init()

	-- Load saved key if exists
	local savedKey = loadSavedKey()
	if savedKey then
		ui.input.Text = savedKey
	end

	-- Handle verify button click
	ui.verify.verifyButton.MouseButton1Click:Connect(function()
		local key = ui.input.Text

		if PandaAuth:ValidateKey(key) then
			saveKey(key)
			-- ui.verify.verifyButton.Text = "Valid Key!"
			-- ui.verify.verifyButton.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
            Notif.New("Key verified successfully!", 5)
			wait(1)
			ui.container:Destroy()
			if callback then
				callback(true)
			end
		else
            Notif.New("Invalid Key! Try again.", 5)
			-- ui.verify.verifyButton.Text = "Invalid Key!"
			-- ui.verify.verifyButton.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
			if callback then
				callback(false)
			end
		end
	end)

	-- Handle Discord button click
	ui.verify.discordButton.MouseButton1Click:Connect(function()
		setclipboard(self.Settings.DISCORD_INVITE)
        Notif.New(`Discord Invite Copied "{self.Settings.DISCORD_INVITE}".`, 5)
	end)

	-- Handle getkey button click
	ui.verify.getkeyButton.MouseButton1Click:Connect(function()
        local key = linkvertise(870731, PandaAuth:GetKey())
        setclipboard(key)
        Notif.New("GetKey link copied in clipboard.", 5)
	end)

	return ui
end

-- Example usage:
--[[
local KeySystem = require("init")
KeySystem:Initialize(function(success)
    if success then
        print("Key verified successfully!")
        -- Your code here after successful verification
    else
        print("Key verification failed!")
    end
end)
]]

return KeySystem
