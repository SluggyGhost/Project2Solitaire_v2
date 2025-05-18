
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

-- DECK
DeckPrototype = PoolPrototype:new(xPos, yPos)
function DeckPrototype:new()
  return DeckPrototype
end

function DeckPrototype:addCardToBottom(card)
  table.insert(self.cards, 1, card)
  self:updateCardPositions()
end

function DeckPrototype:drawFromDeck()
  return table.remove(self.cards)
end

function DeckPrototype:shuffle()
  local cardCount = #self.cards
  for i = 1, cardCount do
    local randIndex = math.random(cardCount)
    local temp = self.cards[randIndex]
    self.cards[randIndex] = self.cards[cardCount]
    self.cards[cardCount] = temp
    cardCount = cardCount - 1
  end
end

-- DRAW PILE
DrawPilePrototype = PoolPrototype:new(xPos, yPos, true, 55, 0)
function DrawPilePrototype:new()
  return DrawPilePrototype
end

-- SUIT PILES
SuitPilePrototype = PoolPrototype:new()
function SuitPilePrototype:new(xPos, yPos)
  local pile = PoolPrototype.new(self, xPos, yPos, true, 0, 0)
  setmetatable(pile, {__index = SuitPilePrototype})
  return pile
end

function SuitPilePrototype:isValidMove(card)
  local top = self.cards[#self.cards]
  if not top then
    return card.rank == 1 -- Only Aces can go in empty suit piles
  end
  return card.suit == top.suit and card.rank == top.rank + 1
end

function SuitPilePrototype:trySnap(card)
  if self:isCardNearSnap(card) and self:isValidMove(card) then
    self:addCard(card)
    return true
  end
  return false
end

-- TABLEAU
TableauPrototype = PoolPrototype:new()
function TableauPrototype:new(xPos, yPos)
  local tableau = PoolPrototype:new(xPos, yPos, true, 0, 30)
  setmetatable(tableau, {__index = TableauPrototype})
  return tableau
end

function TableauPrototype:isValidMove(card)
  local top = self.cards[#self.cards]
  if not top then
    return card.rank == 13 -- Only Kings can go in empty tableaus
  end
  return top.faceUp and card.color ~= top.color and card.rank == top.rank - 1
end

function TableauPrototype:trySnap(card)
  if self:isCardNearSnap(card) and self:isValidMove(card) then
    self:addCard(card)
    return true
  end
  return false
end
