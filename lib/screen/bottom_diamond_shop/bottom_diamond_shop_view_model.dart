import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:orange_ui/api_provider/api_provider.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/model/get_diamond_pack.dart';
import 'package:stacked/stacked.dart';

class BottomDiamondShopViewModel extends BaseViewModel {
  List<DiamondPack> diamondPriceList = [];

  late StreamSubscription<dynamic> _subscription;
  final Set<String> _productId = <String>{};
  List<ProductDetails> products = [];
  bool isLoading = false;

  void init() {
    fetchDiamondPackage();
    initInAppPurchase();
  }

  void fetchDiamondPackage() {
    isLoading = true;
    ApiProvider().getDiamondPack().then((value) async {
      diamondPriceList = value.data ?? [];

      for (var element in diamondPriceList) {
        if (Platform.isAndroid) {
          _productId.add(element.androidProductId ?? '');
        } else {
          _productId.add(element.iosProductId ?? '');
        }
      }

      // Fetch Product
      final ProductDetailsResponse response =
          await InAppPurchase.instance.queryProductDetails(_productId);

      products = response.productDetails;
      isLoading = false;
      notifyListeners();
    });
  }

  void initInAppPurchase() {
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
  }

  void _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (var element in purchaseDetailsList) {
      if (element.status == PurchaseStatus.pending) {
        log('Pending ');
        CommonUI.lottieLoader();
      } else {
        Get.back();
        if (element.status == PurchaseStatus.error) {
          log('Error :: ${element.error?.message}');
          CommonUI.snackBar(message: element.error?.message ?? '');
        } else if (element.status == PurchaseStatus.purchased ||
            element.status == PurchaseStatus.restored) {
          log('Purchase Successfully');

          // Call Api To Add Diamond In Wallet
          DiamondPack diamondPackData = diamondPriceList.firstWhere((e) {
            if (Platform.isIOS) {
              return e.iosProductId == element.productID;
            } else {
              return e.androidProductId == element.productID;
            }
          });
          addCoinApiCall(diamondPackData.amount ?? 0);
        }
        if (element.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(element);
        }
      }
    }
  }

  void makePurchase(ProductDetails products) {
    PurchaseParam purchaseParam = PurchaseParam(productDetails: products);
    InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
  }

  void addCoinApiCall(int coin) {
    CommonUI.lottieLoader();
    ApiProvider().addCoinFromWallet(coin).then((value) {
      if (Get.isBottomSheetOpen == true) {
        Get.back();
      }
      Get.back();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
