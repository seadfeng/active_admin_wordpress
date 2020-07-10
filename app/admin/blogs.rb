ActiveAdmin.register Blog do 
    permit_params  :admin_user_id,  :name , :description , :user, :password, :url
    menu priority: 10 
    active_admin_paranoia 

    controller do
        def create  
            params[:blog][:admin_user_id] = current_admin_user.id
            super 
        end
    end
    index do
        selectable_column
        id_column   
        column :admin_user   
        column :url     
        column :name    
        column :login do |source|
            link_to image_tag("icons/arrows.svg", width: "20", height: "20")  , login_admin_blog_path(source) , target: "_blank" , method: :put , class: ""  
        end
        column :description     
        column :status    
        column :created_at
        column :updated_at
        actions
    end

    
    filter :admin_user, :if => proc { current_admin_user.admin? }
    filter :url
    filter :name

    form do |f|
        f.inputs I18n.t("active_admin.blogs.form" , default: "Blog")  do  
            f.input :url       
            f.input :name     
            f.input :user     
            f.input :password     
            f.input :description     
        end
        f.actions
    end 


    member_action :login, method: :put do   
        render "admin/blogs/login.html.erb" , locals: { blog_url: resource.url} 
    end

end