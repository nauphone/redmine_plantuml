class RedminePlantumlController < ApplicationController

  def filter
    filename = params[:name]
    file_name = "#{filename}.png"
    path = Rails.root.join('tmp', 'plantuml')
    image = Magick::Image.read(Rails.root.join(path, file_name)).first
    send_data image.to_blob, :type => 'image/png', :disposition => 'inline', :filename => "#{file_name}"
  end
end
