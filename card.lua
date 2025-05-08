
require "vector"

CardClass = {}

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2
}

SUIT = {
  HEARTS = "hearts",
  DIAMONDS = "diamonds",
  CLUBS = "clubs",
  SPADES = "spades"
}

function CardClass:new(xPos, yPos, suit, rank)
  local card = {}
  local metadata = {__index = CardClass}
  setmetatable(card, metadata)
  
  card.position = Vector(xPos, yPos)
  card.size = Vector(50, 70)
  
  card.state = CARD_STATE.IDLE -- Default to Idle state
  
  card.suit = suit
  card.rank = rank
  
  return card
end

function CardClass:update()
  if self.state == CARD_STATE.GRABBED and grabber then
    -- Update position to follow mouse, accounting for grab offset
    local mousePos = grabber.currentMousePos
    if mousePos then
      self.position = Vector(mousePos.x - self.size.x/2, mousePos.y -self.size.y/2)
    end
  end
end

function CardClass:draw()
  -- Drop shadow if held or hovered
  if self.state ~= CARD_STATE.IDLE then
    love.graphics.setColor(0, 0, 0, 0.8)
    local offset = 4 * (self.state == CARD_STATE.GRABBED and 2 or 1)
    love.graphics.rectangle("fill", self.position.x + offset, self.position.y + offset, self.size.x, self.size.y, 6, 6)
  end
  
  -- Draw base
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
  
  -- Draw suit and rank
  if (self.suit == "hearts" or self.suit == "diamonds") then
    love.graphics.setColor(1, 0, 0, 1)
  else
    love.graphics.setColor(0, 0, 0, 1)
  end
  if suitImages[self.suit] then
    love.graphics.draw(suitImages[self.suit], self.position.x + 10, self.position.y + 10)
  end
  if rankImages[self.rank] then
    love.graphics.draw(rankImages[self.rank], self.position.x + 30, self.position.y + 10)
  end
end

function CardClass:checkForMouseOver(grabber)
  if self.state == CARD_STATE.GRABBED then
    return
  end

  local mousePos = grabber.currentMousePos
  if not mousePos then return false end

  local isMouseOver =
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y

  self.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE
  
  return isMouseOver
end