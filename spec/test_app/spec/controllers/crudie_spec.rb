require 'rails_helper'
require 'crudie/spec'

RSpec.describe ProjectsController, :type => :controller do
  extend Crudie::Spec
  test_create(:project)
  test_index(:project)
  test_show(:project)
  test_update(:project)
  test_destroy(:project)
end
