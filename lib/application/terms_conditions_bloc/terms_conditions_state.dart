part of 'terms_conditions_bloc.dart';

@immutable
abstract class TermsConditionsState extends Equatable {
  const TermsConditionsState();

  @override
  List<Object> get props => [];
}

class TermsConditionsInitial extends TermsConditionsState {}

class TermsConditionsLoading extends TermsConditionsState {}

class TermsConditionsLoaded extends TermsConditionsState {
  final TermsConditionsModel model;
  const TermsConditionsLoaded(this.model);
}

class TermsConditionsFailed extends TermsConditionsState {
  final String message;

  const TermsConditionsFailed(this.message);
}
