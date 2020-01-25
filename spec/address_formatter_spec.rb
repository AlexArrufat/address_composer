RSpec.describe AddressFormatter do
  it "has a version number" do
    expect(Address::Formatter::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end

  Dir["address-formatting/testcases/**/*.yaml"].each do |file|
    test = YAML.load_file(File.join(file))
    description = test["description"]
    components = test["components"]
    expected_formatted_address = test["expected"]

    describe "#{File.basename(file)} - #{description}" do
      subject(:formatted_address) { described_class.format(components) }

      it "formats the address correctly" do
        expect(formatted_address).to eq expected_formatted_address
      end
    end
  end
end
