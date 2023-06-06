import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_auth/model/HistoryKunjunganModel.dart';
import 'package:flutter_auth/network/RepositoryKunjungan.dart';
import 'package:flutter_auth/screens/detailHistory.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryKunjungan extends StatefulWidget {
  const HistoryKunjungan({Key key}) : super(key: key);

  @override
  State<HistoryKunjungan> createState() => _HistoryKunjunganState();
}

class _HistoryKunjunganState extends State<HistoryKunjungan> {
  List<HistoryKunjunganModel> history = [];
  RepositoryKunjungan re = RepositoryKunjungan();

  String searchKeyword = '';
  int displayedItemCount = 10;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _prepareData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _prepareData() async {
    await getData();
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        displayedItemCount += 10;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "History Kunjungan",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 60, 170, 182)
            ],
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              SizedBox(height: 3),
              TextField(
                cursorColor: Colors.blue,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  hintText: "Search",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchKeyword = value.toLowerCase();
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: displayedItemCount,
                  itemBuilder: (BuildContext context, int index) {
                    if (index >= history.length) return SizedBox();

                    final visit = history[index];
                    List<String> tanggal = visit.created_at.split(' ');

                    if (searchKeyword.isNotEmpty &&
                        !visit.created_at.toLowerCase().contains(searchKeyword) &&
                        !visit.upaya_kesehatan.toLowerCase().contains(searchKeyword)) {
                      return SizedBox();
                    }

                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 5 / 10,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    Align
                                    (
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Tanggal Input : " + tanggal[0].toString(),
                                        style: TextStyle(color: Color.fromARGB(255, 133, 133, 132), fontSize: 12),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(visit.upaya_kesehatan ?? "-")
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, 
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => DetailHistory(parameter : visit),
                                    )
                                  );
                                },
                                child: Icon(Icons.remove_red_eye),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));
    List<HistoryKunjunganModel> data = await re.getKunjungan(user['id']);
    setState(() {
      history = data;
    });
  }
}
