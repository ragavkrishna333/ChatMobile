import 'package:chatapp/Repository/chat_repo.dart';
import 'package:chatapp/provider/homechat_provider.dart';
import 'package:chatapp/screens/Tabscreen.dart';
import 'package:chatapp/screens/Home.dart';
import 'package:chatapp/screens/groupchat/model/provider/group_Provider.dart';
import 'package:chatapp/screens/signup.dart';
import 'package:chatapp/widgets/formfield.dart';
import 'package:chatapp/widgets/snackbar.dart';
import 'package:chatapp/widgets/socketservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _MyHomePageState();
}

bool passVisible = true;

class _MyHomePageState extends State<Login> {
  TextEditingController uid = TextEditingController();
  TextEditingController pass = TextEditingController();
  void login() async {
    await SocketService().connect();
    // Perform additional login actions, such as saving user info, navigating to the home screen, etc.
    Navigator.pushReplacementNamed(context, 'Tabscreen',
        arguments: 0); // Navigate to home screen after login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 150, bottom: 40),
                child: Lottie.asset('asset/Animation - 1718944363013.json',
                    height: 250, width: 250),
              ),
              Formfield1(
                obsecure: false,
                inputFormatters: [UpperCaseTextFormatter()],
                label: Text("User ID"),
                controller: uid,
              ),
              Formfield1(
                suffix: GestureDetector(
                    child: passVisible
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                    onTap: () {
                      setState(() {
                        passVisible = !passVisible;
                        print(passVisible);
                      });
                    }),
                obsecure: passVisible,
                label: Text("Password"),
                controller: pass,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Color.fromARGB(214, 0, 0, 0),
                    onPressed: () async {
                      print(uid.text);
                      print(pass.text);
                      Map result =
                          await ChatRepository().login(uid.text, pass.text);
                      print(result);
                      if (result["Status"] == "S") {
                        login();
                        HomechatProvider myData = Provider.of<HomechatProvider>(
                            context,
                            listen: false);
                        myData.initialSocketFunction();
                        Provider.of<HomechatProvider>(context, listen: false)
                            .setUser(result['Uid'], result['User_Name']);
                        Provider.of<GroupProvider>(context, listen: false)
                            .getCurrentUserData({
                          "Uid": result['Uid'],
                          "User_Name": result['User_Name']
                        });

                        Snackbarpage().showSnackbar(
                            context,
                            result['SuccessMsg'],
                            const Color.fromARGB(255, 52, 116, 54));
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) => Tabscreen(
                        //     index: 0,
                        //   ),
                        // ));
                      } else if (result["errMsg"] == "No User Found") {
                        Snackbarpage().showSnackbar(context, result['errMsg'],
                            Color.fromARGB(236, 153, 1, 1));
                      }
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't Have an Account ?  "),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignUp(),
                        ));
                      },
                      child: Text(
                        "Click to SignUp",
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
