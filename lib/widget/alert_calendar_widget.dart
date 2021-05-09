import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_calendar/controller/smart_calendar_controller.dart';

enum WidgetType { alertDialog, snackbar }

class MonthCalendarWidget extends StatefulWidget {
  const MonthCalendarWidget({
    Key key,
    @required this.widgetType,
    @required this.backWardClick,
    @required this.forWardClick,
    @required this.clickOverTitle,
    @required this.clickOnMonth,
  }) : super(key: key);
  final WidgetType widgetType;
  final GestureTapCallback backWardClick;
  final GestureTapCallback forWardClick;
  final GestureTapCallback clickOverTitle;
  final GestureTapCallback clickOnMonth;

  @override
  _MonthCalendarWidgetState createState() => _MonthCalendarWidgetState();
}

class _MonthCalendarWidgetState extends State<MonthCalendarWidget> {
  SmartCalendarController controller;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<SmartCalendarController>()) {
      controller = Get.find<SmartCalendarController>();
    } else {
      controller = Get.put(SmartCalendarController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildMonthCalendarWidget();
  }

  _buildMonthCalendarWidget() {
    switch (widget.widgetType) {
      case WidgetType.alertDialog:
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: Get.width,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                      onPressed: widget.backWardClick,
                    ),
                    GestureDetector(
                      onTap: widget.clickOverTitle,
                      child: Obx(() => Text('${controller.currentYear}')),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      ),
                      onPressed: widget.forWardClick,
                    ),
                  ],
                ),
              ),
              Container(
                width: Get.width,
                height: 200,
                child: GridView.builder(
                  padding: EdgeInsets.only(
                      left: 5.0, right: 5.0, top: 10, bottom: 10),
                  itemCount: controller.months.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: 2.2),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: widget.clickOnMonth,
                      child: Card(
                        color: _buildMonthCardColor(index),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80)),
                        child: Container(
                          width: 25,
                          height: 25,
                          child: Center(
                              child: Obx(() => Text(
                                    controller.months[index]
                                        .toString()
                                        .capitalizeFirst,
                                    style: TextStyle(color: Colors.white),
                                  ))),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
        break;

      case WidgetType.snackbar:
        return SnackBar(
            content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Get.width,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                      onPressed: widget.backWardClick),
                  GestureDetector(
                    onTap: widget.clickOverTitle,
                    child: Obx(() => Text('${controller.currentYear}')),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      ),
                      onPressed: widget.forWardClick),
                ],
              ),
            ),
            Container(
              width: Get.width,
              height: 200,
              child: GridView.builder(
                padding:
                    EdgeInsets.only(left: 5.0, right: 5.0, top: 10, bottom: 10),
                itemCount: controller.months.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 2.2),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: widget.clickOnMonth,
                    child: Card(
                      color: _buildMonthCardColor(index),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80)),
                      child: Container(
                        width: 25,
                        height: 25,
                        child: Center(
                            child: Obx(() => Text(
                                  controller.months[index]
                                      .toString()
                                      .capitalizeFirst,
                                  style: TextStyle(color: Colors.white),
                                ))),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
        break;
    }
  }

  _buildMonthCardColor(int index) {
    if ((controller.currentMonth - 1) == index) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }
}
