module CommonTags
  module ApplicationHelper
    def render_tags_for(taggable)
      taggable.taggings.map { |tagging| render_tag(tagging) }
        .join(' ')
        .html_safe
    end

    def render_modifyable_tags_for(taggable, list_permalink = 'podyplomie')
      list = List.find_by permalink: list_permalink
      render 'common_tags/taggable_form', taggable: taggable, list: list
    end

    private
      def render_tag(tagging)
        content_tag :span, tagging.tag.name, class: 'common-tag'
      end

      def render_modifyable_tag(tagging)
        tag = tagging.tag
        icon = if tag.specialization?
                 content_tag :span, '', class: 'common-tag-icon'
               else
                 nil
               end
        remove = link_to 'x',
                         (common_tags.tagging_path(tagging)),
                         method: :delete,
                         remote: true,
                         data: { toggle: 'remove-tagging', id: tagging.id }
        content_tag :span, class: 'common-tag' do
          "#{icon}#{tag.name} #{remove}".html_safe
        end
      end

      def add_tag_button
        content_tag :span, '+', class: 'common-tag-add'
      end
  end
end
