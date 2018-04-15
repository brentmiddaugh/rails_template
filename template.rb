def source_paths
  Array(super) +
    [File.join(File.expand_path(File.dirname(__FILE__)),'rails_root')]
end

# Add Default Gems
gem "devise"
gem "pundit"

gem_group :development, :test do
  gem "faker"
end

gem_group :development do
  gem 'letter_opener'
  gem 'guard', require: false
  gem 'guard-livereload', require: false
  gem 'guard-minitest', require: false
  gem 'rack-livereload'
  gem 'rubocop', require: false
  gem 'simplecov', require: false
end

#Install Gems
run "bundle install"

# Install and Setup Devise
rails_command "g devise:install"
environment 'config.action_mailer.default_url_options = {host: "http://localhost:3000"}', env: 'development'
rails_command "g devise User username avatar"

# Install Pundit
rails_command "g pundit:install"

# Add Role and Permission Models
rails_command "g model Role name"
rails_command "g model Permission name model_name can_create:boolean can_read:boolean can_update:boolean can_delete:boolean"
rails_command "g model UserRole user:references role:references"
rails_command "g model RolePermission role:references permission:references"

# Add Guard File
inside "." do
  copy_file 'Guardfile'
end

# Add default application controller
remove_file 'app/controllers/application_controller.rb'
inside "app" do
  inside "controllers" do
    copy_file 'template_application_controller.rb', 'application_controller.rb'
  end
end
