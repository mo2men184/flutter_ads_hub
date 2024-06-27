import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter_ads_hub/utils/ad_utils.dart' as utils;
import 'package:flutter_ads_hub/services/ad_service.dart';
import 'package:flutter_ads_hub/models/ad_config.dart' as models;

class AdsController extends GetxController {
  BannerAd? googleBannerAd;
  FacebookBannerAd? fbBannerAd;
  var currentAdNetwork = models.AdNetwork.Google.obs;
  var adLoadError = false.obs;
  var retryCount = 0.obs;
  final int maxRetry = 3;

  final AdService adService = AdService();

  @override
  void onInit() {
    super.onInit();
    loadAdConfig();
  }

  void loadAdConfig() async {
    models.AdConfig config = await adService.getAdConfig();
    switchAdNetwork(config.network, config.adUnitId);
  }

  void loadGoogleAd(String adUnitId) {
    utils.loadGoogleAd(
      adUnitId,
      BannerAdListener(
        onAdLoaded: (ad) {
          adLoadError.value = false;
          retryCount.value = 0;
        },
        onAdFailedToLoad: (ad, error) {
          adLoadError.value = true;
          ad.dispose();
          retryLoadAd(adUnitId, models.AdNetwork.Google);
        },
      ),
    );
  }

  void loadFbAd(String adUnitId) {
    fbBannerAd = FacebookBannerAd(
      placementId: adUnitId,
      bannerSize: BannerSize.STANDARD,
      listener: (result, value) {
        if (result == BannerAdResult.ERROR) {
          adLoadError.value = true;
          retryLoadAd(adUnitId, models.AdNetwork.Facebook);
        } else if (result == BannerAdResult.LOADED) {
          adLoadError.value = false;
          retryCount.value = 0;
        }
      },
    );
  }

  void switchAdNetwork(models.AdNetwork network, String adUnitId) {
    currentAdNetwork.value = network;
    adLoadError.value = false;
    retryCount.value = 0;

    if (network == models.AdNetwork.Google) {
      loadGoogleAd(adUnitId);
    } else {
      loadFbAd(adUnitId);
    }
  }

  void retryLoadAd(String adUnitId, models.AdNetwork network) {
    if (retryCount.value < maxRetry) {
      retryCount.value++;
      switchAdNetwork(network, adUnitId);
    }
  }

  @override
  void onClose() {
    googleBannerAd?.dispose();
    super.onClose();
  }
}
