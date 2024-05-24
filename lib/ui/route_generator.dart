import 'package:flutter/material.dart';
import 'package:flutter_homework/ui/bloc/login/login_page.dart';
import 'package:flutter_homework/ui/bloc/list/list_page.dart';
import 'package:flutter_homework/ui/bloc/login/login_bloc.dart';
import 'package:flutter_homework/ui/bloc/list/list_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => LoginBloc(),
                  child: const LoginPageBloc(),
                ));

      case '/list':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (context) => ListBloc(), child: const ListPageBloc()),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
