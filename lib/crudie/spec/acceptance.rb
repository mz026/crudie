module Crudie::Spec::Acceptance
  def self.included base
    class << base
      def include_acceptance_spec_for resource, options = {}
        resource_name = options[:resource][:name]
        resource_names = resource_name.to_s.pluralize
        resource_name_id = "#{resource_name}_id"
        resource_creator = options[:resource][:creator]
        resource_context = options[:resource][:context]

        parent_exists = ! options[:parent].nil?

        if parent_exists
          parent = options[:parent]
          parent_name = parent[:name]
          parent_names = parent_name.to_s.pluralize
          parent_creator = parent[:creator]
          parent_name_id = "#{parent_name}_id"

          singular_url = "/#{parent_names}/:#{parent_name_id}/#{resource_names}/:#{resource_name_id}"
          plural_url = "/#{parent_names}/:#{parent_name_id}/#{resource_names}"

          let(:parent_instance) { parent_creator.call }
          let(parent_name_id) { parent_instance.id }
        else
          plural_url = "/#{resource_names}"
          singular_url = "/#{resource_names}/:#{resource_name_id}"
        end


        

        # index spec
        get plural_url do
          let!(:resources) do
            3.times do |i|
              parent_exists ? 
                resource_creator.call(i, parent_instance) : 
                resource_creator.call(i)
            end
          end

          example 'Index' do
            do_request
            expect(response_status).to eq 200
            expect(JSON.parse(response_body).count).to eq 3
          end
        end

        # show spec
        get singular_url do
          let(resource_name_id) { resource_instance.id }
          let!(:resource_instance) do
            parent_exists ?
              resource_creator.call(1, parent_instance) :
              resource_creator.call(1)
          end

          example 'Show' do
            do_request
            expect(JSON.parse(response_body)['id']).to eq(resource_instance.id)
          end
        end


        # Create spec
        parameters = options[:parameters]

        post plural_url do
          parameters.each do |key, detail|
            parameter key, detail[:desc], detail[:options]
            let(key) { detail[:value] }
          end
          
          example 'Create' do
            do_request

            if parent_exists
              expect(resource_context.call(parent_instance).count).to eq 1
            else
              expect(resource_context.call.count).to eq 1
            end

          end
        end

        put singular_url do
          parameters.each do |key, detail|
            parameter key, detail[:desc], detail[:options]
            let(key) { detail[:value] }
          end
          let(resource_name_id) { resource_instance.id }
          let!(:resource_instance) do
            if parent_exists
              resource_creator.call(1, parent_instance)
            else
              resource_creator.call(1)
            end
          end

          example 'Updating' do
            do_request

            resource_instance.reload
            parameters.each do |key, val|
              expect(resource_instance.send(key)).to eq(send(key))
            end
          end
        end


        delete singular_url do
          parameters.each do |key, detail|
            parameter key, detail[:desc], detail[:options]
            let(key) { detail[:value] }
          end
          let(resource_name_id) { resource_instance.id }
          let!(:resource_instance) do
            if parent_exists
              resource_creator.call(1, parent_instance)
            else
              resource_creator.call(1)
            end
          end

          example 'Deletion' do
            do_request
            if parent_exists
              expect(resource_context.call(parent_instance)
                                     .where(resource_instance.id)).to be_empty
            else
              expect(resource_context.call
                                     .where(resource_instance.id)).to be_empty
            end
          end
        end
        
      end
    end
  end
end
