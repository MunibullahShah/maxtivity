import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:maxtivity/config/theme/app_colors.dart';
import 'package:maxtivity/constants/app_constants.dart';
import 'package:maxtivity/constants/asset_paths.dart';
import 'package:maxtivity/modules/stats/controller/stats_controller.dart';
import 'package:maxtivity/utils/ui/buttons/side_bar_button.dart';
import 'package:maxtivity/utils/ui/custom_text.dart';
import 'package:maxtivity/utils/ui/drawer/custom_drawer.dart';

class StatsView extends StatelessWidget {
  StatsView({Key? key}) : super(key: key);

  final StatsController statsController = Get.put(StatsController());
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  String _formatMinutes(int minutes) {
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return mins == 0 ? '${hours}h' : '${hours}h ${mins}m';
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StatsController>(builder: (logic) {
      return Scaffold(
        key: _key,
        drawer: CustomDrawer(),
        body: Container(
          height: screenHeight,
          margin: EdgeInsets.only(
            top: screenHeight * 0.06,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            bottom: screenHeight * 0.03,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SidebarButton(
                sidebarIcon: sidebarIcon,
                onTap: () {
                  _key.currentState!.openDrawer();
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomText(
                text: 'Statistics',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: logic.totalSessions == 0
                    ? Center(
                        child: CustomText(
                          text: 'No sessions yet.\nStart a focus session to see your stats.',
                          fontSize: 16,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: screenWidth * 0.04,
                              runSpacing: screenWidth * 0.04,
                              children: [
                                _statCard(
                                  label: 'Today',
                                  value: _formatMinutes(logic.todayMinutes),
                                ),
                                _statCard(
                                  label: 'This Week',
                                  value: _formatMinutes(logic.weekMinutes),
                                ),
                                _statCard(
                                  label: 'Total Focus',
                                  value:
                                      _formatMinutes(logic.totalFocusMinutes),
                                ),
                                _statCard(
                                  label: 'Sessions',
                                  value: '${logic.totalSessions}',
                                ),
                                _statCard(
                                  label: 'Completed',
                                  value:
                                      '${(logic.completionRate * 100).round()}%',
                                ),
                                _statCard(
                                  label: 'Current Streak',
                                  value: '${logic.currentStreak} d',
                                ),
                                _statCard(
                                  label: 'Longest Streak',
                                  value: '${logic.longestStreak} d',
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.04),
                            CustomText(
                              text: 'Last 7 days',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            _weeklyChart(logic.last7Days),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _statCard({required String label, required String value}) {
    return Container(
      width: screenWidth * 0.42,
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
        horizontal: screenWidth * 0.04,
      ),
      decoration: BoxDecoration(
        color: AppColors().secondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: value,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors().secondary,
          ),
          SizedBox(height: screenHeight * 0.005),
          CustomText(
            text: label,
            fontSize: 13,
            color: AppColors().grey,
          ),
        ],
      ),
    );
  }

  Widget _weeklyChart(List<DailyFocus> days) {
    final maxMinutes = days.fold<int>(
        1, (max, d) => d.minutes > max ? d.minutes : max);
    final chartHeight = screenHeight * 0.18;

    return SizedBox(
      height: chartHeight + screenHeight * 0.04,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days.map((d) {
          final barHeight = chartHeight * (d.minutes / maxMinutes);
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomText(
                text: d.minutes > 0 ? '${d.minutes}' : '',
                fontSize: 10,
                color: AppColors().grey,
              ),
              SizedBox(height: screenHeight * 0.005),
              Container(
                width: screenWidth * 0.07,
                height: d.minutes > 0 ? barHeight : 2,
                decoration: BoxDecoration(
                  color: d.minutes > 0
                      ? AppColors().secondary
                      : AppColors().lightGrey,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              SizedBox(height: screenHeight * 0.008),
              CustomText(
                text: DateFormat('E').format(d.day)[0],
                fontSize: 12,
                color: AppColors().grey,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
