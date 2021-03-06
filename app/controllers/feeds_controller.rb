require 'open-uri'
require 'feedzirra'
class FeedsController < ApplicationController
  caches_page :index
  def index
    expires_in 2.months
    respond_to do |wants|
      wants.html {}
    end
  end
  
  def load
    @full_feed = FullFeed.new({:url => params[:url], :selectors => params[:selectors]})
    respond_to do |format|
      if @full_feed.valid?
        @full_feed.process
        format.html
        format.rss # Add this line so we can respond in RSS format.
      else
        format.html { redirect_to(feeds_path) }
        format.rss { render :text => "that's not going to work", :status => :unprocessable_entity }
      end
    end
  end 

  def preview
    @full_feed = FullFeed.new(params[:full_feed])
    
    respond_to do |format|
      if @full_feed.valid?
        @feed_path = load_feeds_url(:format => :rss, :selectors => @full_feed.selectors, :url => @full_feed.url)
        @entries = @full_feed.process(10).entries
        format.html { }
      else
        format.html { render :action => :index}
      end
    end
  end
end
