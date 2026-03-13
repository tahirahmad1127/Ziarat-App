part of 'privacy_policy_bloc.dart';

@immutable
abstract class PrivacyPolicyState extends Equatable {
  const PrivacyPolicyState();

  @override
  List<Object> get props => [];
}

class PrivacyPolicyInitial extends PrivacyPolicyState {}

class PrivacyPolicyLoading extends PrivacyPolicyState {}

class PrivacyPolicyLoaded extends PrivacyPolicyState {
  final PrivacyPolicyModel model;
  const PrivacyPolicyLoaded(this.model);
}

class PrivacyPolicyFailed extends PrivacyPolicyState {
  final String message;

  const PrivacyPolicyFailed(this.message);
}
