require "vector"

GrabberClass = {}

function GrabberClass:new()
  local grabber = {}
  local metadata = {__index = GrabberClass}
  setmetatable(grabber, metadata)
  
  grabber.currentMousePos = nil
  grabber.grabPos = nil
  grabber.heldObject = nil
  
  return grabber
end

function GrabberClass:update()
  self.currentMousePos = Vector(
    love.mouse.getX(),
    love.mouse.getY()
  )

  -- Click (grab)
  if love.mouse.isDown(1) and self.grabPos == nil then
    self:grab()
  end
  -- Release
  if not love.mouse.isDown(1) and self.grabPos ~= nil then
    self:release()
  end
end

function GrabberClass:grab()
  self.grabPos = self.currentMousePos
  
  for _, card in ipairs(drawnCards) do
    if card:checkForMouseOver(self) then
      self.heldObject = card
      card.state = CARD_STATE.GRABBED
      break
    end
  end
end

function GrabberClass:release()
  if self.heldObject == nil then
    self.grabPos = nil
    return
  end

  self.heldObject.state = CARD_STATE.IDLE
  self.heldObject = nil
  self.grabPos = nil
end
