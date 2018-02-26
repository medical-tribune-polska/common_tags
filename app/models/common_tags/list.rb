module CommonTags
  class List < ActiveRecord::Base
    include HasNameAndPermalink

    has_many :tags

    def to_param
      permalink
    end
  end
end
