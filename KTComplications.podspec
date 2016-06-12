#
# Be sure to run `pod lib lint KTComplications.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KTComplications'
  s.version          = '0.1.0'
  s.summary          = 'WatchOS 2 Complications framework.'

  s.description      = <<-DESC
    KTComplications is a convenience pod for creating Apple Watch complications faster.
                       DESC

  s.homepage         = 'https://github.com/kvtaniguchi/KTComplications'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kevin Taniguchi' => 'ktaniguchi@urbn.com' }
  s.source           = { :git => 'https://github.com/kvtaniguchi/KTComplications.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'KTComplications/Classes/**/*'
end
