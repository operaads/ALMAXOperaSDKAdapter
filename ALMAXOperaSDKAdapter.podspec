Pod::Spec.new do |spec|
  # ――― 基本信息 ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.name         = "ALMAXOperaSDKAdapter"
  spec.version      = "2.8.3.0"
  spec.summary      = "Opera Ads Custom Adapter for AppLovin MAX Mediation Platform."
  spec.description  = <<-DESC
    ALMAXOperaSDKAdapter is a custom mediation adapter that enables the integration of
    Opera Advertising SDK (OpAdxSdk) with the AppLovin MAX mediation platform.

    Supported Ad Formats:
    - Banner Ads (Standard, MREC, Leader)
    - Interstitial Ads
    - Rewarded Ads
    - Native Ads

    This adapter bridges Opera Ads SDK callbacks to AppLovin MAX mediation callbacks,
    enabling seamless ad serving through the AppLovin MAX platform.
  DESC

  spec.homepage     = "https://github.com/operaads/ALMAXOperaSDKAdapter"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Opera Ads" => "chenl@opera.com" }

  # ――― 平台设置 ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.platform     = :ios, "13.0"
  spec.ios.deployment_target = "13.0"
  spec.swift_version = "5.0"


  # ――― 源码位置 ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source       = {
    :git => "https://github.com/operaads/ALMAXOperaSDKAdapter.git",
    :tag => "#{spec.version}"
  }

  # ――― 文件与依赖配置 ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  # 制作静态包的关键设置
  spec.static_framework = true

  spec.vendored_frameworks = "OpAdxAdapterAppLovin.xcframework"
  # 源码路径 - Objective-C源文件
  #spec.source_files  = "OpAdxAdapterAppLovin/**/*.{h,m}"

  # 公开头文件
  #spec.public_header_files = "OpAdxAdapterAppLovin/**/*.h"

  # --- 依赖项 ---
  # AppLovin SDK
  spec.dependency 'AppLovinSDK'

  # Opera Ads SDK
  spec.dependency 'OpAdxSdk', '2.8.2'

  # ――― 工程配置 ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  # 静态库需要 -ObjC 标志以加载 Category
  # spec.pod_target_xcconfig = {
  #   'OTHER_LDFLAGS' => '-ObjC',
  #   'VALID_ARCHS' => 'arm64 x86_64'
  # }

  # ――― 元数据 ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  # spec.requires_arc = true

end
