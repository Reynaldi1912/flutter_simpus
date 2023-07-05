class HistoryKunjunganModel {
  final int id;
  final int nik;
  final int created_by;
  final int jml_anggota;
  final int umur;
  final int bpjs;
  final String tgl_lahir;
  final String no_hp;
  final String alamat;
  final String berat_badan;
  final String tinggi_badan;
  final String nama;
  final String diagnosa;
  final String tekanan_darah;
  final String upaya_kesehatan;
  final String penyuluhan;
  final String dokumentasi;
  final String created_at;


  const HistoryKunjunganModel({this.id, this.nik,this.bpjs, this.nama,this.umur,this.tgl_lahir,this.jml_anggota,this.no_hp,this.alamat, this.created_by  ,this.diagnosa, this.tekanan_darah , this.berat_badan ,this.tinggi_badan, this.upaya_kesehatan,this.penyuluhan , this.dokumentasi , this.created_at});
  factory HistoryKunjunganModel.fromJson(Map<String, dynamic> json) {
    return HistoryKunjunganModel(
      id: json['id'],
      nik: json['nik'],
      nama: json['nama'],
      umur: json['umur'],
      bpjs: json['bpjs'],
      tgl_lahir: json['tgl_lahir'],
      jml_anggota: json['jml_anggota_keluarga'],
      no_hp: json['no_hp'],
      alamat: json['alamat'],
      created_by: json['created_by'],
      berat_badan: json['berat_badan'],
      tinggi_badan: json['tinggi_badan'],
      diagnosa: json['diagnosa'],
      tekanan_darah: json['tekanan_darah'],
      penyuluhan: json['penyuluhan'],
      upaya_kesehatan: json['upaya_kesehatan'],
      dokumentasi: json['dokumentasi'],
      created_at: json['created_at'],
    );
  }
}

