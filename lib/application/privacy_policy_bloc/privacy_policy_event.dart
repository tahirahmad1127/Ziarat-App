part of 'privacy_policy_bloc.dart';

@immutable
abstract class PrivacyPolicyEvent extends Equatable {
  const PrivacyPolicyEvent();

  @override
  List<Object> get props => [];
}

class GetPrivacyPolicyEvent extends PrivacyPolicyEvent {
  const GetPrivacyPolicyEvent();
}

