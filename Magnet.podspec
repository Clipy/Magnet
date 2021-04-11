Pod::Spec.new do |s|
  s.name         = "Magnet"
  s.version      = "3.2.0"
  s.summary      = "Customize global hotkeys in macOS."
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage     = "https://github.com/Clipy/Magnet"
  s.author       = { "Econa77" => "f.s.1992.ip@gmail.com" }
  s.source       = { :git => "https://github.com/Clipy/Magnet.git", :tag => "v#{s.version}" }
  s.platform     = :osx, '10.10'
  s.source_files = 'Lib/Magnet/**/*.swift'
  s.swift_version = '5.0'
  s.frameworks   = 'Carbon', 'Cocoa'
  s.dependency 'Sauce', '~> 2.2'
end
