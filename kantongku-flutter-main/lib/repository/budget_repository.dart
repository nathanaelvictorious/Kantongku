import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kantongku/component/snackbar.dart';
import 'package:kantongku/model/budget_model.dart';
import 'package:kantongku/model/transaction_model.dart';

class BudgetRepository {
  static String urlServer = 'http://192.168.1.8:8000/api';

  static Future<List<Budget>> getData(userId, date) async {
    Uri url = Uri.parse("$urlServer/budgets/$userId?date=$date");

    var response = await get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as List;
      return jsonResponse.map((e) => Budget.createFromJson(e)).toList();
    }
    return [];
  }

  static Future<List<Transaction>> getTransaction(budgetId) async {
    Uri url = Uri.parse("$urlServer/transactions/budget/$budgetId");

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

  static Future addData(
      context, userId, title, category, limit, description, date) async {
    try {
      Response response = await post(
        Uri.parse("$urlServer/budgets"),
        body: {
          "user_id": userId,
          "title": title,
          "category": category,
          "limit": limit,
          "description": description,
          "date": date,
        },
      );
      if (response.statusCode == 201) {
        Navigator.pop(context);
        Navigator.pop(context);

        GlobalSnackBar.show(context, 'Anggaran berhasil ditambahkan.');
      } else {
        Navigator.pop(context);
        GlobalSnackBar.show(context, 'Anggaran gagal ditambahkan');
      }
    } catch (e) {
      Navigator.pop(context);
      GlobalSnackBar.show(context, e.toString());
    }
  }

  static Future updateData(context, budgetId, title, limit, description) async {
    try {
      Response response = await put(
        Uri.parse("$urlServer/budgets/$budgetId"),
        body: {
          "title": title,
          "limit": limit,
          "description": description,
        },
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);

        GlobalSnackBar.show(context, 'Anggaran berhasil diubah.');
      } else {
        Navigator.pop(context);
        GlobalSnackBar.show(context, 'Anggaran gagal diubah');
      }
    } catch (e) {
      Navigator.pop(context);
      GlobalSnackBar.show(context, e.toString());
    }
  }

  static Future deleteData(context, budgetId) async {
    try {
      Response response = await delete(
        Uri.parse("$urlServer/budgets/$budgetId"),
      );
      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);

        GlobalSnackBar.show(context, 'Anggaran berhasil dihapus.');
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        GlobalSnackBar.show(context, 'Anggaran gagal dihapus.');
      }
    } catch (e) {
      Navigator.pop(context);
      Navigator.pop(context);
      GlobalSnackBar.show(context, e.toString());
    }
  }
}
