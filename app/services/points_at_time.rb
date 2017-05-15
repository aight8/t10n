# A snapshot which contains the amount of points at the given time
class PointsAtTime
  attr_accessor :points
  attr_accessor :time

  def initialize(points, time = nil)
    if time.nil?
      @time = Time.now.to_i
    else
      raise "Expecting \"time\" to be a number: #{time.inspect}" unless time.respond_to?(:to_i)
      @time = time.to_i
    end

    @points = points
  end
end
