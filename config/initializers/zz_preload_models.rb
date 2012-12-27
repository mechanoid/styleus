# We preload the models here, to let their component registration take effect
# on the routes builded by their categories later.

# TODO: to be discussed, how to handle this better.
# this active code can break applications, if their libraries depend on later initializers.
# after_initialization before routing would be the best.

Rails.configuration.after_initialize do
  model_path = Rails.root.join 'app/models'

  Dir.open(model_path).each do |file_handler|
    file_path = model_path.join(file_handler)
    require file_path if File.file?(file_path) && file_handler =~ /.*\.rb/
  end
end