import 'package:flutter/material.dart';
import '../models/donasi_ini.dart';
import '../services/api_service.dart';

class DonasiListScreen extends StatefulWidget {
  const DonasiListScreen({Key? key}) : super(key: key);

  @override
  State<DonasiListScreen> createState() => _DonasiListScreenState();
}

class _DonasiListScreenState extends State<DonasiListScreen> {
  late Future<List<Donasi>> futureDonasi;

  @override
  void initState() {
    super.initState();
    futureDonasi = ApiService.getDonasi();
  }

  void _refresh() {
    setState(() {
      futureDonasi = ApiService.getDonasi();
    });
  }

  Future<void> _deleteDonasi(int id) async {
    try {
      await ApiService.deleteDonasi(id);
      _refresh();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Donasi berhasil dihapus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _addDonasi() async {
    await Navigator.pushNamed(context, '/tambah-donasi');
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Donasi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      body: FutureBuilder<List<Donasi>>(
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
            return const Center(child: Text('Belum ada donasi'));
          }

          return ListView.builder(
            itemCount: donasiList.length,
            itemBuilder: (context, index) {
              final donasi = donasiList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(donasi.foto),
                  ),
                  title: Text(donasi.nama),
                  subtitle: Text('Rp ${donasi.nominal.toStringAsFixed(0)} - ${donasi.pesan}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/edit-donasi',
                            arguments: donasi,
                          ).then((_) => _refresh());
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteDonasi(donasi.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDonasi,
        child: const Icon(Icons.add),
      ),
    );
  }
}