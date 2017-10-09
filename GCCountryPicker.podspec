Pod::Spec.new do |s|
  s.name = 'GCCountryPicker'
  s.version = '1.0.4'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.summary = 'A localized, searchable country picker view controller for iOS 11+ written in Swift.'
  s.description  = <<-DESC
                   A localized, searchable country picker view controller UI component for iOS 11+ written in Swift.
                   DESC
  s.homepage = 'https://github.com/graycampbell/GCCountryPicker'
  s.author = 'Gray Campbell'
  s.source = { :git => 'https://github.com/graycampbell/GCCountryPicker.git', :tag => s.version }

  s.ios.deployment_target = '11.0'

  s.source_files = 'GCCountryPicker/*.{h,m,swift}'

  s.requires_arc = true
  s.module_name = 'GCCountryPicker'
end
