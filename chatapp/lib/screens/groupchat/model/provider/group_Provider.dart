import 'dart:convert';

import 'package:chatapp/Repository/chat_repo.dart';
import 'package:chatapp/screens/groupchat/model/creategroupmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupProvider extends ChangeNotifier {
  List memberList = [];
  List<bool> isChecked = [];
  Map currentUserdata = {};
  getCurrentUserData(Map value) {
    currentUserdata = value;
    notifyListeners();
  }

  initialFunction() {
    getMembersList();
  }

  getMembersList() async {
    memberList = await ChatRepository().getMembers() ?? {};
    memberList
        .removeWhere((element) => element["Uid"] == currentUserdata["Uid"]);
    isChecked = List.generate(memberList.length, (_) => false);
    notifyListeners();
  }

  bool createG = false;
  createButton(bool value) {
    createG = value;
    notifyListeners();
  }

  TextEditingController groupNameController = TextEditingController();
  Set<GroupMember> groupMembers = {};
  CreateGroup createGroupData() {
    return CreateGroup(
        groupName: groupNameController.text,
        groupMembers: groupMembers.toList());
  }

  addMembersFunction(Set<GroupMember> value) {
    groupMembers.add(GroupMember(
        uid: currentUserdata['Uid'],
        userName: currentUserdata['User_Name'],
        admin: "Y"));
    groupMembers.addAll(value);
    // for (var element in groupMembers) {
    // print("jkkkkkkkkkkkkkkkkkk&${jsonEncode(element)}");
    // }
    notifyListeners();
  }

  Map result = {};
  createGroupFunction() async {
    result = await ChatRepository().createGroupApi(createGroupData()) ?? {};
    notifyListeners();
  }
}
