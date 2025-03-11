part of 'star_cubit.dart';

sealed class StarState extends Equatable {
  final int star;
  const StarState(this.star);

  @override
  List<Object> get props => [star];
}

final class StarInitial extends StarState {
  StarInitial(super.star);

  @override
  List<Object> get props => super.props;
}

final class StarChanged extends StarState{
  StarChanged(super.star);

  @override
  List<Object> get props => super.props;
}

final class StarSaved extends StarState{
  final int maxStar;

  StarSaved(super.star, {required this.maxStar});
  
  @override
  List<Object> get props => [super.star, this.maxStar];
}

final class StarLoaded extends StarState{
  StarLoaded(super.star);

  @override
  List<Object> get props => [super.star];
}
