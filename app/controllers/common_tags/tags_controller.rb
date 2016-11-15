module CommonTags
  class TagsController < ApplicationController
    def index
      @tags = Tag.order('name').all
    end

    def edit
      @tag = Tag.find params[:id]
    end

    def update
      @tag = Tag.find params[:id]

      if @tag.update tag_params
        @tag.publish_update tag_params
        redirect_to action: 'index'
      else
        render 'edit'
      end
    end

    def new
      @tag = Tag.new
    end

    def create
      @tag = Tag.new tag_params

      if @tag.save
        @tag.publish_create
        redirect_to action: 'index'
      else
        render 'new'
      end
    end

    def destroy
      @tag = Tag.find params[:id]
      unless @tag.destroy.persisted?
        @tag.publish_destroy
        redirect_to action: 'index'
      end
    end

    def suggestions
      @tags = Tag.where 'name LIKE ?', "%#{params[:q]}%"
      render json: @tags.map(&:to_suggest)
    end

    def related_suggestions
      @tag = Tag.find params[:tag_id]
      @tags = Tag.where.not(id: @tag.id).where 'name LIKE ?', "%#{params[:q]}%"
      render json: @tags.map(&:to_suggest)
    end

    private
      def tag_params
        params.require(:tag).permit :name,
                                    :specialization,
                                    connected_tag_ids: []
      end
  end
end
