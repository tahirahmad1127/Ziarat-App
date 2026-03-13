import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'counter_event.dart';
import 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  static const String _counterKey = 'tasbih_counter';
  int _count = 0;

  CounterBloc() : super(CounterInitialState(count: 0)) {
    on<CounterLoadEvent>((event, emit) {
      emit(CounterIncState(incCount: _count));
    });

    on<CounterIncEvent>((event, emit) async {
      _count++;
      await _saveCount(_count);
      emit(CounterIncState(incCount: _count));
    });

    on<CounterResetEvent>((event, emit) async {
      _count = 0;
      await _clearCount();
      emit(CounterInitialState(count: 0));
    });

    _loadCount();
  }

  Future<void> _loadCount() async {
    final prefs = await SharedPreferences.getInstance();
    _count = prefs.getInt(_counterKey) ?? 0;
    add(const CounterLoadEvent());
  }

  Future<void> _saveCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_counterKey, count);
  }

  Future<void> _clearCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_counterKey);
  }
}