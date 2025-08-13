import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:maxtivity/modules/history/model/history_model.dart';
import 'package:maxtivity/utils/network/backend_repository.dart';
import 'package:mockito/mockito.dart'; // You can use Mockito to mock the network request
import 'package:maxtivity/modules/history/repository/history_repository.dart';

class MockBackendRepository extends Mock implements BackendRepository {}

void main() {
  group('HistoryRepository', () {
    final mockBackendRepository = MockBackendRepository();
    final historyRepository = HistoryRepository();

    test('getHistory returns a list of HistoryModel on success', () async {
      final fakeResponse = {
        'status': "200",
        'message': {
          "data": [
            {
              "startTime": DateTime.now(),
              "endTime": DateTime.now().add(Duration(minutes: 2))
            },
            {
              "startTime": DateTime.now().add(Duration(minutes: 3)),
              "endTime": DateTime.now().add(Duration(minutes: 5))
            },
          ],
        },
      };
      when(mockBackendRepository.getHistory()).thenAnswer((_) async {
        return jsonEncode(fakeResponse);
      });

      final result = await historyRepository.getHistory();

      expect(result, isA<List<HistoryModel>>());
      expect(result.length, 2);
    });

    test('getHistory returns an empty list on error', () async {
      // Arrange
      final fakeResponse = {'status': "400"};
      when(mockBackendRepository.getHistory()).thenAnswer((_) async {
        return jsonEncode(fakeResponse);
      });

      // Act
      final result = await historyRepository.getHistory();

      // Assert
      expect(result, isEmpty);
    });
  });
}
