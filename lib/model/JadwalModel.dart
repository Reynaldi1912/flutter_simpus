class Jadwal {
  final String upaya_kesehatan;
  final int id;
  final String kegiatan;
  final String tanggal_mulai;
  final String rincian_pelaksanaan;
  final int id_desa;
  final String nama_pelaksana1;
  final String nama_pelaksana2;
  final int status;

  const Jadwal({
    this.upaya_kesehatan,
    this.id,
    this.kegiatan,
    this.tanggal_mulai,
    this.rincian_pelaksanaan,
    this.id_desa,
    this.nama_pelaksana1,
    this.nama_pelaksana2,
    this.status
  });

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    return Jadwal(
      upaya_kesehatan: json['upaya_kesehatan'],
      id: json['id'],
      kegiatan: json['kegiatan'],
      tanggal_mulai: json['tanggal_mulai'],
      rincian_pelaksanaan: json['rincian_pelaksanaan'],
      id_desa: json['id_desa'],
      nama_pelaksana1: json['nama_pelaksana1'],
      nama_pelaksana2: json['nama_pelaksana2'],
      status: json['status']
    );
  }
}