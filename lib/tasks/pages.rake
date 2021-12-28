namespace :pages do
  desc "Migrates paperclip data to shrine column"
  task :migrate_images_shrine => :environment do
    Page.find_each do |page|
      page.write_shrine_data(:image)
      page.save!
    end
  end
end
