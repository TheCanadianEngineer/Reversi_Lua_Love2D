-- Draw The 8x8 Grid
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

    -- Diameter of Circles
    local circleSize = 100

    -- Go Through Circle (Coins) Matrix and Draws the Circles
    for Row = 1, #circleGrid do
      for Col = 1, #circleGrid[Row] do
        if circleGrid[Row][Col] ~= "" then
            if circleGrid[Row][Col] == 0 then
                love.graphics.setColor (0, 0, 0)
            elseif circleGrid[Row][Col] == 1 then
                love.graphics.setColor(1, 1, 1)
            end
            -- Drawing Circles
            love.graphics.circle("fill", (Col - 1) * 125 + 125 / 2, (Row - 1) * 125 + 125 / 2, circleSize / 2, 50)
        end
      end
    end
end

function searchDirs(mouserow, mousecol, dirrow, dircol)
    local newCoordsX = mouserow + dirrow
      local newCoordsY = mousecol + dircol
        local tempFlip = {}
   while newCoordsX <= 8 and newCoordsX >= 1 and newCoordsY <= 8 and newCoordsY >= 1 do

      

      if circleGrid[newCoordsX][newCoordsY] ~= playerstate then
         tempFlip[#tempFlip + 1] = {newCoordsX, newCoordsY}
      elseif circleGrid[newCoordsX][newCoordsY] == playerstate then 
         if #tempFlip > 0 then
            for i = 1, #tempFlip do
                ToFlip[#ToFlip + 1 ] = tempFlip[i]
            end
         end
         return
      else 
        break
      end
        
        newCoordsX = newCoordsX + dirrow
        newCoordsY = newCoordsY + dircol
   end
end

function dirSetup(row, col)
    ToFlip = {}
   local dirs = {{0, 1}, {1, 0}, {0, -1}, {-1, 0},
              {1, 1}, {-1, 1}, {-1, -1}, {1, -1}}

   for i = 1, #dirs do
      searchDirs(row, col, dirs[i][1], dirs[i][2])
   end
   
end

function flipPieces()
    for i = 1, #ToFlip do
        local rows = ToFlip[i][1]
        local cols = ToFlip[i][2]
        circleGrid[rows][cols] = playerstate
    end
end


function love.load()
    -- Load assets and initialize variables here
        -- Chip Grid

        
        _G.circleGrid = {
            {"","","","","","","",""},
            {"","","","","","","",""},
            {"","","","","","","",""},
            {"","","", 0, 1,"","",""},
            {"","","", 1, 0,"","",""},
            {"","","","","","","",""},
            {"","","","","","","",""},
            {"","","","","","","",""},
            }
    -- FONT
    font = love.graphics.newFont("AmericanCaptain-MdEY.otf", 62)
    
    --Arrays to Store Circles That Need to be Flipped
    _G.ToFlip = {}

    -- Setting Width and Height Variables
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()

    -- Player State and Scores During Game
    playerstate = 0  

    blackCurrentScore = 2
    whiteCurrentScore = 2
end

function love.mousepressed()
    if mouseRow > 0 and mouseRow <= 8 and mouseCol > 0 and mouseCol <= 8 then
        if circleGrid[mouseRow][mouseCol] == "" then
            circleGrid[mouseRow][mouseCol] = playerstate
            dirSetup(mouseRow, mouseCol)
            flipPieces()
            playerstate = 1 - playerstate
        end
    end
end

-- Function to Draw the Current Scores (Pretty Self Explanatory)
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
        _G.mouseRow = math.ceil(love.mouse.getY() / 125)
        _G.mouseCol = math.ceil(love.mouse.getX() / 125)
end

function love.draw()
    -- Render the game here

        -- Rendering Bottom Rectangle and Grid
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

--  Print Mouse Grid Coords 
    love.graphics.print(mouseRow..", "..mouseCol, 600, 600, nil)

    -- Rendering Chips and Current Scores
    drawChips()
    drawCurrentScore()
end

