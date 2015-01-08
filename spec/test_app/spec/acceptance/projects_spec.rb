require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Projects' do
  # context
  let(:user) { User.create :name => 'jack' }
  let(:user_id) { user.id }

  
  get '/users/:user_id/projects' do
    let!(:projects) do
      3.times do |i|
        user.projects.create :name => "project #{i}"
      end
    end

    example 'Index' do
      do_request
      expect(response_status).to eq 200
      expect(JSON.parse(response_body).count).to eq 3
    end
  end

  get '/users/:user_id/projects/:project_id' do
    let!(:project) do
      user.projects.create :name => "project name"
    end
    let(:project_id) { project.id }

    example 'Show' do
      do_request
      expect(JSON.parse(response_body)['id']).to eq(project.id)
    end
  end

  post '/users/:user_id/projects' do
    parameter :user_id, 'user id', required: true
    parameter :name, 'project name', :scope => :project
    let(:name) { 'project name' }
    
    example 'Create' do
      do_request

      expect(user.projects.count).to eq 1
    end
  end

  put '/users/:user_id/projects/:project_id' do
    parameter :user_id, 'user id', :required => true
    parameter :name, 'new name of project', :scope => :project
    let!(:project) { user.projects.create :name => 'old name' }
    let(:project_id) { project.id }
    let(:name) { 'new name' }

    example 'Updating' do
      do_request

      project.reload
      expect(project.name).to eq 'new name'
    end
  end

  delete '/users/:user_id/projects/:project_id' do
    parameter :user_id, 'user id', :required => true
    let!(:project) { user.projects.create :name => 'old name' }
    let(:project_id) { project.id }

    example 'Deletion' do
      do_request
      expect(Project.where(project.id)).to be_empty
    end
  end

end
