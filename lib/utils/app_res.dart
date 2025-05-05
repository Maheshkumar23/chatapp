import 'package:orange_ui/generated/l10n.dart';

class AppRes {
  static const String isSuccessPurchase = "is_success_purchase";
  static const String hmmA = "h:mm a";
  static const String hhMmA = "hh:mm a";
  static const String dMY = "dd MMM yyyy";
  static const String isHttp = "http://";
  static const String isHttps = "https://";
  static String reverseSwipeDisc(int reverseSwipePrice) {
    return "${S.current.reverseSwipeWillCostYou} $reverseSwipePrice ${S.current.coinsPleaseConfirmIfYouToContinueOrNot}";
  }

  static String messageDisc(int? messagePrice) {
    return "${S.current.messagePriceWillCostYou} ${messagePrice ?? 0} ${S.current.coinsPerMsgPleaseConfirmIfYouToContinueOr}";
  }

  static String liveStreamDisc(int? liveWatchingPrice) {
    return "${S.current.liveStreamPriceWillCostYou} ${liveWatchingPrice ?? 0} ${S.current.coinsPerMinutesPleaseConfirmIfYouToContinueOr}";
  }

  static const String reportName = 'reportName';
  static const String reportImage = 'reportImage';
  static const String reportAge = 'reportAge';
  static const String reportAddress = 'reportAddress';
  static const String report = 'Report';
  static const String defaultFullname = 'Unknown';
  static const String male = 'Male';
  static const String female = 'Female';
  static const String other = 'Other';
  static String videoDurationDescription(int second) {
    return 'This video is more then $second seconds.  Please select another...';
  }
}
