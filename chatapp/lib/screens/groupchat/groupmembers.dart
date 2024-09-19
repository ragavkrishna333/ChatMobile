import 'package:chatapp/Repository/chat_repo.dart';
import 'package:chatapp/provider/homechat_provider.dart';
import 'package:chatapp/screens/Tabscreen.dart';
import 'package:chatapp/screens/groupchat/AlertBox.dart';
import 'package:chatapp/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class GroupMembers extends StatefulWidget {
  const GroupMembers({super.key, required this.groupId});
  final String groupId;
  @override
  State<GroupMembers> createState() => _GroupMembersState();
}

class _GroupMembersState extends State<GroupMembers> {
  late HomechatProvider myData;
  @override
  void initState() {
    myData = Provider.of<HomechatProvider>(context, listen: false);

    super.initState();
  }

  @override
  void dispose() {
    // myData.groupMembers.clear();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 221, 119),
          title: Text("Group Members"),
          actions: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertBox(
                    title: "Group Delete",
                    content: "You're Ablout to Delete the Group, Are you sure?",
                    onPressed: () async {
                      Map result = await ChatRepository().deleteGroup(
                              groupId: widget.groupId,
                              currentUid: myData.loginUserId,
                              admin: myData.adminFunction()) ??
                          {};
                      if (result.isNotEmpty) {
                        Navigator.pop(context);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Tabscreen(
                            index: 1,
                          ),
                        ));
                        Snackbarpage().showSnackbar(
                            context,
                            result['SuccessMsg'],
                            const Color.fromARGB(221, 0, 0, 0));
                      } else {
                        Navigator.pop(context);
                        Snackbarpage().showSnackbar(
                            context,
                            "Only Admin can Delete the Group",
                            const Color.fromARGB(221, 0, 0, 0));
                      }
                    },
                  ),
                );
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  height: 45,
                  width: 45,
                  child: Icon(Icons.delete_rounded)),
            ),
            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: Icon(Icons.logout)),
              ),
            )
          ],
        ),
        body: Consumer<HomechatProvider>(builder: (context, myData, child) {
          return ListView.builder(
            itemCount: myData.groupMembers.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Row(
                  children: [
                    Text(
                      myData.groupMembers[index]['User_Name'] ?? "",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "(${myData.groupMembers[index]['Uid'] ?? ""})",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                trailing: myData.groupMembers[index]['Admin'] == "Y"
                    ? Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(131, 255, 222, 124)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5.0, 3, 5, 3),
                          child: Text(
                            "Admin",
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 153, 0)),
                          ),
                        ),
                      )
                    : SizedBox(),
              );
            },
          );
        }),
      ),
    );
  }
}
