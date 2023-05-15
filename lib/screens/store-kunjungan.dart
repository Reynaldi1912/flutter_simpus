import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class StoreKunjungan extends StatefulWidget {
  const StoreKunjungan({Key key}) : super(key: key);

  @override
  State<StoreKunjungan> createState() => _StoreKunjunganState();
}

class _StoreKunjunganState extends State<StoreKunjungan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Input Kunjungan"),
      ),
    );
  }
}