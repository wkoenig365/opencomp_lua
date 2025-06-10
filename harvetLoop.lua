-- Usage: turtle run harvestInferium.lua <width> <depth> <sleepTime>

local args = { ... }
if #args < 3 then
  error("Usage: harvestInferium.lua <width> <depth> <sleepTime>")
end

local width     = tonumber(args[1])
local depth     = tonumber(args[2])
local pause     = tonumber(args[3])
local matureAge = 7  -- change if your inferium crop uses a different age

-- Refuel only using coal or charcoal
local function refuelIfNeeded()
  if turtle.getFuelLevel() == 0 then
    for slot = 1, 16 do
      turtle.select(slot)
      local item = turtle.getItemDetail()
      if item and (item.name == "minecraft:coal" or item.name == "minecraft:charcoal") then
        turtle.refuel()
        break
      end
    end
    turtle.select(1)
  end
end

local function inspectAndHarvest()
  local ok, data = turtle.inspectDown()
  if ok and data.name ~= "minecraft:chest" then
    turtle.suckDown()
  end
  if ok and data.state and data.state.age then
    local age = data.state.age
    print("Crop age:", age)
    if age >= matureAge then
      turtle.digDown()
      turtle.suckDown()
      os.sleep(0.1)
      turtle.suckDown()
    end
  end
end

local function harvestRow()
  for col = 1, width do
    inspectAndHarvest()
    if col < width then
      turtle.forward()
    end
  end
end

local function turnForNextRow(row)
  if row % 2 == 1 then
    turtle.turnRight()
    turtle.forward()
    turtle.turnRight()
  else
    turtle.turnLeft()
    turtle.forward()
    turtle.turnLeft()
  end
end

local function returnToStart()
  local endedEast = (depth % 2 == 1)
  local endX = endedEast and width or 1
  local endZ = depth

  if endX > 1 then
    if endedEast then
      turtle.turnRight(); turtle.turnRight()
    end
    for i = 1, endX - 1 do turtle.forward() end
  end

  if endedEast and endX == 1 then
    turtle.turnLeft()
  elseif (not endedEast) and endX == 1 then
    turtle.turnRight()
  else
    turtle.turnRight()
  end

  for i = 1, endZ - 1 do turtle.forward() end
  turtle.turnRight()
end

local function depositAll()
  for slot = 1, 16 do
    turtle.select(slot)
    local detail = turtle.getItemDetail()
    if detail then
      local name = detail.name
      if name ~= "minecraft:coal" and name ~= "minecraft:charcoal" then
        turtle.dropDown()
      end
    end
  end
  turtle.select(1)
end

-- Main loop
while true do
  refuelIfNeeded()
  
  for row = 1, depth do
    harvestRow()
    if row < depth then
      turnForNextRow(row)
    end
  end

  returnToStart()
  depositAll()

  print("Sleeping for", pause, "seconds")
  os.sleep(pause)
end
