import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kantongku/component/snackbar.dart';
import 'package:kantongku/model/user_model.dart';
import 'package:kantongku/ui/navbar/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  static String urlServer = 'http://192.168.1.7:8000/api';

  static Future register(context, name, email, username, password) async {
    Uri url = Uri.parse("$urlServer/users");

    try {
      var response = await post(
        url,
        headers: {
          'Accept': 'application/json',
        },
        body: {
          "username": username,
          "name": name,
          "password": password,
          "email": email,
        },
      );

      if (response.statusCode == 201) {
        Navigator.pop(context);

        GlobalSnackBar.show(
            context, 'Selamat! Registrasi akun berhasil, silahkan login');
      } else {
        Navigator.pop(context);
        GlobalSnackBar.show(context, 'Registrasi gagal!');
      }
      return null;
    } catch (e) {
      Navigator.pop(context);
      GlobalSnackBar.show(context, e.toString());
    }
  }

  static Future login(context, username, password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Uri url = Uri.parse("$urlServer/users/login");

    try {
      var response = await post(
        url,
        headers: {
          'Accept': 'application/json',
        },
        body: {
          "username": username,
          "password": password,
        },
      );

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonResponse['id'] != null) {
        Navigator.pop(context);
        prefs.setString('id', jsonResponse['id'].toString());
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => (const Navbar())));
        // return await getUser(context);
      } else {
        Navigator.pop(context);
        GlobalSnackBar.show(context, 'Username atau password salah!');
      }
      return null;
    } catch (e) {
      Navigator.pop(context);
      GlobalSnackBar.show(context, e.toString());
    }
  }

  static Future getUser(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString('id');
    Uri url = Uri.parse("$urlServer/users/$userId");

    try {
      var response = await post(
        url,
        headers: {
          'Accept': 'application/json',
        },
        body: {
          "userId": userId,
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

        return User.createFromJson(jsonResponse);
      } else {
        GlobalSnackBar.show(context, 'eror');
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
