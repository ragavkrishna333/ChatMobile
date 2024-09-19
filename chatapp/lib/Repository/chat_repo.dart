import 'dart:convert';

import 'package:chatapp/screens/groupchat/model/creategroupmodel.dart';
import 'package:http/http.dart' as http;

class ChatRepository {
  String baseUrl = "http://192.168.2.124:29096/";

  Future<dynamic> signUp(String uid, String uname, String password) async {
    var url = Uri.parse("${baseUrl}signUp");
    var responds = await http.post(url, body: '''{
    "Uid": "$uid",
    "User_Name": "$uname",
    "Pass": "$password"
}''');
    if (responds.statusCode == 200) {
      var result = jsonDecode(responds.body);
      return result;
    }
    return jsonDecode(responds.body);
  }

  Future<dynamic> login(String uid, String password) async {
    var url = Uri.parse("${baseUrl}login");
    var responds = await http.post(url, body: '''{
    "Uid": "$uid",
    "Pass": "$password"
}''');
    if (responds.statusCode == 200) {
      var result = jsonDecode(responds.body);
      return result;
    }
    return jsonDecode(responds.body);
  }

  Future<dynamic> getMembers() async {
    var url = Uri.parse("${baseUrl}getMembers");
    var responds = await http.get(url);
    if (responds.statusCode == 200) {
      var result = jsonDecode(responds.body);
      if (result['Status'] == 'S') {
        return result['MembersArr'];
      } else {
        return [];
      }
    }
    return jsonDecode(responds.body);
  }

  Future<dynamic> getGroupList() async {
    var url = Uri.parse("${baseUrl}fetchGroup");
    var responds = await http.get(url);
    if (responds.statusCode == 200) {
      var result = jsonDecode(responds.body);
      if (result['Status'] == 'S') {
        return result['Group_Data'];
      } else {
        return [];
      }
    }
    return jsonDecode(responds.body);
  }

  Future<dynamic> createGroupApi(CreateGroup parameter) async {
    var url = Uri.parse("${baseUrl}createGroup");
    var responds = await http.post(url, body: jsonEncode(parameter));
    if (responds.statusCode == 200) {
      var result = jsonDecode(responds.body);

      if (result['Status'] == 'S') {
        return result;
      } else {
        return {};
      }
    }
    return jsonDecode(responds.body);
  }

  Future<dynamic> deleteGroup(
      {required String groupId,
      required String currentUid,
      required String admin}) async {
    var url = Uri.parse("${baseUrl}deleteGroup");
    var responds = await http.delete(url, body: '''{
    "Group_ID":"$groupId",
    "Uid":"$currentUid",
    "Admin":"$admin"
}''');
    if (responds.statusCode == 200) {
      var result = jsonDecode(responds.body);

      if (result['Status'] == 'S') {
        return result;
      } else {
        return {};
      }
    }
    return jsonDecode(responds.body);
  }

  Future<dynamic> getPreviousChat() async {
    var url = Uri.parse("${baseUrl}fetchChat");
    var responds = await http.get(url);
    if (responds.statusCode == 200) {
      var result = jsonDecode(responds.body);
      if (result['Status'] == 'S') {
        return result['SocketMsg'];
      } else {
        return [];
      }
    }
    return jsonDecode(responds.body);
  }
}
