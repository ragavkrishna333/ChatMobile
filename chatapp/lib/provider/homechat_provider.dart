import 'dart:convert';

import 'package:chatapp/Repository/chat_repo.dart';
import 'package:chatapp/widgets/socketservice.dart';
import 'package:flutter/material.dart';

class HomechatProvider extends ChangeNotifier {
  Map chatMap = {};
  Map socketMap = {};
  Set groupsocketList = {};
  Set socketList = {};
  List chatList = [];
  List homeChatList = [];
  List groupList = [];
  Map groupMap = {};
  List groupMembers = [];
  List memberList = [];

  initialfunction() {
    getGroupList();
  }

  getMembersList() async {
    memberList = await ChatRepository().getMembers() ?? {};
    memberList.removeWhere((element) => element["Uid"] == loginUserId);
    notifyListeners();
  }

  getGroupList() async {
    groupList = await ChatRepository().getGroupList() ?? [];
    // groupList.where((element) => element['Group_Members'])
    print(loginUserId);
    // bool containVal =
    //     groupMembers.any((member) => member['Uid'] == loginUserId);
    // if (!containVal) {
    //   groupList.removeWhere((group) => !group["Group_Members"]
    //       .any((member) => member["Uid"] == loginUserId));
    //   print("ddddddddddd$groupList");
    // }
    // groupName=groupList.where
    notifyListeners();
  }

  setGroupMap(Map value) {
    groupMap = value;
    groupMembers = groupMap['Group_Members'];
    notifyListeners();
  }

  // Function to check if Uid exists using the `where` method
  bool containsUid(List<dynamic> list, String uid) {
    return list.where((map) => map['Uid'] == uid).isNotEmpty;
  }

  bool timeMsg(List<dynamic> list, String time) {
    return list.where((map) => map['Created_Time'] == time).isNotEmpty;
  }

  void addMap(Map newMap) {
    // Extract the Uid and Message from the new map
    String newUid = newMap['Uid'];

    // Find the index of the map with the same Uid
    int index = homeChatList.indexWhere((map) => map['Uid'] == newUid);

    if (index == -1) {
      // If no map with the same Uid is found, add the new map to the list
      homeChatList.add(newMap);
    } else {
      String newMessage = newMap['Message'];
      // If a map with the same Uid is found, check if the Message is different
      if (homeChatList[index]['Message'] != newMessage) {
        // Update the Message in the existing map
        homeChatList[index]['Message'] = newMessage;
        // homeChatList[index]['Created_Time'] = newMap['Created_Time'];
        homeChatList[index]['Created_Time'] = newMap['Created_Time'];
      }
    }
  }

  setChatMap(Map value) {
    chatMap = value;
    // print("setttttttttttttttttttttt");
    addMap(value);
    notifyListeners();
  }

  String sender = "";
  String currentuser = "";
  setChatList(List value) {
    chatList = value;

    notifyListeners();
  }

  String adminFunction() {
    List adminList =
        groupMembers.where((element) => element['Admin'] == 'Y').toList();

    if (containsUid(adminList, loginUserId)) {
      return "Y";
    } else {
      return "N";
    }
  }

  String loginUserId = "";
  String loginUserName = "";
  setUser(String value, String uname) {
    loginUserId = value;
    loginUserName = uname;
    notifyListeners();
  }

  List outerMsgList = [];
  Map<String, dynamic> decodeData = {};
  List totalchatListdata = [];
  List userChatList = [];
  List grUserchatList = [];
  List outerMsg2 = [];
  String currentChatUid = "";
  setCurrenchatUid(String uid) {
    currentChatUid = uid;
    notifyListeners();
  }

  previousPVmsg() {
    userChatList = totalchatListdata
        .where((element) =>
            (element['ToUid'] == loginUserId ||
                element['FromUid'] == loginUserId) &&
            element.containsValue('pv') &&
            !element.containsValue('gr'))
        .toList();
    for (var element in userChatList) {
      // addMap({"Uid": element['FromUid'], "User_Name": element['FromUserName']});
      if ((element['ToUid'] == loginUserId && element.containsValue('pv')) ||
          (element['FromUid'] == loginUserId && element.containsValue('pv')) &&
              !element.containsValue('gr')) {
        // socketMap = element;
        if (currentChatUid == element['FromUid'] ||
            element['FromUid'] == loginUserId ||
            element['ToUid'] == loginUserId) {
          socketList.addAll([element]);
        }

        addMap({
          "Uid": "${element['FromUid']}",
          "User_Name": "${element['FromUserName']}",
          "Created_Time":
              "${userChatList[userChatList.length - 1]['Created_Time']}",
          "Message": "${element['Message']}"
        });

        notifyListeners();
      }
    }
    notifyListeners();
  }

  previousGRmsg() {
    grUserchatList = totalchatListdata
        .where((element) =>
            element['ToGroupID'] != "" &&
            element.containsValue('gr') &&
            !decodeData.containsValue('pv'))
        .toList();

    for (var data in grUserchatList) {
      outerMsg2 = groupList
          .where(
            (element) =>
                element['GroupID'] == data['ToGroupID'] &&
                !data.containsValue('pv'),
          )
          .toList();
      if (outerMsg2.any((element) =>
          element['GroupID'] == data['ToGroupID'] &&
          data.containsValue('gr') &&
          !data.containsValue('pv'))) {
        outerMsgList.addAll([data]);
        groupsocketList.addAll([data]);
      }
    }
    notifyListeners();
  }

  initialSocketFunction() async {
    totalchatListdata = await ChatRepository().getPreviousChat() ?? [];
    await getGroupList();
    await previousPVmsg();
    await previousGRmsg();

    SocketService().listenToSocket((event) {
      decodeData = jsonDecode(event);

      print(decodeData);
      // bool isMemberIngroup = groupMembers
      //     .any((element) => element['Uid'] == decodeData['FromUid']);
      if ((decodeData['ToUid'] == loginUserId &&
              decodeData.containsValue('pv')) ||
          (decodeData['FromUid'] == loginUserId &&
                  decodeData.containsValue('pv')) &&
              !decodeData.containsValue('gr')) {
        socketMap.addAll(decodeData);

        socketList.addAll([decodeData]);
        // print("oooooooooooooooooooooooo");
        addMap({
          "Uid": "${decodeData['FromUid']}",
          "User_Name": "${decodeData['FromUserName']}",
          "Created_Time": "${decodeData['Created_Time']}",
          "Message": "${decodeData['Message'] ?? ""}"
        });
        notifyListeners();
      } else if ((decodeData['ToUid'] == chatMap['Uid'] &&
              decodeData.containsValue('pv')) ||
          (decodeData['FromUid'] == chatMap['Uid'] &&
                  decodeData.containsValue('pv')) &&
              !decodeData.containsValue('gr')) {
        socketMap.addAll(decodeData);
        socketList.addAll([decodeData]);
        sender = chatList
            .where(
              (element) => element['Uid'] == socketMap['ToUid'],
            )
            .toList()[0]['User_Name'];
        currentuser = chatList
            .where(
              (element) => element['Uid'] == socketMap['FromUid'],
            )
            .toList()[0]['User_Name'];
        notifyListeners();
      }
      List outerMsg1 = groupList
          .where(
            (element) => element['GroupID'] == decodeData['ToGroupID'],
          )
          .toList();
      if (outerMsg1.any((element) =>
          element['GroupID'] == decodeData['ToGroupID'] &&
          !decodeData.containsValue('pv'))) {
        outerMsgList.addAll([decodeData]);
        // if ((decodeData['ToGroupID'] == groupMap['GroupID'] &&
        //         decodeData.containsValue('gr')) &&
        //     isMemberIngroup) {
        //   socketMap = decodeData;
        //   print("kkkkkkkkkkkk$socketMap");
        //   socketList.addAll([decodeData]);
        //   notifyListeners();
        // }
        groupsocketList.addAll([decodeData]);
        notifyListeners();
      }
    });
    notifyListeners();
  }
}
