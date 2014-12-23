require 'rails_helper'

RSpec.describe ProjectsController, :type => :controller do
  let(:user) { double(:user, :projects => projects) }
  let(:projects) { double(:projects) }
  let(:project) { double(:project, :valid? => true) }
  before :each do
    allow(User).to receive(:find).and_return(user)
  end

  describe 'POST :create' do
    let(:params) do
      {
        :user_id => 123,
        :project => {
          :name => 'sample project name'
        }
      }
    end

    before :each do
      expect(projects).to receive(:create).with(params[:project]).and_return(project)
    end

    it 'creates project under user' do
      post :create, params
    end

    it "sets controller.@project as project" do
      post :create, params
      
      expect(controller.instance_variable_get(:@project)).to be(project)
    end

    it "returns 409 if resource is not valid" do
      allow(project).to receive_messages(:valid? => false,
                                         :errors => double(:messages => 'the messages'))
      post :create, params
      expect(response.status).to eq 409
    end
  end

  describe 'GET :index' do
    let(:params) do
      {
        :user_id => 123
      }
    end
    it "returns projects of user" do
      get :index, params
      expect(controller.instance_variable_get(:@projects)).to be(projects)
      expect(response.status).to eq 200
    end
  end

  describe "GET :show" do
    let(:params) do
      {
        :id => 111,
        :user_id => 123
      }
    end
    before :each do
      allow(projects).to receive(:find).and_return(project)
    end

    it "shows the resource instance by id" do
      get :show, params
      expect(controller.instance_variable_get(:@project)).to be project
    end
  end

  describe "PUT :update" do
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
      allow(projects).to receive(:find).and_return(project)
    end

    it "updates instance" do
      expect(project).to receive(:update_attributes).with(params[:project])
      put :update, params
      expect(controller.instance_variable_get(:@project)).to be project
    end

    it "render 409 if updating failed" do
      expect(project).to receive(:update_attributes).with(params[:project]).and_return(false)
      expect(project).to receive(:errors).and_return(double(:messages => 'the messages'))

      put :update, params
      expect(response.status).to eq 409
    end
    
  end
end
