RSpec.describe Industry do
  require_relative 'whole_value_role'
  it_behaves_like 'Whole Value' do
    subject { described_class.new(202_010) }
  end

  def cast(*args)
    described_class.cast(*args)
  end

  it 'can be created by string code' do
    value = cast('101010')
    expect(value.to_s).to eq('Energy Equipment & Services')
    expect(value.code).to eq('101010')
    expect(value.name).to eq('Energy Equipment & Services')
    expect(value).to be_present
    expect(value).not_to be_exceptional
  end

  it 'can be created by integer code' do
    value = cast(101_010)
    expect(value.to_s).to eq('Energy Equipment & Services')
    expect(value.code).to eq('101010')
    expect(value.name).to eq('Energy Equipment & Services')
    expect(value).to be_present
    expect(value).not_to be_exceptional
  end

  it 'can be created by name' do
    value = cast('Gas Utilities')
    expect(value.to_s).to eq('Gas Utilities')
    expect(value.code).to eq('551020')
    expect(value.name).to eq('Gas Utilities')
    expect(value).to be_present
    expect(value).not_to be_exceptional
  end

  it 'can be created by name ignoring case' do
    value = cast('MEDIA')
    expect(value.to_s).to eq('Media')
    expect(value.code).to eq('502010')
    expect(value.name).to eq('Media')
    expect(value).to be_present
    expect(value).not_to be_exceptional
  end

  it 'can handle industry object' do
    value = cast(cast('MEDIA'))
    expect(value.to_s).to eq('Media')
    expect(value.code).to eq('502010')
    expect(value.name).to eq('Media')
    expect(value).to be_present
    expect(value).not_to be_exceptional
  end

  it 'returns exceptional no valid' do
    value = cast('ASFGTGEE')
    expect(value.to_s).to eq('ASFGTGEE')
    expect(value).not_to be_blank
    expect(value).to be_exceptional
  end

  it 'can handle blank' do
    value = cast('')
    expect(value.to_s).to eq('')
    expect(value).to be_blank
    expect(value).not_to be_exceptional
  end

  it 'can handle nil' do
    value = cast(nil)
    expect(value.to_s).to eq('')
    expect(value).to be_blank
    expect(value).not_to be_exceptional
  end
end
