enum AdNetwork { Google, Facebook }

class AdConfig {
  final String adUnitId;
  final AdNetwork network;

  AdConfig({required this.adUnitId, required this.network});
}
