import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Formfield1 extends StatelessWidget {
  const Formfield1(
      {super.key,
      required this.controller,
      this.label,
      this.inputFormatters,
      required this.obsecure,
      this.suffix});
  final TextEditingController controller;
  final Widget? suffix;
  final Widget? label;
  final bool obsecure;
  final List<TextInputFormatter>? inputFormatters;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        obscureText: obsecure,
        inputFormatters: inputFormatters,
        controller: controller,
        decoration: InputDecoration(
            suffix: suffix,
            label: label,
            focusedBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            enabledBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
      ),
    );
  }
}
