# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'
use_frameworks!

def common_pods
  
  # Swift style
  pod 'SwiftLint', '0.47.1'
  
  # Resource manager
  pod 'R.swift', '7.3.0'
  
  # RxSwift
  pod 'RxSwift', '6.5.0'
  pod 'RxCocoa', '6.5.0'
  
  # NetWork
  pod 'Moya', '15.0.0'
    
  # Load Net Img
  pod 'Kingfisher', '7.7.0'
    
  # UI Layout
  pod 'SnapKit', '5.6.0'
end

target 'LXSummary' do
  # Comment the next line if you don't want to use dynamic frameworks
  common_pods

  # Pods for LXSummary

  target 'LXSummaryTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxTest'
  end

  target 'LXSummaryUITests' do
    # Pods for testing
  end

end
