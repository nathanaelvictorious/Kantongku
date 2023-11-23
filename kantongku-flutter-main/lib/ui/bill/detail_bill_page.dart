import 'package:flutter/material.dart';
import 'package:kantongku/component/text_style.dart';

class DetailBillPage extends StatefulWidget {
  const DetailBillPage({super.key});

  @override
  State<DetailBillPage> createState() => _DetailBillPageState();
}

class _DetailBillPageState extends State<DetailBillPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Tagihan',
          style: TextStyleComp.mediumBoldPrimaryColorText(context),
        ),
      ),
    );
  }

  Widget detailTagihanWidgets() {
    return Column();
  }
}
