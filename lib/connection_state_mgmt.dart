import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectData {
  bool connected = true;
}

class ConnectDataNotifier extends StateNotifier<ConnectData> {
  ConnectDataNotifier(ConnectData connectData)
      : super(connectData ?? ConnectData());

  ConnectData connectData = ConnectData();

  void changeData(ConnectData newData) {
    state = newData;
  }

  void printData() {
    print("printData initialData.listMovies.length=" +
        connectData.connected.toString());
  }
}

final connectDataProvider = StateNotifierProvider<ConnectDataNotifier>((ref) {
  return ConnectDataNotifier(ConnectData());
});

// void main() {
//   runApp(ProviderScope(child: MyApp()));
// }
//
// //to watch the provider:
// Consumer(
// // Rebuild only the Text when counterProvider updates
// builder: (context, watch, child) {
// // Listens to the value exposed by counterProvider
// var state_provider = watch(counterProvider.state);
// return Text('$count');
// },
// )
//
// //to read the provider:
// StateNotifierProvider:
// context.read(counterProvider.state);
//
// //to read provider out of context:
// Use "ProviderContainer" to access the provider or its state and read or modify accordingly.
//
// To read and modify state:
// final container = ProviderContainer();
// var filterState = container.read(filterProvider);
// filterState.changeData(filterData);
