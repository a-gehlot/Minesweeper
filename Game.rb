require_relative "./Board.rb"

class Game
    attr_reader :game

    def get_position
        pos = nil
        until pos && pos_valid?(pos)
            puts "enter a coordinate separated by a comma such as 3,4"
            print "> "
            pos = parse_pos(gets.chomp)
        end
        pos
    end

    def get_val
        val = nil
        until val && val_valid?(val)
            puts "enter F for flag, R for reveal, or U for unflag"
            print "> "
            val = parse_val(gets.chomp)
        end
        val
    end

    def parse_val(string)
        string.upcase
    end

    def parse_pos(coordinates)
        coordinates.split(",").map { |char| Integer(char) }
    end

    def pos_valid?(position)
        position.is_a?(Array) &&
        position.length == 2 &&
        position.all? { |x| x.between?(0, 8) }
    end

    def val_valid?(val)
        parse_val(val) == "F" || parse_val(val) == "R" || parse_val(val) == "U"
    end

    def play_turn
        @game.render_game
        pos = get_position
        val = get_val
        determine_value(pos, val)
    end

    def determine_value(position, value)
        if @game[position].flag?
            if value == "U"
                @game[position].value.chomp("F")
                @game[position].reveal
            else
                puts "must first unflag position"
            end
        elsif @game[position].bomb?
            @game[position].reveal
            puts "That was a bomb"
            return
        else
            if value == "F"
                @game[position].value << "F" unless @game[position].revealed
            elsif value == "R"
                @game[position].reveal
                if @game[position].num_n_bombs == 0
                    reveal_zeroes(position)
                    reveal_fringe
                end
            else
                puts "can't unflag a non-flagged position"
            end
        end
    end

    def reveal_zeroes(position)
        neighbors = @game.neighbor_coords(position)
        adjacent_zeroes = neighbors.select { |coords| (@game[coords].num_n_bombs == 0) && (@game[coords].value != "B") && (!@game[coords].revealed) }
        return if adjacent_zeroes.empty?
        adjacent_zeroes.each do |coords|
            @game[coords].reveal
            reveal_zeroes(coords)
        end
    end

    def reveal_fringe
        (0..8).each do |row|
            (0..8).each do |col|
                if @game[[row, col]].num_n_bombs == 0 && @game[[row, col]].revealed
                    @game.neighbor_coords([row,col]). each do |coords|
                        @game[coords].reveal
                    end
                end
            end
        end
    end

    def start_game
        @game = Board.new
        @game.empty_grid
        @game.populate_board
        @game.populate_numbers
    end

    def run 
        self.start_game
        until game_over?
            self.play_turn
        end
    end

    def lose?
        @game.grid.flatten.any? { |tile| tile.bomb? && tile.revealed }
    end

    def win?
        num_revealed = @game.grid.flatten.count { |tile| tile.revealed }
        if num_revealed == 71
            true
            puts "you won!"
        else
            false
        end
    end

    def game_over?
        self.lose? 
    end


end

new_game = Game.new
new_game.run
