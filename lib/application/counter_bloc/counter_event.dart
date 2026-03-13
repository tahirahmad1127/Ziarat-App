import 'package:equatable/equatable.dart';

abstract class CounterEvent extends Equatable {
  const CounterEvent();
}

class CounterIncEvent extends CounterEvent {
  const CounterIncEvent();

  @override
  List<Object?> get props => [];
}

class CounterResetEvent extends CounterEvent {
  const CounterResetEvent();

  @override
  List<Object?> get props => [];
}

class CounterLoadEvent extends CounterEvent {
  const CounterLoadEvent();

  @override
  List<Object?> get props => [];
}