#
# Be sure to run `pod lib lint MKBLEMokoLife.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MKBLEMokoLife'
  s.version          = '1.0.1'
  s.summary          = 'A short description of MKBLEMokoLife.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/MokoPlug/MokoPlug_iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'aadyx2007@163.com' => 'aadyx2007@163.com' }
  s.source           = { :git => 'https://github.com/MokoPlug/MokoPlug_iOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  
  s.resource_bundles = {
    'MKBLEMokoLife' => ['MKBLEMokoLife/Assets/*.png']
  }
  
  s.subspec 'ApplicationModule' do |ss|
    ss.source_files = 'MKBLEMokoLife/Classes/ApplicationModule/**'
    ss.dependency 'MKBaseModuleLibrary'
  end
  
  s.subspec 'CTMediator' do |ss|
    ss.source_files = 'MKBLEMokoLife/Classes/CTMediator/**'
    
    s.dependency 'CTMediator'
  end
  
  s.subspec 'SDK-BML' do |ss|
    ss.source_files = 'MKBLEMokoLife/Classes/SDK-BML/**'
    
    ss.dependency 'MKBaseBleModule'
  end
  
  s.subspec 'Target' do |ss|
    ss.source_files = 'MKBLEMokoLife/Classes/Target/**'
    
    ss.dependency 'MKBLEMokoLife/Functions'
  end
  
  s.subspec 'Functions' do |ss|
    
    ss.subspec 'AboutPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBLEMokoLife/Classes/Functions/AboutPage/Controller/**'
        
        ssss.dependency 'MKBLEMokoLife/Functions/AboutPage/Model'
        ssss.dependency 'MKBLEMokoLife/Functions/AboutPage/View'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBLEMokoLife/Classes/Functions/AboutPage/Model/**'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBLEMokoLife/Classes/Functions/AboutPage/View/**'
        
        ssss.dependency 'MKBLEMokoLife/Functions/AboutPage/Model'
      end
    end
    
    ss.subspec 'DeviceInfo' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBLEMokoLife/Classes/Functions/DeviceInfo/Controller/**'
        ssss.dependency 'MKBLEMokoLife/Functions/DeviceInfo/Model'

      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBLEMokoLife/Classes/Functions/DeviceInfo/Model/**'
      end
    end
    
    ss.subspec 'EnergyPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBLEMokoLife/Classes/Functions/EnergyPage/Controller/**'
        
        ssss.dependency 'MKBLEMokoLife/Functions/EnergyPage/Model'
        ssss.dependency 'MKBLEMokoLife/Functions/EnergyPage/View'
        
        ssss.dependency 'MKBLEMokoLife/Functions/DeviceInfo/Controller'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBLEMokoLife/Classes/Functions/EnergyPage/Model/**'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBLEMokoLife/Classes/Functions/EnergyPage/View/**'
      end
    end
    
    ss.subspec 'ModifyDataPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBLEMokoLife/Classes/Functions/ModifyDataPage/Controller/**'
      end
    end
    
    ss.subspec 'ModifyPowerStatusPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBLEMokoLife/Classes/Functions/ModifyPowerStatusPage/Controller/**'
      end
    end
    
    ss.subspec 'PowerPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBLEMokoLife/Classes/Functions/PowerPage/Controller/**'
        
        ssss.dependency 'MKBLEMokoLife/Functions/PowerPage/Model'
        ssss.dependency 'MKBLEMokoLife/Functions/PowerPage/View'
        
        ssss.dependency 'MKBLEMokoLife/Functions/DeviceInfo/Controller'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBLEMokoLife/Classes/Functions/PowerPage/Model/**'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBLEMokoLife/Classes/Functions/PowerPage/View/**'
      end
    end
    
    ss.subspec 'ScanPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBLEMokoLife/Classes/Functions/ScanPage/Controller/**'
        
        ssss.dependency 'MKBLEMokoLife/Functions/ScanPage/View'
        
        ssss.dependency 'MKBLEMokoLife/Functions/AboutPage/Controller'
        ssss.dependency 'MKBLEMokoLife/Functions/TabBarPage/Controller'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBLEMokoLife/Classes/Functions/ScanPage/View/**'
      end
    end
    
    ss.subspec 'SettingPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBLEMokoLife/Classes/Functions/SettingPage/Controller/**'
        
        ssss.dependency 'MKBLEMokoLife/Functions/SettingPage/Model'
        ssss.dependency 'MKBLEMokoLife/Functions/SettingPage/View'
        
        ssss.dependency 'MKBLEMokoLife/Functions/DeviceInfo/Controller'
        ssss.dependency 'MKBLEMokoLife/Functions/ModifyDataPage/Controller'
        ssss.dependency 'MKBLEMokoLife/Functions/ModifyPowerStatusPage/Controller'
        ssss.dependency 'MKBLEMokoLife/Functions/UpdatePage/Controller'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBLEMokoLife/Classes/Functions/SettingPage/Model/**'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBLEMokoLife/Classes/Functions/SettingPage/View/**'
      end
    end
    
    ss.subspec 'TabBarPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBLEMokoLife/Classes/Functions/TabBarPage/Controller/**'
        
        ssss.dependency 'MKBLEMokoLife/Functions/PowerPage/Controller'
        ssss.dependency 'MKBLEMokoLife/Functions/EnergyPage/Controller'
        ssss.dependency 'MKBLEMokoLife/Functions/TimerPage/Controller'
        ssss.dependency 'MKBLEMokoLife/Functions/SettingPage/Controller'
      end
    end
    
    ss.subspec 'TimerPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBLEMokoLife/Classes/Functions/TimerPage/Controller/**'
        
        ssss.dependency 'MKBLEMokoLife/Functions/TimerPage/Model'
        ssss.dependency 'MKBLEMokoLife/Functions/TimerPage/View'
        
        ssss.dependency 'MKBLEMokoLife/Functions/DeviceInfo/Controller'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBLEMokoLife/Classes/Functions/TimerPage/Model/**'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBLEMokoLife/Classes/Functions/TimerPage/View/**'
      end
    end
    
    ss.subspec 'UpdatePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBLEMokoLife/Classes/Functions/UpdatePage/Controller/**'
        
        ssss.dependency 'MKBLEMokoLife/Functions/UpdatePage/Model'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBLEMokoLife/Classes/Functions/UpdatePage/Model/**'
      end
      
      sss.dependency 'iOSDFULibrary'
      
    end
    
    ss.dependency 'MKBLEMokoLife/SDK-BML'
    ss.dependency 'MKBLEMokoLife/CTMediator'
    
    ss.dependency 'MKBaseModuleLibrary'
    ss.dependency 'MKCustomUIModule'
    ss.dependency 'HHTransition'
    ss.dependency 'MLInputDodger'
    
  end
  
end
