require 'rspec'
require_relative '../main'

RSpec.describe do
  context 'JsonLexer' do
    it 'tokenizes an empty object' do
      lexer = JsonLexer.new('{}')
      expect(lexer.tokenize).to eq([{type: '{', value: '{'}, {type: '}', value: '}'}])
    end

    it 'tokenizes an empty array' do
      lexer = JsonLexer.new('[]')
      expect(lexer.tokenize).to eq([{type: '[', value: '['}, {type: ']', value: ']'}])
    end

    it 'tokenizes a simple object' do
      lexer = JsonLexer.new('{"key": "value"}')
      expect(lexer.tokenize).to include({type: 'STRING', value: 'key'}, {type: ':', value: ':'}, {type: 'STRING', value: 'value'})
    end

    it 'tokenizes a simple array' do
      lexer = JsonLexer.new('[1, 2, 3]')
      expect(lexer.tokenize).to include({type: 'NUMBER', value: 1}, {type: ',', value: ','}, {type: 'NUMBER', value: 2})
    end

    it 'tokenizes boolean values' do
      lexer = JsonLexer.new('[true, false]')
      expect(lexer.tokenize).to include({type: 'TRUE', value: 'true'}, {type: 'FALSE', value: 'false'})
    end

    it 'tokenizes null value' do
      lexer = JsonLexer.new('[null]')
      expect(lexer.tokenize).to include({type: 'NULL', value: 'null'})
    end

    it 'ignores whitespace' do
      lexer = JsonLexer.new("{ \n\t\"key\" \t: \n \"value\" \n}")
      expect(lexer.tokenize).to include({type: 'STRING', value: 'key'}, {type: ':', value: ':'}, {type: 'STRING', value: 'value'})
    end
  end
end
