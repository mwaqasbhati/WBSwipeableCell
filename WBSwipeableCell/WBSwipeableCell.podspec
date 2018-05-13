#
# Be sure to run `pod lib lint WBSwipeableCell.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WBSwipeableCell'
  s.version          = '0.1.0'
  s.summary          = 'This Controller provides custom Option Menu layout for Collection View and Table View Cells'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'This Controller provides 3 type of different layouts for collection view and Table View Cells'

  s.homepage         = 'https://github.com/mwaqasbhati/WBSwipeableCell'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mwaqasbhati' => 'm.waqas.bhati@hotmail.com' }
  s.source           = { :git => 'https://github.com/mwaqasbhati/WBSwipeableCell.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.swift_version = '4.0'
  s.ios.deployment_target = '9.0'
  s.source_files = 'WBSwipeableCell/Classes/**/*'
  s.resource_bundles = {
    'WBSwipeableCell' => ['WBSwipeableCell/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
