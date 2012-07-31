class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :layout_by_resource
  helper RailsAdmin::Engine.helpers
  before_filter :rails_admin_dynamic_config

  protected


  def rails_admin_dynamic_config

      model_list = [ Photo, User, Article ]

      model_list.each do |m|
          RailsAdmin::Config.reset_model( m )
      end

    RailsAdmin::Config::Actions.reset

    RailsAdmin.config do |config|


      config.current_user_method { current_user } # auto-generated
      config.main_app_name = ['Javiobando', 'Admin']


      config.excluded_models = [User]


      config.model Article do
        label "Entrada" 
        label_plural "Articulos"
        #navigation_label 'Entradas, Cursos y Libros'
        weight 0
      
        field :section, :enum do
          label 'Seccion'
        end
        field :view_as, :enum do
          label 'Ver como'
        end
        #field :published_at, :date do
        #  date_format :simple
        #  label "Publicado el"
        #  group :default
        #end

        field :photos do
          label "Imagenes"
        end


        edit do
          include_all_fields
        end

      end


      config.model Photo do    
        label "Foto" 
        label_plural "Fotos"

        field :image do
          label "Imagen"
        end

        field :orientation do
          partial "form_orientation_select"
          label 'Orientacion'
        end
        field :photoable do
          label "Registro Relacionado"
        end
        list do
          include_fields :image, :photoable
        end
        edit do
          exclude_fields_if do
            true
          end        
          include_fields :image, :orientation, :description
        end

      end




    end

  end


  
  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end  

end




