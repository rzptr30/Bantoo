import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TambahDonasiScreen extends StatefulWidget {
  const TambahDonasiScreen({Key? key}) : super(key: key);

  @override
  State<TambahDonasiScreen> createState() => _TambahDonasiScreenState();
}

class _TambahDonasiScreenState extends State<TambahDonasiScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _namaController = TextEditingController();
  final _nominalController = TextEditingController();
  final _pesanController = TextEditingController();
  final _fotoController = TextEditingController();
  
  Future<void> _tambahDonasi() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ApiService.tambahDonasi(
          nama: _namaController.text,
          nominal: double.parse(_nominalController.text),
          pesan: _pesanController.text,
          foto: _fotoController.text,
        );
        
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Donasi berhasil ditambahkan')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Donasi Baru'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Donasi',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nominalController,
                decoration: const InputDecoration(
                  labelText: 'Nominal Donasi',
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nominal tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pesanController,
                decoration: const InputDecoration(
                  labelText: 'Pesan Donasi',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pesan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fotoController,
                decoration: const InputDecoration(
                  labelText: 'URL Foto',
                  hintText: 'assets/images/donasi_1.jpg',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'URL foto tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _tambahDonasi,
                child: const Text('TAMBAH DONASI'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _namaController.dispose();
    _nominalController.dispose();
    _pesanController.dispose();
    _fotoController.dispose();
    super.dispose();
  }
}