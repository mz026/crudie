require 'rails_helper'
require 'rspec_api_documentation/dsl'
require 'crudie/spec'

resource 'Projects' do
  include Crudie::Spec::Acceptance

  include_acceptance_spec_for :project, 
                              :parent => {
                                :name => :user,
                                :creator => ->{ User.create :name => 'jack' }
                              },
                              :resource => {
                                :name => :project,
                                :creator => ->(user, i){ user.projects.create :name => i }
                              }
end
