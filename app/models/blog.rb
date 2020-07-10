class Blog < ApplicationRecord
    include Validates

    acts_as_paranoid

    belongs_to :admin_user

    with_options presence: true do     
        validates :admin_user,  :url  
        validates :url, url: true
    end  
    
end
