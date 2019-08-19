# require_relative "./Board.rb"

class Tile
    attr_reader :value
    attr_accessor :num_n_bombs

    def initialize(value)
        @value = value
        @num_n_bombs = 0
    end

    def bomb?
        self.value.include?("B") ? true : false
    end

    def flag?
        self.value.include?("F") ? true : false
    end


    
end
