require 'open-uri'

class UpdateTitleJob < ApplicationJob
  queue_as :default

  def perform(short_url_id)
    short_url = ShortUrl.find(short_url_id)
    title = open(short_url.full_url).read.scan(/<title>(.*?)<\/title>/)
    short_url.update(title: title[0][0])
  end
end
