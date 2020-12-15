require 'rails_values/blank'

module RailsValues
  RSpec.describe Blank do
    require_relative 'whole_value_role'
    it_behaves_like 'Whole Value' do
      subject { described_class.new }
    end

    it 'can be created' do
      b = described_class.new
      expect(b.to_s).to eq('')
    end

    it 'equals other blank' do
      expect(subject).to eq(described_class.new)
    end

    it 'can be humanized' do
      expect(subject.humanize).to eq('')
    end

    it 'is blank when content is blank' do
      expect(described_class.new).to be_blank
    end

    it 'is not exceptional' do
      expect(described_class.new).not_to be_exceptional
    end
  end
end
