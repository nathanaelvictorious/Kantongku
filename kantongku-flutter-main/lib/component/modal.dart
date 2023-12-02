import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kantongku/component/text_style.dart';

class GlobalModal {
  static void loadingModal(deviceWidth, context) {
    showModalBottomSheet(
        isDismissible: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(deviceWidth / 20),
              topRight: Radius.circular(deviceWidth / 20)),
        ),
        builder: (context) {
          return PopScope(
           canPop: false,
            child: StatefulBuilder(builder: (context, StateSetter setState) {
              return IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.all(deviceWidth / 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Mohon ditunggu',
                        style: TextStyleComp.bigBoldText(context),
                      ),
                      SizedBox(
                        height: deviceWidth / 20,
                      ),
                      SpinKitFadingCube(
                        color: Theme.of(context).primaryColor,
                        size: deviceWidth / 15,
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }
}
