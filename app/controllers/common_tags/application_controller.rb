module CommonTags
  class ApplicationController < ::ApplicationController
    class << self
      if Rails::VERSION::STRING.to_i <= 3
        alias_method :before_action, :before_filter
        alias_method :after_action, :after_filter
      end
    end
  end
end
