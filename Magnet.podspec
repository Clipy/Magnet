Pod::Spec.new do |s|
  s.name         = "Magnet"
  s.version      = "2.3.0"
  s.summary      = "Customize global hotkeys in macOS."
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage     = "https://github.com/Clipy/Magnet"
  s.author       = { "Econa77" => "f.s.1992.ip@gmail.com" }
  s.source       = { :git => "https://github.com/Clipy/Magnet.git", :tag => "v#{s.version}" }
  s.platform     = :osx, '10.9'
  s.source_files = 'Lib/Magnet/*.swift'
  s.frameworks   = 'Carbon', 'Cocoa'
end
