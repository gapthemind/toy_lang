require 'spec_helper'

describe ToyLang::Parser do

  before(:each) do
    @parser = ToyLang::Parser.new
  end

  describe "expression" do
    it "parses numbers" do
      @parser.program = "2"
      @parser.expression.should == { number: "2" }
    end
  end

  describe "return expression" do
    it "parses" do
      @parser.program = "return 2"
      @parser.return_expression.should == {return: { number: "2" }}
    end
  end
end
