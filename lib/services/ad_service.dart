import 'package:easypg/utils/tools.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {

  final String adUnitId = "ca-app-pub-2937476914243605/4384385641";
  static final instance = AdService._();
  AdService._();

  RewardedAd? rewardedAd;

  Future loadAd() async {
    await RewardedAd.load(adUnitId: adUnitId, request: AdRequest(), rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) => rewardedAd = ad, onAdFailedToLoad: (error) => logError('some_error', error, StackTrace.current),),);
  }

  Future<int> showAd() async {
    int rewardAm = 0;
    rewardedAd == null ? await  loadAd() : null;
    rewardedAd?.show(onUserEarnedReward: (ad, reward) {
      rewardAm = reward.amount.toInt();
    },);
    return rewardAm;
  }
}