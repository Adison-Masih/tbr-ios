// ignore_for_file: unused_element

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Const {
  static String name = "The Beauty Rox";
  static String domain = "https://thebeautyrox.com/";
  static String apiUrl = "https://thebeautyrox.com/api/";
  static String secretKey = "PAPA";
}

enum HttpMethods { GET, POST }

String getApiUrl({@required String method}) {
  return Const.apiUrl + method;
}

String getImage({@required String filename}) {
  return Const.domain + "uploads/" + filename;
}

Future<dynamic> callApi({
  @required String url,
  HttpMethods method = HttpMethods.GET,
  Map<String, dynamic> postParams = const {'name': "Hello"},
  String csrfToken = "",
  bool decode = true,
}) async {
  if (method == HttpMethods.GET) {
    http.Response response = await http.get(
      Uri.parse(url),
    );
    var body = response.body;

    return jsonDecode(body);
  } else {
    http.Response response = await http.post(
      Uri.parse(url),
      body: jsonEncode(postParams),
    );

    var body = response.body;

    return decode ? jsonDecode(body) : body;
  }
}

Future<void> alertMsg({
  @required context,
  @required title,
  @required text,
  @required callback,
}) async {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: callback,
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(text),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
