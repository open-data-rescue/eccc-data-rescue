if @page
    json.id @page.id
    if @page.image.present?
        json.image do
            json.original @page.image_url(:original)
        end
    else
        json.image nil
    end
end
