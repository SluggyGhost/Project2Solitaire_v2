
CardClass = {}

function CardClass:new(xPos, yPos, suit, rank, faceUp)
  local card = {}
  local metadata = {__index = CardClass}
  setmetatable(card, metadata)
  
  card.position = Vector(xPos, yPos)
  card.size = Vector(50, 70)
  
  card.state = CARD_STATE.IDLE -- Default to Idle state
  
  card.suit = suit
  card.rank = rank
  card.faceUp = faceUp or false
  
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

  love.graphics.setColor(1, 1, 1, 1)

  if not self.faceUp then
    -- Draw the card back
    love.graphics.draw(faceDownImage, self.position.x, self.position.y)
    return
  end

  -- Card face
  love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)

  -- Suit and rank coloring
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

function isOppositeColor(card1, card2)
  local redSuits = { hearts = true, diamonds = true }
  return (redSuits[card1.suit] and not redSuits[card2.suit]) or (not redSuits[card1.suit] and redSuits[card2.suit])
end