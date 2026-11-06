
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/bmi_model.dart';

class BMIService {
  Future<List<dynamic>> bacaJSON(String file) async {
    final String response =
        await rootBundle.loadString(file);

    return jsonDecode(response) as List<dynamic>;
  }

  Future<HasilBMI> hitungKategori(BMIModel data) async {
    final bmi = data.nilaiBMI;

    if (data.umurBulan >= 240) {
      final json = await bacaJSON(
        'assets/data/bmi_dewasa.json',
      );

      for (var item in json) {
        final min = (item['batasMin'] as num).toDouble();
        final max = (item['batasMax'] as num).toDouble();

        if (bmi >= min && bmi < max) {
          return HasilBMI(
            bmi: bmi,
            kategori: item['nama'],
            saran: item['saran'],
            kelompok: data.kelompokUsia,
          );
        }
      }
    } else {
      final bool balita = data.umurBulan < 60;

      final file = balita
          ? 'assets/data/bmi_balita.json'
          : 'assets/data/bmi_anak_remaja.json';

      final json = await bacaJSON(file);

      final jenisKelamin =
          data.jenisKelamin.toLowerCase();

      final referensi = json.firstWhere(
        (item) =>
            item['jenisKelamin'] == jenisKelamin &&
            item['umurBulan'] == data.umurBulan,
        orElse: () => null,
      );

      if (referensi == null) {
        throw Exception(
          'Data referensi WHO untuk umur dan jenis kelamin ini belum tersedia.',
        );
      }

      final l = (referensi['L'] as num).toDouble();
      final m = (referensi['M'] as num).toDouble();
      final s = (referensi['S'] as num).toDouble();

      final zScore = l == 0
          ? log(bmi / m) / s
          : (pow(bmi / m, l) - 1) / (l * s);

      String kategori;
      String saran;

      if (balita) {
        if (zScore < -2) {
          kategori = 'Berat badan kurang';
          saran = 'Perlu evaluasi pertumbuhan dan asupan gizi.';
        } else if (zScore <= 1) {
          kategori = 'Normal';
          saran = 'Pertahankan pola makan dan pertumbuhan sehat.';
        } else if (zScore <= 2) {
          kategori = 'Berisiko berat badan berlebih';
          saran = 'Pantau pola makan dan pertumbuhan anak.';
        } else if (zScore <= 3) {
          kategori = 'Berat badan berlebih';
          saran = 'Konsultasikan pertumbuhan anak dengan tenaga kesehatan.';
        } else {
          kategori = 'Obesitas';
          saran = 'Konsultasikan kondisi anak dengan tenaga kesehatan.';
        }
      } else {
        if (zScore < -3) {
          kategori = 'Sangat kurus';
          saran = 'Perlu pemeriksaan status gizi oleh tenaga kesehatan.';
        } else if (zScore < -2) {
          kategori = 'Kurus';
          saran = 'Perhatikan kecukupan nutrisi dan pertumbuhan.';
        } else if (zScore <= 1) {
          kategori = 'Normal';
          saran = 'Pertahankan pola makan dan aktivitas sehat.';
        } else if (zScore <= 2) {
          kategori = 'Berat badan berlebih';
          saran = 'Perhatikan pola makan dan aktivitas fisik.';
        } else {
          kategori = 'Obesitas';
          saran = 'Konsultasikan hasil dengan tenaga kesehatan.';
        }
      }

      return HasilBMI(
        bmi: bmi,
        kategori: kategori,
        saran: saran,
        kelompok: data.kelompokUsia,
      );
    }

    throw Exception('Kategori BMI tidak ditemukan.');
  }
}
