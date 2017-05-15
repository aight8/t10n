#require 'singleton'
# include Singleton

require 'faraday'

# Some endpoints of the HackerNews API with concurrency load support
class HackerNewsApi
  # The base API URL to HackerNews API (with trailing slash)
  @@api_base_url = 'https://hacker-news.firebaseio.com/v0/'

  def initialize
    @conn = Faraday.new(:url => @@api_base_url) do |faraday|
      faraday.adapter :em_http
      faraday.request :json
      faraday.response :json, :content_type => /\bjson$/
    end
  end

  # Fetch one item
  def fetch_item(id)
    response = @conn.get "item/#{id}.json"
    response.body
  end

  # Fetch multiple items and return all items as array
  def fetch_multiple_items(ids)
    responses = []
    @conn.in_parallel do
      ids.each do |id|
        responses.push @conn.get "item/#{id}.json"
      end
    end
    responses.each do |response|
      response.body
    end
  end

  # Fetches the last 500 story ids
  def fetch_new_story_ids
    response = @conn.get 'newstories.json'
    response.body
  end
end
