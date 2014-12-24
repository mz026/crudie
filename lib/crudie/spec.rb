module Crudie
  module Spec
    def test_post resource
      resource = :project
      resources = :projects
      context = :user


      describe "POST :create" do
        let(:crudie_context) { double(:curdie_context, :find => crudie_instance) }
        let(:crudie_instance) { double(:curdie_instance, :valid? => true) }


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
  end
end
