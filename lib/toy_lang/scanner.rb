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

    LANGUAGE_SYMBOLS = {
      open_block: /\A\{/,
      close_block: /\A\}/,
      open_parentheses: /\A\(/,
      close_parentheses: /\A\)/,
      comma: /\A,/
    }

    RESERVED_WORDS = %w[return def]

    def set_program(program)
      @program = program
      @token_list =[] # used to keep tokens in look_aheads
    end

    def get_next_token
      if @token_list.empty?
        consume_token
      else
        @token_list.shift
      end
    end

    def look_ahead(number_of_tokens = 1)
      end_of_file_met = false
      while @token_list.size < number_of_tokens
        throw :scanner_exception if end_of_file_met
        token = consume_token
        @token_list << token
        end_of_file_met = token.is? :eof
      end
      @token_list[number_of_tokens - 1]
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

    private

    def consume_token
      clear_whitespace
      if @program.size == 0
        return Token.new(:eof)
      elsif @program =~ IDENTIFIER
        return identifier
      elsif @program =~ DIGITS
        return digit
      end

      # Check for language symbols
      LANGUAGE_SYMBOLS.each do |symbol, reg_exp|
        if @program =~ reg_exp
          consume(reg_exp)
          return Token.new(symbol)
        end
      end

      throw :scanner_exception # Unrecognized token
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
