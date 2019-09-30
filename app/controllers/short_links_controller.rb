class ShortLinksController < ApplicationController
  before_action :set_short_link, only: :show

  def create
    @short_link = ShortLink.create_with(user_id: params[:user_id]).find_or_create_by(long_link: params[:long_link])
    status = @short_link.id ? :created : :unprocessable_entity
    if status == :created
      render json: {long_link: @short_link.long_link, short_link: "http://test.host/#{@short_link.encoded_id}"}, status: status
    else
      render json: @short_link.errors.messages, status: status
    end
  end

  def show
    redirect_to @short_link.long_link, status: :moved_permanently
  end

  def analytics
    @short_link = ShortLink.find_quietly(params[:id])
    status = @short_link != 0 ? :ok : :not_found
    if status == :ok
      render json: {long_link: @short_link.long_link, short_link: "http://test.host/#{@short_link.encoded_id}", usage_count: "#{@short_link.use_count}"}, status: status
    else
      render json: {usage_count: 0}, status: status
    end
  end

  private

  def set_short_link
    @short_link = ShortLink.find_by_encoded_id(params[:id])
    head :not_found unless @short_link
  end

  def short_link_params
    params.permit(:long_link, :user_id)
  end
end
