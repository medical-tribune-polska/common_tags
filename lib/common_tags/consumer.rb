require 'hutch'

module CommonTags
  class Consumer
    include Hutch::Consumer
    consume 'mt.common_tags.changes'
    queue_name ''

    def process(message)
      return if message[:instance_name] == CommonTags.instance_name

      Rails.logger.info "Consuming message common_tags"
      Rails.logger.info "Message: #{message}"

      if MessageHandler.new(message).process
        Rails.logger.info("Message processed!")
      else
        Rails.logger.info("Message failed!")
      end
    end

    class MessageHandler
      attr_reader :message
      def initialize(message)
        @message = message
      end

      def process
        unless message_accessible?
          Rails.logger.info "Unaccessible message!"
          return
        end

        send "#{message[:action]}_tag"
      end

      def create_tag
        create_tags_if_missing *message[:attributes][:connected_tag_ids]
        CommonTags::Tag.create message[:attributes]
      end

      def destroy_tag
        CommonTags::Tag.find(message[:id]).destroy
      end

      def update_tag
        create_tags_if_missing message[:id]
        CommonTags::Tag.find(message[:id]).update message[:attributes]
      end

      def message_accessible?
        %w(create update destroy).include? message[:action]
      end

      def create_tags_if_missing(*tag_ids)
        found_tag_ids = CommonTags::Tag.where('id IN (?)', tag_ids).pluck(:id)
        missing_tag_ids = tag_ids - found_tag_ids
        missing_tag_ids.each { |id| create_missing_tag id }
      end

      def create_missing_tag(id)
        Tag.create JSON.parse(Net::HTTP.get(URI.parse("#{CommonTags.master_host}/common_tags/api/tags/#{id}")))
      end
    end
  end
end