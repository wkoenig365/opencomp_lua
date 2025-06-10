-- debugHarvest.lua
-- Usage: turtle run debugHarvest.lua <width> <depth> <sleepTime>

local args = { ... }
if #args < 3 then
  error("Usage: debugHarvest.lua <width> <depth> <sleepTime>")
end

local width  = tonumber(args[1])
local depth  = tonumber(args[2])
local pause  = tonumber(args[3])

for row = 1, depth do
  for col = 1, width do
    print(string.format("Row %d/%d, Col %d/%d", row, depth, col, width))

    local ok, data = turtle.inspectDown()
    if ok then
      print("inspectDown:", data.name)
    end

    local moved, reason = turtle.forward()
    if not moved then
      print("forward() failed:", reason or "unknown reason")
      local fOk, fData = turtle.inspect()
      if fOk then print("inspect front:", fData.name) end
      return
    end
  end

  if row < depth then
    if row % 2 == 1 then
      turtle.turnRight()
      local moved, reason = turtle.forward()
      if not moved then
        print("turnRight + forward failed:", reason or "unknown reason")
        return
      end
      turtle.turnRight()
    else
      turtle.turnLeft()
      local moved, reason = turtle.forward()
      if not moved then
        print("turnLeft + forward failed:", reason or "unknown reason")
        return
      end
      turtle.turnLeft()
    end
  end
end

print("Completed one full sweep.")
os.sleep(pause)
