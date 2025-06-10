-- harvestLoop.lua
-- Usage: turtle run harvestLoop.lua <width> <depth> <sleepTime>

local args = { ... }
if #args < 3 then
  error("Usage: harvestLoop.lua <width> <depth> <sleepTime>")
end

local width     = tonumber(args[1])
local depth     = tonumber(args[2])
local sleepTime = tonumber(args[3])

assert(width >= 1 and depth >= 1 and sleepTime >= 0,
       "width & depth must be ≥1; sleepTime ≥0")

-- check below and harvest if fully mature (age ≥7)
local function harvestHere()
  local ok, data = turtle.inspectDown()
  if ok and data.state and data.state.age and data.state.age >= 7 then
    turtle.digDown()
  end
end

-- sweep one row of length `width`
local function harvestRow()
  for x = 1, width do
    harvestHere()
    if x < width then turtle.forward() end
  end
end

-- at end of each row, step into next and reverse dir
local function turnForNextRow(row)
  if row % 2 == 1 then
    turtle.turnRight(); turtle.forward(); turtle.turnRight()
  else
    turtle.turnLeft (); turtle.forward(); turtle.turnLeft ()
  end
end

-- deposit everything into the chest below
local function depositAll()
  for slot = 1, 16 do
    turtle.select(slot)
    turtle.dropDown()
  end
  turtle.select(1)
end

-- return to starting chest at (1,1), facing east
local function returnToStart()
  -- determine where we ended:
  -- if depth is odd, we sweep east-to-west odd number of times => end on east edge
  local endedEast = (depth % 2 == 1)
  -- compute final X coordinate
  local endX = endedEast and width or 1
  local endZ = depth

  -- 1) get back to x=1
  if endX > 1 then
    if endedEast then
      -- we’re facing east ⇒ turn around to face west
      turtle.turnRight(); turtle.turnRight()
    end
    for i = 1, endX - 1 do
      turtle.forward()
    end
  end
  -- now at x=1, still at z=endZ, facing west (if we moved) or still facing east/west

  -- 2) face north (toward z=1)
  -- if we’re facing west, a right turn goes north; if east, a left
  local faceCheckOK = true
  if endedEast and endX == 1 then
    -- still facing east
    turtle.turnLeft()
  elseif (not endedEast) and endX == 1 then
    -- still facing west
    turtle.turnRight()
  else
    -- after an x‐move we’re guaranteed facing west
    turtle.turnRight()
  end

  for i = 1, endZ - 1 do
    turtle.forward()
  end

  -- 3) face east to reset orientation
  -- currently facing north ⇒ right turn points east
  turtle.turnRight()
end

-- main loop
while true do
  -- 1) sweep the rectangle
  for row = 1, depth do
    harvestRow()
    if row < depth then
      turnForNextRow(row)
    end
  end

  -- 2) return & unload
  returnToStart()
  depositAll()

  -- 3) pause
  print(("Sleeping for %d seconds…"):format(sleepTime))
  os.sleep(sleepTime)
end
