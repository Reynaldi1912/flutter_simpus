class Exception {
  String created_at;
  String status;
  String alasan;

  Exception({this.created_at, this.status, this.alasan});
  factory Exception.fromJson(Map<String, dynamic> json) {
    return Exception(
      created_at: json['created_at'],
      status: json['status'],
      alasan: json['alasan'],
    );
  }
}

