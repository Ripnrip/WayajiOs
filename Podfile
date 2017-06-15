# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Wayaj' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Wayaj
  
  pod 'OneSignal'	
  pod 'Spring', :git => 'https://github.com/MengTo/Spring.git', :branch => 'swift3'
  pod 'paper-onboarding', '~> 2.0.1' 
  pod "AMTooltip"
  pod 'Eureka', '~> 2.0.0-beta.1'
  pod 'LocationPickerViewController'
  pod 'AWSCore'
  pod 'AWSCognito'
  pod 'AWSCognitoIdentityProvider'
  pod 'AWSDynamoDB'
  pod 'AWSS3'
  pod 'AWSLambda'
  pod 'AWSSNS'



  target 'WayajTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'WayajUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'OneSignalNotificationServiceExtension' do
      pod 'OneSignal', '>= 2.5.2', '< 3.0'
  end
  

end
