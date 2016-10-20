module CommonTags
  def self.configuration=(config)
    @configuration = config
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  def self.instance_name
    configuration.instance_name
  end

  def self.draw_routes?
    configuration.draw_routes
  end

  def self.master_db_name
    configuration.master_db_name
  end

  def self.master_host
    configuration.master_host
  end

  class Configuration
    attr_accessor :draw_routes, :instance_name, :master_db_name, :old_tag_class

    def initialize
      @instance_name = "#{::Rails.application.class.parent.name}_common_tags"
      @draw_routes = false
      @master_db_name = false
      @master_host = 'http://localhost'
    end
  end
end