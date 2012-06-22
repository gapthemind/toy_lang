class Token
  attr_reader :symbol, :content

  def initialize(symbol, content = nil)
    @symbol = symbol
    @content = content
  end
end
