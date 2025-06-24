part of 'mushaf_cubit.dart';

sealed class MushafState extends Equatable {
  final int selectedAyahIndex;
  const MushafState(this.selectedAyahIndex);

  @override
  List<Object> get props => [];
}

final class MushafStarted extends MushafState{
  const MushafStarted(super.selectedAyahIndex);

  @override
  List<Object> get props => [selectedAyahIndex];
}
