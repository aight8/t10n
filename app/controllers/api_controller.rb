require 'json'
require 'awesome_print'

class ApiController < ApplicationController
  def get_newcomers
    top_newcomers_service = TopNewcomersService.new
    top_growth_rate_stories = top_newcomers_service.top_growth_rate_stories
    record_holder = top_newcomers_service.record_holder_story

    render json: {
      record: record_holder.serialize,
      stories: top_growth_rate_stories
    }
  rescue => e
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n") if e.backtrace

    render json: {
      error: {
        type: e.class.to_s,
        message: e.message,
      }
    }
  end
end

