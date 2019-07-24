#import "FlutterApplovinPlugin.h"
#import <AppLovinSDK/AppLovinSDK.h>


@interface FlutterApplovinPlugin() <ALAdLoadDelegate>

@property (nonatomic, copy)     FlutterResult loadedResult;
@property (nonatomic, strong)   NSString *customIdentify;

@property (nonatomic, strong)   ALSdk *lovinSdk;
@property (nonatomic, strong)   ALIncentivizedInterstitialAd *interstitialAd;
@end

@implementation FlutterApplovinPlugin

- (void)initApplovinAd:(NSString *)appKey{
    
    if(appKey.length == 0){
        return;
    }
    self.lovinSdk = [ALSdk sharedWithKey:appKey settings:[ALSdkSettings new]];
    self.interstitialAd = [[ALIncentivizedInterstitialAd alloc] initWithSdk:self.lovinSdk];
    self.interstitialAd.adDisplayDelegate = self;
}

- (void)loadInterstitialAd{
    
    [self.interstitialAd preloadAndNotify:self];
}

- (void)showApplovinAd{
    if (self.customIdentify.length > 0) {
        self.lovinSdk.userIdentifier = [NSString stringWithFormat:@"%@|%@", self.customIdentify, @"freecoin"];
    }
    [self.interstitialAd showAndNotify:self];
}

- (void)configIdentify:(NSString *)userId andPlatform:(NSString *)platform{
    
    self.customIdentify = [NSString stringWithFormat:@"%@|%@", userId ? : @"", platform];
}

#pragma mark - Ad Load Delegate

- (void)adService:(nonnull ALAdService *)adService didLoadAd:(nonnull ALAd *)ad
{
    // We now have an interstitial ad we can show!
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
        [self showApplovinAd];
    }else if ([call.method isEqualToString:@"initApplovin"]){
        NSString *appKey = call.arguments[@"appKey"];
        [self initApplovinAd:appKey];
    }else if ([call.method isEqualToString:@"configUserId"]){
        [self configIdentify:call.arguments[@"userId"] andPlatform:call.arguments[@"platform"]];
    }else {
        result(FlutterMethodNotImplemented);
    }
}

@end
