-- Joshua Acosta
-- CMPM 121
-- Project 2 - Solitaire v2
-- 5/7/25
io.stdout:setvbuf("no")

require "card"
require "grabber"

function love.load()
  love.window.setTitle("Solitaire v2")
  
  -- Load Card Assets
  suitImages = {
    hearts = love.graphics.newImage("images/pip_heart.png"),
    diamonds = love.graphics.newImage("images/pip_diamond.png"),
    clubs = love.graphics.newImage("images/pip_club.png"),
    spades = love.graphics.newImage("images/pip_spade.png")
  }
  rankImages = {
    [1] = love.graphics.newImage("images/1.png"),
    [2] = love.graphics.newImage("images/2.png"),
    [3] = love.graphics.newImage("images/3.png"),
    [4] = love.graphics.newImage("images/4.png"),
    [5] = love.graphics.newImage("images/5.png"),
    [6] = love.graphics.newImage("images/6.png"),
    [7] = love.graphics.newImage("images/7.png"),
    [8] = love.graphics.newImage("images/8.png"),
    [9] = love.graphics.newImage("images/9.png"),
    [10] = love.graphics.newImage("images/10.png"),
    [11] = love.graphics.newImage("images/11.png"),
    [12] = love.graphics.newImage("images/12.png"),
    [13] = love.graphics.newImage("images/13.png")
  }
  faceDownImage = love.graphics.newImage("images/card_face_down.png")
  
  -- Set the window and background
  love.window.setMode(960, 640)
  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)

  -- Important values
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
  centerX, centerY = width / 2, height / 2
  deckX, deckY = centerX/8, centerY/4
  deckWidth, deckHeight = 53, 73
  
  -- Game elements
  grabber = GrabberClass:new()  -- Cursor
  deckTable = {}  -- Full deck
  drawnCards = {} -- Cards drawn from deck
  
  -- Load images
  images = {}
  for nameIndex, name in ipairs({
      1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,
      'pip_heart', 'pip_diamond', 'pip_club', 'pip_spade',
      'mini_heart', 'mini_diamond', 'mini_club', 'mini_spade',
      'card', 'card_face_down',
      'face_jack', 'face_queen', 'face_king',
  }) do
      images[name] = love.graphics.newImage('images/'..name..'.png')
  end
  
  -- Create deck of cards
  for _, suit in ipairs({SUIT.HEARTS, SUIT.DIAMONDS, SUIT.CLUBS, SUIT.SPADES}) do
    for rank = 1, 13 do
      table.insert(deckTable, CardClass:new(0, 0, suit, rank))
    end
  end

  shuffle(deckTable)
  
  table.insert(drawnCards, CardClass:new(100, 100, SUIT.HEARTS, 5))
  table.insert(drawnCards, CardClass:new(300, 100, SUIT.SPADES, 13))
end

function love.update()
  grabber:update()
  checkForMouseHover()

  -- clickDeck()
  
  for _, card in ipairs(drawnCards) do
    card:update()
  end
end

function love.draw()
  -- Deck
  love.graphics.setColor(1, 1, 1, 1) -- white (for images)
  love.graphics.draw(faceDownImage, deckX, deckY)

  -- Suit Piles and Tableaus
  love.graphics.setColor(0, 1, 0, 1) -- green
  love.graphics.rectangle("line", centerX, deckY, deckWidth, deckHeight)
  love.graphics.rectangle("line", centerX * 1.2, deckY, deckWidth, deckHeight)
  love.graphics.rectangle("line", centerX * 1.4, deckY, deckWidth, deckHeight)
  love.graphics.rectangle("line", centerX * 1.6, deckY, deckWidth, deckHeight)
  
  love.graphics.rectangle("line", centerX*0.2, centerY*2/3, deckWidth, deckHeight)
  love.graphics.rectangle("line", centerX*0.4, centerY*2/3, deckWidth, deckHeight)
  love.graphics.rectangle("line", centerX*0.6, centerY*2/3, deckWidth, deckHeight)
  love.graphics.rectangle("line", centerX*0.8, centerY*2/3, deckWidth, deckHeight)
  love.graphics.rectangle("line", centerX*1.0, centerY*2/3, deckWidth, deckHeight)
  love.graphics.rectangle("line", centerX*1.2, centerY*2/3, deckWidth, deckHeight)
  love.graphics.rectangle("line", centerX*1.4, centerY*2/3, deckWidth, deckHeight)

  -- Cards
  for _, card in ipairs(drawnCards) do
    card:draw()
  end
  
  -- Card shadow
  love.graphics.setColor(1, 1, 1, 1)
  if grabber.currentMousePos then
    love.graphics.print("Mouse: " .. tostring(grabber.currentMousePos.x) .. ", " .. tostring(grabber.currentMousePos.y))
  end
end

function checkForMouseHover()
  if not grabber.currentMousePos then
    return
  end
  
  for _, card in ipairs(drawnCards) do
    card:checkForMouseOver(grabber)
  end
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

function returnCard()
  if #drawnCards > 0 then
  end
end


function resetDeck()
  for _, card in ipairs(drawnCards) do
    table.insert(deckTable, card)
  end
  drawnCards = {}
  shuffle(deckTable)
end

-- function clickDeck()
--   local isMouseOver = mousePos.x > deckX and mousePos.x < deckX + deckWidth and mousePos.y > deckY and mousePos.y < deckY + deckHeight

--   if isMouseOver then
--     print("click here")
--   end
-- end

