
import '../models/bmi_model.dart';
import '../services/bmi_service.dart';

class BMIController {
  final BMIService service = BMIService();

  Future<HasilBMI> prosesBMI(BMIModel data) async {
    if (data.nama.trim().isEmpty) {
      throw Exception('Nama tidak boleh kosong.');
    }

    if (data.tinggi <= 0 || data.berat <= 0) {
      throw Exception('Tinggi dan berat harus lebih dari nol.');
    }

    if (data.tanggalLahir.isAfter(DateTime.now())) {
      throw Exception('Tanggal lahir tidak valid.');
    }

    return await service.hitungKategori(data);
  }
}
