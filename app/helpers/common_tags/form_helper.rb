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
    end

    def tags_options_for_select(tags)
      options = tags.map do |t|
        [
          t.name,
          t.id,
          { data: { specialization: t.specialization? } }
        ]
      end
      options_for_select options, selected: tags.map(&:id)
    end
  end
end
