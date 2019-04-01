Pod::Spec.new do |s|
    s.name         = "CHScanConfig"
    s.version      = "0.0.1"
    s.summary      = "扫描/生成二维码、条形码组件."
    s.homepage     = "https://github.com/MeteoriteMan/CHScanConfig"
    s.license      = "MIT"
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.author       = { "张晨晖" => "shdows007@gmail.com" }
    s.platform     = :ios
    s.source       = { :git => "https://github.com/MeteoriteMan/CHScanConfig.git", :tag => s.version }
    s.source_files = 'CHScanConfig/**/*.{h,m}'
    s.frameworks   = 'Foundation', 'UIKit', 'AVFoundation'
end
