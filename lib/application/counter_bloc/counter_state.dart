import 'package:equatable/equatable.dart';

abstract class CounterState extends Equatable {
  const CounterState();
}

class CounterInitialState extends CounterState {
  final int count;
  const CounterInitialState({required this.count});

  @override
  List<Object?> get props => [count];
}

class CounterIncState extends CounterState {
  final int incCount;
  const CounterIncState({required this.incCount});

  @override
  List<Object?> get props => [incCount];
}

class CounterResetState extends CounterState {
  const CounterResetState();

  @override
  List<Object?> get props => [];
}