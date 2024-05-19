import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
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
  LoginBloc() : super(LoginForm()) {
    on<LoginSubmitEvent>(_onLoginSubmit);
    on<LoginAutoLoginEvent>(_onAutoLogin);
  }

  SharedPreferences sp = GetIt.I<SharedPreferences>();
  Dio dio = GetIt.I<Dio>();

  void _onLoginSubmit(LoginSubmitEvent event, Emitter<LoginState> emit) async {
    final Map data = {'email': event.email, 'password': event.password};

    emit(LoginLoading());
    try {
      Response resp = await dio.post('/login', data: data);
      final body = resp.data;
      print(resp.toString());

      if (resp.statusCode == 200 || resp.statusCode == null) {
        // login success? --> (save user token?) + login
        if (event.rememberMe) {
          sp.setString("user", body["token"]);
          await sp.reload();
        }
        emit(LoginSuccess());
      } else {
        emit(LoginError(body["message"]));
      }
    } catch (e) {
      if (e is DioException) {
        final body = e.response?.data;
        emit(LoginError(body['message']));
      } else {
        print("UNKNOWN DIO ERROR");
      }
    }
  }

  void _onAutoLogin(LoginAutoLoginEvent event, Emitter<LoginState> emit) async {
    // try to login with saved credentials
    bool autologin = sp.containsKey("user");
    if (autologin) {
      emit(LoginSuccess());
    } else {
      // no login saved --> go to login UI
      emit(LoginForm());
    }
  }
}
