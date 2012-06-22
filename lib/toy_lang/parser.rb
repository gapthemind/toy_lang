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
  #     expression
  #   function_definition =>
  #     function_header OPEN_BLOCK expression* CLOSE_BLOCK
  #   function_header =>
  #     DEF IDENTIFIER OPEN_PARENTHESES argument_list CLOSE_PARENTHESES
  #   argument_list =>
  #     (IDENTIFIER ( COMMA IDENTIFIER)*)
  #   expression =>
  #     function_call |
  #     additive_expression |
  #     NUMBER
  #   additive_expression =>
  #     substraction_expression PLUS substraction_expression
  #   substraction_expression =>
  #     expression MINUS expression
  #   function_call =>
  #     IDENTIFIER OPEN_PARENTHESES parameter_list CLOSE_PARENTHESES
  #   parameter_list =>
  #     (expression ( COMMA expression)*)
  #
  # An example program would be
  # def fibbo(number) {
  #   if number == 0 return 0
  #   if number == 1 return 1
  #   return fibbo(number-1) + fibbo(number-2)
  # }
  # fibbo(5)
  #
  # This program should output 8
  class Parser

  end
end
