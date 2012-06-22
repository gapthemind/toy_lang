module ToyLang
  class Scanner

    # Tokens the scanner generates
    # :return => for 'return' tokens
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

    def initialize
    end

    def set_program(program)
      @program = program
    end

    def get_next_token
      clear_whitespace
      if @program.size == 0
        return Token.new(:eof)
      elsif @program =~ IDENTIFIER
        return identifier
      elsif @program =~ DIGITS
        return digit
      elsif @program =~ OPEN_BLOCK
        return open_block
      elsif @program =~ CLOSE_BLOCK
        return close_block
      end
    end

    def identifier
      program = consume(IDENTIFIER)
      return Token.new(:return) if program == "return"
      return Token.new(:def) if program == "def"
      return Token.new(:id,program)
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
      content = @program[regexp]
      @program.gsub!(regexp,"")
      content
    end

  end
end
