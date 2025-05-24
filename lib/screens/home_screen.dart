import 'package:flutter/material.dart';
import '../models/donasi_ini.dart';
import '../services/api_service.dart';
import 'tambah_donasi_screen.dart';
import 'edit_donasi_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Donasi>> futureDonasi;

  @override
  void initState() {
    super.initState();
    futureDonasi = ApiService.getDonasi();
  }

  void refreshData() {
    setState(() {
      futureDonasi = ApiService.getDonasi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Donasi')),
      body: FutureBuilder<List<Donasi>>(
        future: futureDonasi,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final donasiList = snapshot.data!;
            return ListView.builder(
              itemCount: donasiList.length,
              itemBuilder: (context, index) {
                final donasi = donasiList[index];
                return ListTile(
                  title: Text(donasi.nama),
                  subtitle: Text('Rp ${donasi.nominal} - ${donasi.pesan}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => EditDonasiScreen(donasi: donasi),
                            ),
                          );
                          refreshData();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await ApiService.deleteDonasi(donasi.id);
                          refreshData();
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahDonasiScreen()),
          );
          refreshData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
