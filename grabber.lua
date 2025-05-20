require "vector"

GrabberClass = {}

function GrabberClass:new()
  local grabber = {}
  local metadata = {__index = GrabberClass}
  setmetatable(grabber, metadata)
  
  grabber.currentMousePos = nil
  grabber.grabPos = nil
  grabber.heldObject = nil
  grabber.originPool = nil
  
  return grabber
end

function GrabberClass:update(pools)
  self.currentMousePos = Vector(
    love.mouse.getX(),
    love.mouse.getY()
  )

  -- Move held object with mouse
  if self.heldObject then
    self.heldObject.position = self.currentMousePos
  end

  -- Click (grab)
  if love.mouse.isDown(1) and self.grabPos == nil then
    self:grab(pools)
  end
  -- Release
  if not love.mouse.isDown(1) and self.grabPos ~= nil then
    self:release(pools)
  end
end

function GrabberClass:grab(pools)
  self.grabPos = self.currentMousePos
  
  for _, pool in ipairs(pools) do
    for i = #pool.cards, 1, -1 do
      local card = pool.cards[i]
      if card:checkForMouseOver(self) and card.faceUp then
        self.heldObject = card
        self.originPool = pool
        table.remove(pool.cards, i)
        return
      end
    end
  end
end

function GrabberClass:release(pools)
  if self.heldObject == nil then
    self.grabPos = nil
    return
  end

  local placed = false
  for _, pool in ipairs(pools) do
    if pool:trySnap(self.heldObject) then
      placed = true
      break
    end
  end

  if not placed and self.originPool then
    self.originPool:addCard(self.heldObject)
  end

  self.heldObject = nil
  self.originPool = nil
  self.grabPos = nil
end
