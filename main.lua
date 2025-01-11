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
            elseif circleGrid[Row][Col] == 2 then
                love.graphics.setColor(0, 0, 0.1, 0.3)
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
        if circleGrid[newCoordsX] and circleGrid[newCoordsX][newCoordsY] then
            if circleGrid[newCoordsX][newCoordsY] ~= playerstate and circleGrid[newCoordsX][newCoordsY] ~= "" and circleGrid[newCoordsX][newCoordsY] ~= 2 then
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
blackCurrentScore = 0
    whiteCurrentScore = 0
    for x = 1, #circleGrid do
        for y = 1, #circleGrid[x] do
        if circleGrid[x][y] == 0 then
            blackCurrentScore = blackCurrentScore + 1
        elseif circleGrid[x][y] == 1 then
            whiteCurrentScore = whiteCurrentScore + 1
        end
        end
    end
end

function searchMoves(moverow, movecol, dirrow, dircol)
    local moveR = moverow
    local moveY = movecol
    local CoordsX = moverow + dirrow
    local CoordsY = movecol + dircol
    local tempMove = {}

    while CoordsX <= 8 and CoordsX >= 1 and CoordsY <= 8 and CoordsY >= 1 do
        if circleGrid[CoordsX] and circleGrid[CoordsX][CoordsY] then
            if circleGrid[CoordsX][CoordsY] ~= playerstate and circleGrid[CoordsX][CoordsY] ~= "" then
                print("Valid move at "..moverow.."/"..movecol)
                tempMove[#tempMove + 1] = {moveR, moveY}
            elseif circleGrid[CoordsX][CoordsY] == playerstate then 
                if #tempMove > 0 then
                    for i = 1, #tempMove do
                        print("Updating Valid Moves")
                        validMoves[#validMoves + 1 ] = tempMove[i]
                        print(validMoves[i][1]..validMoves[i][2])
                    end
                end
                return
            else 
                break
            end
        end
        CoordsX = CoordsX + dirrow
        CoordsY = CoordsY + dircol
    end
end


function moveSetup(row, col)
    
   local dirs = {{0, 1}, {1, 0}, {0, -1}, {-1, 0},
              {1, 1}, {-1, 1}, {-1, -1}, {1, -1}}

   for i = 1, 8 do
      searchMoves(row, col, dirs[i][1], dirs[i][2])
   end
   
end



function checkMoves()
     checkedGrids = {}
    validMoves = {}
     for x = 1, 8 do
        for y = 1, 8 do
            if circleGrid[x][y] == 2 then
                circleGrid[x][y] = ""
            end
        end
     end
    for pRow = 1, 8 do
        for pCol = 1, 8 do
            local key = tostring(pRow) .. "_" .. tostring(pCol)
            if not checkedGrids[key] then
                if circleGrid[pRow][pCol] == "" then
                moveSetup(pRow, pCol)
                checkedGrids[key] = true
            end         
        end
    end
end

function writeMoves()
    print("Writing moves")
    if #validMoves == 0 then
        print("Can't Play")
        canPlay = false
    end
    for i = 1, #validMoves do
        local rows = validMoves[i][1]
        local cols = validMoves[i][2]

        circleGrid[rows][cols] = 2
    end
end

end

function love.load()
    -- Load assets and initialize variables here
    _G.canPlay = true
    _G.gameOver = false
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

        _G.visited = {}
        for row = 1, 8 do
            visited[row] = {}
            for col = 1, 8 do
            visited[row][col] = false
            end
        end

    -- FONT
    font = love.graphics.newFont("AmericanCaptain-MdEY.otf", 62)
    
    --Arrays to Store Circles That Need to be Flipped
    _G.ToFlip = {}
    _G.validMoves = {}
    _G.checkedGrids = {}
    -- Setting Width and Height Variables
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()

    -- Player State and Scores During Game
    playerstate = 0  

    blackCurrentScore = 2
    whiteCurrentScore = 2
    checkMoves()
    writeMoves()
end

function love.mousepressed()
    if mouseRow > 0 and mouseRow <= 8 and mouseCol > 0 and mouseCol <= 8 then
        if canPlay == true and gameOver == false then
            if circleGrid[mouseRow][mouseCol] == 2 then
            circleGrid[mouseRow][mouseCol] = playerstate
            dirSetup(mouseRow, mouseCol)
            flipPieces()
            playerstate = 1 - playerstate
            checkMoves()
            writeMoves()
            end
        elseif canPlay == false and gameOver == false then
            playerstate = 1 - playerstate
            checkMoves()
            writeMoves()
            canPlay = true
        end 
    end

    if blackCurrentScore + whiteCurrentScore ==  64 then
        gameOver = true
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
    -- love.graphics.print(mouseRow..", "..mouseCol, 600, 600, nil)

    -- Rendering Chips and Current Scores
    

    drawChips()
    drawCurrentScore()

    love.graphics.setColor(1, 0, 0)
    if canPlay == false then
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", screenWidth / 2 - 400, 400, 800, 300)
        love.graphics.setColor(0, 0, 1)
        love.graphics.print("Player Can't Play", screenWidth / 2 - 100, 550)
    end

    love.graphics.setColor(0, 0, 1)
    if gameOver == true then
        love.graphics.setColor(0, 0, 1)
        love.graphics.rectangle("fill", screenWidth / 2 - 400, 400, 800, 300)
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("Game Over!", screenWidth / 2 - 100, 550)
    end
end