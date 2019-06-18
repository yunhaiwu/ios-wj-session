Pod::Spec.new do |s|

s.name             = "WJSession"
s.version          = "2.0"
s.summary          = "用户用户登录/注销管理工具."


s.homepage         = "https://github.com/yunhaiwu"


s.license      = { :type => "MIT", :file => "LICENSE" }

s.author       = { "yunhai.wu" => "halayun@gmail.com" }

s.platform     = :ios, "6.0"

s.source       = { :git => "https://github.com/yunhaiwu/ios-wj-session.git", :tag => "#{s.version}" }

s.exclude_files = "Example"


s.frameworks = "Foundation", "UIKit"

s.requires_arc = true

s.source_files = 'Classes/*.{h,m}'
s.public_header_files = 'Classes/*.h'

s.dependency 'WJCacheAPI'

end
