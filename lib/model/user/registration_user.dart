import 'package:orange_ui/service/pref_service.dart';
import 'package:orange_ui/story_view/controller/story_controller.dart';
import 'package:orange_ui/story_view/widgets/story_view.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/const_res.dart';

class RegistrationUser {
  RegistrationUser({
    bool? status,
    String? message,
    RegistrationUserData? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  RegistrationUser.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? RegistrationUserData.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  RegistrationUserData? _data;

  RegistrationUser copyWith({
    bool? status,
    String? message,
    RegistrationUserData? data,
  }) =>
      RegistrationUser(
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

class RegistrationUserData {
  RegistrationUserData({
    int? id,
    int? isBlock,
    int? gender,
    String? savedprofile,
    String? likedprofile,
    String? interests,
    int? age,
    String? identity,
    String? fullname,
    String? username,
    String? instagram,
    String? youtube,
    String? facebook,
    String? live,
    String? bio,
    String? about,
    String? lattitude,
    String? longitude,
    int? loginType,
    String? deviceToken,
    String? blockedUsers,
    int? wallet,
    int? totalCollected,
    int? following,
    int? followers,
    int? followingStatus,
    int? totalStreams,
    int? deviceType,
    int? isNotification,
    int? isVerified,
    int? showOnMap,
    int? anonymous,
    int? isVideoCall,
    int? canGoLive,
    int? isLiveNow,
    int? isFake,
    String? password,
    bool? isLiked,
    List<Story>? story,
    List<Images>? images,
  }) {
    _id = id;
    _isBlock = isBlock;
    _gender = gender;
    _savedprofile = savedprofile;
    _likedprofile = likedprofile;
    _interests = interests;
    _age = age;
    _identity = identity;
    _fullname = fullname;
    _username = username;
    _instagram = instagram;
    _youtube = youtube;
    _facebook = facebook;
    _live = live;
    _bio = bio;
    _about = about;
    _following = following;
    _followers = followers;
    _followingStatus = followingStatus;
    _lattitude = lattitude;
    _longitude = longitude;
    _loginType = loginType;
    _deviceToken = deviceToken;
    _blockedUsers = blockedUsers;
    _wallet = wallet;
    _totalCollected = totalCollected;
    _totalStreams = totalStreams;
    _deviceType = deviceType;
    _isNotification = isNotification;
    _isVerified = isVerified;
    _showOnMap = showOnMap;
    _anonymous = anonymous;
    _isVideoCall = isVideoCall;
    _canGoLive = canGoLive;
    _isLiveNow = isLiveNow;
    _isFake = isFake;
    _password = password;
    _story = story;
    _isLiked = isLiked;
    _images = images ?? [];
  }

  RegistrationUserData.fromJson(dynamic json) {
    _id = json['id'];
    _isBlock = json['is_block'];
    _gender = json['gender'];
    _savedprofile = json['savedprofile'];
    _likedprofile = json['likedprofile'];
    _interests = json['interests'];
    _age = json['age'];
    _identity = json['identity'];
    _fullname = json['fullname'];
    _username = json['username'];
    _instagram = json['instagram'];
    _youtube = json['youtube'];
    _facebook = json['facebook'];
    _following = json['following'];
    _followers = json['followers'];
    _followingStatus = json['followingStatus'];
    _live = json['live'];
    _bio = json['bio'];
    _about = json['about'];
    _lattitude = json['lattitude'];
    _longitude = json['longitude'];
    _loginType = json['login_type'];
    _deviceToken = json['device_token'];
    _blockedUsers = json['blocked_users'];
    _wallet = json['wallet'];
    _totalCollected = json['total_collected'];
    _totalStreams = json['total_streams'];
    _deviceType = json['device_type'];
    _isNotification = json['is_notification'];
    _isVerified = json['is_verified'];
    _showOnMap = json['show_on_map'];
    _anonymous = json['anonymous'];
    _isVideoCall = json['is_video_call'];
    _canGoLive = json['can_go_live'];
    _isLiveNow = json['is_live_now'];
    _isFake = json['is_fake'];
    _isLiked = json['is_like'];
    _password = json['password'];
    if (json['stories'] != null) {
      _story = [];
      json['stories'].forEach((v) {
        var s = Story.fromJson(v);
        s.user = this;
        story?.add(s);
      });
    }
    if (json['images'] != null) {
      _images = [];
      json['images'].forEach((v) {
        _images.add(Images.fromJson(v));
      });
    }
  }

  int? _id;
  int? _isBlock;
  int? _gender;
  String? _savedprofile;
  String? _likedprofile;
  String? _interests;
  int? _age;
  String? _identity;
  String? _fullname;
  String? _username;
  String? _instagram;
  String? _youtube;
  String? _facebook;
  String? _live;
  String? _bio;
  String? _about;
  String? _lattitude;
  String? _longitude;
  int? _loginType;
  int? _following;
  int? _followers;
  int? _followingStatus;
  String? _deviceToken;
  String? _blockedUsers;
  int? _wallet;
  int? _totalCollected;
  int? _totalStreams;
  int? _deviceType;
  int? _isNotification;
  int? _isVerified;
  int? _showOnMap;
  int? _anonymous;
  int? _isVideoCall;
  int? _canGoLive;
  int? _isLiveNow;
  int? _isFake;
  String? _password;
  bool? _isLiked;
  List<Story>? _story;
  List<Images> _images = [];

  int? get id => _id;

  int? get isBlock => _isBlock;

  int? get gender => _gender;

  String? get savedprofile => _savedprofile;

  String? get likedprofile => _likedprofile;

  String? get interests => _interests;

  int? get age => _age;
  int? get following => _following;
  int? get followers => _followers;
  int? get followingStatus => _followingStatus;

  String? get identity => _identity;

  String? get fullname => _fullname;
  String? get username => _username;

  String? get instagram => _instagram;

  String? get youtube => _youtube;

  String? get facebook => _facebook;

  String? get live => _live;

  String? get bio => _bio;

  String? get about => _about;

  String? get lattitude => _lattitude;

  String? get longitude => _longitude;

  int? get loginType => _loginType;

  String? get deviceToken => _deviceToken;

  String? get blockedUsers => _blockedUsers;

  int? get wallet => _wallet;

  int? get totalCollected => _totalCollected;

  int? get totalStreams => _totalStreams;

  int? get deviceType => _deviceType;

  int? get isNotification => _isNotification;

  int? get isVerified => _isVerified;

  int? get showOnMap => _showOnMap;

  int? get anonymous => _anonymous;

  int? get isVideoCall => _isVideoCall;

  int? get canGoLive => _canGoLive;

  int? get isLiveNow => _isLiveNow;

  int? get isFake => _isFake;
  bool? get isLiked => _isLiked;

  String? get password => _password;
  List<Story>? get story => _story;
  List<Images> get images => _images;

  void followerCount(int value) {
    _followers = (followers ?? 0) + value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['is_block'] = _isBlock;
    map['gender'] = _gender;
    map['savedprofile'] = _savedprofile;
    map['likedprofile'] = _likedprofile;
    map['interests'] = _interests;
    map['age'] = _age;
    map['identity'] = _identity;
    map['fullname'] = _fullname;
    map['username'] = _username;
    map['instagram'] = _instagram;
    map['youtube'] = _youtube;
    map['facebook'] = _facebook;
    map['live'] = _live;
    map['bio'] = _bio;
    map['following'] = _following;
    map['followers'] = _followers;
    map['followingStatus'] = _followingStatus;
    map['about'] = _about;
    map['lattitude'] = _lattitude;
    map['longitude'] = _longitude;
    map['login_type'] = _loginType;
    map['device_token'] = _deviceToken;
    map['blocked_users'] = _blockedUsers;
    map['wallet'] = _wallet;
    map['total_collected'] = _totalCollected;
    map['total_streams'] = _totalStreams;
    map['device_type'] = _deviceType;
    map['is_notification'] = _isNotification;
    map['is_verified'] = _isVerified;
    map['show_on_map'] = _showOnMap;
    map['anonymous'] = _anonymous;
    map['is_video_call'] = _isVideoCall;
    map['can_go_live'] = _canGoLive;
    map['is_live_now'] = _isLiveNow;
    map['is_fake'] = _isFake;
    map['password'] = _password;
    map['is_like'] = _isLiked;
    if (_story != null) {
      map['stories'] = _story?.map((v) => v.toJson()).toList();
    }
    if (_images.isNotEmpty) {
      map['images'] = _images.map((v) => v.toJson()).toList();
    }
    return map;
  }

  bool isAllStoryShown() {
    var isWatched = true;
    for (var element in (story ?? [])) {
      if (!element.isWatchedByMe()) {
        isWatched = false;
        break;
      }
    }
    return isWatched;
  }
}

class Images {
  Images({
    int? id,
    int? userId,
    String? image,
  }) {
    _id = id;
    _userId = userId;
    _image = image;
  }

  Images.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _image = json['image'];
  }

  int? _id;
  int? _userId;
  String? _image;

  Images copyWith({
    int? id,
    int? userId,
    String? image,
  }) =>
      Images(
        id: id ?? _id,
        userId: userId ?? _userId,
        image: image ?? _image,
      );

  int? get id => _id;

  int? get userId => _userId;

  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['image'] = _image;
    return map;
  }
}

class Interest {
  Interest({
    int? id,
    String? title,
    String? image,
  }) {
    _id = id;
    _title = title;
    _image = image;
  }

  Interest.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _image = json['image'];
  }

  int? _id;
  String? _title;
  String? _image;

  Interest copyWith({
    int? id,
    String? title,
    String? image,
  }) =>
      Interest(
        id: id ?? _id,
        title: title ?? _title,
        image: image ?? _image,
      );

  int? get id => _id;

  String? get title => _title;

  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['image'] = _image;
    return map;
  }
}

class Story {
  Story({
    int? id,
    int? userId,
    int? type,
    int? duration,
    String? content,
    String? viewByUserIds,
    String? createdAt,
    String? updatedAt,
    bool? storyView,
  }) {
    _id = id;
    _userId = userId;
    _type = type;
    _duration = duration;
    _content = content;
    _viewByUserIds = viewByUserIds;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _storyView = storyView;
  }

  Story.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _type = json['type'];
    _duration = json['duration'];
    _content = json['content'];
    _viewByUserIds = json['view_by_user_ids'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _storyView = json['storyView'];
  }
  int? _id;
  int? _userId;
  int? _type;
  int? _duration;
  String? _content;
  String? _viewByUserIds;
  String? _createdAt;
  String? _updatedAt;
  bool? _storyView;
  RegistrationUserData? user;

  int? get id => _id;
  int? get userId => _userId;
  int? get type => _type;
  int? get duration => _duration;
  String? get content => _content;

  // ignore: unnecessary_getters_setters
  String? get viewByUserIds => _viewByUserIds;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  bool? get storyView => _storyView;

  set viewByUserIds(String? value) {
    _viewByUserIds = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['type'] = _type;
    map['duration'] = _duration;
    map['content'] = _content;
    map['view_by_user_ids'] = _viewByUserIds;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['storyView'] = _storyView;
    return map;
  }

  bool isWatchedByMe() {
    var arr = viewByUserIds?.split(',') ?? [];
    return arr.contains(PrefService.userId.toString());
  }

  List<String> viewedByUsersIds() {
    return viewByUserIds?.split(',') ?? [];
  }

  StoryItem toStoryItem(StoryController controller) {
    if (type == 1) {
      return StoryItem.pageVideo(
        '${ConstRes.aImageBaseUrl}$content',
        story: this,
        controller: controller,
        duration: Duration(seconds: (duration ?? 0).toInt()),
        shown: isWatchedByMe(),
        id: id ?? 0,
        viewedByUsersIds: viewedByUsersIds(),
      );
    } else if (type == 0) {
      return StoryItem.pageImage(
        story: this,
        url: '${ConstRes.aImageBaseUrl}$content',
        controller: controller,
        duration: const Duration(seconds: storyDuration),
        shown: isWatchedByMe(),
        id: id ?? 0,
        viewedByUsersIds: viewedByUsersIds(),
      );
    } else {
      return StoryItem.text(
        story: this,
        title: content ?? '',
        backgroundColor: ColorRes.black,
        shown: isWatchedByMe(),
        id: id ?? 0,
        duration: const Duration(seconds: storyDuration),
        viewedByUsersIds: viewedByUsersIds(),
      );
    }
  }

  DateTime get date => DateTime.parse(createdAt ?? '');
}
