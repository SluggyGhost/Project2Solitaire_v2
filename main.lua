-- Joshua Acosta
-- CMPM 121
-- Project 2 - Solitaire v2
-- 5/7/25
io.stdout:setvbuf("no")

require "card"
require "grabber"
require "pool"
require "button"
require "const"
require "vector"

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
  
  -- Game elements
  grabber = GrabberClass:new()  -- Cursor
  deck = DeckPrototype:new(deckX, deckY)  -- Full deck
  drawnCards = DrawPilePrototype:new(centerX, deckY) -- Cards drawn from deck
  resetButton = ButtonClass:new(centerX, centerY, "RESET", 100, 100, function() resetState() end)
  
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
      local card = CardClass:new(0, 0, suit, rank)
      deck:addCard(card)
    end
  end

  deck:shuffle()

  card = deck:drawFromDeck()
  drawnCards:addCard(card)
  card = deck:drawFromDeck()
  drawnCards:addCard(card)
  for _, card in ipairs(drawnCards.cards) do
    print(card.suit .. " " .. card.rank)
  end
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
  resetButton:draw()

  -- Deck
  love.graphics.setColor(1, 1, 1, 1) -- white (for images)
  love.graphics.draw(faceDownImage, deckX, deckY)

  -- Suit Piles and Tableaus
  love.graphics.setColor(0, 1, 0, 1) -- green
  love.graphics.rectangle("line", centerX, deckY, deckWidth, deckHeight)
  love.graphics.rectangle("line", centerX * 1.2, deckY, deckWidth, deckHeight)
  love.graphics.rectangle("line", centerX * 1.4, deckY, deckWidth, deckHeight)
  love.graphics.rectangle("line", centerX * 1.6, deckY, deckWidth, deckHeight)
  
  local tableauAlign = 0
  for i = 1, 7 do
    tableauAlign = tableauAlign + tableauLeftEdge
    love.graphics.rectangle("line", tableauAlign, tableauY, deckWidth, deckHeight)
  end

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

function resetState()
  -- Clear all pools
  deck.cards = {}
  drawnCards.cards = {}
  for _, t in ipairs(tableaus) do t.cards = {} end

  -- Build a new deck
  local suits = {SUIT.HEARTS, SUIT.DIAMONDS, SUIT.CLUBS, SUIT.SPADES}
  for _, suit in ipairs(suits) do
    for rank = 1, 13 do
      local card = CardClass:new(suit, rank)
      deck:addCard(card)
    end
  end

  -- Shuffle the deck
  deck:shuffle()

  -- Deal cards to tableaus
  for i = 1, 7 do
    for j = 1, i do
      local card = deck:drawFromDeck()
      table.insert(tableaus[i].cards, card)
    end
    -- Flip the top card face-up
    local topCard = tableaus[i].cards[#tableaus[i].cards]
    if topCard then topCard.faceUp = true end
    tableaus[i]:updateCardPositions()
  end
end

function love.mousePressed(x, y, button)
  if button == 1 then
    local mousePos = Vector(x, y)
    resetButton:click(mousePos)
  end
end
