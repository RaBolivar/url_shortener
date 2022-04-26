class ShortUrl < ApplicationRecord
  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze
  BASE = 62
  validates_presence_of :full_url
  validate :validate_full_url

  def short_code
    generate_short_code(self.id) if self.id.present?
  end

  def update_title!
    UpdateTitleJob.perform_later(self.id)
  end

  def self.find_by_short_code(short_code)
    id = 0
    short_code.each_char { |c| id = id*BASE + CHARACTERS.index(c) }
    ShortUrl.find(id)
  end

  def validate_full_url
    errors.add(:full_url, "Full url is not a valid url") unless valid_url?(full_url)
  end

  private

  def valid_url?(uri)
    uri = URI.parse(uri)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end

  def generate_short_code(short_url_id)
    short_code = ""
     
    # for each digit find the base 62
    while (short_url_id > 0) do
      short_code += CHARACTERS[short_url_id % BASE]  
      short_url_id = short_url_id / BASE
		end

    # reversing the short code
    short_code.reverse
	end
end
