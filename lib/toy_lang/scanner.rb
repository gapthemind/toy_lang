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
    # that form the lexemes of the language
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

    def self.token(token_symbol, regular_expression, token_description = {})
      LANGUAGE_TOKENS[token_symbol] = regular_expression
      TOKEN_METHODS[token_symbol] = token_description[:scan_method]
    end

    public
    IDENTIFIER = reg_exp('[a-z]+')
    WHITESPACE = reg_exp('[ \t\r\f]+') # Like \s without \n
    NUMBER = reg_exp('\d+')
    # for the time being, token separators are:
    #   whitespace,
    #   parentheses both the ( and the { pair
    #   comma
    #   plus
    #   minus
    #   equals
    TOKEN_SEPARATOR = reg_exp('[\s\{\}\(\),\+\-=]') 

    CHECK_FOR_TOKEN_SEPARATOR = true

    LANGUAGE_TOKENS = {}
    TOKEN_METHODS = {}

    token :new_line, reg_exp('\n'), scan_method: :basic_token
    token :open_block, escaped_reg_exp('{'), scan_method: :basic_token
    token :close_block, escaped_reg_exp('}'), scan_method: :basic_token
    token :open_parentheses, escaped_reg_exp('('), scan_method: :basic_token
    token :close_parentheses, escaped_reg_exp(')'), scan_method: :basic_token
    token :equals, reg_exp('=='), scan_method: :basic_token
    token :plus, escaped_reg_exp('+'), scan_method: :basic_token
    token :minus, escaped_reg_exp('-'), scan_method: :basic_token
    token :comma, reg_exp(','), scan_method: :basic_token

    RESERVED_WORDS = %w[return def if]

    def set_program(program)
      @program = program
      @token_list =[] # used to keep tokens in look_aheads
      @new_line=true
      @identation_level=0
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
      if @new_line
        @new_line = false
        new_identation_level = identation_level
        if new_identation_level != @identation_level
          return open_or_close_block(new_identation_level)
        end
      end
      token = identify_token
      @new_line = token.is? :new_line
      token
    end

    def open_or_close_block(new_identation_level)
      if @identation_level == new_identation_level + 1
        @identation_level = new_identation_level
        return Token.new(:close_block)
      elsif @identation_level == new_identation_level - 1
        @identation_level = new_identation_level
        return Token.new(:open_block)
      end
      throw :scanner_exception
    end

    def identation_level
      if @program[/\A +/]
        @program[/\A +/].length / 2
      else
        0
      end
    end

    def basic_token(symbol, content)
      return Token.new(symbol, content)
    end

    def identify_token
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
          return send(TOKEN_METHODS[symbol], symbol, consume(reg_exp))
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
