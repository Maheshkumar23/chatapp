import 'package:orange_ui/model/user/registration_user.dart';

/// status : true
/// message : "all data fetch\nsuccessful"
/// data : [{"id":11,"title":"Music","image":"uploads/P1xJQyVTIj1YZxizRfbDdT1x5WE2yMLF7forLmgX.png"},{"id":10,"title":"Foodies","image":"uploads/gJ51Sv3mZxsTudTcySvEhlC5ToDFf9lF4xSFKDUd.png"},{"id":9,"title":"Movies","image":"uploads/b8B9IRxGjEylIvfjDSWozwtczDGFzTEbmWAt7Nqi.png"},{"id":8,"title":"Walking","image":"uploads/VJkUU1OITfNNrKrnnWGC2TzUS6KbinVo5SAcivol.png"},{"id":7,"title":"Chef","image":"uploads/hERepjzwQi40NcCcnk1kJOT3sc5Tkf80rsLpgmnp.png"},{"id":6,"title":"Singing","image":"uploads/EgbAZng3V7wMdWQhOcMWWHy8g1OhVWCxVjZDM2ZG.png"},{"id":4,"title":"Travel","image":"uploads/gZCZRzfg7e6kB4cYzKgV8lRcBHLdNRwTZPyHRPYF.png"},{"id":2,"title":"Artist","image":"uploads/eoALUGAez3EJLII4xHsMfoKA5f1dkylaVymy4MNW.png"}]

class GetInterest {
  GetInterest({
    bool? status,
    String? message,
    List<Interest>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  GetInterest.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Interest.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Interest>? _data;

  GetInterest copyWith({
    bool? status,
    String? message,
    List<Interest>? data,
  }) =>
      GetInterest(
        status: status ?? _status,
        message: message ?? _message,
        data: data ?? _data,
      );

  bool? get status => _status;

  String? get message => _message;

  List<Interest>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
