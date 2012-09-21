class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :layout_by_resource
  helper RailsAdmin::Engine.helpers
  before_filter :rails_admin_dynamic_config

  protected


  def rails_admin_dynamic_config

      model_list = [ Photo, User, Article, Portada,Personal, Comercial ]

      model_list.each do |m|
          RailsAdmin::Config.reset_model( m )
      end

    RailsAdmin::Config::Actions.reset

    RailsAdmin.config do |config|


      config.current_user_method { current_user } # auto-generated
      config.main_app_name = ['Javiobando', 'Admin']


      #config.excluded_models = [User]

      config.model Article do
        label "Entrada" 
        label_plural "Articulos"
        weight 0
      end

      config.model Portada do
        label "Portada" 
        label_plural "Portada"
        field :section do
          default_value do
            'po'
          end
        end
      end

      config.model Personal do
        label "Personal" 
        label_plural "Personal"
        field :section do
          default_value do
            'pe'
          end
        end
      end

      config.model Comercial do
        label "Comercial" 
        label_plural "Comercial"

        field :section do
          default_value do
            'co'
          end
        end

      end

      [Article, Portada, Personal, Comercial ].each do |model_class|

        config.model model_class do
        
          field :section, :enum do
            label 'Seccion'
          end
          field :view_as, :enum do
            label 'Ver como'
          end
          field :published_at, :date do
            date_format :default
            label "Publicado el"
          end
          field :draft do
            label "Borrador"
          end

          field :photos do
            label "Imagenes"
            #orderable true
            #nested_form false
            #partial "form_multiple_select"
            
          end

          list do
            exclude_fields_if do
              true
            end
            if model_class == Article
              filters [:section]
              include_fields :section, :published_at, :view_as, :draft, :photos
              sort_by :section, :published_at
            else
              include_fields :published_at, :view_as, :draft, :photos
              sort_by :published_at
            end
            field :photos do
              pretty_value do
                value.map{ |photo| bindings[:view].tag(:img, { :width=> 50, :src => photo.image.url(:thumb) }) }.join('').html_safe
              end
            end
            
          end


          edit do
            include_all_fields
          end

        end
      end


      config.model Photo do    
        label "Foto" 
        label_plural "Fotos"

        field :image do
          label "Imagen"
        end
        field :tag do
          label 'Etiqueta'
        end
        field :orientation do
          label 'Orientacion'
          #partial "form_multiple_select"
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
          include_fields :image,:tag, :orientation, :description
        end

      end

      config.model User do
        label "Usuario" 
        label_plural "Usuarios"
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




