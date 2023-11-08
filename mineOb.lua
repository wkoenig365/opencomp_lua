-- Function to check if the turtle's inventory is full
local function isInventoryFull()
  for i = 1, 16 do
    if turtle.getItemCount(i) == 0 then
      return false
    end
  end
  return true
end

-- Function to deposit inventory into a chest behind the turtle
local function depositInventory()
  turtle.turnLeft()
  turtle.turnLeft() -- Turn around to face the chest
  for i = 1, 16 do
    turtle.select(i)
    turtle.drop() -- This will drop the item into the chest
  end
  turtle.turnLeft()
  turtle.turnLeft() -- Turn back around to face the obsidian
end

-- Main mining loop
while true do
  -- Mine the obsidian block
  while not isInventoryFull() do
    if turtle.detect() then
      turtle.dig() -- Mine the block in front of the turtle
    end
    sleep(0.5) -- Wait for half a second to prevent too rapid of a loop if there's no block
  end

  -- If the inventory is full, deposit the items into the chest
  depositInventory()
  -- The turtle is now ready to start mining again
end
