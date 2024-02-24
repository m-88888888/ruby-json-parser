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
      when '0'..'9', '.'
        start = i
        i += 1 while @input[i] =~ /[0-9]/ || @input[i] == '.'
        tokens << { type: 'NUMBER', value: @input[start...i].to_f }
      when /\s/
        i += 1
      else
        if @input[i..i + 3] == 'true'
          tokens << { type: 'BOOL', value: 'true' }
          i += 4
        elsif @input[i..i + 4] == 'false'
          tokens << { type: 'BOOL', value: 'false' }
          i += 5
        elsif @input[i..i + 3] == 'null'
          tokens << { type: 'NULL', value: 'null' }
          i += 4
        else
          raise "Unknown token: #{@input[i]}"
        end
      end
    end

    tokens
  end

end

class JsonParser
  def initialize(tokens)
    @tokens = tokens
    @index = 0
  end

  def parse
    token = peek

    case token[:type]
    when '{'
      parse_object
    when '['
      parse_array
    when 'STRING'
      self.next[:value]
    when 'NUMBER'
      self.next[:value]
    when 'NULL'
      self.next[:value]
      nil
    when 'BOOL'
      self.next[:value] == 'true'
    else
      raise "Unknown token: #{token[:type]}"
    end
  end

  private

  # return the head of the token stream
  def peek
    @tokens[@index]
  end

  # move the head of the token stream to the next token
  def next
    @index += 1
    @tokens[@index - 1]
  end

  def parse_object
    token = peek
    object = {}

    self.next if token[:type] == '{'

    while token[:type] != '}'
      key_token = self.next
      colon_token = self.next

      unless key_token[:type] == 'STRING' || colon_token[:type] == ':'
        raise 'Error: a pair (key(string) and : token) token is expected'
      end

      object[key_token[:value].to_sym] = parse

      token = self.next
    end

    object
  end

  def parse_array
    token = peek
    array = []

    self.next if token[:type] == '['

    while token[:type] != ']'
      array << parse

      token = self.next
    end

    array
  end
end

json = File.read('./json/nest.json')
tokens = JsonLexer.new(json).tokenize
pp tokens
parsed_json = JsonParser.new(tokens).parse
puts parsed_json
