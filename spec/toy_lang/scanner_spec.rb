require 'spec_helper'

describe ToyLang::Scanner do

  before(:each) do
    @scanner = ToyLang::Scanner.new
  end

  it "returns :eof when no tokens left" do
    @scanner.set_program("")
    assert_token_is :eof
  end

  it "clears white spaces" do
    @scanner.set_program("  \n\t")
    assert_token_is :eof
  end

  it "returns :class when token is 'class'" do
    @scanner.set_program("class")
    assert_token_is :class
  end

  it "returns :def when token is 'def'" do
    @scanner.set_program("class")
    assert_token_is :class
  end

  it "returns :id when token is not a reserved word" do
    @scanner.set_program("classic")
    assert_token_is :id
  end

  it "returns token content when token is not a reserved word" do
    @scanner.set_program("classic")
    assert_token_content_is "classic"
  end

  it "returns :number when token is digits" do
    @scanner.set_program("9823")
    assert_token_is :number
  end

  it "returns content when token is digits" do
    @scanner.set_program("9823")
    assert_token_content_is "9823"
  end

  it "returns :open_block when token is '{'" do
    @scanner.set_program("{")
    assert_token_is :open_block
  end

  it "returns :close_block when token is '}'" do
    @scanner.set_program("}")
    assert_token_is :close_block
  end

  it "scans small program" do
    @scanner.set_program """
      class test {
        def method {
          9
        }
      }
      """
    assert_token_is :class
    assert_token_and_content_is :id, "test"
    assert_token_is :open_block
    assert_token_is :def
    assert_token_and_content_is :id, "method"
    assert_token_is :open_block
    assert_token_and_content_is :number, "9"
    assert_token_is :close_block
    assert_token_is :close_block
    assert_token_is :eof
  end

  def assert_token_content_is(content)
    @scanner.get_next_token.content.should == content
  end

  def assert_token_is(symbol)
    @scanner.get_next_token.symbol.should be symbol
  end

  def assert_token_and_content_is(symbol, content)
    token = @scanner.get_next_token
    token.symbol.should be symbol
    token.content.should == content
  end

end