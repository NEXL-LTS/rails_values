require 'rails_values/email_address_list'

module RailsValues
  RSpec.describe EmailAddressList do
    def cast(content)
      EmailAddressList.cast(content)
    end

    require 'rails_values/rspec/whole_value_role'
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

    describe '#include?' do
      it do
        list = cast(['@cc', 'b@f.de', 'a@b.ci', 'a.a', 'broken', nil])
        expect(list).to include('b@f.de')
        expect(list).to include('a@b.ci')
        expect(list).to include('broken')
        expect(list).to include('@cc')
        expect(list).to include('a.a')
        expect(list).not_to include(nil) # blank values are dropped
      end
    end
  end
end
