part of 'star_cubit.dart';

sealed class StarState extends Equatable {
  final int star;
  const StarState(this.star);

  @override
  List<Object> get props => [star];
}

final class StarInitial extends StarState {
  const StarInitial(super.star);

}

final class StarChanged extends StarState{
  const StarChanged(super.star);

}

final class StarSaved extends StarState{
  final int maxStar;

  const StarSaved(super.star, {required this.maxStar});
  
  @override
  List<Object> get props => [super.star, maxStar];
}

final class StarLoaded extends StarState{
  const StarLoaded(super.star);

  @override
  List<Object> get props => [super.star];
}
