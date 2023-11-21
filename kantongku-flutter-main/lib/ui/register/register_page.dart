import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kantongku/component/color.dart';
import 'package:kantongku/component/modal.dart';
import 'package:kantongku/repository/user_repository.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
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
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: deviceWidth / 20,
              left: deviceWidth / 20,
              right: deviceWidth / 20),
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
                    "Registrasi Akun",
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
                      "Silahkan isi form registrasi di bawah ini",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: deviceWidth / 25,
                      ),
                    ),
                  ),
                  usernameTextField(deviceWidth),
                  namaTextField(deviceWidth),
                  emailTextField(deviceWidth),
                  passwordTextField(deviceWidth),
                  registerButton(deviceWidth),
                  backButton(deviceWidth),
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

  Widget namaTextField(deviceWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Nama Lengkap",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: deviceWidth / 30,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: deviceWidth / 35),
          child: TextFormField(
            controller: namaController,
            autofocus: false,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
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
                  FontAwesomeIcons.addressCard,
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
              fillColor: const Color.fromRGBO(255, 255, 255, 1),
              hintText: 'Masukkan nama lengkap anda',
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

  Widget emailTextField(deviceWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: deviceWidth / 30,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: deviceWidth / 35),
          child: TextFormField(
            controller: emailController,
            autofocus: false,
            keyboardType: TextInputType.emailAddress,
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
                  FontAwesomeIcons.solidEnvelope,
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
              hintText: 'Masukkan email anda',
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

  Widget registerButton(deviceWidth) {
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
                UserRepository.register(
                    context,
                    namaController.text,
                    emailController.text,
                    usernameController.text,
                    passwordController.text);
                GlobalModal.loadingModal(deviceWidth, context);
              },
              child: Text(
                "Daftar",
                style: TextStyle(
                    fontSize: deviceWidth / 28, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }

  Widget backButton(deviceWidth) {
    return SizedBox(
      width: deviceWidth,
      child: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          'Kembali',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: deviceWidth / 25, decoration: TextDecoration.underline),
        ),
      ),
    );
  }
}
