require_relative "./Board.rb"

class Tile
    attr_reader :value
    
    def initialize(value)
        @value = value
    end

    def bomb?
        self.value.include?("B") ? true : false
    end

    def flag?
        self.value.include?("F") ? true : false
    end




    
end