local findtarget = dofile(... .. "/Lua/findtarget.lua")
	EditGUI = {}
	
UnlinkNetwork = function()
	if SERVER then
		-- lets send a net message to all clients so they remove our link
		local msg = Networking.Start("lualinker.remove")
		msg.WriteUInt16(UShort(itemedit1.ID))
		msg.WriteUInt16(UShort(itemedit2.ID))
		Networking.Send(msg)
    end
end

LinkNetwork = function()
    if SERVER then
        -- lets send a net message to all clients so they add our link
        local msg = Networking.Start("lualinker.add")
        msg.WriteUInt16(UShort(itemedit1.ID))
        msg.WriteUInt16(UShort(itemedit2.ID))
        Networking.Send(msg)
    end
end

network = function(itemedit)
	if SERVER then
		property = itemedit.SerializableProperties[Identifier("Test")]
		Networking.CreateEntityEvent(itemedit, itemedit.ChangePropertyEventData(property, itemedit))
	end
end

FindClientCharacter = function(character)  
    for key, value in pairs(Client.ClientList) do
        if value.Character == character then
            return value
        end
    end
end

local function AddMessage(text, client)
   local message = ChatMessage.Create("Lua Editor", text, ChatMessageType.Default, nil, nil)
   message.Color = Color(255, 95, 31)

   if CLIENT then
       Game.ChatBox.AddMessage(message)
   else
       Game.SendDirectChatMessage(message, client)
   end
end

if SERVER then return end

	local modPath = ...

	local frame = GUI.Frame(GUI.RectTransform(Vector2(1, 1)), nil)
	frame.CanBeFocused = false


	local menu = GUI.Frame(GUI.RectTransform(Vector2(0.5, 1), frame.RectTransform, GUI.Anchor.CenterRight), nil)
	menu.CanBeFocused = false
	menu.Visible = false
	menu.RectTransform.AbsoluteOffset = Point(0, -40)

	local menuContent = GUI.Frame(GUI.RectTransform(Vector2(0.4, 0.6), menu.RectTransform, GUI.Anchor.CenterRight))

	local targets = GUI.ListBox(GUI.RectTransform(Vector2(0.93, 0.1), menuContent.RectTransform, GUI.Anchor.TopCenter))
	targets.RectTransform.AbsoluteOffset = Point(0, 17)

	GUI.TextBlock(GUI.RectTransform(Vector2(1, 0.3), targets.Content.RectTransform), "Choose What Item To Edit", nil, nil, GUI.Alignment.Center)

	local itemeditlayout = GUI.LayoutGroup(GUI.RectTransform(Vector2(1, 0.5), targets.Content.RectTransform), nil)
	itemeditlayout.isHorizontal = true
	itemeditlayout.Stretch = true
	itemeditlayout.RelativeSpacing = 0.008


	local itemeditbutton1 = GUI.Button(GUI.RectTransform(Vector2(0.482, 0.2), itemeditlayout.RectTransform), "None")
	local itemeditbutton2 = GUI.Button(GUI.RectTransform(Vector2(0.482, 0.2), itemeditlayout.RectTransform), "None")

	local menuList = GUI.ListBox(GUI.RectTransform(Vector2(0.93, 0.7), menuContent.RectTransform, GUI.Anchor.Center))
	menuList.RectTransform.AbsoluteOffset = Point(0, -17)

	local itemname = GUI.TextBlock(GUI.RectTransform(Vector2(1, 0.1), menuList.Content.RectTransform), "None", nil, nil, GUI.Alignment.Center)
	itemname.TextColor = Color((255), (153), (153))
	itemname.TextScale = 1.3

	local spritedepthtext = GUI.TextBlock(GUI.RectTransform(Vector2(1, 0.055), menuList.Content.RectTransform), "Sprite Depth", nil, nil, GUI.Alignment.Center)
	local spritedepth = GUI.NumberInput(GUI.RectTransform(Vector2(1, 0.1), menuList.Content.RectTransform), NumberType.Float)

	local rotationtext = GUI.TextBlock(GUI.RectTransform(Vector2(1, 0.035), menuList.Content.RectTransform), "Rotation", nil, nil, GUI.Alignment.Center)
	local rotation = GUI.NumberInput(GUI.RectTransform(Vector2(1, 0.1), menuList.Content.RectTransform), NumberType.Int)

	local scaletext = GUI.TextBlock(GUI.RectTransform(Vector2(1, 0.035), menuList.Content.RectTransform), "Scale", nil, nil, GUI.Alignment.Center)
	local scale = GUI.NumberInput(GUI.RectTransform(Vector2(1, 0.1), menuList.Content.RectTransform), NumberType.Float)


	local spritecolortext = GUI.TextBlock(GUI.RectTransform(Vector2(1, 0.05), menuList.Content.RectTransform), "Sprite Color", nil, nil, GUI.Alignment.Center)
	local colorlayout = GUI.LayoutGroup(GUI.RectTransform(Vector2(1, 0.075), menuList.Content.RectTransform), nil)
	colorlayout.isHorizontal = true
	colorlayout.Stretch = true
	colorlayout.RelativeSpacing = 0.001

	local redtext = GUI.TextBlock(GUI.RectTransform(Vector2(0.01, 0.01), colorlayout.RectTransform), "R", nil, nil, GUI.Alignment.BottomCenter)
	local red = GUI.NumberInput(GUI.RectTransform(Vector2(0.05, 0.1), colorlayout.RectTransform), NumberType.Int)
	local greentext = GUI.TextBlock(GUI.RectTransform(Vector2(0.01, 0.01), colorlayout.RectTransform), "G", nil, nil, GUI.Alignment.BottomCenter)
	local green = GUI.NumberInput(GUI.RectTransform(Vector2(0.05, 0.1), colorlayout.RectTransform), NumberType.Int)
	local bluetext = GUI.TextBlock(GUI.RectTransform(Vector2(0.01, 0.01), colorlayout.RectTransform), "B", nil, nil, GUI.Alignment.BottomCenter)
	local blue = GUI.NumberInput(GUI.RectTransform(Vector2(0.05, 0.1), colorlayout.RectTransform), NumberType.Int)

	local tagstextblock = GUI.TextBlock(GUI.RectTransform(Vector2(1, 0.055), menuList.Content.RectTransform), "Tags", nil, nil, GUI.Alignment.Center)
	local tagstext = GUI.TextBox(GUI.RectTransform(Vector2(1, 0.2), menuList.Content.RectTransform), "")

	local display = GUI.TickBox(GUI.RectTransform(Vector2(1, 0.2), menuList.Content.RectTransform), "Display Side By Side When Linked")
	
	local noninteractable = GUI.TickBox(GUI.RectTransform(Vector2(1, 0.2), menuList.Content.RectTransform), "Non Interactable")
	
	local canbepicked = GUI.TickBox(GUI.RectTransform(Vector2(1, 0.2), menuList.Content.RectTransform), "Can Be Picked")
	canbepicked.visible = false
	
	local locked = GUI.TickBox(GUI.RectTransform(Vector2(1, 0.2), menuList.Content.RectTransform), "Locked")
	locked.visible = false
	
	local mirrorlayout = GUI.LayoutGroup(GUI.RectTransform(Vector2(1, 0.04), menuList.Content.RectTransform), nil)
	mirrorlayout.isHorizontal = true
	mirrorlayout.Stretch = true
	mirrorlayout.RelativeSpacing = 0.002

	local mirrorButtonx = GUI.Button(GUI.RectTransform(Vector2(0.482, 0.2), mirrorlayout.RectTransform), "Mirror X", nil, "GUIButtonSmall")
	local mirrorButtony = GUI.Button(GUI.RectTransform(Vector2(0.482, 0.2), mirrorlayout.RectTransform), "Mirror Y", nil, "GUIButtonSmall")

	local targetabletagstext = GUI.TextBlock(GUI.RectTransform(Vector2(1, 0.055), menuList.Content.RectTransform), "Tags To Not Target", nil, nil, GUI.Alignment.Center)
	targetabletagstext.visible = false
	EditGUI.targetabletags = GUI.TextBox(GUI.RectTransform(Vector2(1, 0.2), menuList.Content.RectTransform), "")
	EditGUI.targetabletags.visible = false

	EditGUI.targetnoninteractable = GUI.TickBox(GUI.RectTransform(Vector2(1, 0.2), menuList.Content.RectTransform), "Target Non Interactable")
	EditGUI.targetnoninteractable.visible = false

	local misc = GUI.ListBox(GUI.RectTransform(Vector2(0.93, 0.14), menuContent.RectTransform, GUI.Anchor.BottomCenter))
	misc.RectTransform.AbsoluteOffset = Point(0, 23)


	local misclayout = GUI.LayoutGroup(GUI.RectTransform(Vector2(1, 0.5), misc.Content.RectTransform), nil)
	misclayout.isHorizontal = true
	misclayout.Stretch = true
	misclayout.RelativeSpacing = 0.004

	local linktargets = GUI.Button(GUI.RectTransform(Vector2(0.482, 0.2), misclayout.RectTransform), "None")
	local clear = GUI.Button(GUI.RectTransform(Vector2(0.482, 0.2), misclayout.RectTransform), "Clear")
	local settings = GUI.Button(GUI.RectTransform(Vector2(0.482, 0.2), misclayout.RectTransform), "Settings")

	local closeButton = GUI.Button(GUI.RectTransform(Vector2(1, 1), misc.Content.RectTransform), "Close", GUI.Alignment.Center)
	closeButton.OnClicked = function ()
    menu.Visible = not menu.Visible
	end
	
	local hidden = false
	local check = true
	
	Component = function()
		if itemedit.GetComponentString("Holdable") and hidden == false then
			holdable = true
			canbepicked.visible = true
			canbepicked.Selected = itemedit.GetComponentString("Holdable").CanBePicked
		else
			holdable = false
			canbepicked.visible = false
		end
		if itemedit.GetComponentString("ConnectionPanel") and hidden == false then
			connectionpanel = true
			locked.visible = true
			locked.Selected = itemedit.GetComponentString("ConnectionPanel").Locked
		else
			connectionpanel = false
			locked.visible = false
		end
	end

	Links = function()
		local isLinked = false
	
		for key, value in pairs(itemedit1.linkedTo) do
			if value == itemedit2 then
				isLinked = true
				break
			end
		end
	
		if isLinked then
			Unlink = true
			linktargets.Text = "Unlink"
		else
			Unlink = false
			linktargets.Text = "Link"
		end
	end

	settingmenu = function()
		if settingsmenu == true then
			EditGUI.targetnoninteractable.visible = true
			targetabletagstext.visible = true
			EditGUI.targetabletags.visible = true
		else
			EditGUI.targetnoninteractable.visible = false
			targetabletagstext.visible = false
			EditGUI.targetabletags.visible = false
		end
	end
	
	valuetrue = function()
		spritedepthtext.visible = true
		spritedepth.visible = true
		rotationtext.visible = true
		rotation.visible = true
		scaletext.visible = true
		scale.visible = true
		spritecolortext.visible = true
		redtext.visible = true
		red.visible = true
		greentext.visible = true
		green.visible = true
		bluetext.visible = true
		blue.visible = true
		colorlayout.visible = true
		display.visible = true
		mirrorButtonx.visible = true
		mirrorButtony.visible = true
		noninteractable.visible = true
		itemname.visible = true
		tagstext.visible = true
		tagstextblock.visible = true
	end
	
	valuefalse = function()
		spritedepthtext.visible = false
		spritedepth.visible = false
		rotationtext.visible = false
		rotation.visible = false
		scaletext.visible = false
		scale.visible = false
		spritecolortext.visible = false
		redtext.visible = false
		red.visible = false
		greentext.visible = false
		green.visible = false
		bluetext.visible = false
		blue.visible = false
		colorlayout.visible = false
		display.visible = false
		mirrorButtonx.visible = false
		mirrorButtony.visible = false
		noninteractable.visible = false
		canbepicked.visible = false
		locked.visible = false
		itemname.visible = false
		tagstext.visible = false
		tagstextblock.visible = false
	end
	
	reloadvalues = function()
		spritedepth.FloatValue = itemedit.SpriteDepth * 1000
		rotation.IntValue = itemedit.Rotation
		scale.FloatValue = itemedit.Scale * 1000
		red.IntValue, green.IntValue, blue.IntValue = itemedit.SpriteColor.R,itemedit.SpriteColor.G,itemedit.SpriteColor.B
		display.Selected = itemedit.DisplaySideBySideWhenLinked
		noninteractable.Selected = itemedit.NonInteractable
		tagstext.Text = itemedit.Tags
		Component()
		Links()
	end

Hook.Add("Edit", "edit", function(statusEffect, deltaTime, item)
	local owner = FindClientCharacter(item.ParentInventory.Owner)
	local target = findtarget.findtarget(item)
	
	-- Start Of Checks
	
	if Game.IsMultiplayer and owner.Permissions == 0 then
		AddMessage("Insuffient Permissions", owner)
		return
	end
	
    if not menu.Visible then
		menu.Visible = not menu.Visible
    end
	
    if target == nil then
        AddMessage("No item found", owner)
        return
    end
	
    if target == itemedit1 or target == itemedit2 then
        AddMessage("Please Choose Another Item", owner)
        return
    end
	
    if check == true then
        itemedit1 = target
		itemname.Text = itemedit1.Name
		itemeditbutton1.Text = itemedit1.Name
		itemedit = itemedit1
		check = false
    else
        itemedit2 = target
		itemeditbutton2.Text = itemedit2.Name
		check = true
	end
	
	if itemedit == nil then
		return
	end
	
	-- End Of Checks
	
	if hidden == false then
		Component()
	end
	
	if itemedit2 == nil then
	
	else
	Links()
	end

	itemeditbutton1.OnClicked = function()
		if itemedit1 == nil then
		else
			itemname.Text = itemedit1.Name
			itemedit = itemedit1
			hidden = false
			reloadvalues()
			valuetrue()
			settingsmenu = false
			settingmenu()
		end
	end
	
	itemeditbutton2.OnClicked = function()	
		if itemedit2 == nil then
		else
			itemname.Text = itemedit2.Name
			itemedit = itemedit2
			hidden = false
			reloadvalues()
			valuetrue()
			settingsmenu = false
			settingmenu()
		end
	end
		
	local function LinkAdd(itemedit1, itemedit2)
		itemedit1.AddLinked(itemedit2)
		itemedit2.AddLinked(itemedit1)
	end

	local function LinkRemove(itemedit1, itemedit2)
		itemedit1.RemoveLinked(itemedit2)
		itemedit2.RemoveLinked(itemedit1)
	end
		
	-- Start Of Values

	spritedepth.FloatValue = itemedit.SpriteDepth * 1000
	spritedepth.MinValueFloat = 100
	spritedepth.MaxValueFloat = 900
	spritedepth.valueStep = 50
	spritedepth.OnValueChanged = function ()
		itemedit.SpriteDepth = spritedepth.FloatValue / 1000
		network(itemedit)
	end
	
	rotation.IntValue = itemedit.Rotation
	rotation.MinValueInt = 0
	rotation.MaxValueInt = 360
	rotation.valueStep = 10
	rotation.OnValueChanged = function ()
		itemedit.Rotation = rotation.IntValue
		network(itemedit)
	end
	
	scale.FloatValue = itemedit.Scale * 1000
	scale.MinValueFloat = 400
	scale.MaxValueFloat = 600
	scale.valueStep = 50
	scale.OnValueChanged = function ()
		itemedit.Scale = scale.FloatValue / 1000
		network(itemedit)
	end
	
	red.IntValue, green.IntValue, blue.IntValue = itemedit.SpriteColor.R,itemedit.SpriteColor.G,itemedit.SpriteColor.B
	red.MinValueInt = 0
	green.MinValueInt = 0
	blue.MinValueInt = 0
	red.MaxValueInt = 255
	green.MaxValueInt = 255
	blue.MaxValueInt = 255
	red.OnValueChanged = function ()
		itemedit.SpriteColor = Color(red.IntValue,green.IntValue,blue.IntValue)
		network(itemedit)
	end
	green.OnValueChanged = function ()
		itemedit.SpriteColor = Color(red.IntValue,green.IntValue,blue.IntValue)
		network(itemedit)
	end
	blue.OnValueChanged = function ()
		itemedit.SpriteColor = Color(red.IntValue,green.IntValue,blue.IntValue)
		network(itemedit)
	end


	mirrorButtonx.OnClicked = function()
		if itemedit then
			itemedit.FlipX(false)
			network(itemedit)
		end
	end

	mirrorButtony.OnClicked = function()
		if itemedit then
			itemedit.FlipY(false)
			network(itemedit)
		end
	end
	
	tagstext.Text = itemedit.Tags
	tagstext.OnTextChangedDelegate = function (tagstext)
		itemedit.Tags = tagstext.Text
		network(itemedit)
	end

	display.Selected = itemedit.DisplaySideBySideWhenLinked
	display.OnSelected = function ()
		itemedit.DisplaySideBySideWhenLinked = display.Selected == true
		network(itemedit)
	end

	noninteractable.Selected = itemedit.NonInteractable
	noninteractable.OnSelected = function ()
		itemedit.NonInteractable = noninteractable.Selected == true
		network(itemedit)
	end
	
	if holdable == true then
		canbepicked.Selected = itemedit.GetComponentString("Holdable").CanBePicked
		canbepicked.OnSelected = function ()
			itemedit.GetComponentString("Holdable").CanBePicked = canbepicked.Selected == true
			network(itemedit)
		end
	end
	
	
	if connectionpanel == true then
		locked.Selected = itemedit.GetComponentString("ConnectionPanel").Locked
		locked.OnSelected = function ()
			itemedit.GetComponentString("ConnectionPanel").Locked = locked.Selected == true
			network(itemedit)
		end
	end

	if itemedit1 ~= nil and itemedit2 ~= nil then
		linktargets.OnClicked = function()
			if not itemedit1.Linkable then
				AddMessage(itemedit1.Name .. " is not Linkable", owner)
				return
			end
			if not itemedit2.Linkable then
				AddMessage(itemedit2.Name .. " is not Linkable", owner)
				return
			end
				
			if Unlink == true then
				LinkRemove(itemedit1, itemedit2)
				UnlinkNetwork()
				Links()
			else
				LinkAdd(itemedit1, itemedit2)
				LinkNetwork()
				Links()
			end
		end
	end

	clear.OnClicked = function()
		hidden = true
		check = true
		valuefalse()
		itemedit = nil
		itemedit1 = nil
		itemedit2 = nil
		itemname.Text = "None"
		linktargets.Text = "None"
		itemeditbutton1.Text = "None"
		itemeditbutton2.Text = "None"
	end

	
	-- End Of Values
	
end)


	settings.OnClicked = function()
		if settingsmenu == true then
			settingsmenu = false
			hidden = false
			if itemedit == nil then
			
			else
				reloadvalues()
				valuetrue()
			end
			settingmenu()
		else
			settingsmenu = true
			hidden = true
			valuefalse()
			settingmenu()
		end
	end
	
	tagList = table.concat(findtarget.validTags, ",")
	EditGUI.targetabletags.text = (tagList)
	
	EditGUI.targetabletags.OnTextChangedDelegate = function()
		findtarget.validTags = {}
		for tag in string.gmatch(EditGUI.targetabletags.text, "[^,%s]+") do
			table.insert(findtarget.validTags, tag)
		end
	end
	
	
Hook.Patch("Barotrauma.GameScreen", "AddToGUIUpdateList", function()
    frame.AddToGUIUpdateList()
end)

Hook.Patch("Barotrauma.SubEditorScreen", "AddToGUIUpdateList", function()
    frame.AddToGUIUpdateList()
end)
