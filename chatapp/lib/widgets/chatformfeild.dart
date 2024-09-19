import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatFormfield extends StatefulWidget {
  const ChatFormfield({
    super.key,
    required this.onPressed,
    required this.controller,
  });
  final void Function() onPressed;
  final TextEditingController controller;
  @override
  State<ChatFormfield> createState() => _ChatFormfieldState();
}

class _ChatFormfieldState extends State<ChatFormfield> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 10),
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextFormField(
                controller: widget.controller,
                decoration: const InputDecoration(
                    hintText: "Message",
                    filled: true,
                    border: InputBorder.none,
                    fillColor: Color.fromARGB(172, 231, 231, 231),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2,
                            color: Color.fromARGB(255, 255, 218, 107)),
                        borderRadius: BorderRadius.all(Radius.circular(25)))),
              ),
            ),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.15,
              child: MaterialButton(
                shape: CircleBorder(),
                color: Colors.amber,
                onPressed: widget.onPressed,
                child: const Icon(Icons.send),
              ),
            )
          ],
        ),
      ),
    );
  }
}
