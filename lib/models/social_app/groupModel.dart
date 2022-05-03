// @dart=2.9
import 'dart:convert';

import 'package:fast_chat/models/social_app/social_user_model.dart';

class GroupModel {
  int groupId;
  String groupName;
  List<SocialUserModel> listSocialUserModel;

  GroupModel({
    this.groupId,
    this.groupName,
    this.listSocialUserModel,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> listSocialUserModel = json['listSocialUserModel'] ?? [];

    var usersList = listSocialUserModel.map((e) => SocialUserModel.fromJson(e)).toList();

    return GroupModel(
        groupId: json['groupId'],
        groupName: json['groupName'],
        listSocialUserModel: usersList
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'listSocialUserModel': listSocialUserModel.map((e) => e.toMap())?.toList(),
    };
  }

  @override
  String toString() {
    return const JsonEncoder.withIndent(' ').convert(this);
  }
}
