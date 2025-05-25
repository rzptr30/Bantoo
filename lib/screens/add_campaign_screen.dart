import 'package:flutter/material.dart';
import '../models/donasi_ini.dart';
import '../services/api_service.dart';

class AddCampaignScreen extends StatefulWidget {
  final Donasi? existingDonasi; // Null jika tambah baru, berisi data jika edit
  
  const AddCampaignScreen({
    Key? key,
    this.existingDonasi,
  }) : super(key: key);

  @override
  State<AddCampaignScreen> createState() => _AddCampaignScreenState();
}

class _AddCampaignScreenState extends State<AddCampaignScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _targetAmountController;
  late TextEditingController _imageUrlController;
  bool _isEmergency = false;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    
    // Inisialisasi controller dengan data yang sudah ada jika dalam mode edit
    _titleController = TextEditingController(text: widget.existingDonasi?.title ?? '');
    _descriptionController = TextEditingController(text: widget.existingDonasi?.description ?? '');
    _targetAmountController = TextEditingController(
      text: (widget.existingDonasi?.targetAmount ?? widget.existingDonasi?.target ?? '')
          .toString()
          .replaceAll('null', '')
    );
    _imageUrlController = TextEditingController(
      text: widget.existingDonasi?.imageUrl ?? widget.existingDonasi?.foto ?? ''
    );
    _isEmergency = widget.existingDonasi?.isEmergency ?? false;
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetAmountController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
  
  Future<void> _saveCampaign() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();
      final targetAmount = double.tryParse(_targetAmountController.text) ?? 0.0;
      final imageUrl = _imageUrlController.text.trim();
      
      bool success;
      
      if (widget.existingDonasi != null) {
        // Mode edit
        success = await ApiService.updateDonasi(
          id: widget.existingDonasi!.id!,
          title: title,
          description: description,
          targetAmount: targetAmount,
          imageUrl: imageUrl,
          isEmergency: _isEmergency,
          collectedAmount: widget.existingDonasi!.collectedAmount ?? 0.0,
        );
      } else {
        // Mode tambah baru
        success = await ApiService.tambahDonasi(
          title: title,
          description: description,
          targetAmount: targetAmount,
          imageUrl: imageUrl,
          isEmergency: _isEmergency,
          collectedAmount: 0.0,
          deadline: DateTime.now().add(const Duration(days: 30)).toIso8601String(),
        );
      }
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.existingDonasi != null 
            ? 'Campaign berhasil diperbarui' 
            : 'Campaign berhasil ditambahkan')),
        );
        Navigator.pop(context, true); // true menandakan sukses
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan campaign')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingDonasi != null ? 'Edit Campaign' : 'Tambah Campaign'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Judul Campaign',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Judul tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Deskripsi',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Deskripsi tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _targetAmountController,
                      decoration: const InputDecoration(
                        labelText: 'Target Donasi (Rp)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Target donasi tidak boleh kosong';
                        }
                        final number = double.tryParse(value);
                        if (number == null || number <= 0) {
                          return 'Target donasi harus berupa angka positif';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: const InputDecoration(
                        labelText: 'URL Gambar',
                        border: OutlineInputBorder(),
                        hintText: 'https://example.com/image.jpg',
                      ),
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      title: const Text('Emergency Campaign'),
                      value: _isEmergency,
                      onChanged: (newValue) {
                        setState(() {
                          _isEmergency = newValue ?? false;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _saveCampaign,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        widget.existingDonasi != null ? 'UPDATE' : 'SIMPAN',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}