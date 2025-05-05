import 'package:orange_ui/model/user/registration_user.dart';

class UserNotification {
  UserNotification({
    bool? status,
    String? message,
    List<UserNotificationData>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  UserNotification.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(UserNotificationData.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<UserNotificationData>? _data;

  UserNotification copyWith({
    bool? status,
    String? message,
    List<UserNotificationData>? data,
  }) =>
      UserNotification(
        status: status ?? _status,
        message: message ?? _message,
        data: data ?? _data,
      );

  bool? get status => _status;

  String? get message => _message;

  List<UserNotificationData>? get data => _data;

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

class UserNotificationData {
  UserNotificationData({
    int? id,
    int? userId,
    int? dataUserId,
    int? type,
    String? createdAt,
    String? updatedAt,
    RegistrationUserData? dataUser,
  }) {
    _id = id;
    _userId = userId;
    _dataUserId = dataUserId;
    _type = type;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _dataUser = dataUser;
  }

  UserNotificationData.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _dataUserId = json['data_user_id'];
    _type = json['type'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _dataUser = json['user'] != null
        ? RegistrationUserData.fromJson(json['user'])
        : null;
  }

  int? _id;
  int? _userId;
  int? _dataUserId;
  int? _type;
  String? _createdAt;
  String? _updatedAt;
  RegistrationUserData? _dataUser;

  UserNotificationData copyWith({
    int? id,
    int? userId,
    int? dataUserId,
    int? type,
    String? createdAt,
    String? updatedAt,
    RegistrationUserData? dataUser,
  }) =>
      UserNotificationData(
        id: id ?? _id,
        userId: userId ?? _userId,
        dataUserId: dataUserId ?? _dataUserId,
        type: type ?? _type,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        dataUser: dataUser ?? _dataUser,
      );

  int? get id => _id;

  int? get userId => _userId;

  int? get dataUserId => _dataUserId;

  int? get type => _type;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  RegistrationUserData? get dataUser => _dataUser;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['data_user_id'] = _dataUserId;
    map['type'] = _type;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_dataUser != null) {
      map['user'] = _dataUser?.toJson();
    }
    return map;
  }
}
