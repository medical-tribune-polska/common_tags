module CommonTags
  module FormHelper
    module CommonTagHelper
      def tags_field(method = :tag_ids, list_permalink = nil)
        list = CommonTags::List.find_by_permalink list_permalink

        return "Tag list [#{list_permalink || 'nil'}] not found" unless list

        html_options = {
          multiple: true,
          class: 'form-control',
          id: "#{@object_name}_#{method}",
          data: {
            toggle: 'common_tags_select',
            suggestions: @template.common_tags.suggestions_list_tags_path(list),
          }
        }
        @template.select_tag "#{@object_name}[#{method}]",
                             @template.tags_options_for_select(@object.tags),
                             html_options
      end
    end
  end
end
