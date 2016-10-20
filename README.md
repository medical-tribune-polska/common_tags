# CommonTags
Wspólny system tagów. To jest Rails Engine, który synchronizuję tagi w
aplikacjach korzystając z rabbitmq. Zażondzać tagami można w "master"
applikacji. Wszystkie inny dostaną widomość o tym że coś się zmieniło.
(W sume, można zmieniać tagi w każdej applikacji, tylko trzeba ustawić
confi.draw_routes, ale mi się wydaję że lepiej mieć to w jednym miejscu).

## Usage

### Taggable
Make model taggable:
```ruby
include CommonTags::Taggable
```

### View Helpers
Render tags as string:
```ruby
render_tags_for(@taggable)
```
Render tags as form:
```ruby
render_modifyable_tags_for(@taggable)
```
Form helper:
```ruby
f.tags_field
```

## Installation
Add this line to your application's Gemfile:
```ruby
gem 'common_tags'
```
And then execute:
```bash
$ bundle
```
Copy migrations:
```bash
$ rake common_tags:install:migrations
```
Mount common_tags routes:
```ruby
# config/routes.rb
mount CommonTags::Engine => "/common_tags"
```
Include helpers:
```ruby
# app/controllers/application_controller.rb
helper CommonTags::Engine.helpers
```

### As master
Configuration:
```ruby
# config/initializers/common_tags.rb
CommonTags.configure do |config|
  # in master application
  config.draw_routes = true
end
```
Copy tags from vod_backend:
 `import_from_vod.sql.example`

### As slave
Configuration:
```ruby
# config/initializers/common_tags.rb
CommonTags.configure do |config|
  # for initial copy tags from master
  config.master_db_name = 'mtportal_development'

  # for tags api
  config.master_host = 'http://localhost'
end
```
Copy tags from master:
```bash
$ rake common_tags:update_all_tags
```

#### If `class Tag` already exists in app:
rename old `class Tag` and related association
migrate old tags:
'migrate_old_tags.rb.example'