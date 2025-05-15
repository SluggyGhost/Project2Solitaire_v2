
width = love.graphics.getWidth()
height = love.graphics.getHeight()
centerX, centerY = width / 2, height / 2
deckX, deckY = centerX/8, centerY/8
deckWidth, deckHeight = 53, 73
tableauY = centerY/2
tableauLeftEdge = centerX*0.2

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