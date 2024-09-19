import 'package:chatapp/router/routerscreen.dart';
import 'package:chatapp/screens/groupchat/model/creategroupmodel.dart';
import 'package:chatapp/screens/groupchat/model/provider/group_Provider.dart';
import 'package:chatapp/screens/login.dart';
import 'package:chatapp/provider/homechat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomechatProvider()),
        ChangeNotifierProvider(create: (_) => GroupProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
        ),
        // home: const Login(),
        initialRoute: '/',
        onGenerateRoute: AppRoutes().onGenerateRoute,
      ),
    );
  }
}
