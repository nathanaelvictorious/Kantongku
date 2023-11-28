import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kantongku/component/snackbar.dart';
import 'package:kantongku/model/transaction_model.dart';

class TransactionRepository {
  static String urlServer = 'http://192.168.1.8:8000/api';

  static Future<List<Transaction>> getAllData(userId) async {
    Uri url = Uri.parse("$urlServer/transactions/user/$userId");

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

  static Future addDataWithoutBudgetSaving(
      context, userId, category, amount, dateTime, description) async {
    try {
      Response response = await post(
        Uri.parse("$urlServer/transactions"),
        body: {
          "user_id": userId,
          "category": category,
          "amount": amount,
          "date_time": dateTime,
          "description": description,
        },
      );
      if (response.statusCode == 201) {
        Navigator.pop(context);
        Navigator.pop(context);

        GlobalSnackBar.show(context, 'Transaksi berhasil ditambahkan.');
      } else {
        Navigator.pop(context);
        GlobalSnackBar.show(context, 'Transaksi gagal ditambahkan');
      }
    } catch (e) {
      Navigator.pop(context);
      GlobalSnackBar.show(context, e.toString());
    }
  }

  static Future addDataTransBudget(context, userId, budgetId, category, amount,
      dateTime, description) async {
    try {
      Response response = await post(
        Uri.parse("$urlServer/transactions"),
        body: {
          "user_id": userId,
          "budget_id": budgetId,
          "category": category,
          "amount": amount,
          "date_time": dateTime,
          "description": description,
        },
      );
      if (response.statusCode == 201) {
        Navigator.pop(context);
        Navigator.pop(context);

        GlobalSnackBar.show(
            context, 'Transaksi berhasil ditambahkan ke anggaran.');
      } else {
        Navigator.pop(context);
        GlobalSnackBar.show(context, 'Transaksi gagal ditambahkan');
      }
    } catch (e) {
      Navigator.pop(context);
      GlobalSnackBar.show(context, e.toString());
    }
  }

  static Future addDataTransSaving(context, userId, savingId, category, amount,
      dateTime, description) async {
    try {
      Response response = await post(
        Uri.parse("$urlServer/transactions"),
        body: {
          "user_id": userId,
          "saving_id": savingId,
          "category": category,
          "amount": amount,
          "date_time": dateTime,
          "description": description,
        },
      );
      if (response.statusCode == 201) {
        Navigator.pop(context);
        Navigator.pop(context);

        GlobalSnackBar.show(
            context, 'Transaksi berhasil ditambahkan ke tabungan.');
      } else {
        Navigator.pop(context);
        GlobalSnackBar.show(context, 'Transaksi gagal ditambahkan');
      }
    } catch (e) {
      Navigator.pop(context);
      GlobalSnackBar.show(context, e.toString());
    }
  }

  static Future updateDataWithoutBudgetSaving(
      context, transactionId, amount, description) async {
    try {
      Response response = await put(
        Uri.parse("$urlServer/transactions/$transactionId"),
        body: {
          "amount": amount,
          "description": description,
        },
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);

        GlobalSnackBar.show(context, 'Transaksi berhasil diubah.');
      } else {
        Navigator.pop(context);
        GlobalSnackBar.show(context, 'Transaksi gagal diubah');
      }
    } catch (e) {
      Navigator.pop(context);
      GlobalSnackBar.show(context, e.toString());
    }
  }

  static Future updateDataTransBudget(
      context, transactionId, budgetId, amount, description) async {
    try {
      Response response = await put(
        Uri.parse("$urlServer/transactions/$transactionId"),
        body: {
          "budget_id": budgetId,
          "amount": amount,
          "description": description,
        },
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);

        GlobalSnackBar.show(context, 'Transaksi anggaran berhasil diubah.');
      } else {
        Navigator.pop(context);
        GlobalSnackBar.show(context, 'Transaksi anggaran gagal diubah');
      }
    } catch (e) {
      Navigator.pop(context);
      GlobalSnackBar.show(context, e.toString());
    }
  }

  static Future updateDataTransSaving(
      context, transactionId, savingId, amount, description) async {
    try {
      Response response = await put(
        Uri.parse("$urlServer/transactions/$transactionId"),
        body: {
          "saving_id": savingId,
          "amount": amount,
          "description": description,
        },
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);

        GlobalSnackBar.show(context, 'Transaksi tabungan berhasil diubah.');
      } else {
        Navigator.pop(context);
        GlobalSnackBar.show(context, 'Transaksi tabungan gagal diubah');
      }
    } catch (e) {
      Navigator.pop(context);
      GlobalSnackBar.show(context, e.toString());
    }
  }

  static Future deleteData(context, transactionId) async {
    try {
      Response response = await delete(
        Uri.parse("$urlServer/transactions/$transactionId"),
      );
      var jsonR = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);

        GlobalSnackBar.show(context, 'Transaksi berhasil dihapus.');
      } else {
        debugPrint(jsonR);
        Navigator.pop(context);
        Navigator.pop(context);
        GlobalSnackBar.show(context, 'Transaksi gagal dihapus.');
      }
    } catch (e) {
      debugPrint(e.toString());

      Navigator.pop(context);
      Navigator.pop(context);
      GlobalSnackBar.show(context, e.toString());
    }
  }
}
