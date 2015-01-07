# Crudie spec
#
# Crudie::Spec::Unit
# usage:
# RSpec.describe ProjectsController, :type => :controller do
#   include Crudie::Spec
#   include_crudie_spec_for :project, :context_name => :user
# end

module Crudie
  module Spec
    require 'crudie/spec/unit'
  end
end
