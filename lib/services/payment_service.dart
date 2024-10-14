import 'package:easypg/provider/data_provider.dart';
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
    logEvent('done!${response.data}');
  }

  Future<void> paymentError(PaymentFailureResponse response) async {
    logEvent('error!${response.error}');
  }

  Future<void> externalWallet(ExternalWalletResponse response) async {
    logEvent('idk!${response.walletName}');
  }

  Future<void> openCheckout() async {
    final options = {
      'key': 'my_api_key',
      'amount': 2000,
      'name': 'HeHe Store',
      'description': "he he he he!",
      'prefill': {'contact': DataProvider.instance.getUser.phoneNo, 'email': null},
    };
    try {
      razorpay.open(options);
    } catch (e, stackTrace) {
      logError('razorpay', e, stackTrace);
    }
  }
}
