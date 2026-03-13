part of 'sim_provider_bloc.dart';


@immutable
abstract class SimProviderState extends Equatable {
  const SimProviderState();

  @override
  List<Object> get props => [];
}

class SimProviderInitial extends SimProviderState {}

class SimProviderLoading extends SimProviderState {}

class SimProviderLoaded extends SimProviderState {
  final SimProviderListingModel model;
  const SimProviderLoaded(this.model);
}

class PackagesLoaded extends SimProviderState {
  final PackageListingModel model;
  const PackagesLoaded(this.model);
}

class SimProviderFailed extends SimProviderState {
  final String message;

  const SimProviderFailed(this.message);
}
