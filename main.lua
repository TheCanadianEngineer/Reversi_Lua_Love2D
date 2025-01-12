-- Draw The Game Board
function drawBoard()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(reversiBoard, 0, 0, 0, 5, 5)
end


--Draw Chips to Board
function drawChips()

    -- Diameter of Circles
    local circleSize = 100

    -- Go Through Circle (Coins) Matrix and Draws the Circles Corresponding to What Number is at What Location
    for Row = 1, #circleGrid do
      for Col = 1, #circleGrid[Row] do
        if circleGrid[Row][Col] ~= "" then
            if circleGrid[Row][Col] == 0 then
                --Black Chips
                love.graphics.setColor (1, 1, 1)
                love.graphics.draw(blackChip, (Col - 1) * 125 + 12, (Row - 1) * 125 + 12)
            elseif circleGrid[Row][Col] == 1 then
                --White Chips
                love.graphics.setColor(1, 1, 1)
                love.graphics.draw(whiteChip, (Col - 1) * 125 + 12, (Row - 1) * 125 + 12)
            elseif circleGrid[Row][Col] == 2 then
                --Valid Moves Chips
                love.graphics.setColor(0, 0, 1, 0.3)
                love.graphics.circle("fill", (Col - 1) * 125 + 125 / 2, (Row - 1) * 125 + 125 / 2, circleSize / 2, 50)
            end
        end
      end
    end
end

--Searching for Possible Pieces to Flip
function searchDirs(mouserow, mousecol, dirrow, dircol)

    --Setting Local Variables
    local newCoordsX = mouserow + dirrow
    local newCoordsY = mousecol + dircol
    local tempFlip = {}

    --Itterate Through The Circle Grid in Certain Directions
    while newCoordsX <= 8 and newCoordsX >= 1 and newCoordsY <= 8 and newCoordsY >= 1 do
        if circleGrid[newCoordsX] and circleGrid[newCoordsX][newCoordsY] then
            if circleGrid[newCoordsX][newCoordsY] ~= playerstate and circleGrid[newCoordsX][newCoordsY] ~= "" and circleGrid[newCoordsX][newCoordsY] ~= 2 then
                tempFlip[#tempFlip + 1] = {newCoordsX, newCoordsY}
            elseif circleGrid[newCoordsX][newCoordsY] == playerstate then 
                --Inputting Coords of Chips to Flip if There are Some
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
        --Check Next Grid in the Same Direction as Before
        newCoordsX = newCoordsX + dirrow
        newCoordsY = newCoordsY + dircol
    end
end


function dirSetup(row, col)
    ToFlip = {}
    --List of Directions
    local dirs = {{0, 1},
                 {1, 0},
                 {0, -1},
                 {-1, 0},
                 {1, 1},
                 {-1, 1},
                 {-1, -1},
                 {1, -1}}

    -- Itterate Through Directions and Then Calls the Direction Searching Function
    for i = 1, #dirs do
      searchDirs(row, col, dirs[i][1], dirs[i][2])
    end
end


function flipPieces()
    -- Itterates Through the List of Pieces That Need to be Flipped and Flips Them
    for i = 1, #ToFlip do
        --Local Variables to Help Select the Correct X and Y Values
        local rows = ToFlip[i][1]
        local cols = ToFlip[i][2]
        --Update Circle Grid 
        circleGrid[rows][cols] = playerstate
    end
    --Player Score Variables Being set to 0
    blackCurrentScore = 0
    whiteCurrentScore = 0

    --Check Circle Grid and Update the Scores
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

-- Check for Valid Moves in Certain Directions
function searchMoves(moverow, movecol, dirrow, dircol)
    --Declare Local Variables
    local moveR = moverow
    local moveY = movecol
    local CoordsX = moverow + dirrow
    local CoordsY = movecol + dircol
    local tempMove = {}

    --Itterate Through Directions
    while CoordsX <= 8 and CoordsX >= 1 and CoordsY <= 8 and CoordsY >= 1 do
        if circleGrid[CoordsX] and circleGrid[CoordsX][CoordsY] then
            if circleGrid[CoordsX][CoordsY] ~= playerstate and circleGrid[CoordsX][CoordsY] ~= "" then
                print("Valid move at "..moverow.."/"..movecol)
                tempMove[#tempMove + 1] = {moveR, moveY}
            elseif circleGrid[CoordsX][CoordsY] == playerstate then 
                if #tempMove > 0 then
                    for i = 1, #tempMove do
                        --Inputting Coords of Chips to Valid Moves if There are Some
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
        --Check Next Grid in the Same Direction as Before
        CoordsX = CoordsX + dirrow
        CoordsY = CoordsY + dircol
    end
end


function moveSetup(row, col)
    
   --List of Directions
    local dirs = {{0, 1},
                 {1, 0},
                 {0, -1},
                 {-1, 0},
                 {1, 1},
                 {-1, 1},
                 {-1, -1},
                 {1, -1}}
-- Itterate Through Directions and Then Calls the Direction Searching Function for Valid Moves
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

    --Check Grid for Valid Moves and CHecks if Square was Already Checked
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

--Updating The Circle Grid whith Valid Moves and Changes a State Variable if There are None
function writeMoves()
    print("Writing moves")

    --No Valid Moves
    if #validMoves == 0 then
        print("Can't Play")
        canPlay = false
    end
    --Update Circle Grid With Valid Moves
    for i = 1, #validMoves do
        local rows = validMoves[i][1]
        local cols = validMoves[i][2]
        circleGrid[rows][cols] = 2
    end
end

end

function love.load()
-- Load assets and initialize variables here
    --Setting Filter for Perfect Pixels
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Game State Variables
    canPlay = true
    gameOver = false

    -- Load Images
    reversiBoard = love.graphics.newImage("reversi-board.png")

    blackChip = love.graphics.newImage("Images/black-chip.png")
    whiteChip = love.graphics.newImage("Images/white-chip.png")

    blackNoPlay = love.graphics.newImage("Images/black-can-not-play-message.png")
    whiteNoPlay = love.graphics.newImage("Images/white-can-not-play-message.png")

    blackWin = love.graphics.newImage("Images/black-won-message.png")
    whiteWin = love.graphics.newImage("Images/white-won-message.png")

    -- Chip Grid
    circleGrid = {
    {"","","","","","","",""},
    {"","","","","","","",""},
    {"","","","","","","",""},
    {"","","", 0, 1,"","",""},
    {"","","", 1, 0,"","",""},
    {"","","","","","","",""},
    {"","","","","","","",""},
    {"","","","","","","",""},
    }

    -- Resetting The Checked Grids Array
    visited = {}
    for row = 1, 8 do
        visited[row] = {}
        for col = 1, 8 do
            visited[row][col] = false
        end
    end

    -- FONT
    font = love.graphics.newFont("AmericanCaptain-MdEY.otf", 62)
    
    --Arrays to Store Circles That Need to be Flipped, Valid Moves and Checked Squares
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

    --Check for Valid Moves for Black at the Start of the Game
    checkMoves()
    writeMoves()
end

-- Every Time the Mouse is Clicked
function love.mousepressed()
    if mouseRow > 0 and mouseRow <= 8 and mouseCol > 0 and mouseCol <= 8 then
        --Checks if Mouse is on a Playable Square
        if canPlay == true and gameOver == false then
            if circleGrid[mouseRow][mouseCol] == 2 then
                --Update it to be the Player's Square
                circleGrid[mouseRow][mouseCol] = playerstate
                --Checks for Pieces to Flip and Flips Them
                dirSetup(mouseRow, mouseCol)
                flipPieces()
                --Update Player State
                playerstate = 1 - playerstate
                --Check for Valid Moves
                checkMoves()
                writeMoves()
            end
        elseif canPlay == false and gameOver == false then
            --Changes Player State and Checks Valid Moves for Them
            playerstate = 1 - playerstate
            checkMoves()
            writeMoves()
            --Reset Playability
            canPlay = true
        end 
    end
    --Check if Game is Over
    if blackCurrentScore + whiteCurrentScore ==  64 then
        gameOver = true
    end
end
--Repeat Every Screen Refresh
function love.update(dt)
    --Mouse Coordinate On Grid
    mouseRow = math.ceil(love.mouse.getY() / 125)
    mouseCol = math.ceil(love.mouse.getX() / 125)
end

-- Function to Draw the Current Scores (Pretty Self Explanatory)
function drawCurrentScore()
    love.graphics.setFont(font, 100)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("•"..blackCurrentScore, 125, 1148, nil, 2, 2)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("•"..whiteCurrentScore, 757.5, 1148, nil, 2, 2)
end

function love.draw()
    -- Render the game here

        -- Rendering Bottom Rectangle and Board
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

    --Draw the Chips and the Scores
    drawChips()
    drawCurrentScore()

    --Deal With Game Over State
    if gameOver == true then
        if playerstate == 0 then
            love.graphics.setColor(0, 0, 0, 0.5)
            love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(blackWin, screenWidth / 2 - blackWin:getWidth(), 350, 0, 2, 2)
        elseif playerstate == 1 then
            love.graphics.setColor(0, 0, 0, 0.5)
            love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(whiteWin, screenWidth / 2 - whiteWin:getWidth(), 350, 0, 2, 2)
        end
    end

    --Deal with Can't Play State
    if canPlay == false and gameOver == false then
        if playerstate == 0 then
            love.graphics.setColor(0, 0, 0, 0.5)
            love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(blackNoPlay, screenWidth / 2 - blackNoPlay:getWidth(), 350, 0, 2, 2)
        elseif playerstate == 1 then
            love.graphics.setColor(0, 0, 0, 0.5)
            love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(whiteNoPlay, screenWidth / 2 - whiteNoPlay:getWidth(), 350, 0, 2, 2)

            love.graphics.setColor(0, 0, 0, 0.7)
            love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
        end
    end
end