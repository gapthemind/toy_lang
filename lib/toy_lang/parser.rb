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
  #     conditional_expression |
  #     function_call |
  #     return_statement
  #   function_definition =>
  #     function_header OPEN_BLOCK expression* CLOSE_BLOCK
  #   function_header =>
  #     DEF IDENTIFIER OPEN_PARENTHESES argument_list CLOSE_PARENTHESES
  #   argument_list =>
  #     (IDENTIFIER ( COMMA IDENTIFIER)*)
  #   conditional_expression =>
  #     IF condition OPEN_BLOCK expression* CLOSE_BLOCK
  #   expression =>
  #     additive_expression
  #   additive_expression =>
  #     substraction_expression PLUS substraction_expression
  #   substraction_expression =>
  #     primary_expresion MINUS primary_expresion
  #   primary_expresion =>
  #     NUMBER
  #   function_call =>
  #     IDENTIFIER OPEN_PARENTHESES parameter_list CLOSE_PARENTHESES
  #   parameter_list =>
  #     (expression ( COMMA expression)*)
  #   return_statement =>
  #     RETURN expression
  #
  # An example program would be
  # def fibbo(number) {
  #   if number == 0 { return 0 }
  #   if number == 1 { return 1 }
  #   return fibbo(number-1) + fibbo(number-2)
  # }
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
      elsif ((ast = conditional_expression) != nil)
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

    # conditional_expression =>
    #   IF condition OPEN_BLOCK expression* CLOSE_BLOCK
    def conditional_expression
      return nil
    end

    # function_call =>
    #   IDENTIFIER OPEN_PARENTHESES parameter_list CLOSE_PARENTHESES
    def function_call
      unless @scanner.look_ahead.symbol == :id &&
             @scanner.look_ahead(2).symbol == :open_parentheses
        return nil
      end

      method_name = @scanner.get_next_token.content
      @scanner.get_next_token # open parentheses
      params = parameter_list()

      # Verify close parentheses
      if @scanner.get_next_token.symbol != :close_parentheses
        throw :parser_exception
      end

      return { function_call: method_name, params: params }
    end

    # parameter_list =>
    #   (expression ( COMMA expression)*)
    def parameter_list
      # TODO: create proper implementation
      [ { number: "1" } ]
    end

    # return_statement =>
    #   RETURN expression
    def return_statement
      unless @scanner.look_ahead.symbol == :return
        return nil
      end

      @scanner.get_next_token
      return {return: expression()}
    end

    # expression =>
    #   ....
    # !!! INCOMPLETE IMPLEMENTATION !!!
    # To get going, expression can only be a number
    def expression
      token = @scanner.get_next_token
      if token.symbol == :number
        return { number: token.content }
      end
      throw Exception.new("Could not evaluate expression")
    end

  end
end
