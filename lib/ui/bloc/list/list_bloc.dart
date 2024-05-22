import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_homework/network/user_item.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(ListInitial()) {
    on<ListLoadEvent>(_onListLoad);
  }

  void _onListLoad(ListLoadEvent event, Emitter<ListState> emit) async {
    if (state is ListLoading) {
    } else {
      emit(ListLoading());

      Dio dio = GetIt.I<Dio>();

      Response resp;

      try {
        resp = await dio.get('/users');

        final body = resp.data;

        if (resp.statusCode == 200 || resp.statusCode == null) {
          List<UserItem> userItemList = [];

          for (final u in body) {
            userItemList.add(UserItem(u['name'], u['avatarUrl']));
          }

          emit(ListLoaded(userItemList));
        } else {
          emit(ListError(body['message']));
        }
      } on DioException catch (e) {
        final body = e.response?.data;
        emit(ListError(body['message']));
      }
    }
  }
}
