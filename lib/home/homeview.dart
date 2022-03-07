import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'homecontroller.dart';

class MyHomePage extends GetView<HomeController> {
  final String title;
  final TextStyle _style = const TextStyle(fontSize: 17.0);

  MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key) {
    Get.put(HomeController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            setEvent(),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 18.0),
              child: TextField(
                  controller: controller.textEditingController.value,
                  style: _style),
            ),
            ElevatedButton(
                onPressed: () {
                  controller.onInsertEvent(
                      controller.textEditingController.value.text);
                  // show snackbar event added
                },
                child: const Text("Insert Event"))
          ],
        ),
      ),
    );
  }

  Widget setEvent() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
              onPressed: controller.onEventSet,
              child: Text(
                "Set Event",
                style: _style,
              )),
          ObxValue((Rx<DateTime> rxDateTime) {
            return Text(
              "$rxDateTime",
              style: _style,
            );
          }, controller.dateTime),
        ],
      ),
    );
  }
}
