import 'package:flutter/material.dart';
import 'package:flutter_auth/network/api.dart';

class DetailHistory extends StatefulWidget {
  // const DetailHistory({Key key}) : super(key: key);
  final dynamic parameter;
  DetailHistory({this.parameter});

  @override
  State<DetailHistory> createState() => _DetailHistoryState();

}

class _DetailHistoryState extends State<DetailHistory> {
  String baseUrl = Network().getUrl().replaceAll("/api", "");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "DETAIL KUNJUNGAN",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Data Pasien" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Table(
                columnWidths: {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                },
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Nik"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(": ${widget.parameter.nik}"),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Nama"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(": ${widget.parameter.nama}"),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Umur"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(": ${widget.parameter.umur}"),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Tanggal Lahir"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(": ${widget.parameter.tgl_lahir}"),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Jumlah Anggota Keluarga"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(": ${widget.parameter.jml_anggota} Orang"),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Nomor HP"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(": ${widget.parameter.no_hp}"),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("BPJS"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(widget.parameter.bpjs == 1 ? ": Punya" : ": Tidak Punya"),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Alamat"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(": ${widget.parameter.alamat}"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 10),
              Text("Hasil Kunjungan" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Table(
                columnWidths: {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                },
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Berat Badan"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(": ${widget.parameter.berat_badan.toString()} kg"),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Tinggi Badan"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(": ${widget.parameter.tinggi_badan} cm"),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Tekanan Darah"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(": ${widget.parameter.tekanan_darah}"),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Diagnosa"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(": ${widget.parameter.diagnosa}"),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Penyuluhan"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(": ${widget.parameter.penyuluhan}"),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Dokumentasi"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(":"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Image.network(baseUrl.toString()+ 'images/'+widget.parameter.dokumentasi)
            ],
          ),
        ),
      )
    );
  }
}