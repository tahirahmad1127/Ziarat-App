part of 'terms_conditions_bloc.dart';

@immutable
abstract class TermsConditionsEvent extends Equatable {
  const TermsConditionsEvent();

  @override
  List<Object> get props => [];
}

class GetTermsConditionsEvent extends TermsConditionsEvent {
  const GetTermsConditionsEvent();
}

