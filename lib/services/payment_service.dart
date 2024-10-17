import 'package:easypg/provider/data_provider.dart';
import 'package:easypg/services/api_handler.dart';
import 'package:easypg/services/app_configs.dart';
import 'package:easypg/utils/app_keys.dart';
import 'package:easypg/utils/tools.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentService {
  static final instance = PaymentService._();
  late Razorpay razorpay;
  PaymentService._() {
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, paymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, paymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWallet);
  }

  Future<void> paymentSuccess(PaymentSuccessResponse response) async {

    //TODO: after we api key
    ApiHandler.instance.updateMoneyToWallet(response.data![AppKeys.amountPaid]);
    logEvent('done!${response.data}');
  }

  Future<void> paymentError(PaymentFailureResponse response) async {
    logEvent('error!${response.error}');
  }

  Future<void> externalWallet(ExternalWalletResponse response) async {
    logEvent('idk!${response.walletName}');
  }

  Future<void> openCheckout(int amount) async {
    String api = await AppConfigs.instance.getRazorpayApi();
    if (api == "TESTING") {
      await ApiHandler.instance.updateMoneyToWallet(amount);
      return;
    }
    final options = {
      'key': api,
      'amount': amount,
      'name': 'Easy PG',
      'description': "Purchase Credits",
      'prefill': {'contact': DataProvider.instance.getUser.phoneNo, 'email': null},
    };

    try {
      razorpay.open(options);
    } catch (e, stackTrace) {
      logError('razorpay', e, stackTrace);
    }
  }
}
