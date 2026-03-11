# ALMAXOperaSDKAdapter

Custom adapter for integrating Opera Ads SDK with AppLovin MAX mediation platform.

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/ALMAXOperaSDKAdapter.svg)](https://cocoapods.org/pods/ALMAXOperaSDKAdapter)
[![Platform](https://img.shields.io/cocoapods/p/ALMAXOperaSDKAdapter.svg?style=flat)](https://cocoapods.org/pods/ALMAXOperaSDKAdapter)
[![License](https://img.shields.io/cocoapods/l/ALMAXOperaSDKAdapter.svg?style=flat)](https://github.com/operaads/ALMAXOperaSDKAdapter/blob/main/LICENSE)

English | [简体中文](README.MD)

## Overview

ALMAXOperaSDKAdapter is a custom mediation adapter that enables seamless integration of Opera Advertising SDK (OpAdxSdk) with the AppLovin MAX mediation platform. This adapter bridges Opera Ads SDK callbacks to AppLovin MAX mediation callbacks, enabling ad serving through the AppLovin MAX platform.

## Supported Ad Formats

- ✅ Banner Ads (Standard, MREC, Leader)
- ✅ Interstitial Ads
- ✅ Rewarded Ads
- ✅ Native Ads

## Requirements

- iOS 13.0+
- AppLovin SDK 12.0.0+
- OpAdxSdk 2.8.3
- Xcode 13.0+

## Installation

### CocoaPods

Add the following to your `Podfile`:

```ruby
# AppLovin SDK
pod 'AppLovinSDK'

# Opera Ads SDK
pod 'OpAdxSdk', '2.8.3'

# Opera Ads AppLovin MAX Adapter
pod 'ALMAXOperaSDKAdapter', '2.8.3.0'
```

Then run:

```bash
pod install
```

## Quick Start

### 1. Initialize AppLovin SDK

```objective-c
#import <AppLovinSDK/AppLovinSDK.h>

// Initialize in AppDelegate
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Get AppLovin SDK instance
    ALSdk *sdk = [ALSdk sharedWithKey:@"your_applovin_sdk_key"];

    // Initialize SDK
    [sdk initializeSdkWithCompletionHandler:^(ALSdkConfiguration *configuration) {
        NSLog(@"AppLovin SDK initialized");
    }];

    return YES;
}
```

### 2. Configure Custom Ad Network

When configuring ad units in AppLovin MAX dashboard:

1. Select "Manage" -> "Networks"
2. Configure iOS Adapter Class Name
3. Enter OpAdxAppLovinAdapter

**iOS Adapter Class Name**:
`OpAdxAppLovinAdapter`

4. Return and select "Ad Units"
5. Create a new ad unit or select an existing one
6. Custom Networks -> Click the Custom Network configured above
7. Configure App ID/Placement ID/Custom Parameters and other settings
8. Save

**App ID**: Your Opera App ID
your_opera_app_id
Example: pub134xxxxxxxxxxx/ep13xxxxxxxxxxxx/app14xxxxxxxxxxxx

**Placement ID**: Your Opera Placement ID
your_opera_placement_id
Example: s1xxxxxxxxxxxxx

**Custom Parameters** - JSON format:
```json
{"bundleId": "your_bundle_id"}
```
Example: {"bundleId": "xxxxxxxxxx"} 
The digital ID of the app in the Apple Store

### 3. Load and Show Ads

Use AppLovin MAX standard APIs to load and show ads:

#### Banner Ads

```objective-c
#import <AppLovinSDK/AppLovinSDK.h>

@interface BannerViewController () <MAAdViewAdDelegate>
@property (nonatomic, strong) MAAdView *adView;
@end

@implementation BannerViewController

- (void)loadBanner {
    self.adView = [[MAAdView alloc] initWithAdUnitIdentifier:@"your_ad_unit_id"];
    self.adView.delegate = self;

    // Set banner size
    self.adView.frame = CGRectMake(0, 0,
                                   UIScreen.mainScreen.bounds.size.width,
                                   50);

    // Load ad
    [self.adView loadAd];

    // Add to view
    [self.view addSubview:self.adView];
}

#pragma mark - MAAdViewAdDelegate

- (void)didLoadAd:(MAAd *)ad {
    NSLog(@"Banner loaded successfully");
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier
                                 withError:(MAError *)error {
    NSLog(@"Banner failed to load: %@", error.message);
}

- (void)didDisplayAd:(MAAd *)ad {
    NSLog(@"Banner displayed");
}

- (void)didClickAd:(MAAd *)ad {
    NSLog(@"Banner clicked");
}

- (void)didExpandAd:(MAAd *)ad {
    NSLog(@"Banner expanded");
}

- (void)didCollapseAd:(MAAd *)ad {
    NSLog(@"Banner collapsed");
}

@end
```

#### Interstitial Ads

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
    NSLog(@"Interstitial loaded successfully");
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier
                                 withError:(MAError *)error {
    NSLog(@"Interstitial failed to load: %@", error.message);
}

- (void)didDisplayAd:(MAAd *)ad {
    NSLog(@"Interstitial displayed");
}

- (void)didClickAd:(MAAd *)ad {
    NSLog(@"Interstitial clicked");
}

- (void)didHideAd:(MAAd *)ad {
    NSLog(@"Interstitial dismissed");
    // Load next ad
    [self.interstitialAd loadAd];
}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error {
    NSLog(@"Interstitial failed to display: %@", error.message);
    // Load next ad
    [self.interstitialAd loadAd];
}

@end
```

#### Rewarded Ads

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
    NSLog(@"Rewarded ad loaded successfully");
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier
                                 withError:(MAError *)error {
    NSLog(@"Rewarded ad failed to load: %@", error.message);
}

- (void)didDisplayAd:(MAAd *)ad {
    NSLog(@"Rewarded ad displayed");
}

- (void)didClickAd:(MAAd *)ad {
    NSLog(@"Rewarded ad clicked");
}

- (void)didHideAd:(MAAd *)ad {
    NSLog(@"Rewarded ad dismissed");
    // Load next ad
    [self.rewardedAd loadAd];
}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error {
    NSLog(@"Rewarded ad failed to display: %@", error.message);
    // Load next ad
    [self.rewardedAd loadAd];
}

- (void)didRewardUserForAd:(MAAd *)ad withReward:(MAReward *)reward {
    NSLog(@"User earned reward: %ld %@", (long)reward.amount, reward.label);
}

@end
```

#### Native Ads

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
    NSLog(@"Native ad loaded successfully");

    // Clean up previous ad if needed
    if (self.nativeAd) {
        [self.nativeAdLoader destroyAd:self.nativeAd];
    }

    self.nativeAd = ad;

    // Add to view
    [self.view addSubview:nativeAdView];

    // Set constraints or frame
    nativeAdView.frame = CGRectMake(0, 100,
                                    UIScreen.mainScreen.bounds.size.width,
                                    300);
}

- (void)didFailToLoadNativeAdForAdUnitIdentifier:(NSString *)adUnitIdentifier
                                       withError:(MAError *)error {
    NSLog(@"Native ad failed to load: %@", error.message);
}

- (void)didClickNativeAd:(MAAd *)ad {
    NSLog(@"Native ad clicked");
}

@end
```

### Native Ad Features

The adapter uses `OpAdxNativeAdView` to render native ads, including the following components:
- Title
- Body
- Icon
- Media View
- Call to Action
- Ad Choices

## Version History

### 2.8.3.0 (2026-03-11)
- Compiled using Xcode (16.2) to enhance compatibility

### 2.8.2.0 (2026-03-10)
- ✅ Support for AppLovin SDK 12.0+
- ✅ Fixed native ad MediaView type preservation issue
- ✅ Fixed rewarded ad reward callback to use actual reward data
- ✅ Added Banner ad lifecycle callbacks
- ✅ Optimized error handling and logging
- ✅ Support for all major ad formats

### 2.8.0.0
- Initial release
- Support for Banner, Interstitial, Rewarded, and Native ad formats

## Important Notes

### 1. Initialization Order
AppLovin SDK must be initialized before loading ads.

### 2. Callback Order
The adapter strictly follows AppLovin MAX recommended callback order:

**Interstitial and Rewarded Ad Display**:
1. `didDisplayAd:` - Ad displayed
2. `didClickAd:` - Ad clicked (if occurs)
3. For rewarded ads: `didRewardUserForAd:withReward:` - User earned reward

**Interstitial and Rewarded Ad Dismissal**:
1. `didHideAd:` - Ad dismissed

### 3. Native Ad Rendering
Native ads use AppLovin's `MANativeAdView` for rendering. The adapter automatically handles conversion from Opera Ads native ad components to AppLovin format.

### 4. Error Handling
All errors are returned through AppLovin MAX's standard error callbacks with detailed error information.


### Common Issues

**Q: Ads not loading?**
A: Check the following:
1. Verify custom network configuration in AppLovin MAX dashboard, especially bundleId
2. Ensure adapter class name is correctly set
3. Ensure Opera Ads SDK is successfully initialized
4. Check console logs for detailed error messages

**Q: Adapter class not found?**
A: Make sure:
1. `ALMAXOperaSDKAdapter` Pod is correctly installed
2. Class name is configured on the website
3. Use the full class name, e.g., `OpAdxAppLovinAdViewAdapter`
4. Clean and rebuild your project

**Q: Native ad not displaying correctly?**
A: Ensure all view elements of `MANativeAdView` are properly configured.

**Q: No App Open ads?**
A: AppLovin currently does not support App Open ads in waterfall mediation.

## Sample Project

For a complete sample project, see:
- [OpAdxSDK Demo - AppLovin Adapter](https://github.com/operaads/iOS-sdk/tree/main/Demo/ApplovinAdapter)

## Technical Support

- 📧 Email: chenl@opera.com
- 📖 Documentation: [Opera Ads iOS SDK Documentation]
- 🐛 Issue Tracker: [GitHub Issues](https://github.com/operaads/ALMAXOperaSDKAdapter/issues)

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) file for details.

## Related Links

- [Opera Ads SDK](https://github.com/operaads/iOS-sdk)
- [AppLovin MAX Documentation](https://dash.applovin.com/documentation/mediation/ios/getting-started/integration)
- [CocoaPods](https://cocoapods.org/pods/ALMAXOperaSDKAdapter)
