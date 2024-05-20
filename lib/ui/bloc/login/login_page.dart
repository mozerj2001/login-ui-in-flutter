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
  LoginBloc _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();
    _loginBloc.add(LoginAutoLoginEvent());
  }

  final _key = GlobalKey<FormState>();
  bool _isValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => _loginBloc,
        child: _loginPrompt(),
      ),
    );
  }

  Widget _loginPrompt() {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginError) {
            _showSnackBar(context, state.message);
          } else if (state is LoginSuccess) {
            _switchToList();
          }
        },
        child: Form(
            key: _key,
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  _emailField(),
                  _passwordField(),
                  _loginButton(),
                  _rememberMeCheckBox(),
                ]))));
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
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
          validator: (value) => null,
          controller: _emailController,
          obscureText: false,
          decoration: InputDecoration(
            icon: Icon(Icons.person),
            hintText: 'EMAIL',
            errorText: _emailErrorText,
          ),
          enabled: state is LoginLoading ? false : true,
          onChanged: (value) {
            _validateEmail(value);
          });
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
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
          validator: (value) => null,
          controller: _pwdController,
          obscureText: true,
          decoration: InputDecoration(
            icon: Icon(Icons.security),
            hintText: 'PWD',
            errorText: _pwdErrorText,
          ),
          enabled: state is LoginLoading ? false : true,
          onChanged: (value) {
            _validatePwd(value);
          });
    });
  }

  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(25.0),
        child: ElevatedButton(
          onPressed: state is LoginLoading
              ? null
              : () {
                  context.read<LoginBloc>().add(LoginSubmitEvent(
                      _emailController.text, _pwdController.text, _isChecked));
                },
          child: Text('LOGIN'),
        ),
      );
    });
  }

  bool _isChecked = false;
  Widget _rememberMeCheckBox() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return Padding(
          padding: const EdgeInsets.all(25.0),
          child: Row(children: [
            Text('Remember login?'),
            Checkbox(
              value: _isChecked,
              onChanged: state is LoginLoading
                  ? null
                  : (value) {
                      setState(() {
                        _isChecked = value!;
                      });
                    },
            ),
          ]));
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _switchToList() {
    Navigator.of(context).pushReplacementNamed('/list');
  }

  @override
  void dispose() {
    super.dispose();
  }
}
