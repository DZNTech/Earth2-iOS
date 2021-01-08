platform :ios, '11.0'
use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

target 'Earth2' do
  # UI
  pod 'EmptyDataSet-Swift'
  pod 'SnapKit'
  pod 'QRCode', :git => 'https://github.com/andrewcampoli/QRCode.git', :inhibit_warnings => true
  pod 'ShimmerSwift'
end

target 'E2API' do
    # Network
    pod 'Alamofire', '~> 4.9.1'
    pod 'AlamofireImage', '~> 3.6.0'
    pod 'AlamofireNetworkActivityIndicator', '~> 2.4.0'
    pod 'AlamofireObjectMapper', '~> 5.2.1'

    # Data Parsing
    pod 'SwiftyJSON'
    pod 'ObjectMapper', :inhibit_warnings => true

    # Security
    pod 'Valet'
end

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
end