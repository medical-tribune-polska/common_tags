module CommonTags
  module FormHelper
    def self.included(base)
      ActionView::Helpers::FormBuilder.instance_eval do
        include CommonTagHelper
      end
    end

    module CommonTagHelper
      def tags_field(method = :tag_ids, list_permalink = 'podyplomie')
        list_permalink = 'podyplomie' unless list_permalink.present?
        list = List.find_by permalink: list_permalink

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
