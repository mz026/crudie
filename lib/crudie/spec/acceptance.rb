module Crudie::Spec::Acceptance
  def self.included base
    class << base
      def include_acceptance_spec_for resource, options = {}
        resource_name = options[:resource][:name]
        resource_names = resource_name.to_s.pluralize

        parent = options[:parent]
        parent_name = parent[:name]
        parent_names = parent_name.to_s.pluralize
        parent_creator = parent[:creator]

        
        # index spec
        get "/#{parent_names}/:#{parent_name}_id/#{resource_names}" do
          let(:parent_instance) { parent_creator.call }
          let("#{parent_name}_id") { parent_instance.id }
          let!(:resources) do
            3.times do |i|
              options[:resource][:creator].call(parent_instance, i)
            end
          end

          example 'Index' do
            do_request
            expect(response_status).to eq 200
            expect(JSON.parse(response_body).count).to eq 3
          end
        end

        # show spec
        get "/#{parent_names}/:#{parent_name}_id/#{resource_names}/:#{resource}_id" do
          let(:parent_instance) { parent[:creator].call }
          let("#{parent_name}_id") { parent_instance.id }

          let("#{resource}_id") { resource_instance.id }
          let!(:resource_instance) do
            options[:resource][:creator].call(parent_instance, 1)
          end

          example 'Show' do
            do_request
            expect(JSON.parse(response_body)['id']).to eq(resource_instance.id)
          end
        end


        # post '/users/:user_id/projects' do
        #   parameter :user_id, 'user id', required: true
        #   parameter :name, 'project name', :scope => :project
        #   let(:name) { 'project name' }
        #   
        #   example 'Create' do
        #     do_request

        #     expect(user.projects.count).to eq 1
        #   end
        # end

        
      end
    end
  end
end
