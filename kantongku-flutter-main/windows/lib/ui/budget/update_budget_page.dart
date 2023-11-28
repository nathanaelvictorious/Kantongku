import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:kantongku/component/modal.dart';
import 'package:kantongku/component/text_style.dart';
import 'package:kantongku/repository/budget_repository.dart';

class UpdateBudgetPage extends StatefulWidget {
  final String id;
  final String title;
  final String limit;
  final String description;
  const UpdateBudgetPage({
    required this.id,
    required this.title,
    required this.limit,
    required this.description,
    super.key,
  });

  @override
  State<UpdateBudgetPage> createState() => _UpdateBudgetPageState();
}

class _UpdateBudgetPageState extends State<UpdateBudgetPage> {
  TextEditingController titleCtl = TextEditingController();
  TextEditingController limitCtl = TextEditingController();
  TextEditingController descCtl = TextEditingController();
  final CurrencyTextInputFormatter limitFormatter = CurrencyTextInputFormatter(
    locale: 'id',
    decimalDigits: 0,
    symbol: 'Rp ',
  );

  @override
  void initState() {
    titleCtl = TextEditingController(text: widget.title);
    limitCtl = TextEditingController(text: widget.limit);
    descCtl = TextEditingController(text: widget.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor, //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Update Anggaran',
          style: TextStyleComp.mediumBoldPrimaryColorText(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(deviceWidth / 20),
        child: updateBugdetForm(deviceWidth),
      ),
    );
  }

  Widget updateBugdetForm(deviceWidth) {
    return ListView(
      children: [
        nameBudgetTextFormField(deviceWidth),
        limitBudgetTextFormField(deviceWidth),
        descBudgetTextFormField(deviceWidth),
        sendButton(deviceWidth),
      ],
    );
  }

  Widget nameBudgetTextFormField(deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: deviceWidth / 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nama Anggaran',
            style: TextStyleComp.mediumText(context),
          ),
          TextFormField(
            controller: titleCtl,
            autofocus: false,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade200,
              hintText: 'Masukkan nama anggaran',
              hintStyle: TextStyleComp.mediumText(context),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(deviceWidth / 50)),
                borderSide: const BorderSide(color: Colors.white, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(deviceWidth / 50)),
                borderSide: const BorderSide(color: Colors.white, width: 1.0),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Harus diisi';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget limitBudgetTextFormField(deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: deviceWidth / 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Batas Anggaran',
            style: TextStyleComp.mediumText(context),
          ),
          TextFormField(
            controller: limitCtl,
            autofocus: false,
            keyboardType: TextInputType.number,
            inputFormatters: [limitFormatter],
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade200,
              hintText: 'Masukkan nominal batas anggaran',
              hintStyle: TextStyleComp.mediumText(context),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(deviceWidth / 50)),
                borderSide: const BorderSide(color: Colors.white, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(deviceWidth / 50)),
                borderSide: const BorderSide(color: Colors.white, width: 1.0),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Harus diisi';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget descBudgetTextFormField(deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: deviceWidth / 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deskripsi',
            style: TextStyleComp.mediumText(context),
          ),
          TextFormField(
            controller: descCtl,
            maxLines: 3,
            autofocus: false,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade200,
              hintText: 'Masukkan deskripsi',
              hintStyle: TextStyleComp.mediumText(context),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(deviceWidth / 50)),
                borderSide: const BorderSide(color: Colors.white, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(deviceWidth / 50)),
                borderSide: const BorderSide(color: Colors.white, width: 1.0),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Harus diisi';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget sendButton(deviceWidth) {
    return ElevatedButton(
        onPressed: () async {
          GlobalModal.loadingModal(deviceWidth, context);
          BudgetRepository.updateData(
            context,
            widget.id,
            titleCtl.text,
            limitFormatter.getUnformattedValue() == 0
                ? widget.limit
                : limitFormatter.getUnformattedValue().toString(),
            descCtl.text,
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: deviceWidth / 50),
          child: Text(
            'Simpan',
            style: TextStyleComp.mediumBoldText(context),
          ),
        ));
  }
}
