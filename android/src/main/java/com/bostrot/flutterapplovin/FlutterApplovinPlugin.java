package com.bostrot.flutterapplovin;

import com.applovin.adview.AppLovinInterstitialAd;
import com.applovin.adview.AppLovinInterstitialAdDialog;
import com.applovin.sdk.AppLovinAd;
import com.applovin.sdk.AppLovinAdLoadListener;
import com.applovin.sdk.AppLovinAdSize;
import com.applovin.sdk.AppLovinSdk;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterApplovinPlugin
 */
public class FlutterApplovinPlugin implements MethodCallHandler {
  /**
   * Plugin registration.
   */
  static private AppLovinAd loadedAd;
  public static void registerWith(final Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_applovin");
    channel.setMethodCallHandler(new FlutterApplovinPlugin());
    AppLovinSdk.initializeSdk(registrar.context());
    // Load an Interstitial Ad
    AppLovinSdk.getInstance( registrar.context() ).getAdService().loadNextAd( AppLovinAdSize.INTERSTITIAL,
            new
            AppLovinAdLoadListener()
    {
      @Override
      public void adReceived(AppLovinAd ad)
      {
        loadedAd = ad;
        AppLovinInterstitialAdDialog interstitialAd = AppLovinInterstitialAd.create( AppLovinSdk
                .getInstance( registrar.context() ), registrar.context() );


        interstitialAd.showAndRender( loadedAd );
      }

      @Override
      public void failedToReceiveAd(int errorCode)
      {
        // Look at AppLovinErrorCodes.java for list of error codes.
      }
    } );
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }
}