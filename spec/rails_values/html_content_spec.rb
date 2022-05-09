require 'rails_values/html_content'

module RailsValues
  RSpec.describe HTMLContent do
    require 'rails_values/rspec/whole_value_role'
    it_behaves_like 'Whole Value' do
      subject { described_class.new('<p>HTML</p>') }
    end

    describe 'can be created' do
      let(:content) { described_class.cast('<p><a href="javascript:alert(\'XSS\')">My text</a></p>') }

      it { expect(content.to_s).to eq('<p><a>My text</a></p>') }
      it { expect(content).to be_present }
      it { expect(content).not_to be_exceptional }
    end

    describe 'can handle blank' do
      let(:content) { described_class.cast('') }

      it { expect(content.to_s).to eq('') }
      it { expect(content).not_to be_present }
      it { expect(content).not_to be_exceptional }
    end

    describe 'can handle empty tags and &nbsp; as blank' do
      let(:content) { described_class.cast('<p>&nbsp;</p>') }

      it { expect(content.to_s).to eq('<p> </p>') }
      it { expect(content).not_to be_present }
      it { expect(content).not_to be_exceptional }
    end
  end
end
