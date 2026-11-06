
class BMIModel {
  final String nama;
  final DateTime tanggalLahir;
  final String jenisKelamin;
  final double tinggi;
  final double berat;

  BMIModel({
    required this.nama,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.tinggi,
    required this.berat,
  });

  int get umurBulan {
    final sekarang = DateTime.now();

    int bulan =
        (sekarang.year - tanggalLahir.year) * 12 +
        sekarang.month - tanggalLahir.month;

    if (sekarang.day < tanggalLahir.day) {
      bulan--;
    }

    return bulan;
  }

  int get umurTahun => umurBulan ~/ 12;

  String get kelompokUsia {
    if (umurBulan < 60) {
      return 'Balita';
    } else if (umurBulan < 240) {
      return 'Anak dan Remaja';
    } else {
      return 'Dewasa';
    }
  }

  double get nilaiBMI {
    final tinggiMeter = tinggi / 100;
    return berat / (tinggiMeter * tinggiMeter);
  }
}

class HasilBMI {
  final double bmi;
  final String kategori;
  final String saran;
  final String kelompok;

  HasilBMI({
    required this.bmi,
    required this.kategori,
    required this.saran,
    required this.kelompok,
  });
}
