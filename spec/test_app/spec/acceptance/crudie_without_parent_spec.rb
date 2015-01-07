require 'rails_helper'
require 'rspec_api_documentation/dsl'
require 'crudie/spec'

resource 'User' do
  include Crudie::Spec::Acceptance

  include_acceptance_spec_for :user, 
                              :resource => {
                                :name => :user,
                                :creator => ->(index){ User.create :name => index },
                                :context => ->{ User.all }
                              },
                              :parameters => {
                                :name => {
                                  :desc => 'user name',
                                  :value => 'the new user name',
                                  :options => {
                                    :scope => :user,
                                    :required => true
                                  }
                                }
                              }
end
