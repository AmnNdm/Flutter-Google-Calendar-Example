import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
  Rx<TextEditingController> textEditingController = TextEditingController().obs;
  Rx<DateTime> dateTime = DateTime.now().obs;
  static const _scopes = [CalendarApi.calendarScope];
  final _clientID = ClientId(
      "484223437029-s4ke2dcsgcfnpgs2pccuq67ju6vmmbku.apps.googleusercontent.com"); //OAuth client_id from credentials in google console
  AuthClient? _authClient;
  onEventSet() {
    DatePicker.showDateTimePicker(Get.context!, onConfirm: (date) {
      dateTime.value = date;
    });
  }

  onInsertEvent(String title) {
    if (_authClient != null) {
      insertEvent();
    } else {
      clientViaUserConsent(_clientID, _scopes, prompt)
          .then((AuthClient client) {
        _authClient = client;
        insertEvent();
      });
    }
  }

  insertEvent() {
    var calendar = CalendarApi(_authClient!);
    calendar.calendarList
        .list()
        .then((value) => print("calendar list: $value"));
    String calendarId = "primary";
    Event _event = Event();
    _event.summary = textEditingController.value.text;
    _event.start = EventDateTime(dateTime: dateTime.value);
    _event.end =
        EventDateTime(dateTime: (dateTime.value).add(const Duration(hours: 1)));
    try {
      calendar.events.insert(_event, calendarId).then((value) {
        print("Event Added ${value.status}");
        if (value.status == "confirmed") {
          print('Event added in google calendar');
          textEditingController.value.clear();
        } else {
          print("Unable to add event in google calendar");
        }
      });
    } catch (e) {
      print("Error creating event: $e");
    }
  }

  void prompt(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw Exception("Could not launch url: $url");
    }
  }
}
