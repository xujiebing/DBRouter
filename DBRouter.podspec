Pod::Spec.new do |s|
  s.name             = 'DBRouter'
  s.version          = '1.0.1'
  s.summary          = 'A short description of DBRouter.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/xujiebing/DBRouter'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xujiebing' => 'xujiebing@bwton.com' }
  s.source           = { :git => 'https://github.com/xujiebing/DBRouter.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'DBRouter/Classes/**/*'
  s.prefix_header_file = 'DBRouter/Classes/DBRouterPrefixHeader.pch'
  
end
