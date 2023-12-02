import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kantongku/component/snackbar.dart';
import 'package:kantongku/component/url_server.dart';
import 'package:kantongku/model/bill_model.dart';

class BillRepository {
  static String urlServer = UrlServer.urlServer;

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

  static Future updateData(context, billReminderId, dueDate, name, amount,
      description, isPaid) async {
    try {
      Response response = await put(
        Uri.parse("$urlServer/bill-reminders/$billReminderId"),
        body: {
          "name": name,
          "amount": amount,
          "due_date": dueDate,
          "description": description,
          "is_paid_off": isPaid,
        },
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);

        GlobalSnackBar.show(context, 'Tagihan berhasil diubah.');
      } else {
        Navigator.pop(context);
        GlobalSnackBar.show(context, 'Tagihan gagal diubah');
      }
    } catch (e) {
      Navigator.pop(context);
      GlobalSnackBar.show(context, e.toString());
    }
  }

  static Future deleteData(context, billReminderId) async {
    try {
      Response response = await delete(
        Uri.parse("$urlServer/bill-reminders/$billReminderId"),
      );
      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);

        GlobalSnackBar.show(context, 'Tagihan berhasil dihapus.');
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        GlobalSnackBar.show(context, 'Tagihan gagal dihapus.');
      }
    } catch (e) {
      Navigator.pop(context);
      Navigator.pop(context);
      GlobalSnackBar.show(context, e.toString());
    }
  }
}
