import 'dart:convert';
import 'dart:io';

import 'package:chatapp/provider/homechat_provider.dart';
import 'package:chatapp/screens/Home.dart';
import 'package:chatapp/screens/groupchat/groupchatlist.dart';
import 'package:chatapp/screens/login.dart';
import 'package:chatapp/screens/memberlist.dart';
import 'package:chatapp/widgets/socketservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Tabscreen extends StatefulWidget {
  const Tabscreen({super.key, required this.index});
  final int index;
  @override
  State<Tabscreen> createState() => _TabscreenState();
}

class _TabscreenState extends State<Tabscreen> with TickerProviderStateMixin {
  late TabController tabController;
  late HomechatProvider myData;

  @override
  void initState() {
    tabController =
        TabController(length: 2, vsync: this, initialIndex: widget.index);
    myData = Provider.of<HomechatProvider>(context, listen: false);
    myData.initialfunction();
    // myData.initialSocketFunction();
    super.initState();
  }

  void logout() async {
    await SocketService().closeSocket();
    // Perform additional logout actions such as clearing user data, navigating to the login screen, etc.
    Navigator.pushReplacementNamed(
        context, 'login'); // Example navigation to login screen
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ListTile(
                onTap: () {
                  logout();
                  // SocketService().subscribe(jsonEncode({"Disconnect": true}));
                  // SocketService().socketStream.
                  // SocketService.channel.sink.close();
                  // SocketService().closeSocket();
                  // Navigator.of(context).pushAndRemoveUntil(
                  //   MaterialPageRoute(
                  //     builder: (context) => const Login(),
                  //   ),
                  //   (route) => false,
                  // );
                },
                title: Text("Logout"),
                leading: Icon(Icons.directions_run),
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("ChatApp"),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 8.0,
            ),
            // SizedBox(
            //   height: 35,
            //   child: Searchfield(
            //     isChangeTab: orderTab.indexIsChanging,
            //     tabIndex: myData.currentTabIndex,
            //     focus: focus,
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50.0, 9.0, 50.0, 2),
              child: Container(
                height: 55,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: const Color.fromRGBO(220, 220, 220, 0.937),
                ),
                child: Center(
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    tabAlignment: TabAlignment.center, splashFactory: null,
                    controller: tabController, // Use the custom TabController
                    onTap: (value) {},
                    unselectedLabelColor: const Color.fromARGB(255, 26, 26, 26),
                    tabs: [
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            children: [
                              Text(
                                "Home",
                                style: TextStyle(fontSize: screenWidth * 0.04),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Tab(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          children: [
                            Text(
                              "GroupChat",
                              style: TextStyle(fontSize: screenWidth * 0.04),
                            ),
                          ],
                        ),
                      ))
                    ],
                    splashBorderRadius: null,

                    labelStyle: TextStyle(
                      color: const Color.fromARGB(255, 26, 26, 26),
                      fontSize: 14.0,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w700,
                    ),
                    indicatorWeight: 4.0,
                    indicatorColor: Colors.white,
                    dividerColor: Colors.transparent,
                    labelPadding: EdgeInsets.only(
                      top: 2,
                      left: screenWidth * 0.04,
                      right: screenWidth * 0.04,
                    ),
                    indicatorPadding: EdgeInsets.fromLTRB(
                        -screenWidth * 0.035, 5.0, -screenWidth * 0.035, 5.0),
                    indicator: BoxDecoration(
                      color: const Color.fromARGB(248, 255, 255, 255)
                      // whiteColor
                      ,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {},
                child: TabBarView(
                  controller: tabController,
                  children: [Home(), GroupchatList()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
