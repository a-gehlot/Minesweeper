require_relative "./Board.rb"
require "Remedy"
include Remedy

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
        self.render_game
        pos = get_position
        val = get_val
        determine_value(pos, val)
    end

    def determine_value(position, value)
        if @game[position].flag?
            if value == "u"
                @game[position].value.chomp("f")
                @game[position].reveal
            else
                puts "must first unflag position"
            end
        elsif @game[position].bomb?
            @game[position].reveal
            puts "That was a bomb"
            return
        else
            if value == "f"
                @game[position].value << "f" unless @game[position].revealed
            elsif value == "r"
                @game[position].reveal
                if @game[position].num_n_bombs == 0
                    reveal_zeroes(position)
                    reveal_fringe
                end
            else
                puts "can't unflag a non-flagged position"
                sleep(3)
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
        self.U_I
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

    def render_game
        puts "  #{(0..8).to_a.join(" ")}"
        @game.grid.each_with_index do |row, i|
            row_val = row.each_with_index.map do |tile, j|
                if [i,j] == @cursor
                    row_val = "\u25C9"
                elsif tile.flag?
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

    def U_I
        puts "welcome to minesweeper. Move with wasd. Use f to flag, u to unflag, r to reveal, and q to quit"
        input = Interaction.new
        @cursor = [0, 0]
        until self.game_over?
            self.render_game
            input.loop do |key|
                if key == "w"
                    up = @cursor[0]
                    @cursor[0] = up - 1 unless up - 1 < 0
                elsif key == "a"
                    left = @cursor[1]
                    @cursor[1] = left - 1 unless left - 1 < 0
                elsif key == "s"
                    down = @cursor[0]
                    unless down + 1 > 8
                        @cursor[0] = down + 1
                    end
                elsif key == "d"
                    right = @cursor[1]
                    unless right + 1 > 8
                        @cursor[1] = right + 1
                    end
                elsif key == "f" || key == "u" || key == "r"
                    determine_value(@cursor, key)
                elsif key == "q"
                    return
                else
                    puts "wrong key entered"
                end
                system "clear"
                self.render_game
            end
        end
    end

end

new_game = Game.new
new_game.run
