// lib/views/main_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_ads_hub/controllers/ad_controller.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter_ads_hub/utils/ad_utils.dart' as utils;
import 'package:flutter_ads_hub/models/ad_config.dart' as models;

class MainView extends StatelessWidget {
  final AdsController adController = Get.put(AdsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ad Integration Example'),
        actions: [
          PopupMenuButton<models.AdNetwork>(
            onSelected: (models.AdNetwork result) async {
              models.AdConfig config = await adController.adService
                  .getAdConfig(); // Fetch the ad config again
              adController.switchAdNetwork(result, config.adUnitId);
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<models.AdNetwork>>[
              const PopupMenuItem<models.AdNetwork>(
                value: models.AdNetwork.Google,
                child: Text('Google Ads'),
              ),
              const PopupMenuItem<models.AdNetwork>(
                value: models.AdNetwork.Facebook,
                child: Text('Facebook Ads'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          GetBuilder<AdsController>(
            builder: (controller) {
              if (controller.adLoadError.value) {
                return Container(
                  height: 50,
                  color: Colors.red,
                  child: Center(child: Text('Failed to load ad.')),
                );
              } else if (controller.currentAdNetwork.value ==
                      models.AdNetwork.Google &&
                  controller.googleBannerAd == null) {
                return SizedBox(
                    height: 50,
                    child: Center(child: CircularProgressIndicator()));
              } else if (controller.currentAdNetwork.value ==
                      models.AdNetwork.Facebook &&
                  controller.fbBannerAd == null) {
                return SizedBox(
                    height: 50,
                    child: Center(child: CircularProgressIndicator()));
              } else {
                return controller.currentAdNetwork.value ==
                        models.AdNetwork.Google
                    ? Container(
                        height:
                            controller.googleBannerAd!.size.height.toDouble(),
                        width: controller.googleBannerAd!.size.width.toDouble(),
                        child: AdWidget(ad: controller.googleBannerAd!),
                      )
                    : Container(
                        child: controller.fbBannerAd,
                      );
              }
            },
          ),
        ],
      ),
    );
  }
}
