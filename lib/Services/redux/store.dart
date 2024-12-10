// store.dart
import 'package:redux/redux.dart';
import 'app_state.dart';
import 'reducers.dart';

final store = Store<AppState>(
  appReducer,
  initialState: AppState.initial(),
);
