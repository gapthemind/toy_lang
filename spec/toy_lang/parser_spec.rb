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
      #TODO: expand when parameter_list gets implemented
      @parser.program = "methodname()"
      @parser.statement.should == { function_call: 'methodname', :params => [ {number: "1"}]}
    end
  end
end
