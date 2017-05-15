# Represents a collection of stories as a mutable state
class StoryCollection
  def initialize
    @stories = Hash.new
    @api = HackerNewsApi.new
  end

  def create_by_api_items(items)
    items.each do |res|
      story = Story.create_by_api_item(res.body)
      @stories[story.id] = story
    end
  end

  # Load the items with the given ids into the collection state
  def load_by_ids ids
    items = @api.fetch_multiple_items ids
    create_by_api_items(items)
  end

  # Load the newest 500 stories into the collection state
  def load_newest
    ids = @api.fetch_new_story_ids
    ids = ids.take(220)
    # ids = ids.take(10)
    load_by_ids ids
  end

  def serialize
    @stories.values.map { |story| story.serialize }
  end

  # Returns the internal stories as array
  def stories_list
    @stories.values
  end

  # Returns the sorted list of stories ordered by their growth rate
  def stories_sorted_by_growth_rate
    stories = @stories.values.sort_by do |story|
      story.growth_rate
    end
    stories.reverse
  end
end
