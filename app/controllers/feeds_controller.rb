require 'open-uri'
require 'feedzirra'
class FeedsController < ApplicationController
  before_filter :load_feed, :only => [:preview, :load]
  
  def index
    respond_to do |wants|
      wants.html {}
    end
  end
  
  def load
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
    respond_to do |format|
      if @full_feed.valid?
        @entries = @full_feed.process(2).entries
        format.html { }
      else
        format.html { render :action => :index}
      end
    end
  end
  
  private
  
  def load_feed
    @full_feed = FullFeed.new(params[:full_feed])
  end
end
