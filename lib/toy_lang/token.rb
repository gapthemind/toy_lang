module ToyLang
  class Token
    attr_reader :symbol, :content

    def initialize(symbol, content = nil)
      @symbol = symbol
      @content = content
    end

    def is?(symbol)
      @symbol == symbol
    end

    def is_not?(symbol)
      not is? symbol
    end
  end
end
