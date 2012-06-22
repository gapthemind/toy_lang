class Scanner

  # Tokens the scanner generates
  # :class => for 'class' tokens
  # :def => for 'def' tokens
  # :number => for regexp '\d+'
  # :id => for '[a-z]+'
  # :open_block => for '{'
  # :close_block => for '}'
  # :eof => for end of file

  IDENTIFIER = /\A[a-z]+/
  WHITESPACE = /\A\s+/
  DIGITS = /\A\d+/
  OPEN_BLOCK = /\A\{/
  CLOSE_BLOCK = /\A\}/

  def initialize(text)
    @text = text
  end

  def get_next_token
    clear_whitespace
    if @text.size == 0
      return Token.new(:eof)
    elsif @text =~ IDENTIFIER
      return identifier
    elsif @text =~ DIGITS
      return digit
    elsif @text =~ OPEN_BLOCK
      return open_block
    elsif @text =~ CLOSE_BLOCK
      return close_block
    end
  end

  def identifier
    text = consume(IDENTIFIER)
    return Token.new(:class) if text == "class"
    return Token.new(:def) if text == "def"
    return Token.new(:id,text)
  end

  def digit
    Token.new(:number, consume(DIGITS))
  end

  def open_block
    consume(OPEN_BLOCK)
    Token.new(:open_block)
  end

  def close_block
    consume(CLOSE_BLOCK)
    Token.new(:close_block)
  end

  def clear_whitespace
    consume(WHITESPACE)
  end

  def consume(regexp)
    content = @text[regexp]
    @text.gsub!(regexp,"")
    content
  end

end

