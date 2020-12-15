RSpec.shared_examples 'Whole Value' do
  specify do
    expect(subject).to respond_to(:exceptional?)
    subject.exceptional?
  end

  specify do
    expect(subject).to respond_to(:exceptional_errors)
    active_record_errors = Hash.new { [] }
    subject.exceptional_errors(active_record_errors, :attribute_name, {})
  end

  specify do
    expect(subject).to respond_to(:as_json)
    subject.as_json({}) # can pass in options
    subject.as_json # options is optional
  end

  specify do
    expect(subject).to respond_to(:inspect)
    subject.inspect
  end
end
