class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :name
      t.text :content
      t.string :author_name
      t.timestamps
    end

    1.upto(5) do |i|
      Article.create(
        :name=>         "Title #{i}",
        :content=>      "Some content of article 'Title #{i}'. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam cursus purus eu nibh malesuada viverra. Maecenas commodo, tellus non rhoncus elementum.",
        :author_name=>  "Author_of_#{i}"
      )
    end
  end

  def self.down
    drop_table :articles
  end
end
