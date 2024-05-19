import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/ui/bloc/list/list_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_homework/network/user_item.dart';

class ListPageBloc extends StatefulWidget {
  final String accessToken;
  const ListPageBloc({super.key, required this.accessToken});

  @override
  State<ListPageBloc> createState() => _ListPageBlocState();
}

class _ListPageBlocState extends State<ListPageBloc> {
  ListBloc _listBloc = ListBloc();

  @override
  void initState() {
    super.initState();
    _listBloc.add(ListLoadEvent(widget.accessToken));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => _listBloc,
      child: Column(children: [
        AppBar(
          leading: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _switchToLogin();
              }),
        ),
        _listField(),
      ]),
    ));
  }

  Widget _listField() {
    return BlocBuilder<ListBloc, ListState>(builder: (context, state) {
      if (state is ListLoading) {
        return Center(child: CircularProgressIndicator());
      } else if (state is ListLoaded) {
        return Center(
            child: ListView(
                scrollDirection: Axis.vertical,
                children: [for (final u in state.users) _singleUserWidget(u)]));
      } else {
        return Text(
            "Whoops, something went wrong! Please logout and login again.");
      }
    });
  }

  Widget _singleUserWidget(UserItem u) {
    return Row(children: [
      Image.network(u.avatarUrl),
      Text(u.name),
    ]);
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _switchToLogin() {
    SharedPreferences sp = GetIt.I<SharedPreferences>();

    if (sp.containsKey('TOKEN')) {
      sp.remove('TOKEN');
      sp.reload();
    }

    Navigator.of(context).pushReplacementNamed('/');
  }
}
