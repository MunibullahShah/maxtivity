import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maxtivity/constants/app_constants.dart';
import 'package:maxtivity/constants/asset_paths.dart';
import 'package:maxtivity/modules/history/controller/history_controller.dart';
import 'package:maxtivity/utils/ui/buttons/side_bar_button.dart';
import 'package:maxtivity/utils/ui/custom_text.dart';
import 'package:maxtivity/utils/ui/drawer/custom_drawer.dart';

class HistoryView extends StatelessWidget {
  HistoryView({Key? key}) : super(key: key);

  HistoryController historyController = Get.put(HistoryController());
  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistoryController>(builder: (logic) {
      return Scaffold(
        key: _key,
        drawer: CustomDrawer(),
        body: Container(
          height: screenHeight,
          margin: EdgeInsets.only(
            top: screenHeight * 0.06,
            left: screenWidth * 0.03,
            right: screenWidth * 0.03,
            bottom: screenHeight * 0.03,
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: SidebarButton(
                  sidebarIcon: sidebarIcon,
                  onTap: () {
                    _key.currentState!.openDrawer();
                  },
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              SizedBox(
                height: screenHeight * 0.8,
                child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Start Time:',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              CustomText(
                                text: "startTime",
                                fontSize: 14,
                              ),
                              SizedBox(height: 16),
                              CustomText(
                                text: 'End Time:',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              CustomText(
                                text: "endTime",
                                fontSize: 14,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
