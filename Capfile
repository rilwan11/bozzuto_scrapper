set :stages, %w(development staging prod)
require 'capistrano/ext/multistage'

load 'deploy' if respond_to?(:namespace) # cap2 differentiator


load 'config/deploy' # remove this line to skip loading any of the default tasks