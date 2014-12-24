require 'rails_helper'
require 'crudie/spec'

RSpec.describe ProjectsController, :type => :controller do
  extend Crudie::Spec
  include_crudie_spec :project
end
