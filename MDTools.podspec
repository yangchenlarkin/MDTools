#
# Be sure to run `pod lib lint MDTools.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MDTools'
  s.version          = '0.2.2'
  s.summary          = 'Tools for Objcetive-C.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/yangchenlarkin/MDTools'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Larkin' => 'yangchenlarkin@gmail.com' }
  s.platform      = :ios, "11.0"
  s.source           = { :git => 'https://github.com/yangchenlarkin/MDTools.git', :tag => s.version }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.framework     = "Foundation"
  
  s.subspec 'MDListener' do |a|
    a.name          = "MDListener"
    a.source_files  = "MDTools/Classes/MDListener/*.{h,m}"
  end

  s.subspec 'MDTask' do |a|
    a.name         = "MDTask"
    a.source_files = "MDTools/Classes/MDTask/*.{h,m}"
  end

  s.subspec 'MDProtocolImplementation' do |a|
    a.name         = "MDProtocolImplementation"
    a.source_files = "MDTools/Classes/MDProtocolImplementation/*.{h,m}"
  end

  s.subspec 'MDModuleManager' do |a|
    a.name         = "MDModuleManager"
    a.source_files = "MDTools/Classes/MDModuleManager/*.{h,m}"
    a.dependency 'MDTools/MDProtocolImplementation'
    a.dependency 'Aspects', '~> 1.4.1'
  end
  
  s.subspec 'MDCommonDefines' do |a|
      a.name          = "MDCommonDefines"
      a.source_files  = "MDTools/Classes/MDCommonDefines/**/*"
  end

  s.subspec 'MDObjectCacher' do |a|
      a.name = "MDObjectCacher"
      a.source_files = "MDTools/Classes/MDObjectCacher/**/*"
      a.dependency "MDTools/MDCommonDefines"
  end

  s.subspec 'MDUI' do |a|
      a.name = 'MDUI'
      a.subspec 'MDLockSlider' do |b|
          b.name          = "MDLockSlider"
          b.source_files  = "MDTools/Classes/MDUI/MDLockSlider/**/*"
      end
      a.subspec 'MDUtils' do |b|
          b.name = "MDUtils"
          b.source_files = "MDTools/Classes/MDUI/MDUtils/**/*"
          b.dependency "Aspects"
          b.dependency "MBProgressHUD", "~>1.1.0"
          b.dependency "MDTools/MDCommonDefines"
          b.dependency "MDTools/MDListener"
      end
  end

  s.subspec 'MDGCDTimer' do |a|
      a.name          = "MDGCDTimer"
      a.source_files  = "MDTools/Classes/MDGCDTimer/**/*"
      a.dependency "MDTools/MDCommonDefines"
  end

  s.subspec 'MDRedisClient' do |a|
      a.name          = "MDRedisClient"
      a.source_files  = "MDTools/Classes/MDRedisClient/**/*"
      a.dependency "MDTools/MDCommonDefines"
      a.dependency "hiredis"
  end

  s.subspec 'MDFBRetainCycleDetector' do |a|
      a.name          = "MDFBRetainCycleDetector"
      a.source_files  = "MDTools/Classes/MDFBRetainCycleDetector/**/*"
      a.dependency "FBAllocationTracker"
      a.dependency "FBRetainCycleDetector"
  end

  s.subspec 'MDUtils' do |a|
      a.name = "MDUtils"
      a.source_files = 'MDTools/Classes/MDUtils/**/*'
      a.dependency 'YYCategories', '~> 1.0.4'
  end
  
  s.subspec 'MDKeyValueCache' do |a|
      a.name = "MDKeyValueCache"
      a.source_files = 'MDTools/Classes/MDKeyValueCache/**/*'
      a.dependency "MDTools/MDLock"
  end
  
  s.subspec 'MDLock' do |a|
      a.name = "MDLock"
      a.source_files = 'MDTools/Classes/MDLock/**/*'
  end
end
