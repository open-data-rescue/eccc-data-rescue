namespace :pages do
  desc "Migrates paperclip data to shrine image_data column"
  task :migrate_shrine_data => :environment do
    Page.find_each do |page|
      page.write_shrine_data(:image)
      page.save!
    end
  end
end
