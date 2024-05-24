import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/ui/bloc/list/list_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_homework/network/user_item.dart';

class ListPageBloc extends StatefulWidget {
  const ListPageBloc({super.key});

  @override
  State<ListPageBloc> createState() => _ListPageBlocState();
}

class _ListPageBlocState extends State<ListPageBloc> {
  @override
  void initState() {
    super.initState();
    context.read<ListBloc>().add(ListLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        AppBar(
          leading: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _switchToLogin();
              }),
        ),
        _listField(),
      ]),
    );
  }

  Widget _listField() {
    return BlocConsumer<ListBloc, ListState>(builder: (context, state) {
      if (state is! ListLoaded) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return Container(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: _userListWidget(state.users),
              ),
            ));
      }
    }, listener: (context, state) {
      if (state is ListError) {
        _showSnackBar(context, state.message);
      }
    });
  }

  Widget _userListWidget(List<UserItem> users) {
    return Container(
      color: const Color.fromRGBO(148, 183, 212, 1),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height -
          0.3 * MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: users.map((user) => _singleUserWidget(user)).toList())),
    );
  }

  Widget _singleUserWidget(UserItem u) {
    return Row(children: [
      Image.network(
        u.avatarUrl,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error);
        },
      ),
      Text(u.name, style: const TextStyle(color: Colors.white)),
    ]);
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _switchToLogin() async {
    SharedPreferences sp = GetIt.I<SharedPreferences>();

    if (sp.containsKey('AUTOLOGIN')) {
      sp.remove('AUTOLOGIN');
    }

    sp.remove('ACCESS_TOKEN');
    await sp.reload();

    Navigator.of(context).pushReplacementNamed('/');
  }
}
