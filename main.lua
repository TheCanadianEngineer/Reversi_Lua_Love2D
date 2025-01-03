function drawBoard()
    local tileSize = 125
    
    _G.Grid = {
      {1, 0, 1, 0, 1, 0, 1, 0},
      {0, 1, 0, 1, 0, 1, 0, 1},
      {1, 0, 1, 0, 1, 0, 1, 0},
      {0, 1, 0, 1, 0, 1, 0, 1},
      {1, 0, 1, 0, 1, 0, 1, 0},
      {0, 1, 0, 1, 0, 1, 0, 1},
      {1, 0, 1, 0, 1, 0, 1, 0},
      {0, 1, 0, 1, 0, 1, 0, 1},
    }

    for Row = 1, #Grid do
      for Col = 1, #Grid[Row] do
        if Grid[Row][Col] == 0 then
          love.graphics.setColor (0, 1, 0, 0.5)
        elseif Grid[Row][Col] == 1 then
          love.graphics.setColor(0, 1, 0)
        end
        love.graphics.rectangle("fill", (Col - 1) * tileSize, (Row - 1) * tileSize, tileSize, tileSize)
      end
    end
  end


function drawChips()
    local circleSize = 70

    

    for Row = 1, #circleGrid do
      for Col = 1, #circleGrid[Row] do
        if circleGrid[Row][Col] ~= "" then
            if circleGrid[Row][Col] == 0 then
                love.graphics.setColor (0, 0, 0)
            elseif circleGrid[Row][Col] == 1 then
                love.graphics.setColor(1, 1, 1)
            end
            love.graphics.circle("fill", (Col - 1) * 125 + 125 / 2, (Row - 1) * 125 + 125 / 2, circleSize / 2, 50)
        end
      end
    end
end

function love.load()
    -- Load assets and initialize variables here
        -- Chip Grid
        _G.circleGrid = {
            {"","","","","","","",""},
            {"","","","","","","",""},
            {"","","","","","","",""},
            {"","","",0,1,"","",""},
            {"","","",1,0,"","",""},
            {"","","","","","","",""},
            {"","","","","","","",""},
            {"","","","","","","",""},
            }
    -- FONT
    font = love.graphics.newFont("AmericanCaptain-MdEY.otf", 62)
    

    -- Setting Width and Height Variables
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()

    playerstate = 0  
    blackCurrentScore = 2
    whiteCurrentScore = 2
end

function love.mousepressed()

    -- Choosing Player Turns
    if love.mouse.getY() < 1000 then
        if playerstate == 0 then
        circleGrid[mouseRow][mouseCol] = 0
        playerstate = 1
    elseif playerstate == 1 then
        circleGrid[mouseRow][mouseCol] = 1
        playerstate = 0
    end
    end
    

    -- Placing Chips
    
    
end

function drawCurrentScore()
    love.graphics.setFont(font, 100)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("•"..blackCurrentScore, 125, 1148, nil, 2, 2)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("•"..whiteCurrentScore, 757.5, 1148, nil, 2, 2)
end

function love.update(dt)
    -- Handle game logic here
        
        --Mouse Coordinate On Grid
        if love.mouse.getY() < 1000 then
            _G.mouseRow = math.ceil(love.mouse.getY() / 125)
        else 
            mouseRow = ''
        end

        _G.mouseCol = math.ceil(love.mouse.getX() / 125)
        
        
end

function love.draw()
    -- Render the game here

    -- Rendering Board
    love.graphics.setColor(1, 1, 1, 0.4)
    love.graphics.rectangle("fill", 0, 8 * 125, screenWidth, screenHeight)
    drawBoard()

    -- Printing Text to Screen
    
    love.graphics.setFont(font, 100)

        -- Printing Player Turn
    local textHeight = font:getHeight()
    local y = 1050

    if playerstate == 0 then
        love.graphics.setColor(0, 0, 0)
        local text = "Black's Turn"
        local textWidth = font:getWidth(text) 
        local x = (screenWidth - textWidth) / 2 
        love.graphics.print(text, x, y, nil)
    elseif playerstate == 1 then
        love.graphics.setColor(1, 1, 1)
        local text = "White's Turn"
        local textWidth = font:getWidth(text) 
        local x = (screenWidth - textWidth) / 2 
        love.graphics.print(text, x, y, nil)
    end

--  Check Mouse Grod Coords love.graphics.print(mouseRow..", "..mouseCol, 600, 600, nil)

    -- Printing Current Scores
    drawChips()
    drawCurrentScore()
    
    
end
