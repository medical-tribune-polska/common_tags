module CommonTags
  class TagsController < ApplicationController
    before_action :set_list
    before_action :set_tag, only: [:edit, :update, :destroy]

    def index
      @tags = @list.tags.order('name').all
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
      @tag = @list.tags.build
    end

    def create
      @tag = @list.tags.build tag_params

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
      @tags = @list.tags.where 'name ILIKE ?', "%#{params[:q]}%"
      render json: @tags.map(&:to_suggest)
    end

    private
      def tag_params
        params.require(:tag).permit :name,
                                    :specialization,
                                    :permalink
      end

      def set_list
        permalink = if Rails::VERSION::STRING.to_i <= 3
                      params[:list_permalink]
                    else
                      params[:list_id]
                    end

        @list = List.find_by_permalink permalink
      end

      def set_tag
        @tag = @list.tags.find params[:id]
      end
  end
end
