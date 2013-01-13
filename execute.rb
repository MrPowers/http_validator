require_relative "validator.rb"

class Execute
  def main
    Dir.foreach('./requests') do |item|
      next if item == "." || item == ".."
      puts item
      Validator.new("./requests/" + item).main
      puts ""
    end
  end
end

Execute.new.main