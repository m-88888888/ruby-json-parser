class JsonLexer
  attr_reader :tokens

  def initialize(input)
    @input = input
    @tokens = []

    tokenize
  end

  private

  def tokenize
    i = 0
    while i < @input.length
      case @input[i]
      when '{', '}', '[', ']', ',', ':'
        @tokens << { type: @input[i], value: @input[i] }
        i += 1
      when '"'
        start = i
        i += 1
        i += 1 while @input[i] != '"'
        @tokens << { type: 'STRING', value: @input[start + 1...i] }
        i += 1
      when '0'..'9'
        start = i
        i += 1 while @input[i] =~ /[0-9]/
        @tokens << { type: 'NUMBER', value: @input[start...i].to_i }
      when /\s/
        i += 1
      else
        if @input[i..i + 3] == 'true'
          @tokens << { type: 'TRUE', value: 'true' }
          i += 4
        elsif @input[i..i + 4] == 'false'
          @tokens << { type: 'FALSE', value: 'false' }
          i += 5
        elsif @input[i..i + 3] == 'null'
          @tokens << { type: 'NULL', value: 'null' }
          i += 4
        else
          raise "Unknown token: #{@input[i]}"
        end
      end
    end
  end
end
