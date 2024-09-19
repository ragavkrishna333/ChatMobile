import 'package:chatapp/provider/homechat_provider.dart';
import 'package:chatapp/screens/groupchat/groupmembers.dart';
import 'package:chatapp/widgets/chatformfeild.dart';
import 'package:chatapp/widgets/socketservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class GroupChatpage extends StatefulWidget {
  const GroupChatpage(
      {super.key, required this.toGroupId, required this.groupName});
  final String toGroupId;
  final String groupName;
  @override
  State<GroupChatpage> createState() => _GroupChatpageState();
}

TextEditingController controller = TextEditingController();

class _GroupChatpageState extends State<GroupChatpage> {
  late HomechatProvider myData;
  @override
  void initState() {
    myData = Provider.of<HomechatProvider>(context, listen: false);
    myData.getGroupList();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => GroupMembers(
                  groupId: widget.toGroupId,
                ),
              ));
              // Perform your action here
            },
            child: AppBar(
              backgroundColor: const Color.fromARGB(255, 255, 221, 119),
              title: Text(widget.groupName),
              actions: [Icon(Icons.more_vert)],
            ),
          ),
        ),
        body: Consumer<HomechatProvider>(builder: (context, myData, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    separatorBuilder: (context, index) {
                      if (widget.toGroupId ==
                          myData.groupsocketList.toList()[index]['ToGroupID']) {
                        return SizedBox(
                          height: 15,
                        );
                      }
                      return SizedBox();
                    },
                    itemCount: myData.groupsocketList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: widget.toGroupId ==
                                    myData.groupsocketList.toList()[index]
                                        ['ToGroupID'] &&
                                myData.loginUserId ==
                                    myData.groupsocketList.toList()[index]
                                        ['FromUid'],
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color.fromARGB(
                                          255, 255, 223, 129),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                            alignment: Alignment.centerRight,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.85,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10)),
                                              color: Color.fromARGB(
                                                  255, 236, 207, 120),
                                            ),
                                            child: const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 15.0),
                                              child: Text("You",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 15.0),
                                          child: Text(
                                            myData.groupsocketList
                                                .toList()[index]['Message'],
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: widget.toGroupId ==
                                    myData.groupsocketList.toList()[index]
                                        ['ToGroupID'] &&
                                myData.loginUserId !=
                                    myData.groupsocketList.toList()[index]
                                        ['FromUid'],
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color.fromARGB(
                                          255, 224, 224, 224),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.85,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10)),
                                              color: Color.fromARGB(
                                                  136, 255, 255, 255),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15),
                                              child: Text(
                                                  myData.groupsocketList
                                                          .toList()[index]
                                                      ['FromUserName'],
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            )),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Text(
                                              myData.groupsocketList
                                                  .toList()[index]['Message'],
                                              style: const TextStyle(
                                                  fontSize: 16)),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
                ChatFormfield(
                  controller: controller,
                  onPressed: () {
                    if (controller.text.isNotEmpty &&
                        controller.text.trimLeft() != "") {
                      SocketService().subscribe(
                          '''{"MsgType":"gr", "FromUid":"${myData.loginUserId}" , "ToGroupID":"${widget.toGroupId}","FromUserName":"${myData.loginUserName}", "Message":"${controller.text}" }''');
                      controller.clear();
                    }
                  },
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
