source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target ‘musicAPP’ do
    pod 'Alamofire', '~> 4.0'
    pod 'AlamofireImage', '~> 3.1'
    pod 'SwiftyJSON'
    pod 'RealmSwift'
    pod 'SlideMenuControllerSwift'
    pod 'RxSwift',    '~> 3.0'
    pod 'RxCocoa',    '~> 3.0'
    pod 'ReachabilitySwift', '~> 3'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end