# Crudie
`Crudie` is a Rails plugin handling CRUD API in controller level given a resource.

## Features:
- View layer decoupled
- API parameters decoupled
- Nested resource is supported by `curdie_context`
- Unit test helpers provided

## In a nut shell:
Say we have a resource `Item` and would like to provide APIs to do Creation, Reading, Updating and Deletion (CRUD) on it.
We can do it by 

```ruby
class ItemsController < ApplicationController
  include Crudie
  crudie :item

  def crudie_context
    Item
  end

  def crudie_params
    params.require(:item).permit(:name)
  end
end
```

## Usage:
To use `Crudie`, you have to
1. include `Crudie` in your controller class:

```ruby
include Crudie
```

2. tell crudie the resource name to handle:
```ruby
crudie :item
```

3. provide two helper methods:
- `crudie_context`: the pool to find the resource, if the resource can be found by `Item.find(id)`, then the pool is `Item`.
if the resource is to be found by `user.items` on the other hand, then the pool is `user.items`

- `crudie_params`: parameter to be passed to `create` and `update`, you can use [Strong Parameters](https://github.com/rails/strong_parameters) to handle `require` and `permit` of the params.


## APIs:
- `::crudie(resource_name[, options])`
  - `resource_name`(required): resource name in *singular form*, will be used to find template and set instance variables
  - `options`(optional): 
    - `:template_base`: template base path, default to `''`, will be prepended to template path when rendering
    - `:template_extension`: template extension to be appended to template path, defualt to '.json.jbuilder'
    - `:only`: an array of method names. Only the methods in the array would be added to controller by `::crudie` 
    - `:except`: an array of method nmae. Method names specified in this array would NOT be added to controller.

## How It Works:
`Crudie` defines five instance methods on controller class when `crudie <resource_name>` is called: `index`, `show`, `create`, `update`, and `destroy`, 
which follows [Rails routing convention](http://guides.rubyonrails.org/routing.html#resource-routing-the-rails-default).

### Instance variable setting:
The defined methods set instance variables on controller after doing CRUD operations (pluralize format is covered). The instance variable can be used in view template.
Say we have a resource named `items`:

```ruby
class ItemsController < ApplicationController
  include Crudie
  crudie :items
end
```

- `create`: `@item` will be set
- `index`: `@items` will be set
- `show`: `@item` will be set
- `update`: `@item` will be set
- `destroy`: no instance variable will be set

### Template Rendering
The defined methods do the CRUD operations on the resource and then render templates based on action name, except `delete`, which renders json to hint result directly.

Say we have a resource named `item`, by invoking `crudie :item`, the `create` method will render template on `items/create.json.jbuilder`


## Example

```ruby
# config/route.rb

resources :user do
  resources :items
end


# app/controllers/items_controller
class ItemsController < ApplicationController
  include Crudie
  crudie :items

  def crudie_context
    User.find(params[:user_id]).items
  end

  def crudie_params
    params.require(:item).permit(:name)
  end
end

# app/models/user.rb
class User < ActiveRecord::Base
  has_many :items
end

# spec/controllers/items_controller_spec.rb
describe ItemsController do
  include_crudie_spec_for :items, :context_name => :user
end

```

- views to prepare:
- `items/create.json.jbuilder`
- `items/index.json.jbuilder`
- `items/show.json.jbuilder`
- `items/update.json.jbuilder`


## Testing:
### To Run Tests:
- install dependencies by `$ bundle install`
- run tests by `$ bundle exec rspec spec/`

### Spec helper:

`Crudie` provides spec helper to do 

1. unit tests using RSpec  
2. acceptance test using [rspec_api_documentation](https://github.com/zipmark/rspec_api_documentation)


### Unit test using rspec
```ruby
# controller file
class ItemsController < ApplicationController
  include Crudie
  crudie :items
end

# spec
require 'crudie/spec'
describe ItemsController do
  include Crudie::Spec::Unit
  include_crudie_spec_for :items, :context_name => :user,
                          :only => [ :index, :show, :update ],
                          :except => [ :destroy ]
end
```

### Accepting Test using rspec_api_documentation
1. resource without parent
```ruby
# in spec/acceptance/users_spec.rb

require 'rails_helper'
require 'rspec_api_documentation/dsl'
require 'crudie/spec'

resource 'User' do
  include Crudie::Spec::Acceptance
  include_acceptance_spec_for :resource => {
                                :name => :user,
                                :creator => Proc.new {|index| User.create :name => index },
                                :context => Proc.new { User.all }
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
```

2. resource with parent:
```ruby
# in spec/acceptance/projects_spec.rb

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
```
### Note:
- `parameters[:key][:value]` can take either value or `Proc`

# Licence: 
MIT
