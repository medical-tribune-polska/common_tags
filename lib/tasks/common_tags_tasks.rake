namespace :common_tags do
  desc "Update all tags"
  task :update_all_tags => :environment do
    unless CommonTags.master_db_name
      puts 'TASK CANCELED! Set master_db_name'
      next
    end

    tag_ids = CommonTags::Tag.pluck :id;
    site_group_ids = CommonTags::SiteGroup.pluck :id;
    list_ids = CommonTags::List.pluck :id;

    ActiveRecord::Base.connection.execute <<-SQL
      CREATE EXTENSION IF NOT EXISTS "dblink";

      INSERT INTO common_tags_site_groups (id,
                                           name,
                                           permalink,
                                           created_at,
                                           updated_at)
      SELECT *
      FROM dblink(
        'dbname=#{CommonTags.master_db_name}',
        'SELECT ct.id,
                ct.name,
                ct.permalink,
                ct.created_at,
                ct.updated_at
         FROM common_tags_site_groups ct')
      AS t1(id integer,
            name text,
            permalink text,
            created_at timestamp,
            updated_at timestamp)
      WHERE NOT id = ANY(ARRAY[#{site_group_ids.join(", ")}]);

      INSERT INTO common_tags_lists (id,
                                     name,
                                     permalink,
                                     site_group_id,
                                     created_at,
                                     updated_at)
      SELECT *
      FROM dblink(
        'dbname=#{CommonTags.master_db_name}',
        'SELECT ct.id,
                ct.name,
                ct.permalink,
                ct.site_group_id,
                ct.created_at,
                ct.updated_at
         FROM common_tags_lists ct')
      AS t1(id integer,
            name text,
            permalink text,
            site_group_id integer,
            created_at timestamp,
            updated_at timestamp)
      WHERE NOT id = ANY(ARRAY[#{list_ids.join(", ")}]);

      INSERT INTO common_tags_tags (id,
                                    name,
                                    specialization,
                                    site_group_id,
                                    permalink,
                                    created_at,
                                    updated_at)
      SELECT *
      FROM dblink(
        'dbname=#{CommonTags.master_db_name}',
        'SELECT ct.id,
                ct.name,
                ct.specialization,
                ct.site_group_id,
                ct.permalink,
                ct.created_at,
                ct.updated_at
         FROM common_tags_tags ct')
      AS t1(id uuid,
            name text,
            specialization boolean,
            site_group_id integer,
            permalink text,
            created_at timestamp,
            updated_at timestamp)
      WHERE NOT id = ANY(ARRAY['#{tag_ids.join("'::uuid, '")}']);

      INSERT INTO common_tags_lists_tags (tag_id, list_id)
      SELECT *
      FROM dblink(
        'dbname=#{CommonTags.master_db_name}',
        'SELECT ct.tag_id, ct.list_id
         FROM common_tags_lists_tags ct')
      AS t1(tag_id uuid, list_id integer);
    SQL
  end
end
