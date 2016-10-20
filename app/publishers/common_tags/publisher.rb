module CommonTags
  class Publisher
    class << self
      def publish(message)
        message.merge! instance_name: CommonTags.instance_name
        connection.publish 'mt.common_tags.changes', message
      end

      private
        def connection
          Thread.current[:hutch_connection] ||= new_connection
        end

        def new_connection
          Hutch::Broker
            .new(Hutch::Config)
            .tap { |b| b.connect(enable_http_api_use: false) }
        end
    end
  end
end