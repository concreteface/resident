class Album < ActiveRecord::Base
  BASE_URL = "https://www.residentadvisor.net"
  SEARCH_URL = "https://www.residentadvisor.net/reviews.aspx?format=album&yr=2016&mn=9"

  def parse_page(year, month)
    page = HTTParty.get("https://www.residentadvisor.net/reviews.aspx?format=album&yr=#{year}&mn=#{month}")
    parsed_page = Nokogiri::HTML(page)
    parsed_page
  end

  def link_array
    parsed_page.xpath("//li//a/@href")
  end

  def info_array
    parsed_page.xpath("//li//h1/text()")
  end

  def cover_array
    parsed_page.xpath("//li//img/@src")
  end

  def get_rating(url)
    rating_page = HTTParty.get("#{BASE_URL}#{url}")
    rating_parsed_page = Nokogiri::HTML(rating_page)
    Float(rating_parsed_page.xpath("//span[contains(@class, 'rating')]/text()").to_s)
  end

  def get_links(year, month)
    @reviews = []
    parse_page(year, month)
    link_array.each do |link|
      if (link.to_s =~ /\/reviews\/\d+/ && !link.to_s.include?('comments'))
        reviews << {link: link.to_s, rating: get_rating(link.to_s)}
      end
    end
  end

  def get_info
    info_array.each_with_index do |listing, i|
      if listing.to_s.include?(' - ')
        split = listing.to_s.split(' - ')
        reviews[i][:artist] = split[0]
        reviews[i][:album] = split[1]
      else
        reviews[i - 1][:label] = listing.to_s
      end
    end
    reviews.delete_if {|x| x[:artist] == nil}
  end

  def get_cover
    cover_array.each_with_index do |url, i|
      reviews[i][:cover] = url.to_s
    end
  end

  def to_db(reviews)
  end


end
