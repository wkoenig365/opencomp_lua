-- harvestDebug.lua
-- Usage: turtle run harvestDebug.lua <width> <depth> <sleepTime>

local args = { ... }
if #args < 3 then
  error("Usage: turtle run harvestDebug.lua <width> <depth> <sleepTime>")
end

local width     = tonumber(args[1])
local depth     = tonumber(args[2])
local sleepTime = tonumber(args[3])

print(string.format("DEBUG: Parsed args → width=%s, depth=%s, sleepTime=%s",
      tostring(width), tostring(depth), tostring(sleepTime)))
assert(width and depth and sleepTime,
       "All arguments must be numbers")
assert(width >= 1 and depth >= 1 and sleepTime >= 0,
       "width & depth must be ≥1; sleepTime ≥0")

-- Inspect below and harvest if mature
local function harvestHere()
  local ok, data = turtle.inspectDown()
  if ok then
    local ageStr = data.state and data.state.age and (" age=" .. data.state.age) or ""
    print("DEBUG: inspectDown() → block=" .. data.name .. ageStr)
    if data.state and data.state.age and data.state.age >= 7 then
      print("DEBUG: → digging down")
      turtle.digDown()
    end
  else
    print("DEBUG: inspectDown() → no block below")
  end
end

-- Try a forward step and log the result
local function tryForward()
  local moved = turtle.forward()
  print("DEBUG: forward() → " .. tostring(moved))
  if not moved then
    print("DEBUG: detect() → " .. tostring(turtle.detect()))
  end
  return moved
end

-- Harvest a single row
local function harvestRow()
  for x = 1, width do
    print(string.format("DEBUG: harvesting column %d/%d", x, width))
    harvestHere()
    if x < width then
      tryForward()
    end
  end
end

-- Turn & step into next row
local function turnForNextRow(row)
  print("DEBUG: turnForNextRow(row=" .. row .. ")")
  if row % 2 == 1 then
    turtle.turnRight();  print("DEBUG: turnedRight")
    tryForward()
    turtle.turnRight();  print("DEBUG: turnedRight")
  else
    turtle.turnLeft();   print("DEBUG: turnedLeft")
    tryForward()
    turtle.turnLeft();   print("DEBUG: turnedLeft")
  end
end

-- Return to the chest at (1,1), facing east
local function returnToStart()
  print("DEBUG: returnToStart()")
  local endedEast = (depth % 2 == 1)
  local endX = endedEast and width or 1
  local endZ = depth
  print(string.format("DEBUG: endedEast=%s, endX=%d, endZ=%d",
        tostring(endedEast), endX, endZ))
  -- 1) Move back to x=1
  if endX > 1 then
    if endedEast then
      turtle.turnRight(); turtle.turnRight()
      print("DEBUG: turnedAround to face west")
    end
    for i = 1, endX - 1 do
      tryForward()
    end
  end
  -- 2) Face north (toward z=1)
  if endedEast and endX == 1 then
    turtle.turnLeft();  print("DEBUG: turnedLeft to face north")
  elseif not endedEast and endX == 1 then
    turtle.turnRight(); print("DEBUG: turnedRight to face north")
  else
    -- after X-move we’re always facing west
    turtle.turnRight(); print("DEBUG: turnedRight to face north")
  end
  for i = 1, endZ - 1 do
    tryForward()
  end
  -- 3) Face east
  turtle.turnRight(); print("DEBUG: turnedRight to face east")
end

-- Unload into chest below
local function depositAll()
  print("DEBUG: depositAll()")
  for slot = 1, 16 do
    turtle.select(slot)
    local cnt = turtle.getItemCount(slot)
    if cnt > 0 then
      print("DEBUG: dropping slot " .. slot .. " count=" .. cnt)
    end
    turtle.dropDown()
  end
  turtle.select(1)
end

-- Main loop
while true do
  print("DEBUG: ==== Starting sweep ====")
  for row = 1, depth do
    print("DEBUG: row " .. row .. " of " .. depth)
    harvestRow()
    if row < depth then
      turnForNextRow(row)
    end
  end

  returnToStart()
  depositAll()

  print("DEBUG: sleeping for " .. sleepTime .. "s")
  os.sleep(sleepTime)
end
