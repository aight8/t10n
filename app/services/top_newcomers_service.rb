class TopNewcomersService
  private def get_current_record_holder
    NewcomerRecord.order('growth_rate').last
  end

  private def save_record_holder(story)
    unless story.kind_of?(Story)
      raise 'TopNewcomersService::save_record_holder: requires a Story object.'
    end

    newcomer_record = NewcomerRecord.order('created_at').last

    if newcomer_record.nil? || newcomer_record.item_id != story.id
      newcomer_record = NewcomerRecord.new
      newcomer_record.item_id = story.id
      newcomer_record.save
    end

    newcomer_record.update_attributes(
      title: story.title,
      points: story.points,
      author: story.author,
      total_comments: story.total_comments,
      growth_rate: story.growth_rate,
      item_created_at: story.created_at,
    )
  end

  # Returns the current record holder Story object
  def record_holder_story
    item = get_current_record_holder
    Story.create_by_record_holder_model(item)
  end

  # Returns the top 10 growing stories and update the record holder
  def top_growth_rate_stories
    story_collection = StoryCollection.new
    story_collection.load_newest
    sorted_story_collection = story_collection.stories_sorted_by_growth_rate.take(10)

    if sorted_story_collection.size > 0
      save_record_holder(sorted_story_collection.first)
    end

    sorted_story_collection.map { |story| story.serialize }
  end
end
