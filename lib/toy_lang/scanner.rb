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

    private
    # These two utility functions help us
    # create the set of regulars expressions
    # that form the syntax of the language
    #
    # \A => begining of the string
    def self.reg_exp(reg_exp)
      /\A#{reg_exp}/
    end

    # For characters that have to be escaped
    # in the regular expression
    def self.escaped_reg_exp(reg_exp)
      regular_expression = "\\#{reg_exp}"
      /\A#{regular_expression}/
    end

    public
    IDENTIFIER = reg_exp('[a-z]+')
    WHITESPACE = reg_exp('[ \t\r\f]+') # Like \s without \n
    NUMBER = reg_exp('\d+')
    TOKEN_SEPARATOR = reg_exp('[\s\{\}\(\),]') # for the time being, whitespace, parentheses and comma

    CHECK_FOR_TOKEN_SEPARATOR = true

    LANGUAGE_TOKENS = {
      new_line: reg_exp('\n'),
      open_block: escaped_reg_exp('{'),
      close_block: escaped_reg_exp('}'),
      open_parentheses: escaped_reg_exp('('),
      close_parentheses: escaped_reg_exp(')'),
      comma: reg_exp(',')
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

    private

    def identifier
      ident = consume(IDENTIFIER, CHECK_FOR_TOKEN_SEPARATOR)
      # Check if the token is part of the reserved words
      return Token.new(ident.to_sym, ident) if RESERVED_WORDS.include? ident
      return Token.new(:id,ident)
    end

    def consume_token
      clear_whitespace
      if @program.size == 0
        return Token.new(:eof)
      elsif @program =~ IDENTIFIER
        return identifier
      elsif @program =~ NUMBER
        return Token.new(:number, consume(NUMBER, CHECK_FOR_TOKEN_SEPARATOR))
      end

      # Check for language symbols
      LANGUAGE_TOKENS.each do |symbol, reg_exp|
        if @program =~ reg_exp
          return Token.new(symbol, consume(reg_exp))
        end
      end

      throw :scanner_exception # Unrecognized token
    end

    def clear_whitespace
      consume(WHITESPACE)
    end

    def consume(regexp, check_for_separator = false)
      content = @program[regexp]
      @program.gsub!(regexp,"")
      check_for_token_separator if check_for_separator
      content
    end

    def check_for_token_separator
      if @program.size == 0
        return
      end

      throw :scanner_exception unless @program =~ TOKEN_SEPARATOR
    end

  end
end
