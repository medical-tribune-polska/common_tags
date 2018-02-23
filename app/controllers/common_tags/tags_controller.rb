module CommonTags
  class TagsController < ApplicationController
    before_action :set_tag, only: [:edit, :update, :destroy]
    def index
      @tags = Tag.order('name').all
    end

    def edit
    end

    def update
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
      unless @tag.destroy.persisted?
        @tag.publish_destroy
        redirect_to action: 'index'
      end
    end

    def suggestions
      @tags = Tag.where 'name ILIKE ?', "%#{params[:q]}%"
      render json: @tags.map(&:to_suggest)
    end

    private
      def tag_params
        params.require(:tag).permit :name,
                                    :specialization,
                                    :permalink
      end

      def set_tag
        @tag = Tag.find params[:id]
      end
  end
end
