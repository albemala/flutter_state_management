import 'package:flutter_state_management/flutter_state_management.dart';
import 'package:flutter_state_management_example/conductors/counter-conductor.dart';
import 'package:flutter_state_management_example/conductors/local-storage-conductor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// dart run build_runner build
@GenerateNiceMocks([
  MockSpec<LocalStorageConductor>(),
])
import 'counter_test.mocks.dart';

void main() {
  group('CounterConductor', () {
    late MockLocalStorageConductor mockStorage;
    late ConductorStorage conductorStorage;
    late CounterConductor counterConductor;

    setUp(() {
      mockStorage = MockLocalStorageConductor();
      conductorStorage = ConductorStorage(mockStorage);
      counterConductor = CounterConductor(conductorStorage);
    });

    test('Should be initialized with a count of 0', () {
      expect(counterConductor.counter.value, 0);
    });

    test('Should increment the count by 1', () {
      counterConductor.increment();
      expect(counterConductor.counter.value, 1);
    });

    test('Should decrement the count by 1', () {
      counterConductor.increment();
      counterConductor.decrement();
      expect(counterConductor.counter.value, 0);
    });

    test('Should load data from local storage', () async {
      final mockData = {'count': 5};
      when(mockStorage.load(any)).thenAnswer((_) async => mockData);
      counterConductor = CounterConductor(conductorStorage);
      await counterConductor.load();
      expect(counterConductor.counter.value, 5);
    });

    test('Should update count from a provided map', () {
      final mapData = {'count': 7};
      counterConductor.fromMap(mapData);
      expect(counterConductor.counter.value, 7);
    });

    test('Should default count to 0 if map lacks count key', () {
      final mapData = <String, dynamic>{};
      counterConductor.fromMap(mapData);
      expect(counterConductor.counter.value, 0);
    });

    test('toMap should return a map with current count', () {
      counterConductor.increment();
      final result = counterConductor.toMap();
      expect(result, {'count': 1});
    });

    test('Should save data to local storage', () async {
      counterConductor.increment();
      verify(mockStorage.save(any, any)).called(1);
    });
  });
}
