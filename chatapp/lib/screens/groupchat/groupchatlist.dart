import 'package:chatapp/provider/homechat_provider.dart';
import 'package:chatapp/screens/groupchat/groupchatpage.dart';
import 'package:chatapp/screens/groupchat/model/provider/group_Provider.dart';
import 'package:chatapp/screens/memberlist.dart';
import 'package:chatapp/widgets/tileWiget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupchatList extends StatefulWidget {
  const GroupchatList({super.key});

  @override
  State<GroupchatList> createState() => _GroupchatListState();
}

class _GroupchatListState extends State<GroupchatList> {
  late HomechatProvider myData;
  @override
  void initState() {
    myData = Provider.of<HomechatProvider>(context, listen: false);
    myData.initialfunction();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer2<HomechatProvider, GroupProvider>(
            builder: (context, myData, myGroup, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return
                          // TileWidget(isGroup: true,isUnread: true,message:"${}" ,)

                          ListTile(
                        onTap: () {
                          Provider.of<HomechatProvider>(context, listen: false)
                              .setGroupMap(myData.groupList[index]);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => GroupChatpage(
                              groupName: myData.groupList[index]['Group_Name'],
                              toGroupId: myData.groupList[index]['GroupID'],
                            ),
                          ));
                        },
                        title: Text(
                          myData.groupList[index]['Group_Name'] ?? "",
                        ),
                        trailing: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(172, 255, 209, 70)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "${myData.outerMsgList.where((element) => element['ToGroupID'] == myData.groupList[index]['GroupID']).toList().length}"),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                          height: 10,
                        ),
                    itemCount: myData.groupList.length),
              ),
            ],
          );
        }),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: SizedBox(
              height: 40,
              child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Color.fromARGB(255, 255, 217, 103),
                  onPressed: () {
                    Provider.of<GroupProvider>(context, listen: false)
                        .createButton(true);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MemberListScreen(),
                    ));
                  },
                  child: Text("+ New Group"))),
        ),
      ),
    );
  }
}

List socketList = [];
List functionList(
    Map<dynamic, dynamic> decodeData, Map<dynamic, dynamic> groupMap) {
  if ((decodeData['ToGroupID'] == groupMap['GroupID'] &&
      decodeData.containsValue('gr'))) {
    socketList.addAll([decodeData]);
  }
  return socketList;
}
