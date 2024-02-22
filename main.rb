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
        @tokens << {type: @input[i], value: @input[i]}
        i += 1
      when '"'
        start = i
        i += 1
        i += 1 while @input[i] != '"'
        @tokens << {type: 'STRING', value: @input[start+1...i]}
        i += 1
      when '0'..'9'
        start = i
        i += 1 while @input[i] =~ /[0-9]/
        @tokens << {type: 'NUMBER', value: @input[start...i].to_i}
      when /\s/
        i += 1
      else
        word = @input[i..i+3]
        if ['true', 'false', 'null'].include?(word.strip)
          @tokens << {type: word.strip.upcase, value: word.strip}
          i += word.length
        else
          raise "Unknown token: #{@input[i]}"
        end
      end
    end
  end
end

require 'json'
json = File.read('./json/minimum.json')
pp json
pp JsonLexer.new(json).tokens
