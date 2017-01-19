Pod::Spec.new do |s|
s.name             = 'FlubberView'
s.version          = '0.0.3'
s.summary          = 'A very special UIView subclass.'

s.description      = <<-DESC
A UIView subclass that makes use of UIKit Dynamics to animate a jiggle effect.
DESC

s.homepage         = 'https://github.com/NiceThings/FlubberView'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Matt Buckley' => 'matt@nicethings.io' }
s.source           = { :git => 'https://github.com/NiceThings/FlubberView.git', :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/_nicethings_'

s.ios.deployment_target = '9.0'

s.source_files = 'FlubberView/**/*'

end
