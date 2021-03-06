# index.rss.builder
xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title @full_feed.feed.title
    xml.link @full_feed.feed.url
    xml.updated @full_feed.feed.last_modified
    
    @full_feed.feed.entries.each do |entry|
      xml.item do
        xml.title entry.title
        xml.description entry.summary
        xml.pubDate entry.published.to_s(:rfc822)
        xml.link entry.url
        xml.guid entry.url
      end
    end
  end
end