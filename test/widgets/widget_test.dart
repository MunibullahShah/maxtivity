import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:maxtivity/modules/home/controller/home_controller.dart';
import 'package:maxtivity/modules/home/view/home_view.dart';
import 'package:sizer/sizer.dart';

const double testScreenWidth = 360;
const double testScreenHeight = 640;

void main() {
  group('HomeView', () {
    testWidgets('Renders the Start button', (WidgetTester tester) async {
      await tester.pumpWidget(GetMaterialApp(
        home: Sizer(
          builder: (BuildContext context, Orientation orientation,
              DeviceType deviceType) {
            return HomeView();
          },
        ),
      ));

      expect(find.text('Start'), findsOneWidget);
    });

    testWidgets('Tapping Start button changes state',
        (WidgetTester tester) async {
      final controller = HomeController();
      await tester.pumpWidget(
        GetMaterialApp(
          home: HomeView(),
        ),
      );

      // Verify the initial state
      expect(controller.isPaused, true);

      // Tap the Start button
      await tester.tap(find.text('Start'));
      await tester.pump();

      // Verify the updated state
      expect(controller.isPaused, false);
    });

    testWidgets('Renders the Pause button when timer is active',
        (WidgetTester tester) async {
      final controller = HomeController();
      controller.startTimer();
      await tester.pumpWidget(
        GetMaterialApp(
          home: HomeView(),
        ),
      );

      expect(find.text('Pause'), findsOneWidget);
    });

    testWidgets('Tapping Pause button changes state',
        (WidgetTester tester) async {
      final controller = HomeController();
      controller.startTimer();
      await tester.pumpWidget(
        GetMaterialApp(
          home: HomeView(),
        ),
      );

      // Verify the initial state
      expect(controller.timer.isActive, true);

      // Tap the Pause button
      await tester.tap(find.text('Pause'));
      await tester.pump();

      // Verify the updated state
      expect(controller.timer.isActive, false);
    });

    // Add more test cases for other parts of the widget as needed
  });
}
