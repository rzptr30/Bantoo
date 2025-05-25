import 'package:flutter/material.dart';
import '../models/donasi_ini.dart';
import '../services/api_service.dart';
import 'edit_donasi_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Donasi>> futureDonasi;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshDonasi();
  }

  Future<void> _refreshDonasi() async {
    setState(() {
      futureDonasi = ApiService.getDonasi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantoo'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDonasi,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : FutureBuilder<List<Donasi>>(
                future: futureDonasi,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final donasiList = snapshot.data ?? [];
                  if (donasiList.isEmpty) {
                    return const Center(child: Text('Belum ada data donasi'));
                  }

                  return ListView.builder(
                    itemCount: donasiList.length,
                    itemBuilder: (context, index) {
                      return DonasiCard(
                        donasi: donasiList[index],
                        onRefresh: _refreshDonasi,
                      );
                    },
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add donasi screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DonasiCard extends StatefulWidget {
  final Donasi donasi;
  final VoidCallback onRefresh;

  const DonasiCard({
    super.key,
    required this.donasi,
    required this.onRefresh,
  });

  @override
  State<DonasiCard> createState() => _DonasiCardState();
}

class _DonasiCardState extends State<DonasiCard> {
  bool _isDeleting = false;

  Future<void> _deleteDonasi(int id) async {
    if (_isDeleting) return;
    
    setState(() {
      _isDeleting = true;
    });

    try {
      final success = await ApiService.deleteDonasi(id);
      
      if (mounted) { // Periksa apakah widget masih ada
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Donasi berhasil dihapus')),
          );
          widget.onRefresh();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menghapus donasi')),
          );
        }
      }
    } catch (e) {
      if (mounted) { // Periksa apakah widget masih ada
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with image
          widget.donasi.foto != null && widget.donasi.foto!.isNotEmpty
              ? Image.network(
                  widget.donasi.foto!,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.image)),
                  ),
                )
              : Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.image)),
                ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.donasi.nama ?? 'No Name',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nominal: Rp ${widget.donasi.nominal?.toStringAsFixed(0) ?? '0'} - Pesan: ${widget.donasi.pesan ?? '-'}',
                ),
                const SizedBox(height: 12),
                
                // Progress bar
                if (widget.donasi.progress != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: widget.donasi.progress,
                        backgroundColor: Colors.grey[300],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(widget.donasi.progress! * 100).toStringAsFixed(0)}% Complete',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isDeleting
                          ? null
                          : () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditDonasiScreen(
                                    donasi: widget.donasi,
                                  ),
                                ),
                              );
                              
                              if (result == true) {
                                widget.onRefresh();
                              }
                            },
                      child: const Text('Edit'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: _isDeleting
                          ? null
                          : () => _showDeleteConfirmation(context),
                      child: _isDeleting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Hapus'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Anda yakin ingin menghapus donasi ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteDonasi(widget.donasi.id ?? 0);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}