import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'mushaf_state.dart';

class MushafCubit extends Cubit<MushafState> {
  MushafCubit() : super(MushafStarted(-1));  

  select(int ayahIndex){
    emit(MushafStarted(ayahIndex));
  }
}
