import 'package:orange_ui/model/user/registration_user.dart';

/// status : true
/// message : "all data fetch successful"
/// data : {"id":19,"is_block":0,"gender":1,"savedprofile":null,"likedprofile":null,"interests":[{"id":6,"title":"Singing","image":"uploads/EgbAZng3V7wMdWQhOcMWWHy8g1OhVWCxVjZDM2ZG.png"}],"age":22,"identity":"dhruvkathiriya.retrytech@gmail.com","fullname":"Dhruv Kathiriya","instagram":null,"youtube":null,"facebook":null,"live":"India","bio":"Streaming this kind of content might resulte to account sunpension","about":null,"lattitude":null,"longitude":null,"login_type":4,"device_token":"eisuAVBPo0-VjftjzZFHQO:APA91bHx1zpF4mJC0SAH4Z-MDGhy71Nh-gj4RQKZq5DrGzLhtM-Bch-r92wa6WmBzF8QldO2qjmc0O4Pq7qtSUfYpew1ff8vlT9fw4MF9f-KBWL5ROdqN_HEfJk0KLhUFRyFR79adRf2","wallet":0,"total_collected":0,"total_streams":0,"device_type":2,"is_notification":1,"show_on_map":1,"anonymous":0,"is_video_call":1,"can_go_live":0,"images":[{"image":"uploads/m6ozvK6CUiUsmRA8OTn55qD4P59VrVSJBbT66q7N.jpg","id":120}]}

class GetProfile {
  GetProfile({
    bool? status,
    String? message,
    RegistrationUserData? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  GetProfile.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null
        ? RegistrationUserData.fromJson(json['data'])
        : null;
  }

  bool? _status;
  String? _message;
  RegistrationUserData? _data;

  GetProfile copyWith({
    bool? status,
    String? message,
    RegistrationUserData? data,
  }) =>
      GetProfile(
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
