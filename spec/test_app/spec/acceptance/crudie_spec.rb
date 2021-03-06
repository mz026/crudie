require 'rails_helper'
require 'rspec_api_documentation/dsl'
require 'crudie/spec'

resource 'Projects' do
  include Crudie::Spec::Acceptance
  include_acceptance_spec_for :parent => {
                                :name => :user,
                                :creator => Proc.new { User.create :name => 'jack' }
                              },
                              :resource => {
                                :name => :project,
                                :creator => Proc.new {|i, user| user.projects.create :name => i },
                                :context => Proc.new {|parent| parent.projects }
                              },
                              :parameters => {
                                :name => {
                                  :desc => 'project name',
                                  :value => 'the new project name',
                                  :options => {
                                    :scope => :project,
                                    :required => true
                                  }
                                }
                              }
end
