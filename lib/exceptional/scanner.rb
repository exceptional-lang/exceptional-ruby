#--
# DO NOT MODIFY!!!!
# This file is automatically generated by rex 1.0.5
# from lexical definition file "lib/exceptional/exceptional.rex".
#++

require 'racc/parser'
class Exceptional::Scanner < Racc::Parser
  require 'strscan'

  class ScanError < StandardError ; end

  attr_reader   :lineno
  attr_reader   :filename
  attr_accessor :state

  def scan_setup(str)
    @ss = StringScanner.new(str)
    @lineno =  1
    @state  = nil
  end

  def action
    yield
  end

  def scan_str(str)
    scan_setup(str)
    do_parse
  end
  alias :scan :scan_str

  def load_file( filename )
    @filename = filename
    open(filename, "r") do |f|
      scan_setup(f.read)
    end
  end

  def scan_file( filename )
    load_file(filename)
    do_parse
  end


  def next_token
    return if @ss.eos?
    
    # skips empty actions
    until token = _next_token or @ss.eos?; end
    token
  end

  def _next_token
    text = @ss.peek(1)
    @lineno  +=  1  if text == "\n"
    token = case @state
    when nil
      case
      when (text = @ss.scan(/"[^"]*"/))
         action { [:STRING, text[1..-2]] }

      when (text = @ss.scan(/\#.*/))
         action { [:COMMENT, text[1..-1]] }

      when (text = @ss.scan(/,/))
         action { [:COMMA, text] }

      when (text = @ss.scan(/\./))
         action { [:PERIOD, text] }

      when (text = @ss.scan(/=>/))
         action { [:HASHROCKET, text] }

      when (text = @ss.scan(/==/))
         action { [:COMPARATOR, text.to_sym] }

      when (text = @ss.scan(/!=/))
         action { [:COMPARATOR, text.to_sym] }

      when (text = @ss.scan(/>=/))
         action { [:COMPARATOR, text.to_sym] }

      when (text = @ss.scan(/>/))
         action { [:COMPARATOR, text.to_sym] }

      when (text = @ss.scan(/<=/))
         action { [:COMPARATOR, text.to_sym] }

      when (text = @ss.scan(/</))
         action { [:COMPARATOR, text.to_sym] }

      when (text = @ss.scan(/=/))
         action { [:EQ, text] }

      when (text = @ss.scan(/\+/))
         action { [:PLUS, text.to_sym] }

      when (text = @ss.scan(/\-/))
         action { [:MINUS, text.to_sym] }

      when (text = @ss.scan(/\*/))
         action { [:TIMES, text.to_sym] }

      when (text = @ss.scan(/\//))
         action { [:DIV, text.to_sym] }

      when (text = @ss.scan(/\(/))
         action { [:LPAREN, text] }

      when (text = @ss.scan(/\)/))
         action { [:RPAREN, text] }

      when (text = @ss.scan(/\{/))
         action { [:LBRACE, text] }

      when (text = @ss.scan(/\}/))
         action { [:RBRACE, text] }

      when (text = @ss.scan(/\[/))
         action { [:LBRACKET, text] }

      when (text = @ss.scan(/\]/))
         action { [:RBRACKET, text] }

      when (text = @ss.scan(/let/))
         action { [:LET, text] }

      when (text = @ss.scan(/def/))
         action { [:DEF, text] }

      when (text = @ss.scan(/do/))
         action { [:DO, text] }

      when (text = @ss.scan(/end/))
         action { [:END, text] }

      when (text = @ss.scan(/raise/))
         action { [:RAISE, text] }

      when (text = @ss.scan(/[[:alpha:]_][\w]*/))
         action { [:IDENTIFIER, text] }

      when (text = @ss.scan(/\d+/))
         action { [:NUMBER, text.to_i] }

      when (text = @ss.scan(/[ \t\n]+/))
        ;

      else
        text = @ss.string[@ss.pos .. -1]
        raise  ScanError, "can not match: '" + text + "'"
      end  # if

    else
      raise  ScanError, "undefined state: '" + state.to_s + "'"
    end  # case state
    token
  end  # def _next_token

  def tokenize(code)
    scan_setup(code)
    tokens = []
    while token = next_token
      tokens << token
    end
    tokens
  end
end # class
