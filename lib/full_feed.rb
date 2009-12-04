require 'open-uri'
require 'feedzirra'
require 'nokogiri'

class FullFeed
  attr_accessor :full_feed
  
  
  def initialize(url, options = {})
    @options = options
    @feed = Feedzirra::Feed.fetch_and_parse(url)
  end
  
  def process(limit = nil)    
    @feed.entries = @feed.entries.slice(0,limit) if limit
    
    @feed.entries.each do |entry|
      entry.summary = distill_content(full_content(entry.url))
    end
    
    return @feed
  end
  
  def distill_content(content)
    selectors = @options[:selectors]
    
    unless selectors.empty?
      doc = Nokogiri::HTML.parse(content)
      
      distilled = doc.search(selectors).collect { |selection| selection.to_s }
      
      distilled.join("")
    else
      content
    end    
  end
  
  def full_content(url)
    content = open(url).read
  end
end