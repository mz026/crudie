module Crudie
  module Spec

    def test_index resource
      resource = :project
      resources = :projects
      context = :user

      describe 'GET :index' do
        let(:crudie_context) { double(:crudie_context, :find => crudie_instance) }
        let(:crudie_instance) { double(:crudie_instance, :valid? => true) }
        before :each do
          allow(controller).to receive(:crudie_context).and_return(crudie_context)
        end
        let(:params) do
          {
            :user_id => 123
          }
        end
        it "returns projects of user" do
          get :index, params
          expect(controller.instance_variable_get("@#{resources}")).to be(crudie_context)
          expect(response.status).to eq 200
        end
      end
      
    end

    def test_create resource
      resource = :project
      resources = :projects
      context = :user


      describe "POST :create" do
        let(:crudie_context) { double(:crudie_context, :find => crudie_instance) }
        let(:crudie_instance) { double(:crudie_instance, :valid? => true) }
        before :each do
          allow(controller).to receive(:crudie_context).and_return(crudie_context)
        end

        let(:params) do
          {
            :user_id => 123,
            :project => {
              :name => 'sample project name'
            }
          }
        end

        before :each do
          expect(crudie_context).to receive(:create).with(params[resource]).and_return(crudie_instance)
        end

        it "creates a #{resource} under #{context}" do
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


    def test_show resource
      resource = :project
      resources = :projects
      context = :user

      describe "GET :show" do
        let(:crudie_context) { double(:crudie_context, :find => crudie_instance) }
        let(:crudie_instance) { double(:crudie_instance, :valid? => true) }
        before :each do
          allow(controller).to receive(:crudie_context).and_return(crudie_context)
        end
        let(:params) do
          {
            :id => 111,
            :user_id => 123
          }
        end
        before :each do
          allow(crudie_context).to receive(:find).and_return(crudie_instance)
        end

        it "shows the resource instance by id" do
          get :show, params
          expect(controller.instance_variable_get("@#{resource}")).to be crudie_instance 
        end
      end
      
    end

    def test_update resource
      resource = :project
      resources = :projects
      context = :user

      describe "PUT :update" do
        let(:crudie_context) { double(:crudie_context, :find => crudie_instance) }
        let(:crudie_instance) { double(:crudie_instance, :valid? => true) }
        before :each do
          allow(controller).to receive(:crudie_context).and_return(crudie_context)
        end
        let(:params) do
          {
            :id => 111,
            :user_id => 123,
            :project => {
              :name => 'new name'
            }
          }
        end
        before :each do
          allow(crudie_context).to receive(:find).and_return(crudie_instance)
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

    def test_destroy resource
      describe "DELETE :destroy" do
        let(:crudie_context) { double(:crudie_context, :find => crudie_instance) }
        let(:crudie_instance) { double(:crudie_instance, :valid? => true) }
        before :each do
          allow(controller).to receive(:crudie_context).and_return(crudie_context)
        end
        let(:params) do
          {
            :id => 111,
            :user_id => 123
          }
        end
        before :each do
          allow(crudie_context).to receive(:find).and_return(crudie_instance)
        end
        
        it "destroy the instance" do
          expect(crudie_instance).to receive(:destroy)
          delete :destroy, params
        end
      end
      
    end

  end
end
