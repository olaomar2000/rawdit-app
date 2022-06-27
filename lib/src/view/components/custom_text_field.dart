import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String title;
  final TextEditingController textEditingController;

  const CustomTextField(this.title, {this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: textEditingController,
        maxLines: title == 'الوصف :' || title == 'ملاحظات' ? 5 : null,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: title,
            hintStyle: TextStyle(fontSize: 20),
            fillColor: Color(0xfff3f3f4),
            filled: true),
      ),
    );
  }
}
