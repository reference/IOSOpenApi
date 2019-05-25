Pod::Spec.new do |s|

  s.name         = "IOSOpenApi"
  s.version      = "0.0.1"
  s.summary      = "IOSOpenApi"
  s.homepage     = "https://github.com/reference/IOSOpenApi"
  s.description  = <<-DESC
                OenApi for ios
                * Easy to use.
                * Open codes!
                DESC
  s.license      = "MIT"
  s.author       = { "Scott Ban" => "imti_bandianhong@126.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git =>  "https://github.com/reference/IOSOpenApi.git", :tag => s.version }
  s.requires_arc = true
  s.source_files = ["IOSOpenApi/*.{h,m}","HTTP/*.{h,m}","Model/*.{h,m}"]

  s.dependency "BDToolKit"
  s.dependency "AFNetworking"
  s.dependency "ZXToolbox"
  s.dependency "YYModel"
  s.dependency "StandardHTTPResponse"
end
