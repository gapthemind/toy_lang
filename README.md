# ToyLang

Parser for a simple languange. An example program would be:

  def fibbo(number) {
    if number == 0 { return 0 }
    if number == 1 { return 1 }
    return fibbo(number-1) + fibbo(number-2)
  }

  fibbo(5)

This program should output 8

## Installation

Add this line to your application's Gemfile:

    gem 'toy_lang'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install toy_lang

## Usage
  
  # Create a parser
  @parser = ToyLang::Parser.new
  # Set the program
  @parser.program = "methodname(1,3)"
  # Generate the AST
  puts @parser.program

TODO: Find better names to avoid collision between 'program =' and
program

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
