import 'package:orange_ui/model/user/registration_user.dart';

/// status : true
/// message : "Update successful"
/// data : {"id":19,"is_block":0,"gender":1,"savedprofile":"3","likedprofile":"3","interests":[{"image":"uploads/eoALUGAez3EJLII4xHsMfoKA5f1dkylaVymy4MNW.png","title":"Artist"},{"image":"uploads/gZCZRzfg7e6kB4cYzKgV8lRcBHLdNRwTZPyHRPYF.png","title":"Travel"},{"image":"uploads/EgbAZng3V7wMdWQhOcMWWHy8g1OhVWCxVjZDM2ZG.png","title":"Singing"},{"image":"uploads/hERepjzwQi40NcCcnk1kJOT3sc5Tkf80rsLpgmnp.png","title":"Chef"},{"image":"uploads/VJkUU1OITfNNrKrnnWGC2TzUS6KbinVo5SAcivol.png","title":"Walking"},{"image":"uploads/gJ51Sv3mZxsTudTcySvEhlC5ToDFf9lF4xSFKDUd.png","title":"Foodies"},{"image":"uploads/P1xJQyVTIj1YZxizRfbDdT1x5WE2yMLF7forLmgX.png","title":"Music"}],"age":22,"identity":"dhruvkathiriya.retrytech@gmail.com","fullname":"Dhruv kathiriya","instagram":"https://www.instagram.com/madhuram_sweet/","youtube":"https://www.youtube.com/watch?v=T0ur0HL6d5M&list=RDAETFvQonfV8&index=18","facebook":null,"live":"Surat, Gujarat","bio":"Roget's 21st Century Thesaurus, Third Edition Copyright © 2013 by the Philip Lie","about":"Hi, I am natalia Nora, I am 24 years old and I am looking for someone who is serious in loving and caring for me.","lattitude":null,"longitude":null,"login_type":1,"device_token":"ep9b8HrRV0LnjdMdVjxm4T:APA91bHsaQ19pKrnS9RVU7gi2D2j9TVSKJ33HLk7HBZ5fz9xIXbcXhWSOcRrzP3UtjNCcE_I93UD-zKongHsDP4jFCjCAkGTS98limdygiMDF6bWj_Nx8Cbg70cuJnrlipekvFl7NS9Q","wallet":0,"total_collected":369000,"total_streams":8,"device_type":2,"is_notification":1,"show_on_map":1,"anonymous":1,"is_video_call":0,"can_go_live":2,"images":[{"image":"uploads/dE1qIHpsFvaBaYqCIarIEzVh9kKHKTJScESDMyhh.jpg","id":167},{"image":"uploads/gdEKTEPaiw8Aev9cGmXwcq63ppJeeyRVBozSsmgU.jpg","id":168},{"image":"uploads/yuze3No8mmcwsZkBvQOWHvl15evbQQYfa2zBInk9.jpg","id":169},{"image":"uploads/JYKfoa9VEWU4L95BbPkHHbaOvisLATS4s1XO3aGb.jpg","id":170},{"image":"uploads/dUBovipr4J6MGRkgxpS1gWMGeuc8bH1PEJ1DhaXE.jpg","id":171},{"image":"uploads/KCqGE2Tz6uxYS6oQldL14E5sqrMPKsPZva4LSnjl.jpg","id":172}]}

class UpdateSavedProfile {
  UpdateSavedProfile({
    bool? status,
    String? message,
    RegistrationUserData? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  UpdateSavedProfile.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null
        ? RegistrationUserData.fromJson(json['data'])
        : null;
  }

  bool? _status;
  String? _message;
  RegistrationUserData? _data;

  UpdateSavedProfile copyWith({
    bool? status,
    String? message,
    RegistrationUserData? data,
  }) =>
      UpdateSavedProfile(
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
