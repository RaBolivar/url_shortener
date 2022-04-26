class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  def index
    urls = ShortUrl.all
    respond_to do |format|
      msg = { :urls => urls }
      format.json  { render :json => msg }
    end
  end

  def create
    url = ShortUrl.new(url_params)
    if url.valid?
      url.save
      url.update_title!
      render json: { short_code: url.short_code }
    else
      render json: { errors: url.errors[:full_url] }
    end
  end

  def show
    url = ShortUrl.find_by_short_code(params[:id])
    url.update(click_count: url.click_count + 1) unless url.nil?
    redirect_to url.full_url
  rescue ActiveRecord::RecordNotFound
    render file: "#{Rails.root}/public/404", status: :not_found
  end

  def url_params
    params.permit(:full_url)
  end

end
