import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/ui/bloc/login/login_bloc.dart';

class LoginPageBloc extends StatefulWidget {
  const LoginPageBloc({super.key});

  @override
  State<LoginPageBloc> createState() => _LoginPageBlocState();
}

class _LoginPageBlocState extends State<LoginPageBloc> {
  @override
  void initState() {
    super.initState();
  }

  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loginPrompt(),
    );
  }

  Widget _loginPrompt() {
    return Form(
        key: _key,
        child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          _emailField(),
          _passwordField(),
          _loginButton(),
          _rememberMeCheckBox(),
        ])));
  }

  Widget _emailField() {
    return TextFormField(
      validator: (value) => null,
      obscureText: false,
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        hintText: 'EMAIL',
      ),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      validator: (value) => null,
      obscureText: true,
      decoration: InputDecoration(
        icon: Icon(Icons.security),
        hintText: 'PWD',
      ),
    );
  }

  Widget _loginButton() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: ElevatedButton(
        onPressed: () {},
        child: Text('LOGIN'),
      ),
    );
  }

  bool _isChecked = false;
  Widget _rememberMeCheckBox() {
    return Padding(
        padding: const EdgeInsets.all(25.0),
        child: Row(children: [
          Text('Remember login?'),
          Checkbox(
            value: _isChecked,
            onChanged: (value) {
              setState(() {
                _isChecked = value!;
              });
            },
          ),
        ]));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
