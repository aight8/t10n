# A story item object which could merged with a story object at another time and preserve the points value
class Story
  attr_accessor :id
  attr_accessor :title
  attr_accessor :points
  attr_accessor :author
  attr_accessor :total_comments
  attr_accessor :created_at
  attr_reader :points_at_times

  class << self
    def create_by_api_item(item)
      fields = {
        id: item['id'],
        title: item['title'],
        points: item['score'],
        author: item['by'],
        total_comments: item['descendants'],
        created_at: item['time'],
      }
      Story.new(fields)
    end
    def create_by_record_holder_model(model)
      fields = {
        id: model.item_id,
        title: model.title,
        points: model.points,
        author: model.author,
        total_comments: model.total_comments,
        created_at: model.item_created_at,
      }
      Story.new(fields)
    end
    def serialize(story)
      {
        id: story.id,
        title: story.title,
        points: story.points,
        author: story.author,
        total_comments: story.total_comments,
        growth_rate: story.growth_rate,
        created_at: story.created_at,
      }
    end
  end

  def initialize(fields)
    set_fields fields
    @points_at_times = []

    append_points_at_time @points
  end

  def set_fields(fields)
    @id = fields[:id]
    @title = fields[:title]
    @points = fields[:points]
    @author = fields[:author]
    @total_comments = fields[:total_comments]
    @created_at = fields[:created_at]
  end

  def merge(story)
    raise "It's only possible to merge stories with the same ID." unless story.id == @id
    set_fields story
    append_points_at_time @points
  end

  # Append the "points at time" list which contains point amounts at a specific time of this story
  def append_points_at_time(points, time = nil)
    @points_at_times.push PointsAtTime.new(points, time)
  end

  # Returns the growth rate (unit: points/s)
  def growth_rate
    last = @points_at_times.last
    last.points.to_f / lifetime.to_f
  end

  # Returns the lifetime (in seconds) relative to the last update of the fields
  def lifetime
    last = @points_at_times.last
    @created_at - last.time / 1000
  end

  def serialize
    Story.serialize(self)
  end
end
