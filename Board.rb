require_relative "./Tile.rb"

class Board

    def empty_grid
        @grid = Array.new(9) { Array.new(9) { Tile.new } }
    end

end
