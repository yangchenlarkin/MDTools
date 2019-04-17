#
#  Be sure to run `pod spec lint LTools.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name          = "MDTools"
  s.version       = "0.0.7"
  s.summary       = "Tools for Objcetive-C."
  s.homepage      = "https://github.com/yangchenlarkin/MDTools"
  s.license       = "MIT"
  s.author        = { "xupeng48" => "13585548248@163.com" }
  s.platform      = :ios
  s.source        = { :git => "https://github.com/yangchenlarkin/MDTools.git", :tag => "#{s.version}" }
  s.source_files  = "MDTools/**/*"
  s.framework     = "Foundation"

  s.subspec 'MDListener' do |sl|
    sl.name          = "MDListener"
    sl.source_files  = "MDTools/MDListener/*.{h,m}"
  end

  s.subspec 'MDTask' do |st|
    st.name         = "MDTask"
    st.source_files = "MDTools/MDTask/*.{h,m}"
  end

  s.subspec 'MDProtocolImplementation' do |sp|
    sp.name         = "MDProtocolImplementation"
    sp.source_files = "MDTools/MDProtocolImplementation/*.{h,m}"
  end

  s.subspec 'MDModuleManager' do |sm|
    sm.name         = "MDModuleManager"
    sm.source_files = "MDTools/MDModuleManager/*.{h,m}"
    sm.dependency 'MDTools/MDProtocolImplementation'
    sm.dependency 'Aspects', '~> 1.4.1'
  end

end
