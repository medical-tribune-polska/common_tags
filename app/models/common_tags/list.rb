module CommonTags
  class List < ActiveRecord::Base
    include HasNameAndPermalink

    validates :name, uniqueness: { case_sensitive: false }
    validates :permalink, uniqueness: true

    has_many :tags

    def to_param
      permalink
    end

    def self.name_and_permalink_uniqueness_scope
      []
    end
  end
end
