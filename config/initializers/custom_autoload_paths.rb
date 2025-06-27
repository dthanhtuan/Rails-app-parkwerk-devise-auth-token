Dir[Rails.root.join("domains/*/app/controllers")].each do |controllers_dir|
  Rails.autoloaders.main.push_dir(controllers_dir) if File.directory?(controllers_dir)
end

Dir[Rails.root.join("domains/*/app/models")].each do |models_dir|
  Rails.autoloaders.main.push_dir(models_dir) if File.directory?(models_dir)
end

Dir[Rails.root.join("domains/*/app/mailers")].each do |models_dir|
  Rails.autoloaders.main.push_dir(models_dir) if File.directory?(models_dir)
end
