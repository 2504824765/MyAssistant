# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'iAssistant' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for iAssistant
  pod 'Alamofire'
  pod 'SwiftyJSON', '~> 4.0'
  
  # 加载swiftyJSON之后报错error: SDK does not contain 'libarclite' at the path
  # 似乎是因为项目支持的ios不一样，添加上下面者几行之后重新pod install可以正常编译
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "11.0"
      end
    end
  end

end
