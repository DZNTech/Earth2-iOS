platform :ios, '13.0'
use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

def ios_app_pods
  # UI
  pod 'SnapKit'
  pod 'SwiftValidators', :inhibit_warnings => true
  pod 'UICountingLabel'
  pod 'PanModal'
  pod 'ShimmerSwift'
  pod 'EmptyDataSet-Swift'
end

def api_pods
  # Network
  pod 'Alamofire', '~> 4.9.1'
  pod 'AlamofireImage', '~> 3.6.0'
  pod 'AlamofireNetworkActivityIndicator', '~> 2.4.0'
  pod 'AlamofireObjectMapper', '~> 5.2.1'

  # Data Parsing
  pod 'SwiftyJSON'
  pod 'ObjectMapper', :inhibit_warnings => true

  # Security
  pod 'Valet', '~> 3.2.8'
end

target 'Earth2' do
  ios_app_pods
end

target 'Earth2Tests' do
  ios_app_pods
end

target 'E2API' do
  api_pods
end

target 'E2APITests' do
  api_pods
end

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
      end
    end
end
