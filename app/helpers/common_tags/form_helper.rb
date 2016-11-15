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
          class: 'form-control',
          id: "#{@object_name}_#{method}",
          data: {
            toggle: 'common_tags_select',
            suggestions: @template.common_tags.suggestions_tags_path,
          }
        }
        @template.select_tag "#{@object_name}[#{method}]",
                             @template.tags_options_for_select(@object.tags),
                             html_options
      end

      def connected_tags_field(method = :connected_tag_ids)
        suggestions_path = if @object.new_record?
                             @template.common_tags.suggestions_tags_path
                           else
                             @template.common_tags.tag_related_suggestions_path(@object)
                           end
        html_options = {
          multiple: true,
          class: 'form-control',
          id: "#{@object_name}_#{method}",
          data: {
            toggle: 'common_tags_select',
            suggestions: suggestions_path,
          }
        }
        @template.select_tag "#{@object_name}[#{method}]",
                             @template.tags_options_for_select(@object.connected_tags),
                             html_options
      end
    end

    def tags_options_for_select(tags)
      options = tags.map do |t|
        [
          t.name,
          t.id,
          { data: { specialization: t.specialization?,
                    count: t.tag_connections_count } }
        ]
      end
      options_for_select options, selected: tags.map(&:id)
    end
  end
end
