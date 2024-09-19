import 'package:flutter/material.dart';

class AlertBox extends StatelessWidget {
  const AlertBox(
      {super.key, required this.title, required this.content, this.onPressed});
  final String title;
  final String content;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      title: Text(title),
      content: Text(content),
      actions: [
        SizedBox(
          width: 100,
          child: MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.amber)),
            onPressed: () => Navigator.of(context).pop(),
            color: Colors.white,
            child: Text("Cancel"),
          ),
        ),
        SizedBox(
          width: 100,
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onPressed: onPressed,
            color: Colors.amber,
            child: Text("Delete"),
          ),
        )
      ],
    );
  }
}
