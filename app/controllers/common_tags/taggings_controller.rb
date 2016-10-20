module CommonTags
  class TaggingsController < ApplicationController
    def set
      taggable_class = params[:taggable_type].constantize
      return unless taggable_class.included_modules.include?(Taggable)

      @taggable = taggable_class.find params[:taggable_id]
      @taggable.tag_ids = params[:tag_ids]

      @taggable.reload

      flash.now[:message] = 'saved!'
    end
  end
end
