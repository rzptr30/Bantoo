import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/donasi_ini.dart';
import 'edit_donasi_screen.dart';
import 'tambah_donasi_screen.dart';

class DonasiListPage extends StatefulWidget {
  const DonasiListPage({super.key});

  @override
  State<DonasiListPage> createState() => _DonasiListPageState();
}

class _DonasiListPageState extends State<DonasiListPage> {
  List _donasi = [];

  @override
  void initState() {
    super.initState();
    fetchDonasi();
  }

  void fetchDonasi() async {
    final data = await ApiService.getDonasi();
    setState(() => _donasi = data);
  }

  void hapus(String id) async {
    await ApiService.deleteDonasi(id);
    fetchDonasi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Donasi')),
      body: ListView.builder(
        itemCount: _donasi.length,
        itemBuilder: (context, index) {
          final item = _donasi[index];

          // konversi Map → Donasi agar mudah dipakai ulang
          final donasiObj = Donasi(
            id: item['id'].toString(),
            nama: item['nama'],
            nominal: item['nominal'].toString(),
            pesan: item['pesan'] ?? '',
            foto: (item['foto'] ?? '').toString(),
            progress:
                double.tryParse(item['progress']?.toString() ?? '0') ?? 0,
          );

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(donasiObj.foto),
            ),
            title: Text(donasiObj.nama),
            subtitle: Text("Rp ${donasiObj.nominal}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditDonasiScreen(donasi: donasiObj),
                      ),
                    );
                    if (result == true) fetchDonasi();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => hapus(donasiObj.id),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahDonasiScreen()),
          );
          if (result == true) fetchDonasi();
        },
      ),
    );
  }
}
