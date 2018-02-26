# CommonTags
Wspólny system tagów. To jest Rails Engine, który synchronizuje tagi w
aplikacjach korzystając z rabbitmq. Zażądzać tagami można w "master"
applikacji. Wszystkie inne dostaną widomość o tym że coś się zmieniło.
(W sume, można zmieniać tagi w każdej applikacji, tylko trzeba ustawić
config.draw_routes, ale mi się wydaję że lepiej mieć to w jednym miejscu).

## Usage

### Taggable
Make model taggable:
```ruby
include CommonTags::Taggable
```

### View Helpers
Render tags as string:
```ruby
render_tags_for(@taggable, 'podyplomie')
```
Render tags as form:
```ruby
render_modifyable_tags_for(@taggable, 'podyplomie')
```
Form helper:
```ruby
f.tags_field :tag_ids, 'podyplomie'
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
Include assets:
```javascript
# app/assets/javascripts/application.js
//= require common_tags/application
```
```css
# app/assets/stylesheets/application.css
//*= require common_tags/application
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

#### If `tags` association already exists:
rename association

migrate old tags:
'migrate_old_tags.rb.example'
