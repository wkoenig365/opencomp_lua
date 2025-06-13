-- sierpinski_screensaver.lua

local mon = peripheral.find("monitor") or error("No monitor attached", 0)
mon.setTextScale(1)
mon.setCursorBlink(false)

local w, h = mon.getSize()
mon.clear()
math.randomseed(os.time())

-- define 3 fixed triangle corners
local verts = {
  {1, 1},
  {w, 1},
  {math.floor(w / 2), h},
}

local x, y = math.random(w), math.random(h)
local lastIdx = -1
local yieldInterval = 200

for i = 1, w * h * 5 do
  local idx
  repeat
    idx = math.random(3)
  until idx ~= lastIdx  -- dont pick same vertex twice in a row
  lastIdx = idx

  local vx, vy = table.unpack(verts[idx])
  x = (x + vx) / 2
  y = (y + vy) / 2

  mon.setCursorPos(math.floor(x), math.floor(y))
  mon.setTextColor(colors.white)
  mon.write("0")

  if i % yieldInterval == 0 then sleep(0) end
end

-- show until next input
mon.setCursorPos(1, h)
mon.setTextColor(colors.gray)
mon.write("Press any key for next fractal")
os.pullEvent("key")
os.reboot()  -- or loop back if you want more fractals
