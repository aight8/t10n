require 'faraday'

class HackerNewsApiError < StandardError
  attr_reader :response
  def initialize(message, response = nil)
    super(message)
    @response = response
  end
end

# Some endpoints of the HackerNews API with concurrency load support
class HackerNewsApi
  # The base API URL to HackerNews API (with trailing slash)
  @@api_base_url = 'https://hacker-news.firebaseio.com/v0/'

  def initialize
    @conn = Faraday.new(:url => @@api_base_url) do |faraday|
      ##faraday.adapter :em_http
      faraday.adapter :em_synchrony
      faraday.request :json
      faraday.response :json, :content_type => /\bjson$/
    end
  end

  # Fetch one item
  def fetch_item(id)
    response = @conn.get "item/#{id}.json"
    item = response.body

    raise HackerNewsApiError.new "Response must be an item object.", response unless item.kind_of?(Hash) && item.has_key?('id')

    Rails.logger.info "Fetch item succeed (id: #{item.id})"
    item
  end

  # Fetch multiple items and return all items as array
  def fetch_multiple_items(ids)
    responses = []

    @conn.in_parallel do
      ids.each do |id|
        # responses.push @conn.get "item/#{id}.json"
        (@conn.get "item/#{id}.json").on_complete { |res| responses << res }
      end
    end

    items = responses.each do |response|
      item = response.body
      raise HackerNewsApiError.new "Response must be an item object.", response unless item.kind_of?(Hash) && item.has_key?('id')
      item
    end

    Rails.logger.info "Fetch multiple items succeed (count: #{responses.length})"
    items
  end

  # Fetches the last 500 story ids
  def fetch_new_story_ids
    response = @conn.get 'newstories.json'
    ids = response.body

    raise HackerNewsApiError.new "Response must be an array.", response unless ids.kind_of?(Array)

    Rails.logger.info "Fetch new story ids succeed (count: #{ids.length})"
    ids
  end
end
