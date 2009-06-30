use Merb::Rack::Static, ChefServerSlice.dir_for(:public)
run Merb::Rack::Application.new
