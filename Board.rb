require_relative "./Tile.rb"

class Board

    def empty_grid
        @grid = Array.new(9) { Array.new(9) }
    end

    def populate_board
        (0...9).each do |row|
            (0...9).each do |cell|
                @grid[row][cell] = Tile.new("E")
            end
        end

        while num_mines < 10
            @grid[rand(0...9)][rand(0...9)] = Tile.new("B")
        end

    end

    def num_mines
        @grid.flatten.count { |tile| tile.bomb? }
    end

    def [](arr)
        @grid[arr[0]][arr[1]]
    end
    
    def []=(position, value)
        @grid[position[0]][position[1]] = value
    end



end
