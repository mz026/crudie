require 'rails_helper'
require 'crudie/spec'

RSpec.describe ProjectsController, :type => :controller do
  extend Crudie::Spec
  test_post(:project)

  let(:user) { double(:user, :projects => projects) }
  let(:projects) { double(:projects) }
  let(:project) { double(:project, :valid? => true) }
  before :each do
    allow(User).to receive(:find).and_return(user)
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
      expect(project).to receive(:update_attributes).with(params[:project]).and_return(true)
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

  describe "DELETE :destroy" do
    let(:params) do
      {
        :id => 111,
        :user_id => 123
      }
    end
    before :each do
      allow(projects).to receive(:find).and_return(project)
    end
    
    it "destroy the instance" do
      expect(project).to receive(:destroy)
      delete :destroy, params
    end
  end
end
