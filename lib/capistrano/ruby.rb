require "capistrano/ruby/version"
require "capistrano/ubuntu"

module Capistrano
  module Ruby
    # Your code goes here...
  end
end


import File.expand_path("../tasks/ruby.rake", __FILE__)
