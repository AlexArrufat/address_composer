RSpec.describe AddressComposer do
  it "has a version number" do
    expect(AddressComposer::VERSION).not_to be nil
  end

  Dir["address-formatting/testcases/**/*.yaml"].each do |file|
    tests = Psych.load_stream(File.read(file))
    abbrev = file.include?("/abbreviations/")
    tests.each do |test|
      next if test.nil?

      description = test["description"]
      components = test["components"].merge("should_abbreviate" => abbrev)
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
