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

    it 'tokenizes a number include float ' do
      lexer = JsonLexer.new('{ "discount": 0.12 }')
      expect(lexer.tokenize).to include({type: 'NUMBER', value: 0.12})
    end

    it 'tokenizes boolean values' do
      lexer = JsonLexer.new('[true, false]')
      expect(lexer.tokenize).to include({type: 'BOOL', value: 'true'}, {type: 'BOOL', value: 'false'})
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

  context 'JsonParser' do
    context '#parse_object' do
      let(:tokens) do
        [{:type=>"{", :value=>"{"},
         {:type=>"STRING", :value=>"person"},
         {:type=>":", :value=>":"},
         {:type=>"{", :value=>"{"},
         {:type=>"STRING", :value=>"name"},
         {:type=>":", :value=>":"},
         {:type=>"STRING", :value=>"John"},
         {:type=>",", :value=>","},
         {:type=>"STRING", :value=>"age"},
         {:type=>":", :value=>":"},
         {:type=>"NUMBER", :value=>30},
         {:type=>",", :value=>","},
         {:type=>"STRING", :value=>"car"},
         {:type=>":", :value=>":"},
         {:type=>"NULL", :value=>"null"},
         {:type=>"}", :value=>"}"},
         {:type=>",", :value=>","},
         {:type=>"STRING", :value=>"address"},
         {:type=>":", :value=>":"},
         {:type=>"STRING", :value=>"tokyo"},
         {:type=>"}", :value=>"}"}]
      end

      it 'parse an object' do
        parser = JsonParser.new(tokens)
        expect(parser.send(:parse_object)).to eq({ person: { name: 'John', age: 30, car: nil }, address: 'tokyo' })
      end
    end

    context '#parse_array' do
      let(:tokens) do
        [{:type=>"[", :value=>"["},
        {:type=>"STRING", :value=>"hoge"},
        {:type=>",", :value=>","},
        {:type=>"STRING", :value=>"fuga"},
        {:type=>"]", :value=>"]"}]
      end

      it 'parse an array' do
        parser = JsonParser.new(tokens)
        expect(parser.send(:parse_array)).to eq(['hoge', 'fuga'])
      end
    end
  end
end
