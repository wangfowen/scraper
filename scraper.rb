require 'open-uri'
require 'open_uri_redirections'
require 'csv'
require 'nokogiri'

input = CSV.read(ARGV[0])
output = []
output << ["Price", "Product Name", "Category", "Subcategory", "ASIN", "URL"]

input.each_with_index do |x, i|
  url = x[0]

  if !url.nil? && url.include?("amazon")
    puts "processing row ##{i + 1}..."

    begin
      docs = Nokogiri::HTML(open(url,
        :allow_redirections => :safe,
        "User-Agent" => "Ruby/#{RUBY_VERSION}",
        "Referer" => "http://www.ruby-lang.org/"
      ))

      price = nil
      begin
        price = docs.css("#priceblock_ourprice").children.first.text.strip
      rescue Exception => e
      end
      if price.nil?
        puts "price wasn't found for url #{url}"
      end

      name = nil
      begin
        name = docs.css("#productTitle").children.first.text.strip
      rescue Exception => e
      end
      if name.nil?
        puts "name wasn't found for url #{url}"
      end

      category = nil
      begin
        category =  docs.xpath("//a[@class='a-link-normal a-color-tertiary']").children.first.text.strip
      rescue Exception => e
      end
      if category.nil?
        puts "category wasn't found for url #{url}"
      end

      subcategory = nil
      begin
        subcategory = docs.xpath("//a[@class='a-link-normal a-color-tertiary']").children.last.text.strip
      rescue Exception => e
      end
      if subcategory.nil?
        puts "subcategory wasn't found for url #{url}"
      end

      asin_regex = "(?:[/dp/]|$)([A-Z0-9]{10})"
      asin = url.match(asin_regex)[1]
      if asin.nil?
        puts "asin wasn't found in url #{url}"
      end

      output << [price, name, category, subcategory, asin, url]

      sleep 1
    rescue Exception => e
      puts "couldn't process url #{url}: #{e}"
      output << []

      sleep 1
    end
  end
end

File.write("output.csv", output.map(&:to_csv).join)
puts "complete!"
