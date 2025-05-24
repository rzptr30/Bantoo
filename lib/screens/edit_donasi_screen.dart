import 'package:flutter/material.dart';
import '../models/donasi_ini.dart';
import '../services/api_service.dart';

class EditDonasiScreen extends StatefulWidget {
  const EditDonasiScreen({Key? key}) : super(key: key);

  @override
  State<EditDonasiScreen> createState() => _EditDonasiScreenState();
}

class _EditDonasiScreenState extends State<EditDonasiScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _namaController;
  late TextEditingController _nominalController;
  late TextEditingController _pesanController;
  late TextEditingController _fotoController;
  late double _progress;
  
  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController();
    _nominalController = TextEditingController();
    _pesanController = TextEditingController();
    _fotoController = TextEditingController();
    _progress = 0.0;
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final donasi = ModalRoute.of(context)!.settings.arguments as Donasi;
    _namaController.text = donasi.nama;
    _nominalController.text = donasi.nominal.toString();
    _pesanController.text = donasi.pesan;
    _fotoController.text = donasi.foto;
    _progress = donasi.progress;
  }
  
  Future<void> _updateDonasi() async {
    if (_formKey.currentState!.validate()) {
      final donasi = ModalRoute.of(context)!.settings.arguments as Donasi;
      
      try {
        await ApiService.updateDonasi(
          donasi.id,
          nama: _namaController.text,
          nominal: double.parse(_nominalController.text),
          pesan: _pesanController.text,
          foto: _fotoController.text,
          progress: _progress,
        );
        
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Donasi berhasil diperbarui')),
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
        title: const Text('Edit Donasi'),
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
                onPressed: _updateDonasi,
                child: const Text('SIMPAN PERUBAHAN'),
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