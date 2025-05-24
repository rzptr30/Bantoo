import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TambahDonasiScreen extends StatefulWidget {
  const TambahDonasiScreen({super.key});

  @override
  State<TambahDonasiScreen> createState() => _TambahDonasiScreenState();
}

class _TambahDonasiScreenState extends State<TambahDonasiScreen> {
  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final nominalController = TextEditingController();
  final pesanController = TextEditingController();
  final fotoController = TextEditingController();

  bool isLoading = false;

  void simpan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final success = await ApiService.tambahDonasi(
      namaController.text,
      nominalController.text,
      pesanController.text,
      foto: fotoController.text,
      progress: 0, // default 0
    );

    setState(() => isLoading = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(success
          ? 'Donasi berhasil ditambahkan'
          : 'Gagal menambah donasi'),
    ));
    if (success) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Donasi')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: namaController,
                  decoration: const InputDecoration(labelText: 'Nama'),
                  validator: (v) => v!.isEmpty ? 'Masukkan nama' : null,
                ),
                TextFormField(
                  controller: nominalController,
                  decoration: const InputDecoration(labelText: 'Nominal'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Masukkan nominal' : null,
                ),
                TextFormField(
                  controller: pesanController,
                  decoration: const InputDecoration(labelText: 'Pesan'),
                ),
                TextFormField(
                  controller: fotoController,
                  decoration: const InputDecoration(labelText: 'Foto (URL)'),
                ),
                const SizedBox(height: 24),
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: simpan,
                        child: const Text('Simpan'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
