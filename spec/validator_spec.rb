require_relative "../validator.rb"

describe Validator do
  let(:bad1) { Validator.new("./requests/bad1.txt") }
  let(:bad2) { Validator.new("./requests/bad2.txt") }
  let(:bad3) { Validator.new("./requests/bad3.txt") }
  let(:good3) { Validator.new("./requests/good3.txt") }

  context "#check_request_line" do
    it "adds an error for PUT requests" do
      bad1.check_request_line
      bad1.errors.should include("Not a GET or POST request")
    end

    it "adds an error for invalid paths" do
      bad2.check_request_line
      bad2.errors.should include("Not a valid path")
    end

    it "adds an error for any HTTP version other than 1.1" do
      bad2.check_request_line
      bad2.errors.should include("Wrong HTTP version")
    end
  end
  
  context "#check_header" do
    it "adds an error for invalid URLs" do
      bad1.check_headers
      bad1.errors.should include("URL is invalid")
    end

    it "adds an error for invalid names" do
      bad3.check_headers
      bad3.errors.should include('Invalid name - name must be Accept, Host, or Referer')    
    end
  end

  context "#check_blank_lines" do
    it "adds an error if the header line is blank" do
      bad2.check_blank_lines
      bad2.errors.should include("The headers line is blank")
    end
  end

  context "#main" do
    it "does not have errors for valid HTTP formats" do
      good3.main
      good3.errors.should be_empty
    end
  end
end