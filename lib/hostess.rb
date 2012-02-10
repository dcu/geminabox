require 'sinatra/base'

class Hostess < Sinatra::Base
  set :secure_path, ENV['GEMBOX_SECUREPATH'] || '/private'

  def serve
    path = request.path_info.sub(Hostess.secure_path, "")
    send_file(File.expand_path(File.join(Geminabox.data, *path)), :type => response['Content-Type'])
  end

  %w[/specs.4.8.gz
     /latest_specs.4.8.gz
     /prerelease_specs.4.8.gz
  ].each do |index|
    get "#{Hostess.secure_path}#{index}" do
      content_type('application/x-gzip')
      serve
    end
  end

  %w[/quick/Marshal.4.8/*.gemspec.rz
     /yaml.Z
     /Marshal.4.8.Z
  ].each do |deflated_index|
    get "#{Hostess.secure_path}#{deflated_index}" do
      content_type('application/x-deflate')
      serve
    end
  end

  %w[/yaml
     /Marshal.4.8
     /specs.4.8
     /latest_specs.4.8
     /prerelease_specs.4.8
  ].each do |old_index|
    get "#{Hostess.secure_path}#{old_index}" do
      serve
    end
  end

  get "#{Hostess.secure_path}/gems/*.gem" do
    serve
  end
end
