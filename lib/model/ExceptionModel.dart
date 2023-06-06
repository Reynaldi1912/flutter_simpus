class ExceptionModel {
  final int id;
  final int id_user;
  final int status_appr;
  final String tanggal_mulai;
  final String alasan;
  final String created_at;
  final String updated_at;


  const ExceptionModel({this.id, this.id_user  ,this.tanggal_mulai, this.status_appr , this.alasan , this.created_at , this.updated_at});
  factory ExceptionModel.fromJson(Map<String, dynamic> json) {
    return ExceptionModel(
      id: json['id'],
      id_user: json['id_user'],
      status_appr: json['status_appr'],
      tanggal_mulai: json['tanggal_mulai'],
      alasan: json['alasan'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],

    );
  }
}

