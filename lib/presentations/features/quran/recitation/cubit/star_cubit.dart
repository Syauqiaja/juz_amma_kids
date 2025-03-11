import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:juz_amma_kids/core/services/database_service.dart';

part 'star_state.dart';

class StarCubit extends Cubit<StarState> {
  DatabaseService databaseService = DatabaseService();
  int currentStar = 0;
  int maxStar = 1;
  StarCubit() : super(StarInitial(0));

  void change(int star){
    currentStar = star;
    emit(StarChanged(star));
  }

  void save(int star){
    emit(StarSaved(star, maxStar: maxStar));
  }

  void load(int surahIndex) async {
    var totalAya = await databaseService.getTotalAyaOfSurah(surahIndex, );
    maxStar = totalAya;
    emit(StarLoaded(currentStar));
  }
}
