# ALMAXOperaSDKAdapter

Opera Ads SDK 的 AppLovin MAX 聚合平台自定义适配器。

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/ALMAXOperaSDKAdapter.svg)](https://cocoapods.org/pods/ALMAXOperaSDKAdapter)
[![Platform](https://img.shields.io/cocoapods/p/ALMAXOperaSDKAdapter.svg?style=flat)](https://cocoapods.org/pods/ALMAXOperaSDKAdapter)
[![License](https://img.shields.io/cocoapods/l/ALMAXOperaSDKAdapter.svg?style=flat)](https://github.com/operaads/ALMAXOperaSDKAdapter/blob/main/LICENSE)

[English](README_EN.MD) | 简体中文

## 概述

ALMAXOperaSDKAdapter 是一个自定义聚合适配器，使 Opera Advertising SDK (OpAdxSdk) 能够与 AppLovin MAX 聚合平台无缝集成。该适配器将 Opera Ads SDK 的回调桥接到 AppLovin MAX 的聚合回调，实现通过 AppLovin MAX 平台进行广告投放。

## 支持的广告格式

- ✅ Banner 广告（标准、中矩形、排行榜）
- ✅ 插屏广告（Interstitial）
- ✅ 激励广告（Rewarded）
- ✅ 原生广告（Native）

## 版本要求

- iOS 13.0+
- AppLovin SDK 12.0.0+
- OpAdxSdk 2.8.3
- Xcode 13.0+

## 安装

### CocoaPods

在您的 `Podfile` 中添加：

```ruby
# AppLovin SDK
pod 'AppLovinSDK'

# Opera Ads SDK
pod 'OpAdxSdk', '2.8.3'

# Opera Ads AppLovin MAX 适配器
pod 'ALMAXOperaSDKAdapter', '2.8.3.0'
```

然后运行：

```bash
pod install
```

## 快速开始

### 1. 初始化 AppLovin SDK

```objective-c
#import <AppLovinSDK/AppLovinSDK.h>

// 在 AppDelegate 中初始化
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 获取 AppLovin SDK 实例
    ALSdk *sdk = [ALSdk sharedWithKey:@"your_applovin_sdk_key"];

    // 初始化 SDK
    [sdk initializeSdkWithCompletionHandler:^(ALSdkConfiguration *configuration) {
        NSLog(@"AppLovin SDK initialized");
    }];

    return YES;
}
```

### 2. 配置自定义广告网络

在 AppLovin MAX 后台配置广告单元时：

1. 选择"Manage" -> "Networks"
2. 配置iOS Adapter Class Name
3. 填入OpAdxAppLovinAdapter

**iOS 适配器类名（iOS Adapter Class Name）**：
`OpAdxAppLovinAdapter`

4. 返回并选择"Ad Units"
5. 新增或选中一个广告单元
6. Custom Networks -> 点击刚才配置的Custom Networks
7. 配置App ID/Placement ID/Custom Parameters和其他配置
8. 保存

**App ID**：您的 Opera App ID 
your_opera_app_id
例如: pub134xxxxxxxxxxx/ep13xxxxxxxxxxxx/app14xxxxxxxxxxxx

**Placement ID**：您的 Opera Placement ID 
your_opera_placement_id
例如: s1xxxxxxxxxxxxx

**自定义参数（Custom Parameters）** - JSON格式：
```json
{"bundleId": "your_bundle_id"}
```
例如: {"bundleId": "xxxxxxxx"} app在苹果商店的数字id

### 3. 加载和展示广告

使用 AppLovin MAX 标准 API 加载和展示广告：

#### Banner 广告

```objective-c
#import <AppLovinSDK/AppLovinSDK.h>

@interface BannerViewController () <MAAdViewAdDelegate>
@property (nonatomic, strong) MAAdView *adView;
@end

@implementation BannerViewController

- (void)loadBanner {
    self.adView = [[MAAdView alloc] initWithAdUnitIdentifier:@"your_ad_unit_id"];
    self.adView.delegate = self;

    // 设置 banner 尺寸
    self.adView.frame = CGRectMake(0, 0,
                                   UIScreen.mainScreen.bounds.size.width,
                                   50);

    // 加载广告
    [self.adView loadAd];

    // 添加到视图
    [self.view addSubview:self.adView];
}

#pragma mark - MAAdViewAdDelegate

- (void)didLoadAd:(MAAd *)ad {
    NSLog(@"Banner 加载成功");
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier
                                 withError:(MAError *)error {
    NSLog(@"Banner 加载失败: %@", error.message);
}

- (void)didDisplayAd:(MAAd *)ad {
    NSLog(@"Banner 展示");
}

- (void)didClickAd:(MAAd *)ad {
    NSLog(@"Banner 点击");
}

- (void)didExpandAd:(MAAd *)ad {
    NSLog(@"Banner 展开");
}

- (void)didCollapseAd:(MAAd *)ad {
    NSLog(@"Banner 收起");
}

@end
```

#### 插屏广告

```objective-c
#import <AppLovinSDK/AppLovinSDK.h>

@interface InterstitialViewController () <MAAdDelegate>
@property (nonatomic, strong) MAInterstitialAd *interstitialAd;
@end

@implementation InterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.interstitialAd = [[MAInterstitialAd alloc]
                           initWithAdUnitIdentifier:@"your_ad_unit_id"];
    self.interstitialAd.delegate = self;
}

- (void)loadInterstitial {
    [self.interstitialAd loadAd];
}

- (void)showInterstitial {
    if ([self.interstitialAd isReady]) {
        [self.interstitialAd showAd];
    }
}

#pragma mark - MAAdDelegate

- (void)didLoadAd:(MAAd *)ad {
    NSLog(@"插屏广告加载成功");
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier
                                 withError:(MAError *)error {
    NSLog(@"插屏广告加载失败: %@", error.message);
}

- (void)didDisplayAd:(MAAd *)ad {
    NSLog(@"插屏广告展示");
}

- (void)didClickAd:(MAAd *)ad {
    NSLog(@"插屏广告点击");
}

- (void)didHideAd:(MAAd *)ad {
    NSLog(@"插屏广告关闭");
    // 加载下一个广告
    [self.interstitialAd loadAd];
}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error {
    NSLog(@"插屏广告展示失败: %@", error.message);
    // 加载下一个广告
    [self.interstitialAd loadAd];
}

@end
```

#### 激励广告

```objective-c
#import <AppLovinSDK/AppLovinSDK.h>

@interface RewardedViewController () <MARewardedAdDelegate>
@property (nonatomic, strong) MARewardedAd *rewardedAd;
@end

@implementation RewardedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.rewardedAd = [MARewardedAd sharedWithAdUnitIdentifier:@"your_ad_unit_id"];
    self.rewardedAd.delegate = self;
}

- (void)loadRewardedAd {
    [self.rewardedAd loadAd];
}

- (void)showRewardedAd {
    if ([self.rewardedAd isReady]) {
        [self.rewardedAd showAd];
    }
}

#pragma mark - MARewardedAdDelegate

- (void)didLoadAd:(MAAd *)ad {
    NSLog(@"激励广告加载成功");
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier
                                 withError:(MAError *)error {
    NSLog(@"激励广告加载失败: %@", error.message);
}

- (void)didDisplayAd:(MAAd *)ad {
    NSLog(@"激励广告展示");
}

- (void)didClickAd:(MAAd *)ad {
    NSLog(@"激励广告点击");
}

- (void)didHideAd:(MAAd *)ad {
    NSLog(@"激励广告关闭");
    // 加载下一个广告
    [self.rewardedAd loadAd];
}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error {
    NSLog(@"激励广告展示失败: %@", error.message);
    // 加载下一个广告
    [self.rewardedAd loadAd];
}

- (void)didRewardUserForAd:(MAAd *)ad withReward:(MAReward *)reward {
    NSLog(@"用户获得奖励: %ld %@", (long)reward.amount, reward.label);
}

@end
```

#### 原生广告

```objective-c
#import <AppLovinSDK/AppLovinSDK.h>

@interface NativeViewController () <MANativeAdDelegate>
@property (nonatomic, strong) MANativeAdLoader *nativeAdLoader;
@property (nonatomic, strong) MAAd *nativeAd;
@end

@implementation NativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.nativeAdLoader = [[MANativeAdLoader alloc]
                          initWithAdUnitIdentifier:@"your_ad_unit_id"];
    self.nativeAdLoader.nativeAdDelegate = self;
}

- (void)loadNativeAd {
    [self.nativeAdLoader loadAd];
}

#pragma mark - MANativeAdDelegate

- (void)didLoadNativeAd:(MANativeAdView *)nativeAdView forAd:(MAAd *)ad {
    NSLog(@"原生广告加载成功");

    // 如果已有广告，先清理
    if (self.nativeAd) {
        [self.nativeAdLoader destroyAd:self.nativeAd];
    }

    self.nativeAd = ad;

    // 添加到视图
    [self.view addSubview:nativeAdView];

    // 设置约束或 frame
    nativeAdView.frame = CGRectMake(0, 100,
                                    UIScreen.mainScreen.bounds.size.width,
                                    300);
}

- (void)didFailToLoadNativeAdForAdUnitIdentifier:(NSString *)adUnitIdentifier
                                       withError:(MAError *)error {
    NSLog(@"原生广告加载失败: %@", error.message);
}

- (void)didClickNativeAd:(MAAd *)ad {
    NSLog(@"原生广告点击");
}

@end
```

### 原生广告特性

适配器使用 `OpAdxNativeAdView` 来呈现原生广告，包含以下组件：
- 标题（Title）
- 描述（Body）
- 图标（Icon）
- 媒体视图（Media View）
- 行动号召按钮（Call to Action）
- 广告选择图标（Ad Choices）

## 版本历史

### 2.8.3.0 (2026-03-11)
- 使用xcode(16.2)编译,提高兼容性

### 2.8.2.0 (2026-03-10)
- ✅ 支持 AppLovin SDK 12.0+
- ✅ 修复原生广告 MediaView 类型保留问题
- ✅ 修复激励广告奖励回调使用实际奖励数据
- ✅ 添加 Banner 广告生命周期回调
- ✅ 优化错误处理和日志
- ✅ 支持所有主流广告格式

### 2.8.0.0
- 初始版本
- 支持 Banner、Interstitial、Rewarded、Native 广告格式

## 注意事项

### 1. 初始化顺序
AppLovin SDK 必须在加载广告之前初始化完成。

### 2. 回调顺序
适配器严格遵循 AppLovin MAX 文档推荐的回调顺序：

**插屏广告和激励广告展示**：
1. `didDisplayAd:` - 广告展示
2. `didClickAd:` - 广告点击（如果发生）
3. 对于激励广告：`didRewardUserForAd:withReward:` - 用户获得奖励

**插屏广告和激励广告关闭**：
1. `didHideAd:` - 广告关闭

### 3. 原生广告渲染
原生广告使用 AppLovin 的 `MANativeAdView` 进行渲染，适配器会自动处理 Opera Ads 原生广告组件到 AppLovin 格式的转换。

### 4. 错误处理
所有错误都会通过 AppLovin MAX 的标准错误回调返回，包含详细的错误信息。


### 常见问题

**Q: 广告无法加载？**
A: 检查以下项：
1. AppLovin MAX 后台自定义网络配置是否正确,尤其是bundleId
2. 适配器类名是否正确设置
3. Opera Ads SDK 是否成功初始化
4. 查看日志中的详细错误信息

**Q: 适配器类名找不到？**
A: 确保：
1. `ALMAXOperaSDKAdapter` Pod 已正确安装
2. 已在网站上配置类名
3. 使用完整类名，例如 `OpAdxAppLovinAdViewAdapter`
4. 清理并重新构建项目

**Q: 原生广告显示不正确？**
A: 确保正确配置了 `MANativeAdView` 的所有视图元素。

**Q: 没有开屏广告？**
A: AppLovin暂时不支持waterfall的开屏广告。

## 示例项目

完整的示例项目请参考：
- [OpAdxSDK Demo - AppLovin Adapter](https://github.com/operaads/iOS-sdk/tree/main/Demo/ApplovinAdapter)

## 技术支持

- 📧 Email: chenl@opera.com
- 📖 文档: [Opera Ads iOS SDK 文档]
- 🐛 问题反馈: [GitHub Issues](https://github.com/operaads/ALMAXOperaSDKAdapter/issues)

## 许可证

本项目采用 MIT 许可证。详见 [LICENSE](LICENSE) 文件。

## 相关链接

- [Opera Ads SDK](https://github.com/operaads/iOS-sdk)
- [AppLovin MAX Documentation](https://dash.applovin.com/documentation/mediation/ios/getting-started/integration)
- [CocoaPods](https://cocoapods.org/pods/ALMAXOperaSDKAdapter)
