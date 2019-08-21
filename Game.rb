require_relative "./Board.rb"

class Game
    def get_position
        pos = nil
        until pos && pos_valid?(pos)
            puts "enter a coordinate separated by a comma such as 3,4"
            print "> "
            pos = parse_pos(gets.chomp)
        end
        pos
    end

    def parse_pos(coordinates)
        coordinates.split(",").map { |char| Integer(char) }
    end

    def pos_valid?(position)
        position.is_a?(Array) &&
        position.length == 2 &&
        position.all? { |x| x.between?(0, 8) }
    end



end
