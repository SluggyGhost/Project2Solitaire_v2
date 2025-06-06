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
  tableaus = {
    TableauPrototype:new(1 * tableauLeftEdge, tableauY),
    TableauPrototype:new(2 * tableauLeftEdge, tableauY),
    TableauPrototype:new(3 * tableauLeftEdge, tableauY),
    TableauPrototype:new(4 * tableauLeftEdge, tableauY),
    TableauPrototype:new(5 * tableauLeftEdge, tableauY),
    TableauPrototype:new(6 * tableauLeftEdge, tableauY),
    TableauPrototype:new(7 * tableauLeftEdge, tableauY),
  }
  resetButton = ButtonClass:new(820, 550, "RESET", 100, 40, function() resetState() end)
  drawButton = ButtonClass:new(100, 100, "", 60, 90, function() drawThreeCards() end)

  resetState()
end

function love.update(dt)
  local allPools = {deck, drawnCards, tableaus[1], tableaus[2], tableaus[3], tableaus[4], tableaus[5], tableaus[6], tableaus[7]}
  for _, t in ipairs(tableaus) do table.insert(allPools, t) end
  grabber:update(allPools)
end

function love.draw()
  resetButton:draw()
  drawButton:draw()

  -- Deck
  love.graphics.setColor(1, 1, 1, 1) -- white (for images)
  love.graphics.draw(faceDownImage, deckX, deckY)

  -- Suit Piles and Tableaus (spaces)
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

  deck:draw()
  drawnCards:draw()
  tableaus[1]:draw()
  tableaus[2]:draw()
  tableaus[3]:draw()
  tableaus[4]:draw()
  tableaus[5]:draw()
  tableaus[6]:draw()
  tableaus[7]:draw()
  
  -- Card shadow
  love.graphics.setColor(1, 1, 1, 1)
  if grabber.currentMousePos then
    love.graphics.print("Mouse: " .. tostring(grabber.currentMousePos.x) .. ", " .. tostring(grabber.currentMousePos.y))
  end

  -- Draw the grabbed card on top of everything
  if grabber.heldObject then
    grabber.heldObject:draw()
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
      local card = CardClass:new(0, 0, suit, rank, false)
      deck:addCard(card)
    end
  end

  -- Shuffle the deck
  deck:shuffle()

  -- Deal cards to tableaus
  for i = 1, 7 do
    for j = 1, i do
      local card = deck:drawFromDeck()
      tableaus[i]:addCard(card)
    end
    -- Flip the last card in each tableau face-up
    for _, tableau in ipairs(tableaus) do
      if #tableau.cards > 0 then
        tableau.cards[#tableau.cards].faceUp = true
      end
    end
  end
end

function love.mousePressed(x, y, button)
  if button == 1 then
    local mousePos = Vector(x, y)
    resetButton:click(mousePos)
  end
end


-- Draw 3 new cards
function drawThreeCards()
  for i = #drawnCards.cards, 1, -1 do
    local card = table.remove(drawnCards.cards, i)
    deck:addCardToBottom(card)
  end

  for i = 1, 3 do
    local card = deck:drawFromDeck()
    if not card then break end
    drawnCards:addCard(card)
  end
end
