import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController passwordController;
  final ValueChanged<String> onChanged;
  final String errorText;
  final String labelText;
  final TextInputAction textInputAction;

  const PasswordTextField({
    Key key,
    @required this.passwordController,
    @required this.onChanged,
    @required this.errorText,
    @required this.labelText,
    @required this.textInputAction,
  }) : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState(
    onChanged          : this.onChanged,
    errorText          : this.errorText,
    labelText          : this.labelText,
    textInputAction    : this.textInputAction,
    passwordController : this.passwordController,
  );
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;
  ValueChanged<String> onChanged;
  String errorText;
  String labelText;
  TextInputAction textInputAction;
  VoidCallback onSubmitted;
  FocusNode focusNode;
  TextEditingController passwordController;

  _PasswordTextFieldState({
    this.onChanged,
    this.errorText,
    this.labelText,
    this.textInputAction,
    this.onSubmitted,
    this.focusNode,
    this.passwordController
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.passwordController,
      obscureText: _obscureText,
      decoration: InputDecoration(
        errorText: widget.errorText,
        suffixIcon: IconButton(
          onPressed: () => setState(() => _obscureText = !_obscureText),
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          iconSize: 20.0,
        ),
        labelText: widget.labelText,
        labelStyle: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          color: Colors.grey
        ),
        fillColor: Colors.green,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green
          )
        ),
      ),
      keyboardType: TextInputType.text,
      maxLines: 1,
      onChanged: widget.onChanged,
      textInputAction: widget.textInputAction,
    );
  }
}