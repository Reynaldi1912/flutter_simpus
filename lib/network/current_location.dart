import 'package:geolocator/geolocator.dart';

class Current_Location{

  double latitude;
  double longitude;

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Memeriksa apakah layanan lokasi diaktifkan
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Jika tidak diaktifkan, tampilkan pesan atau lakukan tindakan yang sesuai
      return Future.error('Layanan lokasi tidak diaktifkan');
    }

    // Memeriksa izin lokasi yang diberikan oleh pengguna
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Jika izin ditolak, minta izin
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Jika izin tetap ditolak, tampilkan pesan atau lakukan tindakan yang sesuai
        return Future.error('Izin lokasi ditolak');
      }
    }

    // Mendapatkan posisi saat ini
    return await Geolocator.getCurrentPosition();
  }

}