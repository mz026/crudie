module Crudie
  def self.included base

    def base.crudie resource, options = {}
      template_base = options[:template_base] || ""
      template_extension = options[:template_extension] || "json.jbuilder"
      resources = resource.to_s.pluralize

      define_method(:template_path) do |action|
        "#{template_base}#{resources}/#{action}.#{template_extension}"
      end
      private :template_path

      # define method: `create`
      # create resource under `crudie_context` using `crudie_params`
      # render `#{template_base}#{resources}/create.#{template_extension}`
      define_method(:create) do
        instance = crudie_context.create(crudie_params)
        if instance.valid?
          instance_variable_set("@#{resource}".to_sym, instance)
          render :template => template_path(:create)
        else
          render :status => 409,
                 :json => { :reason => instance.errors.messages }
        end
      end

      # define method: `index`
      # list resources via `crudie_params`
      # render `#{template_base}#{resources}/index.#{template_extension}`
      define_method(:index) do
        instance_variable_set("@#{resources}".to_sym, crudie_context)  
        render :template => template_path(:index)
      end

      # define method: `show`
      # show resource via `crudie_context.find(params[:id])`
      # render `#{template_base}#{resources}/show.#{template_extension}`
      define_method(:show) do
        instance = crudie_context.find(params[:id])
        instance_variable_set("@#{resource}".to_sym, instance)

        render :template => template_path(:show)
      end

    end
  end
end
