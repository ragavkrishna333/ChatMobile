import 'dart:convert';

import 'package:chatapp/provider/homechat_provider.dart';
import 'package:chatapp/widgets/chatformfeild.dart';
import 'package:chatapp/widgets/socketservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Chatpage extends StatefulWidget {
  const Chatpage({super.key, required this.toUid, required this.toUserName});
  final String toUid;
  final String toUserName;
  @override
  State<Chatpage> createState() => _ChatpageState();
}

TextEditingController controller = TextEditingController();

class _ChatpageState extends State<Chatpage> {
  late HomechatProvider myData;
  @override
  void initState() {
    myData = Provider.of<HomechatProvider>(context, listen: false);

    // myData.previousPVmsg();
    // myData.initialfunction();
    // myData.initialSocketFunction();
    super.initState();
  }

  @override
  void dispose() {
    // myData.socketList.clear();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 221, 119),
          title: Text(widget.toUserName),
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
                      if (widget.toUid ==
                              myData.socketList.toList()[index]['FromUid'] ||
                          myData.loginUserId ==
                              myData.socketList.toList()[index]['FromUid']) {
                        return SizedBox(
                          height: 15,
                        );
                      }
                      return SizedBox();
                    },
                    itemCount: myData.socketList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Visibility(
                            visible: widget.toUid ==
                                    myData.socketList.toList()[index]
                                        ['ToUid'] &&
                                widget.toUid !=
                                    myData.socketList.toList()[index]
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
                                            myData.socketList.toList()[index]
                                                ['Message'],
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
                            visible: widget.toUid ==
                                myData.socketList.toList()[index]['FromUid'],
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
                                              child: Text(widget.toUserName,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            )),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Text(
                                              myData.socketList.toList()[index]
                                                  ['Message'],
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
                      Map message = {
                        "MsgType": "pv",
                        "FromUid": myData.loginUserId,
                        "ToUid": widget.toUid,
                        "FromUserName": myData.loginUserName,
                        "Message": controller.text
                      };
                      if (controller.text.isNotEmpty &&
                          controller.text.trimLeft() != "") {
                        SocketService().subscribe(jsonEncode(message));
                      }
                      setState(() {});
                      controller.clear();
                    }),
              ],
            ),
          );
        }),
      ),
    );
  }
}
