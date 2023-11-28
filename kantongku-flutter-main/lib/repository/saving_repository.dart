import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kantongku/component/snackbar.dart';
import 'package:kantongku/model/saving_model.dart';
import 'package:kantongku/model/transaction_model.dart';

class SavingRepository {
  static String urlServer = 'http://192.168.1.8:8000/api';

  static Future<List<Saving>> getData(userId) async {
    Uri url = Uri.parse("$urlServer/savings/$userId");

    var response = await get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as List;
      return jsonResponse.map((e) => Saving.createFromJson(e)).toList();
    }
    return [];
  }

  static Future<List<Transaction>> getTransaction(savingId) async {
    Uri url = Uri.parse("$urlServer/transactions/saving/$savingId");

    var response = await get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as List;
      return jsonResponse.map((e) => Transaction.createFromJson(e)).toList();
    }
    return [];
  }

  static Future addData(context, userId, title, goalAmount, description) async {
    try {
      Response response = await post(
        Uri.parse("$urlServer/savings"),
        body: {
          "user_id": userId,
          "title": title,
          "goal_amount": goalAmount,
          "description": description,
        },
      );
      if (response.statusCode == 201) {
        Navigator.pop(context);
        Navigator.pop(context);

        GlobalSnackBar.show(context, 'Tabungan berhasil ditambahkan.');
      } else {
        Navigator.pop(context);
        GlobalSnackBar.show(context, 'Tabungan gagal ditambahkan');
      }
    } catch (e) {
      Navigator.pop(context);
      GlobalSnackBar.show(context, e.toString());
    }
  }

  static Future updateData(
      context, savingId, title, goalAmount, description) async {
    try {
      Response response = await put(
        Uri.parse("$urlServer/savings/$savingId"),
        body: {
          "title": title,
          "goal_amount": goalAmount,
          "description": description,
        },
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);

        GlobalSnackBar.show(context, 'Tabungan berhasil diubah.');
      } else {
        Navigator.pop(context);
        GlobalSnackBar.show(context, 'Tabungan gagal diubah');
      }
    } catch (e) {
      Navigator.pop(context);
      GlobalSnackBar.show(context, e.toString());
    }
  }

  static Future deleteData(context, savingId) async {
    try {
      Response response = await delete(
        Uri.parse("$urlServer/savings/$savingId"),
      );
      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);

        GlobalSnackBar.show(context, 'Tabungan berhasil dihapus.');
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        GlobalSnackBar.show(context, 'Tabungan gagal dihapus.');
      }
    } catch (e) {
      Navigator.pop(context);
      Navigator.pop(context);
      GlobalSnackBar.show(context, e.toString());
    }
  }
}
