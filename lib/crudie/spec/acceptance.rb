# Acceptance spec helper
# Usage:
# 1. for resource without parent:
# include Crudie::Spec::Acceptance
# include_acceptance_spec_for :resource => {
#                               :name => :user,
#                               :creator => Proc.new {|index| User.create :name => index },
#                               :context => Proc.new { User.all }
#                             },
#                             :parameters => {
#                               :name => {
#                                 :desc => 'user name',
#                                 :value => 'the new user name',
#                                 :options => {
#                                   :scope => :user,
#                                   :required => true
#                                 }
#                               }
#                             }
#
# 2. for resource with parent:
# include Crudie::Spec::Acceptance
# include_acceptance_spec_for :parent => {
#                               :name => :user,
#                               :creator => Proc.new { User.create :name => 'jack' }
#                             },
#                             :resource => {
#                               :name => :project,
#                               :creator => Proc.new {|i, user| user.projects.create :name => i },
#                               :context => Proc.new {|parent| parent.projects }
#                             },
#                             :parameters => {
#                               :name => {
#                                 :desc => 'project name',
#                                 :value => 'the new project name',
#                                 :options => {
#                                   :scope => :project,
#                                   :required => true
#                                 }
#                               }
#                             }

module Crudie::Spec::Acceptance
  def self.included base
    class << base
      def include_acceptance_spec_for options 
        resource_names = options[:resource][:name].to_s.pluralize
        resource_name_id = "#{options[:resource][:name]}_id"
        resource_creator = options[:resource][:creator]
        resource_context = options[:resource][:context]

        request_parameters = options[:parameters]

        parent_exists = ! options[:parent].nil?

        if parent_exists
          parent_names = options[:parent][:name].to_s.pluralize
          parent_creator = options[:parent][:creator]
          parent_name_id = "#{options[:parent][:name]}_id"

          plural_url = "/#{parent_names}/:#{parent_name_id}/#{resource_names}"
          singular_url = "#{plural_url}/:#{resource_name_id}"

          let(:parent_instance) { self.instance_eval &parent_creator}
          let(parent_name_id) { parent_instance.id }
        else
          plural_url = "/#{resource_names}"
          singular_url = "#{plural_url}/:#{resource_name_id}"
        end

        only_actions = options[:only] || [ :index, :show, :update, :destroy, :create ]
        except = options[:except] || []
        actions = only_actions - except

        shared_context 'with_single_resource_instance' do 
          let!(:resource_instance) do
            if parent_exists
              resource_creator.call(1, parent_instance)
            else
              resource_creator.call(1)
            end
          end
        end

        shared_context 'with_parameters' do
          request_parameters.each do |key, detail|
            parameter key, detail[:desc], detail[:options]
            let(key) do
              detail[:value].is_a?(Proc) ?
                detail[:value].call :
                detail[:value]
            end
          end
          let(resource_name_id) { resource_instance.id }
        end

        # index spec
        if actions.include?(:index)
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
        end

        # show spec
        if actions.include?(:show)
          get singular_url do
            include_context 'with_single_resource_instance'
            let(resource_name_id) { resource_instance.id }

            example 'Show' do
              do_request
              expect(JSON.parse(response_body)['id']).to eq(resource_instance.id)
            end
          end
        end

        # Create spec
        if actions.include?(:create)
          post plural_url do
            include_context 'with_parameters'
            example 'Create' do
              do_request

              if parent_exists
                expect(resource_context.call(parent_instance).count).to eq 1
              else
                expect(resource_context.call.count).to eq 1
              end

            end
          end
        end

        # Update spec
        if actions.include?(:update)
          put singular_url do
            include_context 'with_single_resource_instance'
            include_context 'with_parameters'

            example 'Updating' do
              do_request

              resource_instance.reload
              request_parameters.each do |key, val|
                expect(resource_instance.send(key)).to eq(send(key))
              end
            end
          end
        end

        # destroy spec
        if actions.include?(:destroy)
          delete singular_url do
            include_context 'with_single_resource_instance'
            let(resource_name_id) { resource_instance.id }

            example 'Deletion' do
              do_request
              if parent_exists
                expect(resource_context.call(parent_instance)
                                       .where(:id => resource_instance.id)).to be_empty
              else
                expect(resource_context.call
                                       .where(:id => resource_instance.id)).to be_empty
              end
            end
          end
        end
        
      end
    end
  end
end
