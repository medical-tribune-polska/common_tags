module CommonTags
  module FormHelper
    def self.included(base)
      ActionView::Helpers::FormBuilder.instance_eval do
        include CommonTagHelper
      end
    end

    module CommonTagHelper
      def tags_field(method = :tag_ids)
        html_options = {
          multiple: true,
          class: 'taggable-form-select',
          id: "#{@object_name}_#{method}",
          data: {
            toggle: 'common_tags_select',
            'suggestions-url' => @template.common_tags.suggestions_tags_path
          }
        }
        @template.select_tag "#{@object_name}[#{method}]",
                             tags_options,
                             html_options
      end

      private
        def tags_options
          @template.options_from_collection_for_select @object.tags,
                                                       :id,
                                                       :name,
                                                       @object.tag_ids
        end
    end
  end
end
