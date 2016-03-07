Pod::Spec.new do |s|
  s.name             = "LFTPopView"
  s.version          = "0.1.0"
  s.summary          = "iOS customizable pop-up view"
  s.homepage         = "https://github.com/tflhyl/LFTPopView"
  s.license          = 'MIT'
  s.author           = { "Theodore Felix Leo" => "tflhyl@gmail.com" }
  s.source           = { :git => "https://github.com/tflhyl/LFTPopView.git", :tag => s.version.to_s }
  s.platform         = :ios, '7.0'
  s.requires_arc     = true
  s.source_files     = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'LFTPopView' => ['Pod/Assets/*.png']
  }
end
