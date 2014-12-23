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
    it 'creates project under user' do
      expect(projects).to receive(:create).with(params[:project]).and_return(project)
      post :create, params
    end
  end
end
