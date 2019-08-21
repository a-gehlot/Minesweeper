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
            puts "enter F for flag or R for reveal"
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
        parse_val(val) == "F" || parse_val(val) == "B"
    end

    def play_turn
        @game.render_game
        pos = get_position
        val = get_val
        determine_value(pos, val)
    end

    def determine_value(position, value)

    end


    def start_game
        @game = Board.new
        @game.empty_grid
        @game.populate_board
        @game.populate_numbers
    end

end
