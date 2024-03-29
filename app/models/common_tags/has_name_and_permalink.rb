module CommonTags
  module HasNameAndPermalink
    extend ActiveSupport::Concern

    included do
      before_validation :set_default_permalink, if: :permalink_blank?

      validates :name, presence: true, allow_blank: false
      validates :permalink, presence: true, allow_blank: false

      private

        def permalink_blank?
          permalink.blank?
        end

        def set_default_permalink
          self.permalink = name.parameterize
        end
    end
  end
end
