import 'package:orange_ui/model/user/registration_user.dart';

/// status : true
/// message : "anonymous state updated successfully"
/// data : {"id":19,"is_block":0,"gender":1,"savedprofile":"3,4","likedprofile":null,"interests":"11,8,4,2,6,10,7","age":22,"identity":"dhruvkathiriya.retrytech@gmail.com","fullname":"Dhruv kathiriya","instagram":"https://www.instagram.com/madhuram_sweet/","youtube":"https://www.youtube.com/watch?v=T0ur0HL6d5M&list=RDAETFvQonfV8&index=18","facebook":"https://www.instagram.com/madhuram_sweet/","live":"Surat, Gujarat","bio":"Roget's 21st Century Thesaurus, Third Edition Copyright © 2013 by the Philip Lie","about":"Hi, I am natalia Nora, I am 24 years old and I am looking for someone who is serious in loving and caring for me.","lattitude":null,"longitude":null,"login_type":1,"device_token":"c7TT_NynSQKd2Ozg_aH3Kh:APA91bHZJsYfkn6Y6KS3bYY6GDb5InaZH02U8Sxjz_9e9GB89lM7flyOoilY4_aBrDt-cUPkFYVlWjw3oTuTNDGnxjUh56ceAsvjWY_wkpZT_SpTiZGRRh_OxYqA6QdvhPA_OG31Kpur","wallet":0,"total_collected":0,"total_streams":1,"device_type":1,"is_notification":0,"show_on_map":0,"anonymous":0,"is_video_call":1,"can_go_live":0}

class OnOffAnonymous {
  OnOffAnonymous({
    bool? status,
    String? message,
    RegistrationUserData? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  OnOffAnonymous.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null
        ? RegistrationUserData.fromJson(json['data'])
        : null;
  }

  bool? _status;
  String? _message;
  RegistrationUserData? _data;

  OnOffAnonymous copyWith({
    bool? status,
    String? message,
    RegistrationUserData? data,
  }) =>
      OnOffAnonymous(
        status: status ?? _status,
        message: message ?? _message,
        data: data ?? _data,
      );

  bool? get status => _status;

  String? get message => _message;

  RegistrationUserData? get data => _data;

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
