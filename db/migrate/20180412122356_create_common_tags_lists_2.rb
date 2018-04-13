class CreateCommonTagsLists2 < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp'

    create_table :common_tags_lists do |t|
      t.string :name
      t.string :permalink
      t.belongs_to :site_group, index: true
      t.timestamps
    end

    create_table :common_tags_lists_tags, id: false do |t|
      t.belongs_to :list, index: true
      t.uuid :tag_id, index: true
    end

    reversible do |dir|
      dir.up do
        data = [
          { permalink: 'anestezjologia', lists: ['specjalizacje'] },
          { permalink: 'behawioryzm', lists: ['specjalizacje'] },
          { permalink: 'chirurgia', lists: ['specjalizacje'] },
          { permalink: 'choroby-wewnetrzne', lists: ['specjalizacje'] },
          { permalink: 'choroby-zakazne', lists: ['specjalizacje'] },
          { permalink: 'dermatologia', lists: ['specjalizacje'] },
          { permalink: 'diagnostyka-laboratoryjna', lists: ['specjalizacje'] },
          { permalink: 'diagnostyka-obrazowa', lists: ['specjalizacje'] },
          { permalink: 'endokrynologia', lists: ['specjalizacje'] },
          { permalink: 'farmakologia-i-toksykologia', lists: ['specjalizacje'] },
          { permalink: 'gastroenterologia', lists: ['specjalizacje'] },
          { permalink: 'geriatria', lists: ['specjalizacje'] },
          { permalink: 'hematologia', lists: ['specjalizacje'] },
          { permalink: 'kardiologia', lists: ['specjalizacje'] },
          { permalink: 'laryngologia', lists: ['specjalizacje'] },
          { permalink: 'nefrologia-i-urologia', lists: ['specjalizacje'] },
          { permalink: 'neurologia', lists: ['specjalizacje'] },
          { permalink: 'okulistyka', lists: ['specjalizacje'] },
          { permalink: 'onkologia', lists: ['specjalizacje'] },
          { permalink: 'ortopedia', lists: ['specjalizacje'] },
          { permalink: 'parazytologia', lists: ['specjalizacje'] },
          { permalink: 'rehabilitacja', lists: ['specjalizacje'] },
          { permalink: 'rozrod', lists: ['specjalizacje'] },
          { permalink: 'stany-nagle', lists: ['specjalizacje'] },
          { permalink: 'stomatologia', lists: ['specjalizacje'] },
          { permalink: 'zywienie', lists: ['specjalizacje'] },
          { permalink: 'koty', lists: ['gatunki', 'małe zwierzęta'] },
          { permalink: 'psy', lists: ['gatunki', 'małe zwierzęta'] },
          { permalink: 'konie', lists: ['gatunki', 'konie'] },
          { permalink: 'bydlo', lists: ['gatunki', 'przeżuwacze'] },
          { permalink: 'kozy', lists: ['gatunki', 'przeżuwacze'] },
          { permalink: 'owce', lists: ['gatunki', 'przeżuwacze'] },
          { permalink: 'swinie', lists: ['gatunki', 'świnie'] },
          { permalink: 'gesi', lists: ['gatunki', 'ptaki'] },
          { permalink: 'lisy', lists: ['gatunki', 'ptaki'] },
          { permalink: 'kury', lists: ['gatunki', 'ptaki'] },
          { permalink: 'papugi', lists: ['gatunki', 'ptaki'] },
          { permalink: 'ptaki-egzotyczne', lists: ['gatunki', 'ptaki'] },
          { permalink: 'golebie', lists: ['gatunki', 'ptaki'] },
          { permalink: 'kaczki', lists: ['gatunki', 'ptaki'] },
          { permalink: 'myszy', lists: ['gatunki', 'zwierzęta egzotyczne'] },
          { permalink: 'kroliki', lists: ['gatunki', 'zwierzęta egzotyczne'] },
          { permalink: 'fretki', lists: ['gatunki', 'zwierzęta egzotyczne'] },
          { permalink: 'szczury', lists: ['gatunki', 'zwierzęta egzotyczne'] },
          { permalink: 'chomiki', lists: ['gatunki', 'zwierzęta egzotyczne'] },
          { permalink: 'weze', lists: ['gatunki', 'zwierzęta egzotyczne'] },
          { permalink: 'zolwie', lists: ['gatunki', 'zwierzęta egzotyczne'] },
          { permalink: 'gady', lists: ['gatunki', 'zwierzęta egzotyczne'] },
          { permalink: 'szynszyle', lists: ['gatunki', 'zwierzęta egzotyczne'] },
          { permalink: 'jaszczurki', lists: ['gatunki', 'zwierzęta egzotyczne'] },
          { permalink: 'kawie-domowe', lists: ['gatunki', 'zwierzęta egzotyczne'] },
          { permalink: 'gryzonie', lists: ['gatunki', 'zwierzęta egzotyczne'] },
          { permalink: 'jeze', lists: ['gatunki', 'zwierzęta dzikie'] },
          { permalink: 'sarny', lists: ['gatunki', 'zwierzęta dzikie'] },
          { permalink: 'zajace', lists: ['gatunki', 'zwierzęta dzikie'] },
          { permalink: 'jelenie', lists: ['gatunki', 'zwierzęta dzikie'] },
          { permalink: 'lwy', lists: ['gatunki', 'zwierzęta dzikie'] },
          { permalink: 'ryby', lists: ['gatunki', 'zwierzęta egzotyczne'] },
          { permalink: 'psychologia', lists: ['marketing'] },
          { permalink: 'prawo', lists: ['marketing'] },
          { permalink: 'zarzadzanie', lists: ['marketing'] },
        ]

        site_group = CommonTags::SiteGroup.find_or_create_by permalink: 'magwet'

        data.each do |hash|
          lists = hash[:lists].map { |name|  CommonTags::List.find_or_create_by name: name, site_group: site_group }
          tag = CommonTags::Tag.find_by permalink: hash[:permalink], site_group: site_group
          tag ||= CommonTags::Tag.create permalink: hash[:permalink], name: hash[:permalink], site_group: site_group
          lists.each { |list| tag.lists << list }
          tag.save
        end
      end
    end
  end
end
