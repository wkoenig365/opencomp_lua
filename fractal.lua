-- random_fractal_screensaver.lua

local mon = peripheral.find("monitor") or error("No monitor attached", 0)
mon.setTextScale(1)
mon.setCursorBlink(false)

local w, h = mon.getSize()
local yieldInterval = 200        -- yield every N plots
local pointsPerPixel = 5         -- density of plotting
math.randomseed(os.time())

-- all possible colors
local allColors = {
  colors.white, colors.lightGray, colors.gray, colors.black,
  colors.red, colors.orange, colors.yellow, colors.lime,
  colors.green, colors.cyan, colors.lightBlue, colors.blue,
  colors.purple, colors.magenta, colors.brown,
}

while true do
  -- clear for new fractal
  mon.clear()

  -- pick 3–6 random vertices around the screen boundary
  local vertexCount = math.random(3, 6)
  local verts = {}
  for i = 1, vertexCount do
    local angle = (2 * math.pi * (i - 1)) / vertexCount + (math.random() - .5) * 0.2
    local vx = math.floor(w/2 + (w/2 - 1) * math.cos(angle))
    local vy = math.floor(h/2 + (h/2 - 1) * math.sin(angle))
    table.insert(verts, { vx, vy })
  end

  -- build a small random palette of 3–8 distinct colors
  local copy = { table.unpack(allColors) }
  local palette = {}
  for _ = 1, math.random(3, 8) do
    local idx = math.random(#copy)
    table.insert(palette, table.remove(copy, idx))
  end

  -- starting point anywhere
  local x, y = math.random(w), math.random(h)
  local totalPlots = w * h * pointsPerPixel

  -- chaos game plotting
  for plotCount = 1, totalPlots do
    -- move halfway toward a random vertex
    local v = verts[math.random(#verts)]
    x = (x + v[1]) / 2
    y = (y + v[2]) / 2

    -- plot a block
    mon.setCursorPos(math.floor(x), math.floor(y))
    mon.setTextColor(palette[math.random(#palette)])
    mon.write("■")

    -- yield so CC-Tweaked doesn’t time us out
    if plotCount % yieldInterval == 0 then
      sleep(0)
    end
  end

  -- pause before starting the next one
  sleep(2)
end
