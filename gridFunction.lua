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
        if 
        Grid[Row][Col] == 0 then
          love.graphics.setColor (0, 1, 0, 0.5)
        elseif Grid[Row][Col] == 1 then
          love.graphics.setColor(0, 1, 0)
        end
        love.graphics.rectangle("fill", Col * tileSize, Row * tileSize, tileSize, tileSize)
      end
    end
  end

  function love.graphics.draw() 
    drawBoard()
  end