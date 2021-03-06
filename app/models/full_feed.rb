require 'open-uri'
require 'feedzirra'
require 'nokogiri'

class FullFeed < ActiveRecord::Base
  def self.columns() @columns ||= []; end
  def self.column(name, sql_type = nil, default = nil, null = true)
  columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end
  
  column :url, :string
  column :selectors, :string

  validates_presence_of :url
  validates_each :url do |model, att, value|
    begin # check header response
      response = Net::HTTP.get_response(URI.parse(value))
      while response.is_a?(Net::HTTPRedirection)
        # handle redirects
        response = Net::HTTP.get_response(URI.parse(response['location']))
      end
      
      case response
        when Net::HTTPOK
          case response.content_type
            when "text/xml", "application/rss+xml", "application/xml" then true
            else model.errors.add(att, "is not a valid rss feed")
          end
        else model.errors.add(att, "is not valid or is not responding") and false
      end
    rescue # Recover on DNS failures..
      model.errors.add(att, "is not valid or is not responding") and false
    end
  end

  attr_accessor :feed
  
  def initialize(options = {})
    options[:url] = clean_url(options[:url])
    super(options)
  end
  
  def process(limit = nil)    
    @feed = Feedzirra::Feed.fetch_and_parse(self.url)
    @feed.entries = @feed.entries.slice(0,limit) if limit
    
    @feed.entries.each do |entry|
      entry.summary = content(entry.url, self.selectors)
    end
    
    return @feed
  end
  
  private
  
  def content(url, selectors)
    unless (selectors.blank?)
      distilled_content(url, selectors)
    else
      full_content(url)
    end
  end
  
  def distilled_content(url, selectors = nil)
    Rails.cache.fetch({:url => url, :selectors => selectors}.to_param, :expires_in => 30.minutes) do
      content =full_content(url)
      doc = Nokogiri::HTML.parse(content)

      distilled = doc.search(selectors).collect { |selection| selection.to_s }
      distilled.join("")
    end
  end
  
  def full_content(url)
    # cache the scraped content
    Rails.cache.fetch(url, :expires_in => 30.minutes) do
      open(url).read
    end
  end
  
  def clean_url(url)
    url = url.gsub(/^\w+:\/\//, "") # no funny stuff, ok?
    url = "http://#{url}"
  end
end
