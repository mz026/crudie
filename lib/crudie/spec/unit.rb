# Crudie spec
# usage:
# RSpec.describe ProjectsController, :type => :controller do
#   include Crudie::Spec
#   include_crudie_spec_for :project, :context_name => :user
# end
module Crudie::Spec::Unit
  def self.included base
    class << base
      def include_crudie_spec_for resource, options = {}
        context_name = options[:context_name]

        methods_to_test = options[:only] || [ :create, :index, :update, :show, :destroy ]
        excluded_methods = options[:except] || []
        methods_to_test = methods_to_test - excluded_methods

        describe "Crudie spec for `#{resource}`" do
          let(:resource) { resource }
          let(:resources) { resource.to_s.pluralize }
          context 

          methods_to_test.each { |m| send("test_#{m}".to_sym, resource, context_name) }
        end
      end

      private
      def context
        let(:crudie_context) { double(:crudie_context, :find => crudie_instance) }
        let(:crudie_instance) { double(:crudie_instance, :valid? => true) }
        before :each do
          allow(controller).to receive(:crudie_context).and_return(crudie_context)
        end
      end

      def test_index resource, context_name
        describe 'GET :index' do
          let(:params) do
            prm = {}
            prm["#{context_name}_id"] = 123 if context_name
            prm
          end
          it "returns projects of user" do
            get :index, params
            expect(controller.instance_variable_get("@#{resources}")).to be(crudie_context)
            expect(response.status).to eq 200
          end
        end
        
      end

      def test_create resource, context_name
        describe "POST :create" do
          let(:params) do
            prm = {}
            prm["#{context_name}_id".to_sym] = 123 if context_name
            prm[resource] = { 'key' => 'val' }
            prm
          end

          before :each do
            allow(controller).to receive(:crudie_params).and_return(params[resource])
            expect(crudie_context).to receive(:create).with(params[resource]).and_return(crudie_instance)
          end

          it "creates a #{resource} under context" do
            post :create, params
          end

          it "sets controller.@#{resource} as #{resource}" do
            post :create, params
            
            expect(controller.instance_variable_get("@#{resource}")).to be(crudie_instance)
          end

          it "returns 409 if resource is not valid" do
            allow(crudie_instance).to receive_messages(:valid? => false,
                                                       :errors => double(:messages => 'the messages'))
            post :create, params
            expect(response.status).to eq 409
          end
        end
      end


      def test_show resource, context_name
        describe "GET :show" do
          let(:params) do
            prm = { :id => 123 }
            prm["#{context_name}_id"] = 123 if context_name
            prm
          end

          it "shows the resource instance by id" do
            get :show, params
            expect(controller.instance_variable_get("@#{resource}")).to be crudie_instance 
          end
        end
        
      end

      def test_update resource, context_name
        describe "PUT :update" do
          let(:params) do
            prm = { :id => 123, resource => { 'key' => 'val' } }
            prm["#{context_name}_id"] = 123 if context_name
            prm
          end
          before :each do
            allow(controller).to receive(:crudie_params).and_return(params[resource])
          end

          it "updates instance" do
            expect(crudie_instance).to receive(:update_attributes).with(params[resource])
                                                                  .and_return(true)
            put :update, params
            expect(controller.instance_variable_get("@#{resource}")).to be crudie_instance
          end

          it "render 409 if updating failed" do
            expect(crudie_instance).to receive(:update_attributes)
                                         .with(params[resource]).and_return(false)
            expect(crudie_instance).to receive(:errors).and_return(double(:messages => 'the messages'))

            put :update, params
            expect(response.status).to eq 409
          end
          
        end

      end

      def test_destroy resource, context_name
        describe "DELETE :destroy" do
          let(:params) do
            prm = { :id => 123 }
            prm["#{context_name}_id"] = 123 if context_name
            prm
          end
          
          it "destroy the instance" do
            expect(crudie_instance).to receive(:destroy)
            delete :destroy, params
          end
        end
        
      end

    end
  end
end
