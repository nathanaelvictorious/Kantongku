import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kantongku/component/snackbar.dart';
import 'package:kantongku/model/bill_model.dart';

class BillRepository {
  static String urlServer = 'http://192.168.1.8:8000/api';

  static Future<List<Bill>> getData(userId) async {
    Uri url = Uri.parse("$urlServer/bill-reminders/$userId");

    var response = await get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as List;
      return jsonResponse.map((e) => Bill.createFromJson(e)).toList();
    }
    return [];
  }

  static Future addData(
      context, userId, dueDate, name, amount, description) async {
    try {
      Response response = await post(
        Uri.parse("$urlServer/bill-reminders"),
        body: {
          "user_id": userId,
          "name": name,
          "amount": amount,
          "due_date": dueDate,
          "description": description,
        },
      );
      if (response.statusCode == 201) {
        Navigator.pop(context);
        Navigator.pop(context);

        GlobalSnackBar.show(context, 'Tagihan berhasil ditambahkan.');
      } else {
        Navigator.pop(context);
        GlobalSnackBar.show(context, 'Tagihan gagal ditambahkan');
      }
    } catch (e) {
      Navigator.pop(context);
      GlobalSnackBar.show(context, e.toString());
    }
  }
}
