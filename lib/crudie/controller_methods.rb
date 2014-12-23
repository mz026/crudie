module Crudie
  def self.included base

    def base.crudie resource, options = {}
      template_base = options[:template_base] || ""
      template_extension = options[:template_extension] || "json.jbuilder"
      resources = resource.to_s.pluralize

      # define method: `create`
      # create resource under `crudie_context` using `crudie_params`
      # render `#{template_base}#{resources}/create.#{template_extension}`
      define_method(:create) do
        resource_instance = crudie_context.create(crudie_params)
        if resource_instance.valid?
          instance_variable_set("@#{resource}".to_sym, resource_instance)
          render :template => "#{template_base}#{resources}/create.#{template_extension}"
        else
          render :status => 409,
                 :json => { :reason => resource_instance.errors.messages }
        end


      end


      # define_method


    end
  end
end
