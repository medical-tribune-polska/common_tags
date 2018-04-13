module CommonTags
  class Api::TagsController < ActionController::Base
    def show
      @tag = Tag.find params[:id]
      render json: @tag.as_json(methods: [:list_ids])
    end
  end
end
