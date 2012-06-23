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

    RESERVED_WORDS = %w[return def]

    def initialize
    end

    def set_program(program)
      @program = program
      @token_list =[] # used to keep tokens in look_aheads
    end

    def look_ahead(number_of_tokens = 1)
      while @token_list.size < number_of_tokens
        token = consume_token
        @token_list << token
        throw :scanner_exception if token.symbol == :eof && @token_list.size < number_of_tokens
      end
      @token_list[number_of_tokens - 1]
    end

    def get_next_token
      if @token_list.empty?
        consume_token
      else
        @token_list.shift
      end
    end

    def consume_token
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
      ident = consume(IDENTIFIER)
      # Check if the token is part of the reserved words
      return Token.new(ident.to_sym, ident) if RESERVED_WORDS.include? ident
      return Token.new(:id,ident)
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
