class Setting {
  Setting({
    bool? status,
    String? message,
    SettingData? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  Setting.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? SettingData.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  SettingData? _data;

  Setting copyWith({
    bool? status,
    String? message,
    SettingData? data,
  }) =>
      Setting(
        status: status ?? _status,
        message: message ?? _message,
        data: data ?? _data,
      );

  bool? get status => _status;

  String? get message => _message;

  SettingData? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

class SettingData {
  SettingData({
    Appdata? appdata,
    List<Gifts>? gifts,
  }) {
    _appdata = appdata;
    _gifts = gifts;
  }

  SettingData.fromJson(dynamic json) {
    _appdata = json['appdata'] != null ? Appdata.fromJson(json['appdata']) : null;
    if (json['gifts'] != null) {
      _gifts = [];
      json['gifts'].forEach((v) {
        _gifts?.add(Gifts.fromJson(v));
      });
    }
  }

  Appdata? _appdata;
  List<Gifts>? _gifts;

  SettingData copyWith({
    Appdata? appdata,
    List<Gifts>? gifts,
  }) =>
      SettingData(
        appdata: appdata ?? _appdata,
        gifts: gifts ?? _gifts,
      );

  Appdata? get appdata => _appdata;

  List<Gifts>? get gifts => _gifts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_appdata != null) {
      map['appdata'] = _appdata?.toJson();
    }
    if (_gifts != null) {
      map['gifts'] = _gifts?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Gifts {
  Gifts({
    int? id,
    int? coinPrice,
    String? image,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _coinPrice = coinPrice;
    _image = image;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Gifts.fromJson(dynamic json) {
    _id = json['id'];
    _coinPrice = json['coin_price'];
    _image = json['image'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  int? _id;
  int? _coinPrice;
  String? _image;
  String? _createdAt;
  String? _updatedAt;

  Gifts copyWith({
    int? id,
    int? coinPrice,
    String? image,
    String? createdAt,
    String? updatedAt,
  }) =>
      Gifts(
        id: id ?? _id,
        coinPrice: coinPrice ?? _coinPrice,
        image: image ?? _image,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  int? get id => _id;

  int? get coinPrice => _coinPrice;

  String? get image => _image;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['coin_price'] = _coinPrice;
    map['image'] = _image;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}

class Appdata {
  Appdata({
    int? id,
    String? currency,
    int? minThreshold,
    String? coinRate,
    int? minUserLive,
    int? maxMinuteLive,
    int? messagePrice,
    int? reverseSwipePrice,
    int? liveWatchingPrice,
    String? admobIntIos,
    String? admobBannerIos,
    String? admobInt,
    String? admobBanner,
    int? isDating,
    int? isSocialMedia,
    int? postDescriptionLimit,
    int? postUploadImageLimit,
  }) {
    _id = id;
    _currency = currency;
    _minThreshold = minThreshold;
    _coinRate = coinRate;
    _minUserLive = minUserLive;
    _maxMinuteLive = maxMinuteLive;
    _messagePrice = messagePrice;
    _reverseSwipePrice = reverseSwipePrice;
    _liveWatchingPrice = liveWatchingPrice;
    _admobIntIos = admobIntIos;
    _admobBannerIos = admobBannerIos;
    _admobInt = admobInt;
    _admobBanner = admobBanner;
    _isDating = isDating;
    _isSocialMedia = isSocialMedia;
    _postDescriptionLimit = postDescriptionLimit;
    _postUploadImageLimit = postUploadImageLimit;
  }

  Appdata.fromJson(dynamic json) {
    _id = json['id'];
    _currency = json['currency'];
    _minThreshold = json['min_threshold'];
    _coinRate = json['coin_rate'];
    _minUserLive = json['min_user_live'];
    _maxMinuteLive = json['max_minute_live'];
    _messagePrice = json['message_price'];
    _reverseSwipePrice = json['reverse_swipe_price'];
    _liveWatchingPrice = json['live_watching_price'];
    _admobIntIos = json['admob_int_ios'];
    _admobBannerIos = json['admob_banner_ios'];
    _admobInt = json['admob_int'];
    _admobBanner = json['admob_banner'];
    _isDating = json['is_dating'];
    _isSocialMedia = json['is_social_media'];
    _postDescriptionLimit = json['post_description_limit'];
    _postUploadImageLimit = json['post_upload_image_limit'];
  }

  int? _id;
  String? _currency;
  int? _minThreshold;
  String? _coinRate;
  int? _minUserLive;
  int? _maxMinuteLive;
  int? _messagePrice;
  int? _reverseSwipePrice;
  int? _liveWatchingPrice;
  String? _admobIntIos;
  String? _admobBannerIos;
  String? _admobInt;
  String? _admobBanner;
  int? _isDating;
  int? _isSocialMedia;
  int? _postDescriptionLimit;
  int? _postUploadImageLimit;

  Appdata copyWith({
    int? id,
    String? currency,
    int? minThreshold,
    String? coinRate,
    int? minUserLive,
    int? maxMinuteLive,
    int? messagePrice,
    int? reverseSwipePrice,
    int? liveWatchingPrice,
    String? admobIntIos,
    String? admobBannerIos,
    String? admobInt,
    String? admobBanner,
    int? isDating,
    int? isSocialMedia,
    int? postDescriptionLimit,
    int? postUploadImageLimit,
  }) =>
      Appdata(
        id: id ?? _id,
        currency: currency ?? _currency,
        minThreshold: minThreshold ?? _minThreshold,
        coinRate: coinRate ?? _coinRate,
        minUserLive: minUserLive ?? _minUserLive,
        maxMinuteLive: maxMinuteLive ?? _maxMinuteLive,
        messagePrice: messagePrice ?? _messagePrice,
        reverseSwipePrice: reverseSwipePrice ?? _reverseSwipePrice,
        liveWatchingPrice: liveWatchingPrice ?? _liveWatchingPrice,
        admobIntIos: admobIntIos ?? _admobIntIos,
        admobBannerIos: admobBannerIos ?? _admobBannerIos,
        admobInt: admobInt ?? _admobInt,
        admobBanner: admobBanner ?? _admobBanner,
        isDating: isDating ?? _isDating,
        isSocialMedia: isSocialMedia ?? _isSocialMedia,
        postDescriptionLimit: postDescriptionLimit ?? _postDescriptionLimit,
        postUploadImageLimit: postUploadImageLimit ?? _postUploadImageLimit,
      );

  int? get id => _id;

  String? get currency => _currency;

  int get minThreshold => _minThreshold ?? 0;

  String? get coinRate => _coinRate;

  int get minUserLive => _minUserLive ?? 0;

  int get maxMinuteLive => _maxMinuteLive ?? 0;

  int get messagePrice => _messagePrice ?? 0;

  int get reverseSwipePrice => _reverseSwipePrice ?? 0;

  int get liveWatchingPrice => _liveWatchingPrice ?? 0;

  String? get admobIntIos => _admobIntIos;

  String? get admobBannerIos => _admobBannerIos;

  String? get admobInt => _admobInt;

  String? get admobBanner => _admobBanner;

  int? get postDescriptionLimit => _postDescriptionLimit;

  int? get postUploadImageLimit => _postUploadImageLimit;

  int get isDating => _isDating ?? 0;

  int get isSocialMedia => _isSocialMedia ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['currency'] = _currency;
    map['min_threshold'] = _minThreshold;
    map['coin_rate'] = _coinRate;
    map['min_user_live'] = _minUserLive;
    map['max_minute_live'] = _maxMinuteLive;
    map['message_price'] = _messagePrice;
    map['reverse_swipe_price'] = _reverseSwipePrice;
    map['live_watching_price'] = _liveWatchingPrice;
    map['admob_int_ios'] = _admobIntIos;
    map['admob_banner_ios'] = _admobBannerIos;
    map['admob_int'] = _admobInt;
    map['admob_banner'] = _admobBanner;
    map['is_dating'] = _isDating;
    map['is_social_media'] = _isSocialMedia;
    map['post_description_limit'] = _postDescriptionLimit;
    map['post_upload_image_limit'] = _postUploadImageLimit;
    return map;
  }
}
