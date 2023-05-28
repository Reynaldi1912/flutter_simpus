import 'package:flutter/material.dart';

class HistoryKunjungan extends StatefulWidget {
  const HistoryKunjungan({Key key}) : super(key: key);

  @override
  State<HistoryKunjungan> createState() => _HistoryKunjunganState();
}

class _HistoryKunjunganState extends State<HistoryKunjungan> {
  List<String> allVisits = [
    "19 Desember 2022 - Kegiatan: Sosialisasi Ibu Hamil",
    "18 Desember 2022 - Kegiatan: Sosialisasi Ibu Hamil",
    "17 Desember 2022 - Kegiatan: Sosialisasi Ibu Hamil",

    // Daftar kunjungan lainnya
  ];

  String searchKeyword = '';

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
            ])),
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
              SizedBox(height: 10,),
              Expanded(
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: allVisits.length,
                  itemBuilder: (BuildContext context, int index) {
                    final visit = allVisits[index];
                    if (searchKeyword.isNotEmpty && !visit.toLowerCase().contains(searchKeyword)) {
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
                                    Text(visit),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child: ElevatedButton(
                                onPressed: () {},
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
}
