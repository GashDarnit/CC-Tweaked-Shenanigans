local ore_list = {
    "minecraft:diamond_ore",
    "minecraft:deepslate_diamond_ore",
    "minecraft:coal_ore",
    "minecraft:deepslate_coal_ore",
    "minecraft:iron_ore",
    "minecraft:deepslate_iron_ore",
    "minecraft:gold_ore",
    "minecraft:deepslate_gold_ore",
    "minecraft:emerald_ore",
    "minecraft:deepslate_emerald_ore",
}

local Stack = {}
local Backtrackstack = {}

function checkOre(data, direction)
    for i = 1, #ore_list do
        if data.name == ore_list[i] then
            --table.insert(Stack, data.name)
            table.insert(Stack, direction)
            return true
        end
    end
    
    return false
end

function checkAction(direction)
    local success, data
    
    --up
    if direction == "up" then
        success, data = turtle.inspectUp()
    
    --down
    elseif direction == "down" then
        success, data = turtle.inspectDown()
    
    --cardinal directions
    else
        success, data = turtle.inspect()
    end
    
    if success then
        return checkOre(data, direction)
    end
    
    return false
end

function checkAllDirection()
    local hit = 0
    
    --front
    if checkAction("front") then
        hit = hit + 1
    end
    
    --left
    turtle.turnLeft()
    if checkAction("left") then
        hit = hit + 1
    end
    
    --back
    turtle.turnLeft()
    if checkAction("back") then
        hit = hit + 1
    end
    
    --right
    turtle.turnLeft()
    if checkAction("right") then
        hit = hit + 1
    end
    
    --up
    if checkAction("up") then
        hit = hit + 1
    end
    
    --down
    if checkAction("down") then
        hit = hit + 1
    end
    
    turtle.turnLeft()
    
    return hit
end

function flipDirection(direction)
    if direction == "left" then
        return "right"
    elseif direction == "right" then
        return "left"
    elseif direction == "up" then
        return "down"
    elseif direction == "down" then
        return "up"
    elseif direction == "forward" then
        return "backward"
    elseif direction == "backward" then
        return "forward"
    end
end


function executeMovement(movement)
    if movement == "forward" then
        turtle.forward()
    elseif movement == "backward" then
        turtle.back()
    elseif movement == "left" then
        turtle.turnLeft()
    elseif movement == "right" then
        turtle.turnRight()
    elseif movement == "up" then
        turtle.up()
    elseif movement == "down" then
        turtle.down()
    elseif movement == "back" then
        turtle.turnLeft()
        turtle.turnLeft()
    end
end

function dfs()
    local depthList = {}
    local targetDepth
    local checkDirection = true
    
    repeat
        local hit = -1
        
        if checkDirection then
            hit = checkAllDirection()
        end
        
        if hit > 1 then --indicates a split
            for i = 1, hit - 1 do
                table.insert(depthList, #Backtrackstack)
            end
            
        end
        
        if hit == 0 then
            targetDepth = table.remove(depthList)
            removeMultiVerticals(Backtrackstack)
            
            while #Backtrackstack > 0 do
                local previousDirection = table.remove(Backtrackstack)
                previousDirection = flipDirection(previousDirection)
                executeMovement(previousDirection)
                
                if #Backtrackstack == targetDepth then
                    checkDirection = false
                    break
                end
            end
        else
            local currentNode = table.remove(Stack)
            executeMovement(currentNode)
            table.insert(Backtrackstack, currentNode)
            
            if currentNode == "up" then
                turtle.digUp()
                turtle.up()
                table.insert(Backtrackstack, "up")
            elseif currentNode == "down" then
                turtle.digDown()
                turtle.down()
                table.insert(Backtrackstack, "down")
            else
                turtle.dig()
                turtle.forward()
                table.insert(Backtrackstack, "forward")
            end
            
            
            checkDirection = true
        end
        
    until #Stack == 0 and #Backtrackstack == 0
end

function removeMultiVerticals(stack)
    local i = 1
    
    while i < #stack do
        if stack[i] == "up" and stack[i + 1] == "up" or stack[i] == "down" and stack[i + 1] == "down" then
            table.remove(stack, i)
        end
        
        i = i + 1
    end
    
end

function printBacktrackstack()
    local printString = ""
    for i = 1, #Backtrackstack do
        if Backtrackstack[i] == "up" or Backtrackstack[i] == "down" then
            printString = printString .. " " .. Backtrackstack[i]
        end
    end
    
    print(printString)
end

function printStack()
    local printString = ""
    for i = 1, #Stack do
        printString = printString .. " " .. Stack[i]
    end
    
    print(printString)
end

function main()
    dfs()
    
end



main()


