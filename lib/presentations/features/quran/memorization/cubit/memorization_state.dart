part of 'memorization_cubit.dart';

sealed class MemorizationState extends Equatable {

  @override
  List<Object> get props => [];
}

final class MemorizationInitial extends MemorizationState {
  final String? message;

  MemorizationInitial({this.message});
  @override
  // TODO: implement props
  List<Object> get props => [DateTime.now().millisecondsSinceEpoch];
}
final class MemorizationLoading extends MemorizationState {}
final class MemorizationWithData extends MemorizationState {
  final String? message;

  MemorizationWithData({this.message});

  @override
  // TODO: implement props
  List<Object> get props => [DateTime.now().millisecondsSinceEpoch];
}
final class MemorizationDone extends MemorizationState {}