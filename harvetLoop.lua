-- harvestLoop.lua
-- Usage: turtle — run harvestLoop.lua <width> <depth> <sleepTime>
local args = { ... }
if #args < 3 then
  error("Usage: harvestLoop.lua <width> <depth> <sleepTime>")
end

local width     = tonumber(args[1])
local depth     = tonumber(args[2])
local sleepTime = tonumber(args[3])

if not (width and depth and sleepTime) then
  error("All arguments must be numbers: width, depth, sleepTime")
end

-- Harvest a single row of 'width' blocks
local function harvestRow()
  for x = 1, width do
    local ok, data = turtle.inspectDown()
    if ok and data.state and data.state.age and data.state.age >= 7 then
      turtle.digDown()
    end
    if x < width then turtle.forward() end
  end
end

-- At the end of a row, turn & step into the next row
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

-- Return the turtle back to its start (on top of the chest)
local function returnToStart()
  -- If we finished on the “far” side, walk back across the width
  if (depth % 2) == 1 then
    for i = 1, width - 1 do turtle.back() end
  end
  -- Turn around and walk back down the depth
  turtle.turnRight(); turtle.turnRight()
  for i = 1, depth - 1 do turtle.back() end
  -- Re-orient to original facing
  turtle.turnRight(); turtle.turnRight()
end

-- Dump **all** slots into the chest below
local function depositAll()
  for slot = 1, 16 do
    turtle.select(slot)
    turtle.dropDown()
  end
  turtle.select(1)
end

-- Main loop
while true do
  -- Sweep the area
  for row = 1, depth do
    harvestRow()
    if row < depth then
      turnForNextRow(row)
    end
  end

  -- Return & unload
  returnToStart()
  depositAll()

  -- Wait before next pass
  print(("Sleeping for %s seconds…"):format(sleepTime))
  os.sleep(sleepTime)
end
