require 'httparty'
require 'nokogiri'
class AlbumsController < ApplicationController

  def index

  end

  def parse_page(year, month)
    page = HTTParty.get("https://www.residentadvisor.net/reviews.aspx?format=album&yr=#{year}&mn=#{month}")
    parsed_page = Nokogiri::HTML(page)
    parsed_page
  end

  def link_array
  end

  def info_array
  end

  def cover_array
  end

  def get_rating(url)
    rating_page = HTTParty.get("#{BASE_URL}#{url}")
    rating_parsed_page = Nokogiri::HTML(rating_page)
    Float(rating_parsed_page.xpath("//span[contains(@class, 'rating')]/text()").to_s)
  end

  def get_links
    output2.each do |link|
      if (link.to_s =~ /\/reviews\/\d+/ && !link.to_s.include?('comments'))
        reviews << {link: link.to_s, rating: get_rating(link.to_s)}
      end
    end
  end

  def get_info
  end

  def get_cover
  end

end
