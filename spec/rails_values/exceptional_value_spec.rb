require 'rails_values/exceptional_value'

module RailsValues
  RSpec.describe ExceptionalValue do
    require 'rails_values/rspec/whole_value_role'
    it_behaves_like 'Whole Value' do
      subject { described_class.new(nil, 'is invalid') }
    end

    it 'can be created' do
      b = described_class.new(nil, "is invalid because it's nil")
      expect(b.to_s).to eq('')
      expect(b).to be_exceptional
    end

    it 'can add errors to active_record objects' do
      record = SimpleModel.new
      b = described_class.new('', 'is invalid')
      b.exceptional_errors(record.errors, :name, {})

      expect(record.errors.full_messages).to eq(['Name is invalid'])
    end
  end
end
