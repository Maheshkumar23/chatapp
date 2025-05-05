import 'package:orange_ui/model/user/registration_user.dart';

class UserBlockList {
  UserBlockList({
    bool? status,
    String? message,
    RegistrationUserData? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  UserBlockList.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null
        ? RegistrationUserData.fromJson(json['data'])
        : null;
  }

  bool? _status;
  String? _message;
  RegistrationUserData? _data;

  UserBlockList copyWith({
    bool? status,
    String? message,
    RegistrationUserData? data,
  }) =>
      UserBlockList(
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
