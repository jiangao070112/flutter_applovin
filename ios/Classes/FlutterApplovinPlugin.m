#import "FlutterApplovinPlugin.h"
#import <AppLovinSDK/AppLovinSDK.h>


@interface FlutterApplovinPlugin() <ALAdLoadDelegate>

@property (nonatomic, strong) ALAd *ad;
@property (nonatomic, copy) FlutterResult loadedResult;
@end

@implementation FlutterApplovinPlugin

- (void)loadInterstitialAd
{
    // Load an interstitial ad and be notified when the ad request is finished.
    [[ALSdk shared].adService loadNextAd: [ALAdSize sizeInterstitial] andNotify: self];
}

#pragma mark - Ad Load Delegate

- (void)adService:(nonnull ALAdService *)adService didLoadAd:(nonnull ALAd *)ad
{
    // We now have an interstitial ad we can show!
    self.ad = ad;
    self.loadedResult(@"true");
}

- (void)adService:(nonnull ALAdService *)adService didFailToLoadAdWithError:(int)code
{
    // Look at ALErrorCodes.h for the list of error codes.
    self.loadedResult(@"false");
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter_applovin"
                                     binaryMessenger:[registrar messenger]];
    FlutterApplovinPlugin* instance = [[FlutterApplovinPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    [ALSdk initializeSdk];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    if ([call.method isEqualToString:@"loadInterstitial"]){
        [self loadInterstitialAd];
        self.loadedResult = result;
    }else if ([call.method isEqualToString:@"showInterstitial"]){
        [[ALInterstitialAd shared] showOver: [UIApplication sharedApplication].keyWindow andRender: self.ad];
    }else {
        result(FlutterMethodNotImplemented);
    }
}

@end
