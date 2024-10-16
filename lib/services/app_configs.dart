import 'package:easypg/services/api_handler.dart';
import 'package:easypg/utils/app_keys.dart';

class AppConfigs {
  static final AppConfigs instance = AppConfigs._();
  AppConfigs._();
  Map<String, dynamic>? configs;
  int? _perCallCharges;
  int? _activationCharge;
  String? _razorpayApi;

  Future<Map<String, dynamic>> getConfigs() async {
    configs ??= await ApiHandler.instance.getConfigs();
    return configs!;
  }

  Future<int> getPerCallCharges() async => _perCallCharges ??=
      (await getConfigs())[AppKeys.perCallCharge][AppKeys.charge];

  Future<int> getActivationCharges() async => _activationCharge ??=
      (await getConfigs())[AppKeys.activationCharges][AppKeys.charge];

  Future<String> getRazorpayApi() async =>
      _razorpayApi ??= (await getConfigs())[AppKeys.razorPayAPI][AppKeys.api];
}
