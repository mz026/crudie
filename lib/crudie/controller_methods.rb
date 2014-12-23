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
        resource = crudie_context.create(crudie_params)
        render :template => "#{template_base}#{resources}/create.#{template_extension}"
      end


    end
  end
end
