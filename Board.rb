require_relative "./Tile.rb"

class Board

    DELTAS = [[1, 0], [0, 1], [-1, 0], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]


    attr_reader :grid

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

    def populate_numbers
        (0...9).each do |row|
            (0...9).each do |cell|
                if @grid[row][cell].value == "E"
                    @grid[row][cell].value == self.bomb_count([row, cell])
                end
            end
        end
    end


    def num_mines
        @grid.flatten.count { |tile| tile.bomb? }
    end

    def [](arr)
        i, j = arr
        @grid[i][j]
    end
    
    def []=(position, value)
        i, j = position
        @grid[i][j] = value
    end

    def render_cheat
        puts "  #{(0..8).to_a.join(" ")}"
        @grid.each_with_index do |row, i|
            row_val = row.map do |tile| 
                tile.bomb? ? row_val = tile.value : row_val = tile.num_n_bombs
            end
            puts "#{i} #{row_val.join(" ")}"
        end
    end

    def render_game
        puts "  #{(0..8).to_a.join(" ")}"
        @grid.each_with_index do |row, i|
            row_val = row.map do |tile|
                if tile.flag?
                    row_val = "F"
                elsif tile.revealed
                    if tile.bomb?
                        row_val == "B"
                    else
                        row_val = tile.num_n_bombs
                    end
                else
                    row_val = "*"
                end
            end
            puts "#{i} #{row_val.join(" ")}"
        end
    end


    def neighbor_coords(point)
        p_i, p_j = point
        neighbors = []
        DELTAS.each do |d_i, d_j|
            neighbor = [(p_i + d_i), (p_j + d_j)]
            neighbors << neighbor if self.in_bounds?(neighbor)
        end
        neighbors
    end

    def in_bounds?(coords)
        i, j = coords
        0 <= i && i <= 8 && 0 <= j && j <= 8
    end
    
    def bomb_count(point)
        neighbor_coords(point).each do |neighbor|
            self[point].num_n_bombs += 1 if self[neighbor].bomb?
        end
        self[point].num_n_bombs
    end

end