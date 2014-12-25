require 'rails_helper'

describe Crudie do
  describe '::crudie(resource, options)' do
    let(:controller_klass) do
      c = Class.new
      c.send(:include, Crudie)
      c
    end
    it "creates `create`, `index`, `show`, `update`, `destroy` when no option is given" do
      controller_klass.crudie :items

      expected_methods = [ :create, :index, :show, :update, :destroy]
      expected_methods.each do |m|
        expect(controller_klass.instance_methods).to include(m)
      end
    end

    it "creates only the methods specified in `only` option" do
      controller_klass.crudie :items, :only => [:create]
      
      expect(controller_klass.instance_methods).to include(:create)
      expect(controller_klass.instance_methods).not_to include(:update)
    end

    it "excludes the methods listed in `except`" do
      controller_klass.crudie :items, :except => [:create]
      
      expected_methods = [ :index, :show, :update, :destroy]
      expected_methods.each do |m|
        expect(controller_klass.instance_methods).to include(m)
      end
      expect(controller_klass.instance_methods).not_to include(:create)
    end
  end
end

