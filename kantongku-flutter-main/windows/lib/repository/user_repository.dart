import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kantongku/component/snackbar.dart';
import 'package:kantongku/component/url_server.dart';
import 'package:kantongku/model/user_model.dart';
import 'package:kantongku/ui/login/login_page.dart';
import 'package:kantongku/ui/navbar/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  static String urlServer = UrlServer.urlServer;

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
        prefs.setString('id', jsonResponse['id'].toString());
        return await getUser(context);
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

  static Future<User?> getUser(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString('id');
    Uri url = Uri.parse("$urlServer/users/$userId");

    var response = await get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Navbar()),
          (Route<dynamic> route) => false);
      return User.createFromJson(jsonResponse);
    } else {
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

      Navigator.pop(context);
      GlobalSnackBar.show(context, jsonResponse.toString());
    }
    return null;
  }

  static Future logOut(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false);
  }
}
