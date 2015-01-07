require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Projects' do
  get '/users/:user_id/projects' do
    # context
    let(:user) { User.create :name => 'jack' }
    let(:user_id) { user.id }
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
end
