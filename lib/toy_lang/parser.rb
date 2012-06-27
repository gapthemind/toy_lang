module ToyLang

  # This it the class that parses the toy language
  # grammatical rules are lower cased (e.g. statement)
  # tokens are upper case (e.g. COMMA)
  # optional rules are surrounded by parentheses
  #
  # The toy language grammar is as follows
  #
  #   program =>
  #     statement*
  #   statement =>
  #     function_definition |
  #     conditional_statement |
  #     function_call |
  #     return_statement
  #   function_definition =>
  #     function_header OPEN_BLOCK expression* CLOSE_BLOCK
  #   function_header =>
  #     DEF IDENTIFIER OPEN_PARENTHESES argument_list CLOSE_PARENTHESES
  #   argument_list =>
  #     (IDENTIFIER ( COMMA IDENTIFIER)*)
  #   * conditional_statement =>
  #     IF conditional_expression OPEN_BLOCK expression* CLOSE_BLOCK
  #   conditional_expression =>
  #     expression EQUALS expression
  #   * expression =>
  #     additive_expression
  #   * additive_expression =>
  #     substraction_expression (PLUS substraction_expression)+
  #   * substraction_expression =>
  #     primary_expresion (MINUS primary_expresion)+
  #   * primary_expresion =>
  #     NUMBER
  #   * function_call =>
  #     IDENTIFIER OPEN_PARENTHESES parameter_list CLOSE_PARENTHESES
  #   * parameter_list =>
  #     (expression ( COMMA expression)*)
  #   * return_statement =>
  #     RETURN expression
  #
  # An example program would be
  # def fibbo(number)
  #   if number == 0
  #     return 0
  #   if number == 1
  #     return 1
  #   return fibbo(number-1) + fibbo(number-2)
  #
  # fibbo(5)
  #
  # This program should output 8
  class Parser

    def program=(program)
      @scanner = Scanner.new
      @scanner.set_program(program)
    end

    # statement =>
    #   function_definition |
    #   conditional_expression |
    #   function_call |
    #   return_statement
    def statement
      # ast => Abstract Syntax Tree
      if ((ast = function_definition) != nil)
        return ast
      elsif ((ast = conditional_statement) != nil)
        return ast
      elsif ((ast = function_call) != nil)
        return ast
      elsif ((ast = return_statement) != nil)
        return ast
      end
      throw :parser_exception
    end

    # function_definition =>
    #   function_header OPEN_BLOCK expression* CLOSE_BLOCK
    def function_definition
      return nil
    end

    # conditional_statement =>
    #   IF conditional_expression OPEN_BLOCK expression* CLOSE_BLOCK
    def conditional_statement
      unless token_is? :if
        return nil
      end

      @scanner.get_next_token # The 'if'
      condition = conditional_expression
      require :new_line
      require :open_block

      expression_list = []
      while ((new_expression = expression()) != nil)
        expression_list << new_expression
      end

      require :close_block
      return { if: { condition: condition, expressions: expression_list }}
    end

    # conditional_expression =>
    #   expression EQUALS expression
    def conditional_expression
      first_operand = expression
      puts "first_operand #{first_operand}"
      if first_operand == nil
        return nil
      end
      require :equals
      second_operand = expression
      puts "second_operand #{second_operand}"
      if second_operand == nil
        throw :parser_exception
      end

      return {equals: { first_operand: first_operand, second_operand: second_operand } }
    end

    # function_call =>
    #   IDENTIFIER OPEN_PARENTHESES parameter_list CLOSE_PARENTHESES
    def function_call
      unless tokens_are?(:id, :open_parentheses)
        return nil
      end

      method_name = @scanner.get_next_token.content
      @scanner.get_next_token # open parentheses
      params = parameter_list()

      require :close_parentheses

      return { function_call: method_name, params: params }
    end

    # parameter_list =>
    #   (expression ( COMMA expression)*)
    def parameter_list
      expression_list = []
      expr = expression()
      return [] if expr == nil

      expression_list << expr

      while (token_is? :comma)
        @scanner.get_next_token # the comma
        expr = expression()
        expression_list << expr if expr != nil
      end

      expression_list
    end

    # return_statement =>
    #   RETURN expression
    def return_statement
      unless token_is? :return
        return nil
      end

      @scanner.get_next_token
      return {return: expression()}
    end

    # expression =>
    #   ....
    # !!! INCOMPLETE IMPLEMENTATION !!!
    # To get going, expression can only be a number
    # TODO: Do it for real
    def expression
      return additive_expression
    end

    # additive_expression =>
    #   substraction_expression (PLUS substraction_expression)+
    def additive_expression
      recursive_expression(:substraction_expression, :plus)
    end

    # substraction_expression =>
    #   primary_expresion (MINUS primary_expresion)+
    def substraction_expression
      recursive_expression(:primary_expresion, :minus)
    end

    def recursive_expression(operand_method, separator)
      first_operand = send(operand_method)
      if first_operand == nil
        return
      end

      operand_list = [first_operand]
      while (token_is? separator)
        @scanner.get_next_token
        operand = send(operand_method)
        throw scanner_exception if operand == nil
        operand_list << operand
      end

      if operand_list.size == 1
        return first_operand
      else
        return {separator => operand_list}
      end
    end

    def primary_expresion
      puts "left #{@scanner.program}"
      if token_is_not? :number
        nil
      end

      token = @scanner.get_next_token
      return { number: token.content }
    end

    private

    def token_is?(token)
      tokens_are?(token)
    end

    def token_is_not?(token)
      not token_is? token
    end

    def tokens_are?(*tokens)
      look_ahead_index = 1
      tokens.each do |token|
        return false if @scanner.look_ahead(look_ahead_index).is_not? token
        look_ahead_index += 1
      end
      return true
    end

    def require(token)
      throw :parser_exception if token_is_not? token
      @scanner.get_next_token
    end

  end
end
