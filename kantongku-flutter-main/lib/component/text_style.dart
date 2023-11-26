import 'package:flutter/material.dart';

class TextStyleComp {
  static bigBoldPrimaryColorText(context) {
    var kWidth = MediaQuery.of(context).size.width;

    return TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: kWidth / 20);
  }

  static bigBoldRedText(context) {
    var kWidth = MediaQuery.of(context).size.width;
    return TextStyle(
      color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: kWidth / 20,
    );
  }

  static bigBoldWhiteText(context) {
    var kWidth = MediaQuery.of(context).size.width;
    return TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: kWidth / 20,
    );
  }

  static bigBoldText(context) {
    var kWidth = MediaQuery.of(context).size.width;
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: kWidth / 20,
    );
  }

  static bigText(context) {
    var kWidth = MediaQuery.of(context).size.width;
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: kWidth / 20,
    );
  }

  static smallBoldWhiteText(context) {
    var kWidth = MediaQuery.of(context).size.width;
    return TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: kWidth / 30,
    );
  }

  static smallBoldGreenText(context) {
    var kWidth = MediaQuery.of(context).size.width;
    return TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.green,
      fontSize: kWidth / 30,
    );
  }

  static smallBoldRedText(context) {
    var kWidth = MediaQuery.of(context).size.width;
    return TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.bold,
      fontSize: kWidth / 30,
    );
  }

  static smallBoldGrayText(context) {
    var kWidth = MediaQuery.of(context).size.width;

    return TextStyle(
        color: Colors.grey, fontWeight: FontWeight.bold, fontSize: kWidth / 30);
  }

  static smallBoldPrimaryColorText(context) {
    var kWidth = MediaQuery.of(context).size.width;
    return TextStyle(
      color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: kWidth / 30,
    );
  }

  static smallBoldText(context) {
    var kWidth = MediaQuery.of(context).size.width;
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: kWidth / 30,
    );
  }

  static smallText(context) {
    var kWidth = MediaQuery.of(context).size.width;
    return TextStyle(
      fontSize: kWidth / 30,
    );
  }

  static mediumBoldRedText(context) {
    var kWidth = MediaQuery.of(context).size.width;

    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: kWidth / 25,
      color: Colors.red,
    );
  }

  static mediumBoldGrayText(context) {
    var kWidth = MediaQuery.of(context).size.width;

    return TextStyle(
        color: Colors.grey, fontWeight: FontWeight.bold, fontSize: kWidth / 25);
  }

  static mediumBoldWhiteText(context) {
    var kWidth = MediaQuery.of(context).size.width;

    return TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: kWidth / 25);
  }

  static mediumBoldText(context) {
    var kWidth = MediaQuery.of(context).size.width;

    return TextStyle(fontWeight: FontWeight.bold, fontSize: kWidth / 25);
  }

  static mediumBoldPrimaryColorText(context) {
    var kWidth = MediaQuery.of(context).size.width;

    return TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: kWidth / 25);
  }

  static mediumPrimaryColorText(context) {
    var kWidth = MediaQuery.of(context).size.width;

    return TextStyle(
        color: Theme.of(context).primaryColor, fontSize: kWidth / 25);
  }

  static mediumRedText(context) {
    var kWidth = MediaQuery.of(context).size.width;

    return TextStyle(
      fontSize: kWidth / 25,
      color: Colors.red,
    );
  }

  static mediumBoldGreenText(context) {
    var kWidth = MediaQuery.of(context).size.width;

    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: kWidth / 25,
      color: Colors.green,
    );
  }

  static mediumBoldItalicGreenText(context) {
    var kWidth = MediaQuery.of(context).size.width;

    return TextStyle(
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      fontSize: kWidth / 25,
      color: Colors.green,
    );
  }

  static mediumBoldItalicRedText(context) {
    var kWidth = MediaQuery.of(context).size.width;

    return TextStyle(
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      fontSize: kWidth / 25,
      color: Theme.of(context).primaryColor,
    );
  }

  static mediumText(context) {
    var kWidth = MediaQuery.of(context).size.width;

    return TextStyle(fontSize: kWidth / 25);
  }
}
