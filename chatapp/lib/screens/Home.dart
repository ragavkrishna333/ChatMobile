import 'package:chatapp/provider/homechat_provider.dart';
import 'package:chatapp/screens/chatpage.dart';
import 'package:chatapp/screens/memberlist.dart';
import 'package:chatapp/widgets/tileWiget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late HomechatProvider myData;
  @override
  void initState() {
    myData = Provider.of<HomechatProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      myData.previousPVmsg();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Consumer<HomechatProvider>(builder: (context, myData, child) {
        return ListView.builder(
          itemCount: myData.homeChatList.length,
          itemBuilder: (context, index) {
            // print(
            //     "eeeeeeeeeeeeeeeeeeeerrr@&${myData.homeChatList.toList()[index]}");
            return Visibility(
                visible: myData.homeChatList.toList()[index]['Uid'] !=
                    myData.loginUserId,
                child: TileWidget(
                  onTap: () {
                    myData.setCurrenchatUid(
                        myData.homeChatList.toList()[index]['Uid']);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Chatpage(
                        toUid: myData.homeChatList.toList()[index]['Uid'],
                        toUserName: myData.homeChatList.toList()[index]
                            ['User_Name'],
                      ),
                    ));
                  },
                  isGroup: false,
                  title: myData.homeChatList.toList()[index]['User_Name'] ?? "",
                  subtitle: myData.homeChatList.toList()[index]['Uid'] ?? "",
                  time: myData.homeChatList.toList()[index]['Created_Time'] ??
                      "${DateTime.now()}",
                  isUnread: false,
                  unread: "",
                  message: myData.homeChatList.toList()[index]['Message'] ?? "",
                ));
          },
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
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MemberListScreen(),
                  ));
                },
                child: Text("+ New Chat"))),
      ),
    ));
  }
}
