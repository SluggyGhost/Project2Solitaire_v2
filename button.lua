
ButtonClass = {}

function ButtonClass:new(xPos, yPos, text, btWidth, btHeight, onClick)
  local button = {}
  local metadata = {__index = ButtonClass}
  setmetatable(button, metadata)
  
  button.position = Vector(xPos, yPos)
  button.text = text
  button.size = Vector(btWidth, btHeight)
  button.onClick = onClick
  
  return button
end

function ButtonClass:draw()
  self.size = Vector(love.graphics.getFont():getWidth(self.text), love.graphics.getFont():getHeight())

  love.graphics.setColor(1, 0, 0, 0.5)
  love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y)
  love.graphics.print(self.text, self.position.x, self.position.y)

end

function ButtonClass:click(mousePosition)
    if mousePosition.x >= self.position.x and mousePosition.y >= self.position.y and mousePosition.x <= self.position.x + self.size.x and mousePosition.y <= self.position.y + self.size.y then
        self.onClick();
        return true
    end

    return false
end