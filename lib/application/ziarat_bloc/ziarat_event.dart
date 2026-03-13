part of 'ziarat_bloc.dart';

@immutable
abstract class ZiaratEvent extends Equatable {
  const ZiaratEvent();

  @override
  List<Object> get props => [];
}

class GetMakkahZiaratEvent extends ZiaratEvent {
  const GetMakkahZiaratEvent();
}

class GetMadinaZiaratEvent extends ZiaratEvent {
  const GetMadinaZiaratEvent();
}
class SearchZiaratEvent extends ZiaratEvent {
  final String keyword;
  const SearchZiaratEvent({required this.keyword});
}
class GetZiaratDetailsEvent extends ZiaratEvent {
  final String key;
  const GetZiaratDetailsEvent({required this.key});
}

