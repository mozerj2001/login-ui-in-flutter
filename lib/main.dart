import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/network/data_source_interceptor.dart';
import 'package:flutter_homework/ui/bloc/login/login_page.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

//DO NOT MODIFY
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureFixDependencies();
  await configureCustomDependencies();
  runApp(const MyApp());
}

//DO NOT MODIFY
Future configureFixDependencies() async {
  var dio = Dio();
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
    ),
  );
  dio.interceptors.add(DataSourceInterceptor());
  GetIt.I.registerSingleton(dio);
  GetIt.I.registerSingleton(await SharedPreferences.getInstance());
  GetIt.I.registerSingleton(<NavigatorObserver>[]);
}

//Add custom dependencies if necessary
Future configureCustomDependencies() async {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //DO NOT MODIFY
      navigatorObservers: GetIt.I<List<NavigatorObserver>>(),
      //DO NOT MODIFY
      debugShowCheckedModeBanner: false,
      home: MyLoginPage(),
    );
  }
}

class MyLoginPage extends StatelessWidget {
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
}
