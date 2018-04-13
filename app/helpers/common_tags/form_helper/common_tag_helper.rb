module CommonTags
  module FormHelper
    module CommonTagHelper
      def tags_field(method = :tag_ids, site_group_permalink = nil)
        site_group = CommonTags::SiteGroup.find_by_permalink site_group_permalink

        return "Common Tags site group [#{site_group_permalink || 'nil'}] not found" unless site_group

        html_options = {
          multiple: true,
          class: 'form-control',
          id: "#{@object_name}_#{method}",
          data: {
            toggle: 'common_tags_select',
            suggestions: @template.common_tags.suggestions_site_group_tags_path(site_group),
          }
        }
        @template.select_tag "#{@object_name}[#{method}]",
                             @template.tags_options_for_select(@object.tags),
                             html_options
      end
    end
  end
end
