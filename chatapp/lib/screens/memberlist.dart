import 'dart:convert';

import 'package:chatapp/Repository/chat_repo.dart';
import 'package:chatapp/provider/homechat_provider.dart';
import 'package:chatapp/screens/Tabscreen.dart';
import 'package:chatapp/screens/chatpage.dart';
import 'package:chatapp/screens/groupchat/model/creategroupmodel.dart';
import 'package:chatapp/screens/groupchat/model/provider/group_Provider.dart';
import 'package:chatapp/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class MemberListScreen extends StatefulWidget {
  const MemberListScreen({super.key});

  @override
  State<MemberListScreen> createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> {
  late GroupProvider myData;
  @override
  void initState() {
    myData = Provider.of<GroupProvider>(context, listen: false);
    myData.initialFunction();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    groupData.clear();
    myData.createG = false;
    myData.groupMembers.clear();
    myData.groupNameController.text = "";
    myData.memberList.clear();
    myData.result.clear();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Consumer<GroupProvider>(builder: (context, myData, child) {
        return Column(
          children: [
            Container(
              color: Color.fromARGB(183, 211, 211, 211),
              height: 60,
              child: Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.arrow_back_ios)),
                      Visibility(
                        visible: !myData.createG,
                        child: Text(
                          "Members",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Visibility(
                        visible: myData.createG,
                        child: SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: TextFormField(
                            controller: myData.groupNameController,
                            decoration: InputDecoration(
                                hintText: "Group Name",
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                focusedBorder: OutlineInputBorder()),
                          ),
                        ),
                      ),
                    ],
                  )),
                  Visibility(
                    visible: !myData.createG,
                    child: InkWell(
                      onTap: () {
                        myData.createButton(true);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromARGB(255, 255, 220, 114),
                          ),
                          height: 45,
                          width: 45,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "+",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Icon(Icons.groups_3)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: myData.createG,
                    child: InkWell(
                      onTap: () async {
                        if (myData.groupNameController.text.isNotEmpty) {
                          await myData.createButton(false);
                          if (jsonEncode(groupData.toList())
                              .contains(myData.currentUserdata['Uid'])) {
                            // print("tttttttttttttttttttttt");
                          }

                          await myData.addMembersFunction(groupData);
                          print(groupData.toList());
                          await myData.createGroupFunction();
                          if (myData.result.isNotEmpty) {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Tabscreen(
                                index: 1,
                              ),
                            ));
                          } else {
                            Snackbarpage().showSnackbar(
                                context,
                                "Some Thing went wrong",
                                Color.fromARGB(255, 179, 0, 0));
                          }
                        } else {
                          Snackbarpage().showSnackbar(
                              context,
                              "Enter the Group Name",
                              Color.fromARGB(255, 179, 0, 0));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color.fromARGB(255, 255, 220, 114),
                            ),
                            height: 45,
                            width: 45,
                            child: Icon(Icons.check)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: myData.memberList.length,
                itemBuilder: (context, index) {
                  return myData.createG
                      ? CheckboxListTile(
                          value: myData.isChecked[index],
                          onChanged: (value) {
                            if (!myData.createG) {
                              Provider.of<HomechatProvider>(context,
                                      listen: false)
                                  .setChatMap(myData.memberList[index]);
                              Provider.of<HomechatProvider>(context,
                                      listen: false)
                                  .setChatList(myData.memberList);

                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Chatpage(
                                  toUid: myData.memberList[index]['Uid'],
                                  toUserName: myData.memberList[index]
                                      ['User_Name'],
                                ),
                              ));
                            }

                            myData.isChecked[index] = value!;

                            groupData.add(GroupMember(
                                uid: myData.memberList[index]['Uid'],
                                userName: myData.memberList[index]
                                    ['User_Name']));
                            setState(() {});
                          },
                          title: Row(
                            children: [
                              Text(
                                myData.memberList[index]['User_Name'] ?? "",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "(${myData.memberList[index]['Uid'] ?? ""})",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        )
                      : ListTile(
                          onTap: () {
                            Provider.of<HomechatProvider>(context,
                                    listen: false)
                                .setChatMap(myData.memberList[index]);
                            Provider.of<HomechatProvider>(context,
                                    listen: false)
                                .setChatList(myData.memberList);

                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Chatpage(
                                toUid: myData.memberList[index]['Uid'],
                                toUserName: myData.memberList[index]
                                    ['User_Name'],
                              ),
                            ));
                          },
                          title: Row(
                            children: [
                              Text(
                                myData.memberList[index]['User_Name'] ?? "",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "(${myData.memberList[index]['Uid'] ?? ""})",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        );
                },
              ),
            ),
          ],
        );
      }),
    ));
  }
}

bool val = false;
Set<GroupMember> groupData = {};
