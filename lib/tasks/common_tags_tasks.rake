namespace :common_tags do
  desc "Update all tags"
  task :update_all_tags => :environment do
    unless CommonTags.master_db_name
      puts 'TASK CANCELED! Set master_db_name'
      next
    end

    ActiveRecord::Base.connection.execute <<-SQL
      INSERT INTO common_tags_tags (id,
                                    name,
                                    specialization,
                                    tag_connections_count,
                                    created_at,
                                    updated_at)
      SELECT *
      FROM dblink(
        'dbname=#{CommonTags.master_db_name}',
        'SELECT ct.id,
                ct.name,
                ct.specialization,
                ct.tag_connections_count,
                ct.created_at,
                ct.updated_at
         FROM common_tags_tags ct')
      AS t1(id uuid,
            name text,
            specialization boolean,
            tag_connections_count integer,
            created_at timestamp,
            updated_at timestamp);

      INSERT INTO common_tags_tag_connections (tag_id, connected_tag_id)
      SELECT *
      FROM dblink(
        'dbname=#{CommonTags.master_db_name}',
        'SELECT DISTINCT ON (tag_id, connected_tag_id) ctc.tag_id,
                                                       ctc.connected_tag_id
         FROM common_tags_tag_connections ctc')
      AS t1(tag_id uuid, connected_tag_id uuid);
    SQL
  end
end