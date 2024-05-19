import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/ui/bloc/login/login_bloc.dart';
import 'package:validators/validators.dart';

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
  bool _isValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginBloc(),
        child: _loginPrompt(),
      ),
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

  final TextEditingController _emailController = TextEditingController();
  String _emailErrorText = '';
  void _validateEmail(String value) {
    setState(() {
      if (!isEmail(value)) {
        _emailErrorText = 'Email address invalid!';
        _isValid = false;
      } else {
        _emailErrorText = '';
        _isValid = true;
      }
    });
  }

  Widget _emailField() {
    return TextFormField(
        validator: (value) => null,
        controller: _emailController,
        obscureText: false,
        decoration: InputDecoration(
          icon: Icon(Icons.person),
          hintText: 'EMAIL',
          errorText: _emailErrorText,
        ),
        onChanged: (value) {
          _validateEmail(value);
        });
  }

  final TextEditingController _pwdController = TextEditingController();
  String _pwdErrorText = '';
  void _validatePwd(String value) {
    setState(() {
      if (value.length < 6) {
        _pwdErrorText = 'Password too short!';
        _isValid = false;
      } else {
        _pwdErrorText = '';
        _isValid = true;
      }
    });
  }

  Widget _passwordField() {
    return TextFormField(
        validator: (value) => null,
        controller: _pwdController,
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(Icons.security),
          hintText: 'PWD',
          errorText: _pwdErrorText,
        ),
        onChanged: (value) {
          _validatePwd(value);
        });
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
