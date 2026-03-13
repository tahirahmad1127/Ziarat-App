part of 'ziarat_bloc.dart';

@immutable
abstract class ZiaratState extends Equatable {
  const ZiaratState();


  @override
  List<Object> get props => [];
}
List<ZiaratModel> _currentList = [];
class ZiaratInitial extends ZiaratState {}

class ZiaratLoading extends ZiaratState {}

class ZiaratLoaded extends ZiaratState {
  final ZiaratListingModel model;

  const ZiaratLoaded(this.model);
}

///confirm from sir
class ZiaratDetailsLoaded extends ZiaratState {
  final ZiaratDetailModel model;

  const ZiaratDetailsLoaded(this.model);
}
class ZiaratSearchLoaded extends ZiaratState {
  final ZiaratListingModel model;
  const ZiaratSearchLoaded(this.model);

  @override
  List<Object> get props => [model];
}

class ZiaratFailed extends ZiaratState {
   final String message;

  const ZiaratFailed(this.message);
}
