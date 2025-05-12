
require "card"

CardTableClass = {}

function CardTableClass:new(x, y, placementRule)
  local cardTable = {}
  local metadata = {__index = CardTableClass}
  setmetatable(cardTable, metadata)
  
  cardTable.position = Vector(x, y)
  cardTable.placementRule = placementRule or function(_, _) return true end
  cardTable.snapThreshold = 40
  cardTable.showAllCards = true
  
  return cardTable
end

function CardTableClass:draw()
  for i, card in ipairs(self.cards) do
    card:draw()
  end
end

function CardTableClass:update()
  for _, card in ipairs(self.cards) do
    card:update()
  end
end

function CardTableClass:addCard(card)
  if self:canPlace(card) then
    table.insert(self.cards, card)
    card.position = self:getNextCardPosition()
    return true
  end
  return false
end

function CardTableClass:canPlace(card)
  local topCard = self.cards[#self.cards]
  return self.placementRule(topCard, card)
end

function CardTableClass:getNextCardPosition()
  local offsetY = 20 -- for tableau-style vertical offset
  return vector(self.position.x, self.position.y + (#self.cards * offsetY))
end

function CardTableClass:isNearby(card)
  local dx = math.abs(card.position.x - self.position.x)
  local dy = math.abs(card.position.y - self.position.y)
  return dx < self.snapThreshold and dy < self.snapThreshold
end

function shuffle(deck)
    local cardCount = #deck
    for i = 1, cardCount do
        local randIndex = math.random(cardCount)
        local temp = deck[randIndex]
        deck[randIndex] = deck[cardCount]
        deck[cardCount] = temp
        cardCount = cardCount - 1
    end
    return deck
end

function drawCard()
  if #deckTable > 0 then
    local card = table.remove(deckTable)
    table.insert(drawnCards, card)
  end
end