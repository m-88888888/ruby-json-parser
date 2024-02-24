class JsonLexer
  attr_reader :tokens

  def initialize(input)
    @input = input
  end

  def tokenize
    i = 0
    tokens = []

    while i < @input.length
      case @input[i]
      when '{', '}', '[', ']', ',', ':'
        tokens << { type: @input[i], value: @input[i] }
        i += 1
      when '"'
        start = i
        i += 1
        i += 1 while @input[i] != '"'
        tokens << { type: 'STRING', value: @input[start + 1...i] }
        i += 1
      when '0'..'9'
        start = i
        i += 1 while @input[i] =~ /[0-9]/
        tokens << { type: 'NUMBER', value: @input[start...i].to_i }
      when /\s/
        i += 1
      else
        if @input[i..i + 3] == 'true'
          tokens << { type: 'TRUE', value: 'true' }
          i += 4
        elsif @input[i..i + 4] == 'false'
          tokens << { type: 'FALSE', value: 'false' }
          i += 5
        elsif @input[i..i + 3] == 'null'
          tokens << { type: 'NULL', value: 'null' }
          i += 4
        else
          raise "Unknown token: #{@input[i]}"
        end
      end

      tokens
    end
  end
end

json = File.read('./json/nest.json')
tokens = JsonLexer.new(json).tokenize
pp tokens

class JsonParser
  def initialize(tokens)
    @tokens = tokens
    @index = 0
    @result = {}
  end

  def parse
    raise 'todo: implement parse'
    # tokens.each do |token|
    #   case token[:type]
    #   when '{'
    #     parse_object
    #   when '['
    #     parse_array
    #   end
    # end
  end

  private

  # return the head of the token stream
  def peek; end

  # move the head of the token stream to the next token
  def next; end

  def parse_object; end

  def parse_array; end
end
