
import 'package:flutter/material.dart';
import '../models/bmi_model.dart';
import '../controllers/bmi_controller.dart';
import 'hasil_page.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final tinggiController = TextEditingController();
  final beratController = TextEditingController();

  final BMIController bmiController = BMIController();

  DateTime? tanggalLahir;
  String jenisKelamin = 'laki-laki';
  bool loading = false;

  Future<void> pilihTanggal() async {
    final tanggal = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Pilih tanggal lahir',
    );

    if (tanggal != null) {
      setState(() {
        tanggalLahir = tanggal;
      });
    }
  }

  Future<void> hitungBMI() async {
    if (!_formKey.currentState!.validate()) return;

    if (tanggalLahir == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih tanggal lahir.'),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final data = BMIModel(
        nama: namaController.text,
        tanggalLahir: tanggalLahir!,
        jenisKelamin: jenisKelamin,
        tinggi: double.parse(tinggiController.text),
        berat: double.parse(beratController.text),
      );

      final hasil = await bmiController.prosesBMI(data);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HasilPage(
            nama: namaController.text,
            umur: data.umurTahun,
            hasil: hasil,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    tinggiController.dispose();
    beratController.dispose();
    super.dispose();
  }

  Widget inputField({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label wajib diisi.';
        }

        final angka = double.tryParse(value);

        if (angka == null || !angka.isFinite || angka <= 0) {
          return 'Masukkan angka yang valid.';
        }

        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator BMI'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.monitor_weight_outlined,
                size: 75,
                color: Colors.green,
              ),

              const SizedBox(height: 10),

              const Text(
                'Hitung Indeks Massa Tubuh',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              inputField(
                label: 'Nama',
                controller: namaController,
                hint: 'Masukkan nama',
              ),

              const SizedBox(height: 15),

              const Text(
                'Tanggal Lahir',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              OutlinedButton.icon(
                onPressed: pilihTanggal,
                icon: const Icon(Icons.calendar_month),
                label: Text(
                  tanggalLahir == null
                      ? 'Pilih Tanggal Lahir'
                      : '${tanggalLahir!.day}/${tanggalLahir!.month}/${tanggalLahir!.year}',
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                'Jenis Kelamin',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              RadioGroup<String>(
                groupValue: jenisKelamin,
                onChanged: (value) {
                  setState(() {
                    jenisKelamin = value!;
                  });
                },
                child: const Column(
                  children: [
                    RadioListTile<String>(
                      title: Text('Laki-laki'),
                      value: 'laki-laki',
                    ),
                    RadioListTile<String>(
                      title: Text('Perempuan'),
                      value: 'perempuan',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              inputField(
                label: 'Tinggi Badan (cm)',
                controller: tinggiController,
                hint: 'Contoh: 170',
              ),

              const SizedBox(height: 15),

              inputField(
                label: 'Berat Badan (kg)',
                controller: beratController,
                hint: 'Contoh: 60',
              ),

              const SizedBox(height: 25),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: loading ? null : hitungBMI,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'HITUNG BMI',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
