
import 'package:flutter/material.dart';
import '../models/bmi_model.dart';

class HasilPage extends StatelessWidget {
  final String nama;
  final int umur;
  final HasilBMI hasil;

  const HasilPage({
    super.key,
    required this.nama,
    required this.umur,
    required this.hasil,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil BMI'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 25),

            const Icon(
              Icons.monitor_weight,
              color: Colors.green,
              size: 80,
            ),

            const SizedBox(height: 15),

            const Text(
              'HASIL PERHITUNGAN BMI',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(25),

                child: Column(
                  children: [
                    Text(
                      nama,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text('Usia: $umur tahun'),

                    const SizedBox(height: 8),

                    Text('Kelompok: ${hasil.kelompok}'),

                    const SizedBox(height: 20),

                    Text(
                      hasil.bmi.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 42,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Text(
                      'Nilai BMI',
                      style: TextStyle(color: Colors.grey),
                    ),

                    const Divider(height: 30),

                    Text(
                      hasil.kategori,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      hasil.saran,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
