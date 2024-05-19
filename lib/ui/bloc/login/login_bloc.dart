import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_homework/network/user_item.dart';
import 'package:meta/meta.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginForm()) {}

  Stream<LoginState> eventToState(LoginEvent event) async* {
    SharedPreferences sp = GetIt.I<SharedPreferences>();

    if (event is LoginSubmitEvent) {
      Dio _dio = GetIt.I<Dio>();
      var data = {"email": event.email, "password": event.password};

      yield LoginLoading(); // start login attempt on network
      try {
        Response resp = await _dio.post('/login', data: data);
        final body = resp.data;

        // login success? --> (save user) + login
        if (resp.statusCode == 200) {
          if (event.rememberMe) {
            var user = UserItem(event.email, body["token"]);
            sp.setString("user", user.avatarUrl);
            await sp.reload();
          }
          yield LoginSuccess();
        } else {
          yield LoginError(body["message"]);
        }
      } catch (e) {
        print(e);
        yield LoginError("Unsuccessful network exchange!");
      }
    } else if (event is LoginAutoLoginEvent) {
      // try to login with saved credentials
      bool autologin = sp.containsKey("user");
      if (autologin) {
        yield LoginSuccess();
      } else {
        // no login saved --> go to login UI
        yield LoginForm();
      }
    }

    throw NotNullableError("eventToState can not return null!!!");
  }
}
