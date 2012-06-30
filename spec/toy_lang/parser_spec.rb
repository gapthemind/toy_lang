require 'spec_helper'

describe ToyLang::Parser do

  before(:each) do
    @parser = ToyLang::Parser.new
  end

  describe "program" do
    it "consumes statements" do
      @parser.program = "func_call(1)\nfn_call(2)\n"
      @parser.program.size.should == 2
    end
  end

  describe "conditional expression" do
    it "passes for well formed expressions" do
      @parser.program = " 2 == 3 "
      expected = { equals: {first_operand: { number: "2" }, second_operand: { number: "3" } } }
      @parser.conditional_expression.should == expected
    end

    it "fails if no conditional expression" do
      @parser.program= " 2 == if "
      expect { @parser.conditional_expression }.to throw_symbol :parser_exception
    end
  end

  describe "return statement" do
    it "parses" do
      @parser.program = "return 2\n"
      @parser.statement.should == {return: { number: "2" }}
    end
  end

  describe "function call" do
    it "parses function" do
      @parser.program = "methodname(1,3)\n"
      @parser.statement.should == { function_call: 'methodname',
                                    params: [ {number: "1"}, {number: "3"} ]}
    end

    it "throws parser_exception when no closing parentheses" do
      @parser.program = "methodname(1,3"
      expect { @parser.statement }.to throw_symbol :parser_exception
    end

    it "throws parser_exception when no further expression after comma" do
      @parser.program = "methodname(1,"
      expect { @parser.statement }.to throw_symbol :parser_exception
    end

    it "throws parser_exception when first expression empty" do
      @parser.program = "methodname(,3)"
      expect { @parser.statement }.to throw_symbol :parser_exception
    end

    it "throws parser_exception when middle expression empty" do
      @parser.program = "methodname(1,,3)"
      expect { @parser.statement }.to throw_symbol :parser_exception
    end
  end
end
