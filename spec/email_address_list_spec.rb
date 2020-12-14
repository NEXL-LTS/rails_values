RSpec.describe EmailAddressList do
  def cast(content)
    EmailAddressList.cast(content)
  end

  require_relative './whole_value_role'
  it_behaves_like 'Whole Value' do
    subject { cast(['email@test.com']) }
  end

  describe 'valid values' do
    subject { cast(%w[a@u.ba z@a.ac]) }

    it { expect(subject.to_s).to eq('a@u.ba z@a.ac') }
    it { expect(subject.map(&:to_s)).to contain_exactly('a@u.ba', 'z@a.ac') }
    it { is_expected.to be_present }
    it { is_expected.not_to be_exceptional }
  end

  describe 'invalid values' do
    subject { cast(%w[xx yy]) }

    it { expect(subject.to_s).to eq('xx yy') }
    it { is_expected.to be_present }
    it { is_expected.to be_exceptional }
  end

  describe 'ignore blank values' do
    subject { cast(['', nil]) }

    it { expect(subject.to_s).to eq('') }
    it { is_expected.to be_blank }
    it { is_expected.not_to be_exceptional }
  end

  describe 'valid, invalid and blank values together' do
    subject { cast(['@cc', 'b@f.de', 'a@b.ci', nil, 'a.a']) }

    it { expect(subject.to_s).to eq('@cc a.a a@b.ci b@f.de') }
    it { expect(subject.only_regular.to_s).to eq('a@b.ci b@f.de') }
    it { is_expected.not_to be_blank }
    it { is_expected.to be_exceptional }
  end
end
