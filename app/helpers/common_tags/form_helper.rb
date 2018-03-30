module CommonTags
  module FormHelper
    def self.included(base)
      ActionView::Helpers::FormBuilder.instance_eval do
        include CommonTags::FormHelper::CommonTagHelper
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
