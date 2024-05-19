part of 'list_bloc.dart';

@immutable
abstract class ListEvent extends Equatable {}

class ListLoadEvent extends ListEvent {
  final String accessToken;

  ListLoadEvent(this.accessToken);

  @override
  List<Object?> get props => [];
}
