import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextInput extends StatefulWidget {
  String? Function(String?)? validator;
  void Function(String)? onChanged;
  TextEditingController? controller;
  Icon? icon;
  bool? passwordField = false;
  String hint;

  TextInput(
      {Key? key,
      required this.hint,
      this.validator,
      this.controller,
      this.onChanged,
      this.passwordField,
      this.icon})
      : super(key: key);

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  late bool _passwordVisible;
  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        showCursor: true,
        obscureText: widget.passwordField! ? !_passwordVisible : false,
        cursorColor: Colors.grey[400],
        decoration: InputDecoration(
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 80, 67, 225)),
            ),
            hintText: widget.hint,
            fillColor: Colors.white,
            icon: widget.icon,
            suffixIcon: checker(
                isPassword: widget.passwordField,
                visibility: _passwordVisible,
                fun: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                })),
        onChanged: widget.onChanged,
      ),
    );
  }
}

IconButton? checker({isPassword, fun, visibility}) {
  if (isPassword) {
    return IconButton(
      onPressed: fun,
      icon: Icon(
        // Based on passwordVisible state choose the icon
        visibility ? Icons.visibility : Icons.visibility_off,
        color: Colors.grey,
      ),
    );
  }
  return null;
}
