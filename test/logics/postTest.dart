import 'dart:convert';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:maxtivity/utils/network/backend_repository.dart';
import 'package:maxtivity/modules/home/repository/home_repository.dart';

class MockBackendRepository extends Mock implements BackendRepository {}

void main() {
  group('HomeRepository', () {
    final mockBackendRepository = MockBackendRepository();
    final homeRepository = HomeRepository();

    test('saveTime returns status on success', () async {
      // Arrange
      final startTime = DateTime(2023, 11, 6, 9, 0);
      final endTime = DateTime(2023, 11, 6, 17, 0);
      final fakeResponse = {'status': '200'};
      when(mockBackendRepository.saveTime(startTime, endTime))
          .thenAnswer((_) async {
        return jsonEncode(fakeResponse);
      });

      // Act
      final result = await homeRepository.saveTime(startTime, endTime);

      // Assert
      expect(result, '200');
    });

    test('saveTime returns an empty string on error', () async {
      // Arrange
      final startTime = DateTime(2023, 11, 6, 9, 0);
      final endTime = DateTime(2023, 11, 6, 17, 0);
      final fakeResponse = {'status': '400'};
      when(mockBackendRepository.saveTime(startTime, endTime))
          .thenAnswer((_) async {
        return jsonEncode(fakeResponse);
      });

      // Act
      final result = await homeRepository.saveTime(startTime, endTime);

      // Assert
      expect(result, '');
    });
  });
}
