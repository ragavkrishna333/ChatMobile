import 'dart:convert';

CreateGroup createGroupFromJson(String str) =>
    CreateGroup.fromJson(json.decode(str));

String createGroupToJson(CreateGroup data) => json.encode(data.toJson());

class CreateGroup {
  String groupName;
  List<GroupMember> groupMembers;

  CreateGroup({
    required this.groupName,
    required this.groupMembers,
  });

  factory CreateGroup.fromJson(Map<String, dynamic> json) => CreateGroup(
        groupName: json["Group_Name"],
        groupMembers: List<GroupMember>.from(
            json["Group_Members"].map((x) => GroupMember.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Group_Name": groupName,
        "Group_Members":
            List<dynamic>.from(groupMembers.map((x) => x.toJson())),
      };
}

class GroupMember {
  String? admin;
  String uid;
  String userName;

  GroupMember({
    this.admin,
    required this.uid,
    required this.userName,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) => GroupMember(
        admin: json["Admin"],
        uid: json["Uid"],
        userName: json["User_Name"],
      );

  Map<String, dynamic> toJson() => {
        "Admin": admin,
        "Uid": uid,
        "User_Name": userName,
      };
}
