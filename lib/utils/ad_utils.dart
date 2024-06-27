import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

void loadGoogleAd(String adUnitId, BannerAdListener listener) {
  BannerAd bannerAd = BannerAd(
    adUnitId: adUnitId,
    size: AdSize.banner,
    request: AdRequest(),
    listener: listener,
  )..load();
}

void loadFbAd(String adUnitId, Function(BannerAdResult, dynamic) listener) {
  FacebookBannerAd bannerAd = FacebookBannerAd(
    placementId: adUnitId,
    bannerSize: BannerSize.STANDARD,
    listener: listener,
  );
}
