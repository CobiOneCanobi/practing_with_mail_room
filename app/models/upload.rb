class Upload < ActiveRecord::Base
  mount_uploader :name, FileUploader
end
