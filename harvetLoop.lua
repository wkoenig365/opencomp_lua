-- debugHarvest.lua
-- Usage: turtle run debugHarvest.lua <width> <depth> <sleepTime>

local args = { ... }
if #args < 3 then
  error("Usage: debugHarvest.lua <width> <depth> <sleepTime>")
end
local width, depth, sleepTime =
  tonumber(args[1]), tonumber(args[2]), tonumber(args[3])

print(("Starting debug run: width=%d, depth=%d, pause=%ds")
        :format(width, depth, sleepTime))
print("⛽ Fuel level:", turtle.getFuelLevel())
if turtle.getFuelLevel() == 0 then
  print("⚠️  Out of fuel! Put some coal/charcoal/etc in the turtle and try again.")
  return
end

for row = 1, depth do
  for col = 1, width do
    print(("— Row %d/%d, Col %d/%d"):format(row, depth, col, width))
    -- show what’s under us:
    local ok, down = turtle.inspectDown()
    if ok then
      print("inspectDown sees:", down.name)
    else
      print("nothing under me!")
    end
    -- try to move forward, capture error reason:
    local moved, reason = turtle.forward()
    print("forward() →", moved, reason or "<no reason>")
    if not moved then
      -- let’s also peek at what’s in front
      local fOk, front = turtle.inspect()
      print("inspect front:", fOk and front.name or "<nothing>")
      -- pause here so you can read
      print("Pausing debug so you can see the above. Hit Ctrl+T then enter to stop.")
      os.sleep(10)
      return
    end
  end

  -- now the turn logic, same idea:
  if row < depth then
    if row % 2 == 1 then
      turtle.turnRight()
      local m2, r2 = turtle.forward()
      print("turn-move →", m2, r2)
      turtle.turnRight()
    else
      turtle.turnLeft()
      local m2, r2 = turtle.forward()
      print("turn-move →", m2, r2)
      turtle.turnLeft()
    end
  end
end

print("Finished one debug sweep. Pausing before next…")
os.sleep(sleepTime)
