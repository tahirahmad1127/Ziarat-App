part of 'sim_provider_bloc.dart';

@immutable
abstract class SimProviderEvent extends Equatable {
  const SimProviderEvent();

  @override
  List<Object> get props => [];
}

class GetSimProviderEvent extends SimProviderEvent {
  const GetSimProviderEvent();
}


class GetPackagesEvent extends SimProviderEvent {
  final String id;

  const GetPackagesEvent({required this.id});
}

