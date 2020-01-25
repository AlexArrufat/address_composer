RSpec.describe AddressComposer do
  it "has a version number" do
    expect(AddressComposer::VERSION).not_to be nil
  end

  Dir["address-formatting/testcases/**/*.yaml"].each do |file|
    tests = Psych.load_stream(File.read(file))
    tests.each do |test|
      description = test["description"]
      components = test["components"]
      expected_formatted_address = test["expected"]

      describe "#{File.basename(file)} - #{description}" do
        subject(:formatted_address) { described_class.compose(components) }

        it "formats the address correctly" do
          expect(formatted_address).to eq expected_formatted_address
        end
      end
    end
  end
end
