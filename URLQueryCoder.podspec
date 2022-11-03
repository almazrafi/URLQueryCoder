Pod::Spec.new do |spec|
  spec.name = "URLQueryCoder"
  spec.version = "1.0.1"
  spec.summary = "Swift Encoder and Decoder for URL query"

  spec.homepage = "https://github.com/almazrafi/URLQueryCoder"
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.author = { "Almaz Ibragimov" => "almazrafi@gmail.com" }
  spec.source = { :git => "https://github.com/almazrafi/URLQueryCoder.git", :tag => "#{spec.version}" }

  spec.swift_version = '5.5'
  spec.requires_arc = true
  spec.source_files = 'Sources/**/*.swift'

  spec.ios.frameworks = 'Foundation'
  spec.ios.deployment_target = "12.0"

  spec.osx.frameworks = 'Foundation'
  spec.osx.deployment_target = "10.14"

  spec.watchos.frameworks = 'Foundation'
  spec.watchos.deployment_target = "5.0"

  spec.tvos.frameworks = 'Foundation'
  spec.tvos.deployment_target = "12.0"
end
