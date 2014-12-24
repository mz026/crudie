require 'rails_helper'
require 'crudie/spec'

RSpec.describe ProjectsController, :type => :controller do
  include Crudie::Spec
  include_crudie_spec_for :project, :context_name => :user
end
