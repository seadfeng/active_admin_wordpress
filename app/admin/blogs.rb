ActiveAdmin.register Blog do 
    permit_params  :admin_user_id,  :name , :description , :user, :password, :url
    menu priority: 10 
    active_admin_paranoia 

    active_admin_import  validate: true,
            template_object: ActiveAdminImport::Model.new(
                hint: I18n.t("active_admin.accounts.import.hint" , default: "CSV : 'Admin User Id','Url','Name','Description','User','Password'\r\n<br /><a href=\"/admin/blogs/import_csv\">DownLoad Demo</a>") 
            ),
            headers_rewrites: { :'Admin User Id' => :admin_user_id, :'Url' => :url, :'Name'=> :name, :'Description' => :description, :"User" => :user, :'Password' => :password },
            if: proc { current_admin_user.admin? } 


    controller do
        def create  
            params[:blog][:admin_user_id] = current_admin_user.id
            super 
        end

        def scoped_collection
            if current_admin_user.admin?
                super
            else
                end_of_association_chain.where(admin_user_id: current_admin_user.id) 
            end
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
            f.input :admin_user if current_admin_user.admin?        
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

    collection_action :import_csv, method: :get do   
        send_data "Admin User Id,Url,Name,Description,User,Password\r\n1,https://xxxxx.com/,博客名字,备注,admin,admin@123", :disposition => "attachment; filename=blogs.csv", :type => 'text/csv; charset=utf-8; header=present'
    end

end