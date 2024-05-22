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
    if (state is! LoginLoading) {
      final Map data = {'email': event.email, 'password': event.password};

      emit(LoginLoading());
      try {
        Response resp = await dio.post('/login', data: data);
        final String accessToken = resp.data['token'];

        if (resp.statusCode == 200 || resp.statusCode == null) {
          // login success? --> (save user token?) + login
          if (event.rememberMe) {
            sp.setString('AUTOLOGIN', accessToken);
          }

          _addAccessTokenToDioHeader(accessToken);

          emit(LoginSuccess());
          emit(LoginForm());
        } else {
          emit(LoginError(resp.data['message']));
        }
      } catch (e) {
        if (e is DioException) {
          final body = e.response?.data;
          emit(LoginError(body['message']));
          emit(LoginForm());
        }
      }
    }
  }

  void _onAutoLogin(LoginAutoLoginEvent event, Emitter<LoginState> emit) async {
    // try to login with saved credentials
    bool autologin = sp.containsKey('AUTOLOGIN');
    if (autologin) {
      final String accessToken = sp.getString('AUTOLOGIN').toString();
      _addAccessTokenToDioHeader(accessToken);
      emit(LoginSuccess());
    }
  }

  void _addAccessTokenToDioHeader(String accessToken) {
    Dio dio = GetIt.I<Dio>();
    dio.options = BaseOptions(
        headers: {'Authorization': 'Bearer $accessToken'},
        receiveTimeout: const Duration(seconds: 5),
        sendTimeout: const Duration(seconds: 5));
  }
}
