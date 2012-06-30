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
      CHECK_FOR_TOKEN_SEPARATOR[token_symbol] = token_description[:check_for_token_separator]
    end

    public
    WHITESPACE = reg_exp('\A[ \t\r\f]+') # Like \s without \n
    WHITE_LINE = reg_exp('\A\s*(#.*)?$') # empty line or line with comments
    # for the time being, token separators are:
    #   whitespace,
    #   parentheses both the ( and the { pair
    #   comma
    #   plus
    #   minus
    #   equals
    TOKEN_SEPARATOR = reg_exp('[\s\{\}\(\),\+\-=]') 

    LANGUAGE_TOKENS = {}
    TOKEN_METHODS = {}
    CHECK_FOR_TOKEN_SEPARATOR = {}

    token :eof, reg_exp('\A\z'), scan_method: :basic_token
    token :id, reg_exp('[a-z][a-z_]*'), scan_method: :identifier, check_for_token_separator: true
    token :number, reg_exp('\d+'), scan_method: :basic_token, check_for_token_separator: true
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

    attr_reader :program
    attr_reader :token_list

    def set_program(program)
      @program = "#{program}\n"
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

    def consume_token
      # Double newlines should only report one 
      # :new_line token
      was_new_line = @new_line

      if @new_line
        clear_white_line
        @new_line = false
        new_identation_level = identation_level
        if new_identation_level != @identation_level
          return open_or_close_block(new_identation_level)
        end
      end

      new_token = identify_token
      @new_line = new_token.is? :new_line
      new_token
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

    def identifier(symbol,content)
      # Check if the token is part of the reserved words
      return Token.new(content.to_sym, content) if RESERVED_WORDS.include? content
      return Token.new(:id,content)
    end

    def basic_token(symbol, content)
      return Token.new(symbol, content)
    end

    def identify_token
      clear_whitespace

      LANGUAGE_TOKENS.each do |symbol, reg_exp|
        if @program =~ reg_exp
          scan_method = TOKEN_METHODS[symbol]
          needs_token_separator = CHECK_FOR_TOKEN_SEPARATOR[symbol]
          return send(scan_method, symbol, consume(reg_exp, needs_token_separator))
        end
      end

      throw :scanner_exception # Unrecognized token
    end

    def clear_white_line
      while (@program =~ WHITE_LINE && @program.size > 0)
        consume(WHITE_LINE)
        consume(Scanner::reg_exp('\n'))
      end
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
