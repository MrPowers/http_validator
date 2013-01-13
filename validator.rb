require "uri"

class Validator
  attr_reader :contents, :file_path, :headers, :blank_line, :errors
  def initialize(file_path)
    @contents = File.open(file_path).readlines
    @contents.push("\n") # allows for no body
    @errors = []
    @file_path = file_path
    set_variables
  end

  def set_variables
    @request_line = @contents[0]
    @headers = []
    @contents[1..-1].each_with_index do |content, index|
      if content.chomp.empty?
        @blank_line = @contents[index + 1]
        break
      else 
        @headers.push(content)
      end
    end
  end

  def formatted_errors
    @errors.each_with_index do |error, index|
      puts "#{index + 1}. #{error}"
    end
  end

  def add_error(error)
    @errors.push(error)
  end

  def main
    p contents
    p "Headers: #{headers}"
    p "Blank Line: #{blank_line}"
    @contents ? check_request_line : add_error("The contents line is blank")
    @headers.empty? ? add_error("The headers line is blank") : check_headers
    @blank_line ? check_blank_line : add_error("The blank line is nil")
    if @errors.empty?
      puts "#{file_path.sub("./requests/", "")} is valid"
    else
      formatted_errors
    end
  end

  def check_request_line
    method, path, version = @request_line.chomp.split
    check_method(method)
    check_path(path)
    check_version(version)
  end

  def check_method(method)
    unless ["GET", "POST"].include?(method)
      add_error("Not a GET or POST request")
    end
  end

  def check_path(path)
    unless path.match(/\/.+/)
      add_error("Not a valid path")
    end
  end

  def check_version(version)
    if version != "HTTP/1.1"
      add_error("Wrong HTTP version")
    end
  end

  def check_headers
    @headers.each do |header|
      check_header(header)
    end
  end

  def check_header(header)
    name, url = header.split
    puts "NAME: #{name}"
    check_name(name)
    if ["Host:", "Referer:"].include?(name)
      check_url(url)
    end
  end

  def check_name(name)
    unless ["Accept:", "Host:", "Referer:"].include?(name)
      add_error("Invalid name - name must be Accept, Host, or Referer")
    end
  end

  def check_url(url)
    uri = URI.parse(url)
    add_error("URL is invalid") unless uri.kind_of?(URI::HTTP)
  end

  def check_blank_line
    unless @blank_line.chomp.empty?
      add_error("The blank line is not blank")
    end
  end
end

v = Validator.new("./requests/bad2.txt")
p v.contents
p v.main