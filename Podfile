# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Chottky' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  ##platform :io '9.0'
  # Pods for Chottky

  pod 'Firebase/Core'
  pod 'Firebase', '4.0.3'
  pod 'Firebase/Auth'
  pod 'GoogleSignIn'
  pod 'Firebase/AdMob'
  pod 'Firebase/Messaging'
  pod 'Firebase/Database'
  pod 'Firebase/Crash'
  pod 'Firebase/Storage'
  pod 'Google'
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'FacebookShare'
  pod 'GeoFire', :git => 'https://github.com/firebase/geofire-objc.git'
  pod 'SideMenu'
  ##pod 'SwiftyCam'
  pod 'FirebaseUI/Storage'
  pod 'SDWebImage', '~>4.0'
  pod 'PageMenu'
  pod 'lottie-ios'
  pod 'ESTabBarController-swift'
  pod 'ROGoogleTranslate'
  pod "SwiftyCam"
end

  post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'GeoFire' then
      target.build_configurations.each do |config|
        config.build_settings['FRAMEWORK_SEARCH_PATHS'] = "#{config.build_settings['FRAMEWORK_SEARCH_PATHS']} ${PODS_ROOT}/FirebaseDatabase/Frameworks/ $PODS_CONFIGURATION_BUILD_DIR/GoogleToolboxForMac"
        config.build_settings['OTHER_LDFLAGS'] = "#{config.build_settings['OTHER_LDFLAGS']} -framework FirebaseDatabase"
      end
    end
  end
end
