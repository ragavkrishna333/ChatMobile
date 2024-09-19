import 'package:chatapp/Repository/chat_repo.dart';
import 'package:chatapp/screens/login.dart';
import 'package:chatapp/widgets/formfield.dart';
import 'package:chatapp/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SignUp> {
  TextEditingController uid = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController pass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign Up",
          style:
              TextStyle(color: Color.fromARGB(255, 3, 50, 151), fontSize: 18),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 40),
                child:
                    Lottie.asset('asset/Signup.json', height: 180, width: 180),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: const Text(
                  'Sign Here!!',
                  style: TextStyle(
                      color: Color.fromARGB(255, 3, 50, 151), fontSize: 18),
                ),
              ),
              Formfield1(
                obsecure: false,
                label: Text("User ID"),
                controller: uid,
              ),
              Formfield1(
                obsecure: false,
                label: Text("User Name"),
                controller: userName,
              ),
              Formfield1(
                obsecure: true,
                label: Text("Password"),
                controller: pass,
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.5,
                child: MaterialButton(
                  color: Color.fromARGB(214, 0, 0, 0),
                  onPressed: () async {
                    print(userName.text);
                    print(pass.text);
                    var result = await ChatRepository()
                        .signUp(uid.text, userName.text, pass.text);
                    print(result);
                    if (result["Status"] == "S") {
                      Snackbarpage().showSnackbar(context, "SignUp Success",
                          const Color.fromARGB(255, 52, 116, 54));
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Login(),
                      ));
                    }
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
