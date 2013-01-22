require 'fileutils'

begin
  config_file = File.expand_path(File.join(Rails.root, '/config/config.yml'))
  config = YAML.load_file(config_file)

  config.each do |key, value|
    ENV[key] = value
  end
rescue Errno::ENOENT
end
