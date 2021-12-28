class AddImageDataToPages < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :image_data, :json
  end
end
