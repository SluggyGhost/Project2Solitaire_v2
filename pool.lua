
require "card"

PoolPrototype = {}

function PoolPrototype:new(xPos, yPos, showCards, offsetX, offsetY)
  local pool = {}
  local metadata = {__index = PoolPrototype}
  setmetatable(pool, metadata)
  
  pool.position = Vector(xPos, yPos)
  pool.showCards = showCards or false
  pool.offset = Vector(offsetX or 0, offsetY or 0)
  pool.cards = {}
  pool.snapRadius = 20
  
  return pool
end
function PoolPrototype:addCard(card)
  table.insert(self.cards, card)
  self:updateCardPositions()
end
function PoolPrototype:removeCard(card)
  for i, c in ipairs(self.cards) do
    if c == card then
      table.remove(self.cards, i)
      break
    end
  end
  self:updateCardPositions()
end
function PoolPrototype:updateCardPositions()
  for i, card in ipairs(self.cards) do
    card.position = self.position + self.offset * (i-1)
  end
end
function PoolPrototype:isCardNearSnap(card)
  if not card or not card.position then return false end
  local dist = math.sqrt((card.position.x - self.position.x)^2 + (card.position.y - self.position.y)^2)
  return dist <= self.snapRadius
end
function PoolPrototype:trySnap(card)
  if self:isCardNearSnap(card) then
    self:addCard(card)
    return true
  end
  return false
end
function PoolPrototype:draw()
  for _, card in ipairs(self.cards) do
    card:draw()
  end
end