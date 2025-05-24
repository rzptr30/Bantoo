import 'package:flutter/material.dart';
import '../models/donasi_ini.dart';
import '../services/api_service.dart';

class EditDonasiScreen extends StatefulWidget {
  final Donasi donasi;
  const EditDonasiScreen({super.key, required this.donasi});

  @override
  State<EditDonasiScreen> createState() => _EditDonasiScreenState();
}

class _EditDonasiScreenState extends State<EditDonasiScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController namaController;
  late TextEditingController nominalController;
  late TextEditingController pesanController;
  late TextEditingController fotoController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.donasi.nama);
    nominalController = TextEditingController(text: widget.donasi.nominal);
    pesanController = TextEditingController(text: widget.donasi.pesan);
    fotoController = TextEditingController(text: widget.donasi.foto);
  }

  void update() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final success = await ApiService.updateDonasi(
      widget.donasi.id,
      namaController.text,
      nominalController.text,
      pesanController.text,
      foto: fotoController.text,
      progress: widget.donasi.progress,
    );

    setState(() => isLoading = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(success
          ? 'Donasi berhasil diperbarui'
          : 'Gagal memperbarui donasi'),
    ));
    if (success) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Donasi')),
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
                        onPressed: update,
                        child: const Text('Update'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
