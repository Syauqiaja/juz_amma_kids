part of 'read_quran_cubit.dart';

sealed class ReadQuranState extends Equatable {
  const ReadQuranState();

  @override
  List<Object> get props => [];
}

final class ReadQuranInitial extends ReadQuranState {}
final class ReadQuranWithData extends ReadQuranState{
  final int readCount;
  final int maxRead;

  const ReadQuranWithData({required this.readCount, required this.maxRead}); 

  @override
  List<Object> get props => [readCount, maxRead]; 
}
final class ReadQuranError extends ReadQuranState {
  final String message;

  const ReadQuranError({required this.message});
}