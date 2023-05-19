local findtarget = {}
-- findowner
findtarget.FindClientCharacter = function(character)
    if CLIENT then return nil end
    
    for key, value in pairs(Client.ClientList) do
        if value.Character == character then
            return value
        end
    end
end

findtarget.cursor_pos = Vector2(0, 0)
findtarget.cursor_updated = false

findtarget.validTags = {"notlualinkable"}

local function FindClosestItem(submarine, position)
    local closest = nil
    for key, value in pairs(submarine and submarine.GetItems(false) or Item.ItemList) do
        if EditGUI.targetnoninteractable.Selected == true then
            targetnoninter = value.NonInteractable == true
        else
            targetnoninter = value.NonInteractable == false
        end
        
        -- Check if the item has a parent inventory
        local hasParentInventory = value.ParentInventory ~= nil

        -- Skip items with parent inventories
        if not hasParentInventory then
            local hasValidTag = true
            for _, tag in ipairs(findtarget.validTags) do
                if value.HasTag(tag) then
                    hasValidTag = false
                    break
                end
            end

            if hasValidTag and targetnoninter then
                -- check if placable or if it does not have holdable component
                local check_if_p_or_nh = false
                local holdable = value.GetComponentString("Holdable")
                if holdable == nil then
                    check_if_p_or_nh = true
                else
                    if holdable.attachable == true then
                        check_if_p_or_nh = true
                    end
                end
                if check_if_p_or_nh == true then
                    if Vector2.Distance(position, value.WorldPosition) < 100 then
                        if closest == nil then closest = value end
                        if Vector2.Distance(position, value.WorldPosition) <
                            Vector2.Distance(position, closest.WorldPosition) then
                            closest = value
                        end
                    end
                end
            end
        end
    end
    return closest
end


findtarget.findtarget = function(item)
    if CLIENT and Game.IsMultiplayer then 
        -- for better accuracy
        local client_cursor_pos = (item.ParentInventory.Owner).CursorWorldPosition
        local msg = Networking.Start("lualinker.clientsidevalue")
        msg.WriteSingle(client_cursor_pos.X)
        msg.WriteSingle(client_cursor_pos.Y)
        Networking.Send(msg)
        return
    end

    -- SinglePlayer
    if not Game.IsMultiplayer then
        findtarget.cursor_pos = item.ParentInventory.Owner.CursorWorldPosition
    end
    -- fallback
    if not findtarget.cursor_updated and Game.IsMultiplayer then
        findtarget.cursor_pos = item.WorldPosition
    end

    if item.ParentInventory == nil or item.ParentInventory.Owner == nil then return end

    local target = FindClosestItem(item.Submarine, findtarget.cursor_pos)
    return target
end

Networking.Receive("lualinker.clientsidevalue", function(msg)
    local position = Vector2(msg.ReadSingle(), msg.ReadSingle())
    findtarget.cursor_pos = position
    findtarget.cursor_updated = true
end)

return findtarget
