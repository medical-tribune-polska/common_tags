module CommonTags
  class SiteGroup < ActiveRecord::Base
    include HasNameAndPermalink

    validates :name, uniqueness: { case_sensitive: false }
    validates :permalink, uniqueness: true

    has_many :tags
    has_many :lists

    def to_param
      permalink
    end
  end
end
