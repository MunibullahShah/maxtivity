import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maxtivity/constants/app_constants.dart';
import 'package:maxtivity/constants/asset_paths.dart';
import 'package:maxtivity/modules/history/controller/history_controller.dart';
import 'package:maxtivity/utils/helpers/extensions.dart';
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SidebarButton(
                    sidebarIcon: sidebarIcon,
                    onTap: () {
                      _key.currentState!.openDrawer();
                    },
                  ),
                  if (logic.historyList.isNotEmpty)
                    TextButton.icon(
                      onPressed: () => _confirmClearAll(context, logic),
                      icon: const Icon(Icons.delete_sweep_outlined),
                      label: const Text('Clear All'),
                    ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              SizedBox(
                height: screenHeight * 0.8,
                child: logic.isLoading.value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : (logic.historyList.length == 0
                        ? Center(
                            child: CustomText(
                              text: 'No History Found',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : ListView.builder(
                            itemCount: logic.historyList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Card(
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                text: 'Start Time:',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              CustomText(
                                                text: logic
                                                    .historyList[index]
                                                    .startTime
                                                    .toLocal()
                                                    .toFormattedDateTimeString(),
                                                fontSize: 14,
                                              ),
                                              SizedBox(height: 16),
                                              CustomText(
                                                text: 'End Time:',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              CustomText(
                                                text: logic
                                                    .historyList[index]
                                                    .endTime
                                                    .toLocal()
                                                    .toFormattedDateTimeString(),
                                                fontSize: 14,
                                              ),
                                              SizedBox(height: 16),
                                              CustomText(
                                                text:
                                                    'Duration: ${logic.historyList[index].durationMinutes} min'
                                                    '${logic.historyList[index].completed ? '  •  Completed' : '  •  Incomplete'}',
                                                fontSize: 14,
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline,
                                          ),
                                          tooltip: 'Delete session',
                                          onPressed: () => _confirmDelete(
                                            context,
                                            logic,
                                            logic.historyList[index].id,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )),
              )
            ],
          ),
        ),
      );
    });
  }

  void _confirmDelete(
      BuildContext context, HistoryController logic, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete session'),
        content: const Text('Remove this session from your history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              logic.deleteSession(id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll(BuildContext context, HistoryController logic) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear history'),
        content:
            const Text('Delete all saved sessions? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              logic.clearAll();
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
