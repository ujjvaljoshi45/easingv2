import 'package:easypg/services/api_handler.dart';
import 'package:easypg/utils/app_keys.dart';

class AppConfigs {
  static final AppConfigs instance = AppConfigs._();

  AppConfigs._();

  Map<String, dynamic>? configs;
  int? _perCallCharges;
  int? _activationCharge;
  int? _rewardAmount;
  String? _razorpayApi;
  String? _supportLink;
  String? _termsUrl;
  String? _brandingUrl;

  Future<Map<String, dynamic>> getConfigs() async {
    configs ??= await ApiHandler.instance.getConfigs();
    return configs!;
  }

  Future<int> getReward() async =>
      _rewardAmount ??= (await getConfigs())[AppKeys.rewardAmount][AppKeys.charge];

  Future<int> getPerCallCharges() async =>
      _perCallCharges ??= (await getConfigs())[AppKeys.perCallCharge][AppKeys.charge];

  Future<int> getActivationCharges() async =>
      _activationCharge ??= (await getConfigs())[AppKeys.activationCharges][AppKeys.charge];

  Future<String> getRazorpayApi() async =>
      _razorpayApi ??= (await getConfigs())[AppKeys.razorPayAPI][AppKeys.api];

  Future<String> getSupportLink() async =>
      _supportLink ??= (await getConfigs())[AppKeys.supportLink][AppKeys.link];

  Future<String> getTermsLink() async =>
      _termsUrl ??= (await getConfigs())[AppKeys.termsLink][AppKeys.link];

  Future<String> getBrandingLink() async =>
      _brandingUrl ??= (await getConfigs())[AppKeys.brandingLink][AppKeys.link];
}
