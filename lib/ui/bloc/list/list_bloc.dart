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

  SharedPreferences sp = GetIt.I<SharedPreferences>();
  Dio dio = GetIt.I<Dio>();

  void _onListLoad(ListLoadEvent event, Emitter<ListState> emit) async {
    emit(ListLoading());
    Response resp;
    final String accessToken = event.accessToken;

    try {
      resp = await dio.get('/users',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

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
    } catch (e) {
      if (e is DioException) {
        final body = e.response?.data;
        emit(ListError(body['message']));
      } else {
        print("UNKNOWN DIO ERROR");
      }
    }
  }
}
