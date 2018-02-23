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
                                    permalink,
                                    created_at,
                                    updated_at)
      SELECT *
      FROM dblink(
        'dbname=#{CommonTags.master_db_name}',
        'SELECT ct.id,
                ct.name,
                ct.specialization,
                ct.permalink,
                ct.created_at,
                ct.updated_at
         FROM common_tags_tags ct')
      AS t1(id uuid,
            name text,
            specialization boolean,
            permalink text,
            created_at timestamp,
            updated_at timestamp);
    SQL
  end
end
