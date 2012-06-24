require 'spec_helper'

describe ToyLang::Parser do

  before(:each) do
    @parser = ToyLang::Parser.new
  end

  describe "return statement" do
    it "parses" do
      @parser.program = "return 2"
      @parser.statement.should == {return: { number: "2" }}
    end
  end

  describe "function call" do
    it "parses function" do
      @parser.program = "methodname(1,3)"
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
