module CommonTags
  class TagsController < ApplicationController
    before_action :set_site_group
    before_action :set_tag, only: [:edit, :update, :destroy]

    def index
      @tags = @site_group.tags.order('name').all
    end

    def edit
    end

    def update
      if @tag.update tag_params
        @tag.publish_update tag_params
        redirect_to action: 'edit'
      else
        render 'edit'
      end
    end

    def new
      @tag = @site_group.tags.build
    end

    def create
      @tag = @site_group.tags.build tag_params

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
      @tags = @site_group.tags.where 'name ILIKE ?', "%#{params[:q]}%"
      render json: @tags.map(&:to_suggest)
    end

    private
      def tag_params
        params.require(:tag).permit :name,
                                    :specialization,
                                    :permalink,
                                    list_ids: []
      end

      def set_site_group
        @site_group = CommonTags::SiteGroup.find_by_permalink params[:site_group_permalink]
      end

      def set_tag
        @tag = @site_group.tags.find params[:id]
      end
  end
end
