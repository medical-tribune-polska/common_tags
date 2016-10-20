module CommonTags
  class Api::TagsController < ApplicationController
    def show
      @tag = Tag.find params[:id]
      render json: @tag.as_json
    end
  end
end
