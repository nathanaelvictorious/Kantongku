import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kantongku/component/color.dart';
import 'package:kantongku/component/modal.dart';
import 'package:kantongku/repository/user_repository.dart';
import 'package:kantongku/ui/register/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obsecurePassword = true;
  bool loadingLogin = false;

  void togglePassword() {
    setState(() {
      obsecurePassword = !obsecurePassword;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: GlobalColors.lightBlue,
      body: loginForm(deviceWidth),
    );
  }

  Widget loginForm(deviceWidth) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding:
              EdgeInsets.only(left: deviceWidth / 20, right: deviceWidth / 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(deviceWidth / 30),
              ),
            ),
            width: deviceWidth,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: deviceWidth / 15, horizontal: deviceWidth / 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Selamat datang!",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: deviceWidth / 20,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: deviceWidth / 30, bottom: deviceWidth / 20),
                    child: Text(
                      "Silahkan login terlebih dahulu.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: deviceWidth / 25,
                      ),
                    ),
                  ),
                  usernameTextField(deviceWidth),
                  passwordTextField(deviceWidth),
                  loginButton(deviceWidth),
                  registerButton(deviceWidth),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget usernameTextField(deviceWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Username",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: deviceWidth / 30,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: deviceWidth / 35),
          child: TextFormField(
            controller: usernameController,
            autofocus: false,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Container(
                margin: EdgeInsets.only(right: deviceWidth / 25),
                height: deviceWidth / 10,
                width: deviceWidth / 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(deviceWidth / 50),
                      bottomLeft: Radius.circular(deviceWidth / 50)),
                  color: const Color.fromARGB(255, 240, 239, 239),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: Icon(
                  FontAwesomeIcons.solidUser,
                  fill: 1,
                  size: deviceWidth / 28,
                  color: Colors.black,
                ),
              ),
              constraints: BoxConstraints(
                  maxHeight: deviceWidth / 10, minHeight: deviceWidth / 10),
              contentPadding: EdgeInsets.only(left: deviceWidth / 20),
              hintStyle: TextStyle(fontSize: deviceWidth / 28),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Masukkan username anda',
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(deviceWidth / 50)),
                borderSide: const BorderSide(color: Colors.grey, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(deviceWidth / 50)),
                borderSide: const BorderSide(color: Colors.grey, width: 1.0),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Harus diisi';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget passwordTextField(deviceWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Password",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: deviceWidth / 30,
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(top: deviceWidth / 35, bottom: deviceWidth / 15),
          child: TextFormField(
            controller: passwordController,
            autofocus: false,
            obscureText: obsecurePassword,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Container(
                margin: EdgeInsets.only(right: deviceWidth / 25),
                height: deviceWidth / 10,
                width: deviceWidth / 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(deviceWidth / 50),
                      bottomLeft: Radius.circular(deviceWidth / 50)),
                  color: const Color.fromARGB(255, 240, 239, 239),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: Icon(
                  FontAwesomeIcons.key,
                  fill: 1,
                  size: deviceWidth / 28,
                  color: Colors.black,
                ),
              ),
              constraints: BoxConstraints(
                  maxHeight: deviceWidth / 10, minHeight: deviceWidth / 10),
              contentPadding: EdgeInsets.only(left: deviceWidth / 20),
              hintStyle: TextStyle(fontSize: deviceWidth / 28),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Masukkan password anda',
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(deviceWidth / 50)),
                borderSide: const BorderSide(color: Colors.grey, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(deviceWidth / 50)),
                borderSide: const BorderSide(color: Colors.grey, width: 1.0),
              ),
              suffixIcon: InkWell(
                onTap: () {
                  togglePassword();
                },
                child: Icon(
                  obsecurePassword
                      ? FontAwesomeIcons.solidEyeSlash
                      : FontAwesomeIcons.solidEye,
                  size: deviceWidth / 28,
                ),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Harus diisi';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget loginButton(deviceWidth) {
    return SizedBox(
      width: deviceWidth,
      height: deviceWidth / 11,
      child: loadingLogin
          ? ElevatedButton(
              onPressed: () {},
              child: SizedBox(
                height: deviceWidth / 25,
                width: deviceWidth / 25,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )
          : ElevatedButton(
              onPressed: () {
                GlobalModal.loadingModal(deviceWidth, context);
                UserRepository.login(
                    context, usernameController.text, passwordController.text);
              },
              child: Text(
                "Masuk",
                style: TextStyle(
                    fontSize: deviceWidth / 28, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }

  Widget registerButton(deviceWidth) {
    return SizedBox(
      width: deviceWidth,
      child: TextButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const RegisterPage();
          }));
        },
        child: Text(
          'Belum punya akun? Daftar di sini',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: deviceWidth / 25, decoration: TextDecoration.underline),
        ),
      ),
    );
  }
}
