module CommonTags
  class List < ActiveRecord::Base
    include HasNameAndPermalink

    if Rails::VERSION::STRING.to_i <= 3
      attr_accessible :name, :permalink
    end

    has_many :tags

    def to_param
      permalink
    end

    def self.name_and_permalink_uniqueness_scope
      []
    end
  end
end
