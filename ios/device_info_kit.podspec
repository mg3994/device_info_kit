Pod::Spec.new do |s|
  s.name             = 'device_info_kit'
  s.version          = '0.1.0'
  s.summary          = 'DartNative device info plugin'
  s.description      = <<-DESC
Native device info plugin for DartNative framework.
                       DESC
  s.homepage         = 'https://github.com/mg3994/device_info_kit'
  s.license          = { :type => 'BSD', :file => 'LICENSE' }
  s.author           = { 'mg3994' => 'manishgautammg7@yahoo.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.platform         = :ios, '13.0'
  s.swift_version    = '5.0'
end